# 13-genre-omega-regression.R
# Genre-specific aggregate disagreement. For each of the twenty genres, OLS of
#   Omega_g(i) = sum_{s=1}^{4} omega_s(i;g) / SD_s
# on the covariates of script 12 (same predictors, same complete-case sample).
# SD_s is script 12's standardizer (the SD of the genre-summed omega_s), so the
# genre aggregates sum to script 12's Omega and the genre coefficients sum to
# its coefficients. Holm correction runs across all coefficients of the twenty
# models. Saves output/genre-omega-regression.{rds,csv} and the forest plot
# manuscript/figures/fig-genre-omega-forest.pdf.

library(tidyverse)

obj <- readRDS("output/antinomy_scores.rds")
ant <- obj$ant
omega <- obj$omega
omega_dim <- apply(omega, c(1, 3), sum)
sd_omega <- apply(omega_dim, 2, sd)

# Genre names in MFA column order (as in scripts 04 and 09)
genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband",
            "crold", "country", "blueg", "folk", "hymgos", "latspsal",
            "raphiphop", "blurb", "reggae", "toppop", "controck",
            "indalt", "danclub", "hvymtl")
stopifnot(dim(omega)[2] == length(genres))

genre_display <- c(
  classical = "Classical", opera = "Opera", jazz = "Jazz",
  bwayst = "Musicals", moodez = "Mood/Easy", bband = "Big band",
  crold = "Oldies", country = "Country", blueg = "Bluegrass",
  folk = "Folk", hymgos = "Gospel", latspsal = "Latin",
  raphiphop = "Rap", blurb = "Blues", reggae = "Reggae",
  toppop = "Top 40", controck = "Cont. rock", indalt = "Indie",
  danclub = "Dance", hvymtl = "Metal"
)

ssi <- readRDS("data/ssi2012_cleaned.rds") |> haven::zap_labels()
source("scripts/demographics-coding.R")
ssi_rows <- ssi[as.numeric(rownames(ant)), ]
keep <- demographic_keep(ssi_rows)
cat("Complete cases on demographics: N =", sum(keep), "of", nrow(ant), "\n")

# Genre aggregates, weighted like script 12's Omega
omega_sc <- sweep(omega, 3, sd_omega, "/")
Omega_g <- apply(omega_sc, c(1, 2), sum)
colnames(Omega_g) <- paste0("og_", genres)
Omega <- rowSums(sweep(omega_dim, 2, sd_omega, "/"))
stopifnot(max(abs(rowSums(Omega_g) - Omega)) < 1e-8)

dat <- cbind(data.frame(Omega_g, row.names = rownames(ant)),
             demographic_design(ssi_rows))[keep, ]

preds <- c("gender", "race", "age6",
           "educ_somecol", "educ_bach", "educ_postgrad",
           "parentba", "income4",
           "sclass_working", "sclass_middle", "sclass_upper",
           "region")
fits <- lapply(colnames(Omega_g), function(y) lm(reformulate(preds, y), data = dat))
names(fits) <- genres

res <- do.call(rbind, lapply(seq_along(fits), function(j) {
  s <- summary(fits[[j]])$coefficients
  s <- s[rownames(s) != "(Intercept)", , drop = FALSE]
  data.frame(genre = genres[j], term = rownames(s), b = s[, 1], se = s[, 2],
             p = s[, 4], row.names = NULL)
}))
res$holm_p <- p.adjust(res$p, "holm")
res$ci_lo <- res$b - 1.96 * res$se
res$ci_hi <- res$b + 1.96 * res$se

# Genre coefficients must sum to script 12's Omega coefficients (same sample and design)
agg <- readRDS("output/aggregate-regression.rds")$fits$Omega
agg_b <- coef(agg)[-1]
genre_sum <- tapply(res$b, res$term, sum)[names(agg_b)]
cat("Max |sum of genre b - script 12 Omega b|:",
    format(max(abs(genre_sum - agg_b)), digits = 3), "\n")
stopifnot(max(abs(genre_sum - agg_b)) < 1e-8)

# Sensitivity: Holm within each genre (24 coefficients per model) instead of across all 480
res$holm_within <- ave(res$p, res$genre, FUN = function(x) p.adjust(x, "holm"))
cat("\nHolm across 480 survivors:", sum(res$holm_p < .05),
    "; Holm within genre survivors:", sum(res$holm_within < .05), "\n")
cat("Survivors by method, term x genre:\n")
print(as.data.frame(res[res$holm_p < .05 | res$holm_within < .05,
                        c("genre", "term", "b", "p", "holm_p", "holm_within")]),
      row.names = FALSE, digits = 3)
genre_share <- tibble(genre = genres,
                      share = colMeans(Omega_g[keep, ]) / mean(Omega[keep]))

saveRDS(list(fits = fits, table = res, sd_omega = sd_omega, share = genre_share),
        "output/genre-omega-regression.rds")
res |>
  mutate(across(c(b, se, p, holm_p, ci_lo, ci_hi), \(x) round(x, 4))) |>
  write_csv("output/genre-omega-regression.csv")

cat("\nCoefficients:", nrow(res), "; unadjusted p < .05:", sum(res$p < .05),
    "; Holm-adjusted p < .05:", sum(res$holm_p < .05), "\n")
cat("\nHolm survivors by term:\n")
print(as.data.frame(count(filter(res, holm_p < .05), term, sort = TRUE)))
cat("\nGenre share of mean Omega:\n")
print(as.data.frame(mutate(arrange(genre_share, desc(share)), share = round(share, 3))))

# Forest plot: one panel per term, genres on the y-axis ordered by share of Omega
term_labels <- c(
  genderFemale = "Woman",
  raceBlack = "Black", raceAsian = "Asian", raceHispanic = "Hispanic",
  `race>1 race` = ">1 race", raceOther = "Other race",
  `age630-39` = "Age 30-39", `age640-49` = "Age 40-49", `age650-59` = "Age 50-59",
  `age660-69` = "Age 60-69", `age670+` = "Age 70+",
  educ_somecol1 = "Some college", educ_bach1 = "Bachelor's", educ_postgrad1 = "Postgraduate",
  `parentbaParents BA` = "Parents' BA",
  `income4$25-49k` = "$25-49k", `income4$50-74k` = "$50-74k", `income4$75k+` = "$75k+",
  sclass_working1 = "Working class", sclass_middle1 = "Middle class", sclass_upper1 = "Upper class",
  regionMidwest = "Midwest", regionSouth = "South", regionWest = "West")
stopifnot(all(res$term %in% names(term_labels)))

# Genre order follows Dimension 3 of the main MFA: each genre's mean yes-category
# coordinate across the three aspects (the same barycentres used for sign anchoring
# in script 06). Factor levels run bottom to top, so the most positive genre is at the top.
mfa <- readRDS("output/mfa_results.rds")
d3_yes <- sapply(genres, function(g)
  mean(mfa$quali.var$coord[paste0(c("pref", "cons", "eval"), "_", g, "_1"), 3]))
genre_levels <- unname(genre_display[names(sort(d3_yes))])
# Panels only for terms with at least one Holm-adjusted genre coefficient;
# the full 480-row table is in output/genre-omega-regression.csv
survivor_terms <- unique(res$term[res$holm_p < .05])
shown_labels <- term_labels[names(term_labels) %in% survivor_terms]
cat("Panels shown:", length(shown_labels), "of", length(term_labels), "terms\n")
cat("Terms without a corrected genre coefficient:",
    paste(term_labels[!names(term_labels) %in% survivor_terms], collapse = ", "), "\n")
forest <- res |>
  filter(term %in% survivor_terms) |>
  mutate(term = factor(unname(term_labels[term]), levels = unname(shown_labels)),
         genre_lab = factor(unname(genre_display[genre]), levels = genre_levels),
         holm = holm_p < .05)

p_forest <- ggplot(forest, aes(x = b, y = genre_lab)) +
  geom_vline(xintercept = 0, colour = "grey60", linewidth = 0.3) +
  geom_errorbar(aes(xmin = ci_lo, xmax = ci_hi), orientation = "y",
                width = 0, linewidth = 0.3) +
  geom_point(aes(shape = holm), size = 1.4) +
  scale_shape_manual(values = c(`FALSE` = 1, `TRUE` = 16),
                     name = "Holm-adjusted p < .05") +
  # free x-scales, with an x-axis on every panel and the genre labels on the left margin
  facet_wrap(~ term, ncol = 5, scales = "free_x", axes = "all_x") +
  labs(x = "Coefficient (aggregate units, 95% CI)", y = NULL) +
  theme_minimal(base_size = 8) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.text = element_text(size = 5.5),
        strip.text = element_text(size = 7, face = "bold"),
        legend.position = "bottom")
ggsave("manuscript/figures/fig-genre-omega-forest.pdf", p_forest,
       width = 6.5, height = 7.4, dpi = 300)
print(p_forest)
