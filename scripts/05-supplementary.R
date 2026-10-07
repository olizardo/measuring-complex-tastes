# 05-supplementary.R
# Situate the sources of complex tastes socially: project respondent
# demographics as supplementary (illustrative) categorical variables onto
# the MFA of preferences / consumption / evaluations.
#
# Supplementary categories do not influence the analysis; their coordinates
# are the barycenters of the individuals who belong to them.

library(FactoMineR)
library(ggplot2)
library(ggrepel)

res0 <- readRDS("output/mfa_results.rds")
mfa_dat <- readRDS("data/mfa_input.rds")
df <- readRDS("data/ssi2012_cleaned.rds")
df[] <- lapply(df, function(x) if (haven::is.labelled(x)) haven::zap_labels(x) else x)

idx <- as.integer(rownames(mfa_dat))  # original df rows retained as rownames
d <- df[idx, ]

# --- build supplementary variables --------------------------------------------
as_cat <- function(x, levels) {
  f <- factor(x, levels = c(levels, "Missing"))
  f[is.na(f)] <- "Missing"
  f
}

gender <- as_cat(d$female, c(0, 1))
levels(gender) <- c("Male", "Female", "Missing")

race <- as_cat(d$raceeth, 1:6)
levels(race) <- c("Asian", "Black", "Hispanic", "White", ">1 race", "Other",
                  "Missing")

age6 <- cut(d$age, breaks = c(-Inf, 4, 6, 8, 10, 12, Inf),
            labels = c("18-29", "30-39", "40-49", "50-59", "60-69", "70+"))
age6 <- as_cat(as.integer(age6), 1:6)
levels(age6) <- c("18-29", "30-39", "40-49", "50-59", "60-69", "70+", "Missing")

cred <- c("nodipdeg", "hsged", "somcol", "aadeg", "bach", "ma", "docprof")
educ <- rep(NA_character_, nrow(d))
for (j in seq_along(cred)) educ[d[[cred[j]]] == 1] <- cred[j]
educ <- factor(educ, levels = c(cred, "Missing"))
levels(educ) <- c("No diploma", "HS/GED", "Some college", "Associate",
                  "BA", "MA", "Prof/PhD", "Missing")

parentba <- as_cat(d$parented, c(0, 1))
levels(parentba) <- c("Parents no BA", "Parents BA", "Missing")

income4 <- cut(d$income, breaks = c(-Inf, 3, 5, 8, Inf),
               labels = c("<$25k", "$25-49k", "$50-74k", "$75k+"))
income4 <- as_cat(as.integer(income4), 1:4)
levels(income4) <- c("<$25k", "$25-49k", "$50-74k", "$75k+", "Missing")

sclass <- as_cat(d$percclass, 1:4)
levels(sclass) <- c("Lower", "Working", "Middle", "Upper", "Missing")

region <- cut(d$region, breaks = c(0, 2, 4, 7, 9),
              labels = c("Northeast", "Midwest", "South", "West"))
region <- as_cat(as.integer(region), 1:4)
levels(region) <- c("Northeast", "Midwest", "South", "West", "Missing")

sup <- data.frame(gender, race, age6, educ, parentba, income4, sclass, region)
stopifnot(nrow(sup) == nrow(mfa_dat))

# --- rerun MFA with supplementary columns ---------------------------------------
mfa2 <- cbind(mfa_dat, sup)
mfa2[1:ncol(mfa_dat)] <- lapply(mfa_dat, function(x) factor(x, levels = c(0, 1)))
nsup <- ncol(sup)
res <- MFA(mfa2,
           group = c(20, 20, 20, nsup),
           type = c("n", "n", "n", "n"),
           name.group = c("Preference", "Consumption", "Evaluation",
                          "Demographics"),
           num.group.sup = 4,
           graph = FALSE)
saveRDS(res, "output/mfa_results_sup.rds")

# --- category coordinates (barycenters of members' individual coordinates) ------
coord <- res$ind$coord[, 1:3]
cc <- do.call(rbind, lapply(names(sup), function(v) {
  g <- sup[[v]]
  data.frame(variable = v, category = levels(g),
             d1 = tapply(coord[, 1], g, mean),
             d2 = tapply(coord[, 2], g, mean),
             d3 = tapply(coord[, 3], g, mean),
             n = as.integer(table(g)))
}))
cc <- cc[cc$category != "Missing" & cc$n > 0, ]
rownames(cc) <- NULL

# --- correlation ratios (eta^2) of each variable with each dimension -------------
coord <- res$ind$coord[, 1:3]
eta <- sapply(1:3, function(s) {
  sapply(names(sup), function(v) {
    g <- droplevels(sup[[v]])
    m <- tapply(coord[, s], g, mean)
    n_h <- table(g)
    mu <- sum(n_h * m) / sum(n_h)
    ss_b <- sum(n_h * (m - mu)^2)
    ss_b / sum((coord[, s] - mean(coord[, s]))^2)
  })
})
colnames(eta) <- paste0("d", 1:3)
cat("\n== Correlation ratios (eta^2) with MFA dimensions ==\n")
print(round(eta, 3))

cat("\n== Supplementary category coordinates (dims 1-3) ==\n")
print(cbind(cc[, c("variable", "category", "n")],
             round(cc[, c("d1", "d2", "d3")], 2)), row.names = FALSE)

# --- figure: supplementary category barycenters, dims 2-3 ----------------------
el <- c("gender" = "Gender", "race" = "Race/ethnicity", "age6" = "Age",
        "educ" = "Education", "parentba" = "Parents' BA", "income4" = "Income",
        "sclass" = "Subjective class", "region" = "Census region")
pal <- setNames(RColorBrewer::brewer.pal(8, "Dark2"), names(sup))
p8 <- ggplot(cc, aes(d2, d3, color = variable)) +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60") +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  geom_point(size = 2.2) +
  geom_text_repel(aes(label = category), size = 2.5,
                  segment.color = NA, max.overlaps = 20, show.legend = FALSE) +
  scale_color_manual(values = pal, labels = el[names(pal)]) +
  labs(x = "Dimension 2", y = "Dimension 3",
       title = "Supplementary demographic categories in the MFA space",
       subtitle = "Category barycenters; axes cover the category coordinates only") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(), legend.position = "bottom")
ggsave("manuscript/figures/fig-supplementary.pdf", p8, width = 6, height = 4.4)

# --- LaTeX tables ---------------------------------------------------------------
tl <- c(
  "\\begin{tabular}{lccc}", "\\toprule",
  "Variable & Dim 1 & Dim 2 & Dim 3 \\\\", "\\midrule")
for (v in names(el)) {
  tl <- c(tl, paste0(el[v], " & ",
                     paste(sprintf("%.3f", eta[v, ]), collapse = " & "),
                     " \\\\"))
}
tl <- c(tl, "\\bottomrule", "\\end{tabular}")
writeLines(tl, "manuscript/tables/tab-eta.tex")

sl <- c(
  "\\begin{tabular}{llcccc}", "\\toprule",
  "Variable & Category & $n$ & Dim 1 & Dim 2 & Dim 3 \\\\", "\\midrule")
prev <- NULL
for (i in seq_len(nrow(cc))) {
  if (!is.null(prev) && cc$variable[i] != prev) sl <- c(sl, "\\addlinespace")
  cat_esc <- gsub("\\$", "\\\\$", cc$category[i])
  sl <- c(sl, paste0(el[cc$variable[i]], " & ", cat_esc, " & ",
                     cc$n[i], " & ",
                     paste(sprintf("%.2f", cc[i, c("d1", "d2", "d3")]),
                           collapse = " & "), " \\\\"))
  prev <- cc$variable[i]
}
sl <- c(sl, "\\bottomrule", "\\end{tabular}")
writeLines(sl, "manuscript/tables/tab-sup-coord.tex")

saveRDS(list(coord = cc, eta = eta, sup = sup), "output/supplementary.rds")
cat("\nfigures and tables written\n")
