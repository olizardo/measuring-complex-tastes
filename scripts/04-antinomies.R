# 04-antinomies.R
# Geometric operationalization of Ma's (2026) six complex tastes.
#
# MFA geometry: each individual has one partial point per aspect block;
# the global point is their average. For dimension s and individual i:
#   sum_h F_sh(i)^2  =  H * F_s(i)^2  +  sum_h (F_sh(i) - F_s(i))^2
# i.e. partial inertia = global (harmony) part + within-individual
# dispersion of aspects = "antinomy" part. The pairwise squared
# distances between partial points sum to H times the dispersion term
# (H = 3), giving aspect-pair-level disagreement shares.
#
# Discrete complement: each genre x respondent is one of Ma's 8
# configurations (+++ simple positive; --- simple negative; and the six
# antinomies: guilty pleasure ++-, pre-acquired -++, taste pose +-+,
# distanced consumption -+-, justified abstention +--, distant praise --+).

library(FactoMineR)  # loaded for res class methods only

res <- readRDS("output/mfa_results.rds")
mfa_dat <- readRDS("data/mfa_input.rds")
stopifnot(nrow(mfa_dat) == nrow(res$ind$coord))

genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop",
            "blurb", "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")

NDIM <- 3

# --- 1. partial points by aspect -------------------------------------------
cp <- res$ind$coord.partiel
rn <- rownames(cp)
grp <- sub(".*\\.", "", rn)
id  <- sub("\\..*", "", rn)
stopifnot(all(table(id) == NDIM))

P <- sapply(1:NDIM, function(s) cp[grp == "Preference", s])
C <- sapply(1:NDIM, function(s) cp[grp == "Consumption", s])
V <- sapply(1:NDIM, function(s) cp[grp == "Evaluation", s])
colnames(P) <- colnames(C) <- colnames(V) <- paste0("Dim", 1:NDIM)
F <- res$ind$coord[, 1:NDIM]

# identity checks: global = mean of partials; pairwise sum = H * dispersion
cat("max |mean(partials) - global| :",
    max(abs((P + C + V) / 3 - F)), "\n")
W <- (P - F)^2 + (C - F)^2 + (V - F)^2
Tt <- P^2 + C^2 + V^2
cat("max |T - (3F^2 + W)|        :",
    max(abs(Tt - (3 * F^2 + W))), "\n")
dPC <- (P - C)^2; dPV <- (P - V)^2; dCV <- (C - V)^2
cat("max |dPC + dPV + dCV - 3W|  :",
    max(abs(dPC + dPV + dCV - 3 * W)), "\n")

# --- 2. antinomy frame ---------------------------------------------------------
ant <- data.frame(
  F1 = F[, 1], F2 = F[, 2], F3 = F[, 3],
  T1 = Tt[, 1], T2 = Tt[, 2], T3 = Tt[, 3],
  W1 = W[, 1], W2 = W[, 2], W3 = W[, 3],
  dPC1 = dPC[, 1], dPV1 = dPV[, 1], dCV1 = dCV[, 1],
  dPC2 = dPC[, 2], dPV2 = dPV[, 2], dCV2 = dCV[, 2],
  dPC3 = dPC[, 3], dPV3 = dPV[, 3], dCV3 = dCV[, 3]
)
ant$W_tot <- ant$W1 + ant$W2 + ant$W3
ant$share1 <- ant$W1 / ant$T1
ant$share2 <- ant$W2 / ant$T2
ant$share3 <- ant$W3 / ant$T3

# --- 3. Ma's eight configurations per genre x respondent -----------------------
types <- c("simple_pos", "guilty", "preacquired", "pose",
           "distanced", "justified", "distant", "simple_neg")
type_counts <- matrix(0L, nrow(mfa_dat), length(types),
                      dimnames = list(NULL, types))
for (g in genres) {
  p <- mfa_dat[[paste0("pref_", g)]]
  c <- mfa_dat[[paste0("cons_", g)]]
  v <- mfa_dat[[paste0("eval_", g)]]
  type_counts[p &  c &  v, "simple_pos"]   <- type_counts[p &  c &  v, "simple_pos"] + 1L
  type_counts[p &  c & !v, "guilty"]       <- type_counts[p &  c & !v, "guilty"] + 1L
  type_counts[!p & c &  v, "preacquired"]  <- type_counts[!p & c &  v, "preacquired"] + 1L
  type_counts[p & !c &  v, "pose"]         <- type_counts[p & !c &  v, "pose"] + 1L
  type_counts[!p & c & !v, "distanced"]    <- type_counts[!p & c & !v, "distanced"] + 1L
  type_counts[p & !c & !v, "justified"]    <- type_counts[p & !c & !v, "justified"] + 1L
  type_counts[!p & !c &  v, "distant"]     <- type_counts[!p & !c &  v, "distant"] + 1L
  type_counts[!p & !c & !v, "simple_neg"]  <- type_counts[!p & !c & !v, "simple_neg"] + 1L
}
type_counts <- as.data.frame(type_counts)
type_counts$n_complex <- rowSums(type_counts[, c("guilty", "preacquired", "pose",
                                                 "distanced", "justified", "distant")])

# --- 4. relate antinomy scores and type counts to the MFA ----------------------
cat("\n== Distribution of configurations (per genre x respondent) ==\n")
print(round(colMeans(type_counts), 2))
cat("total complex tastes per respondent: mean",
    round(mean(type_counts$n_complex), 2), "\n")
cat("respondents with zero complex tastes:",
    sum(type_counts$n_complex == 0), "\n")

cat("\n== Geometric antinomy scores: summary ==\n")
print(round(summary(ant$W3), 3))
cat("mean antinomy share of partial inertia: dim1",
    round(mean(ant$share1), 3), "| dim2", round(mean(ant$share2), 3),
    "| dim3", round(mean(ant$share3), 3), "\n")

cat("\n== Pair-level disagreement, dim 3 (correlations with dims) ==\n")
print(round(cor(ant[, c("dPC3", "dPV3", "dCV3")], ant[, c("F1", "F2", "F3")],
                method = "spearman"), 2))

cat("\n== Spearman correlations: type counts vs MFA dimensions ==\n")
dims <- ant[, c("F1", "F2", "F3")]
print(round(cor(type_counts, dims, method = "spearman"), 2))

cat("\n== Spearman correlations: type counts vs geometric antinomy scores ==\n")
wcols <- ant[, c("W1", "W2", "W3", "W_tot")]
print(round(cor(type_counts, wcols, method = "spearman"), 2))

# --- 5. manuscript table and figures -------------------------------------------
library(ggplot2)
library(ggrepel)
ant$n_complex <- type_counts$n_complex

# table: Spearman correlations of type counts with MFA coords and antinomy scores
cm <- cor(type_counts, ant[, c("F1", "F2", "F3", "W1", "W2", "W3")],
          method = "spearman")
labs <- c("Simple taste ($+++$)", "Guilty pleasure ($++-$)",
          "Pre-acquired taste ($-++$)", "Taste pose ($+\\,-+$)",
          "Distanced consumption ($-+\\,-$)", "Justified abstention ($+\\,--$)",
          "Distant praise ($--+$)", "Simple non-taste ($---$)",
          "Total complex tastes")
fmt <- function(x) gsub("-", "$-$", sprintf("%.2f", x))
tl <- c(
  "\\begin{tabular}{lcccccc}", "\\toprule",
  " & \\multicolumn{3}{c}{MFA coordinates} & \\multicolumn{3}{c}{Complex-taste scores} \\\\",
  "\\cmidrule(lr){2-4}\\cmidrule(lr){5-7}",
  " & Dim 1 & Dim 2 & Dim 3 & $W_1$ & $W_2$ & $W_3$ \\\\", "\\midrule")
for (i in seq_len(nrow(cm))) {
  tl <- c(tl, paste0(labs[i], " & ", paste(fmt(cm[i, ]), collapse = " & "),
                     " \\\\"))
}
tl <- c(tl, "\\bottomrule", "\\end{tabular}")
writeLines(tl, "manuscript/tables/tab-antinomy.tex")

# figure: mean number of genres held in each configuration
cfg <- type_counts[, setdiff(names(type_counts), "n_complex")]
mc <- data.frame(type = names(colMeans(cfg)), mean = colMeans(cfg))
mc$complex <- !(mc$type %in% c("simple_pos", "simple_neg"))
mc$type <- factor(mc$type, levels = names(sort(colMeans(type_counts))))
p6 <- ggplot(mc, aes(type, mean, fill = complex)) +
  geom_col(color = "grey30", linewidth = 0.2) +
  scale_fill_manual(values = c(`FALSE` = "grey80", `TRUE` = "#D55E00"),
                    labels = c(`FALSE` = "Simple", `TRUE` = "Complex")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(x = NULL, y = "Mean number of genres per respondent", fill = NULL,
       title = "Taste portfolios: mean genres held in each of Ma's
       configurations") +
  theme_minimal(base_size = 10) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        panel.grid.minor = element_blank(),
        legend.position = "top")
ggsave("manuscript/figures/fig-configurations.pdf", p6, width = 5.5, height = 3.6)

# figure: individual map dim 2 x dim 3; the 20% most complex respondents
# (highest W1) highlighted over the full cloud. W1 is uncorrelated with
# these dimensions, so the highlighted points blanket the plane — the
# design makes that null pattern visible instead of fighting the overplotting
hi80 <- ant$W1 >= quantile(ant$W1, .8)
p7 <- ggplot(ant, aes(F2, F3)) +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60") +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  geom_point(data = ant[!hi80, ], color = "grey70", size = 0.6, alpha = 0.45) +
  geom_point(data = ant[hi80, ], aes(color = "Top 20% most complex (W1)"),
             size = 0.8, alpha = 0.75) +
  scale_color_manual(values = c("Top 20% most complex (W1)" = "#D95F02"),
                     name = NULL) +
  labs(x = "Dimension 2 (highbrow vs popular)", y = "Dimension 3 (status valuation)") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(), legend.position = "top")
ggsave("manuscript/figures/fig-antinomy-map.pdf", p7, width = 5.5, height = 4)

# figure: worked example — partial points of the example respondent.
# Two panels share the status-valuation axis (dim 3): left pairs it with
# the general-affirmation axis (dim 1), right with the highbrow-popular
# axis (dim 2, the plane of the paper's other maps). Respondent chosen
# as the highest-W3 respondent holding guilty-pleasure, taste-pose,
# and distant-praise configurations (author-approved example; original data row 362)
ex <- which(rownames(ant) == "362")
mods <- c("Preference", "Consumption", "Evaluation", "Global")
panes <- c("Dimension 1 (general affirmation)",
           "Dimension 2 (highbrow\u2013popular)")
exd <- do.call(rbind, lapply(seq_along(panes), function(s) {
  data.frame(
    modality = factor(mods, levels = mods),
    d = c(P[ex, s], C[ex, s], V[ex, s], F[ex, s]),
    d3 = c(P[ex, 3], C[ex, 3], V[ex, 3], F[ex, 3]),
    panel = factor(panes[s], levels = panes))
}))
segex <- do.call(rbind, lapply(seq_along(panes), function(s) {
  k <- 4 * (s - 1)
  data.frame(x = exd$d[k + 1:3], y = exd$d3[k + 1:3],
             xend = exd$d[k + 4], yend = exd$d3[k + 4],
             panel = exd$panel[k + 1])
}))
pex <- ggplot(exd, aes(d, d3, color = modality, shape = modality)) +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60") +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  geom_segment(data = segex, aes(x, y, xend = xend, yend = yend),
               linetype = "dashed", color = "grey55", linewidth = 0.4,
               inherit.aes = FALSE, show.legend = FALSE) +
  geom_point(size = 3, show.legend = FALSE) +
  geom_text_repel(aes(label = modality), size = 3, segment.color = NA,
                  show.legend = FALSE, box.padding = 0.6,
                  point.padding = 0.4, seed = 3) +
  facet_grid(. ~ panel, scales = "free_x") +
  scale_color_manual(values = c(Preference = "#0072B2", Consumption = "#D55E00",
                                Evaluation = "#009E73", Global = "black")) +
  scale_shape_manual(values = c(Preference = 16, Consumption = 17,
                                Evaluation = 15, Global = 18)) +
  labs(x = NULL, y = "Dimension 3 (status valuation)") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank())
ggsave("manuscript/figures/fig-worked-example.pdf", pex, width = 7, height = 3.8)

saveRDS(list(ant = ant, type_counts = type_counts),
        "output/antinomy_scores.rds")
cat("\nsaved output/antinomy_scores.rds\n")
cat("wrote manuscript/tables/tab-antinomy.tex and figures\n")
