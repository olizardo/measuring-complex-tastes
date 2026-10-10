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
# The partial points also decompose exactly over genres (each partial
# point is 3 * the sum of twenty per-genre contributions), which splits
# W_s into a genre-local dispersion part (omega) and a cross-genre
# coherence part (same disagreement direction repeated across genres).
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

# --- 3b. genre-level decomposition: localized antinomies vs coherence ---------
# Each partial point is exactly 3 * (sum over genres of per-genre
# contributions): c_ighs = Delta_ghs * (z_igh - p_gh), with z the binary
# indicator, p its margin, and Delta = (w_yes * V_yes - w_no * V_no) /
# sqrt(p * (1 - p)) taken from the global PCA (column weights w and
# loadings V satisfy F = X %*% diag(w) %*% V). Deviating each genre's
# three aspect contributions from their three-aspect mean gives
# d_ighs, and W_s(i) = sum_g omega_s(i;g) + 18 sum_{g<g'} sum_h
# d_ighs d_ig'hs, with omega_s(i;g) = 9 sum_h d_ighs^2 the genre-local
# complex-taste score and the second term the cross-genre coherence.

gp <- res$global.pca
w  <- gp$call$col.w
Vl <- gp$svd$V[, seq_len(NDIM)]
enm <- paste0(rep(c("pref", "cons", "eval"), each = 40),
              "_", rep(genres, each = 2, times = 3), "_", rep(0:1, times = 60))
stopifnot(identical(colnames(gp$call$X)[seq_along(enm)], enm))
Zb <- as.matrix(mfa_dat)
stopifnot(identical(colnames(Zb), paste0(rep(c("pref", "cons", "eval"), each = 20),
                                         "_", rep(genres, times = 3))))
pm <- colMeans(Zb)
stopifnot(all(pm > 0 & pm < 1))

Dcoef <- array(0, c(20, 3, NDIM))
Ccont <- array(0, c(nrow(Zb), 20, 3, NDIM))
for (h in 1:3) for (g in 1:20) {
  j1 <- 2 * (20 * (h - 1) + g)
  p  <- pm[20 * (h - 1) + g]
  Dcoef[g, h, ] <- (w[j1] * Vl[j1, ] - w[j1 - 1] * Vl[j1 - 1, ]) /
                   sqrt(p * (1 - p))
  Ccont[, g, h, ] <- (Zb[, 20 * (h - 1) + g] - p) %*% t(Dcoef[g, h, ])
}
cat("\n== Genre-level decomposition: exactness checks ==\n")
cat("max |sum of 60 genre-aspect contributions - global coord| :",
    max(abs(apply(Ccont, c(1, 4), sum) - F)), "\n")
blk <- apply(Ccont, c(1, 3, 4), sum)
cat("max |3 * block sum - partial point| :",
    max(abs(3 * blk[, 1, ] - P), abs(3 * blk[, 2, ] - C),
        abs(3 * blk[, 3, ] - V)), "\n")

migs <- apply(Ccont, c(1, 2, 4), mean)
Cdev <- Ccont
for (h in 1:3) Cdev[, , h, ] <- Ccont[, , h, ] - migs
omega <- 9 * apply(Cdev^2, c(1, 2, 4), sum)   # n x 20 x NDIM genre-local scores
Wloc  <- apply(omega, c(1, 3), sum)           # localized part of W
coh   <- W - Wloc                             # cross-genre coherence part

# brute-force check of the decomposition on a few respondents
chk  <- c(1, nrow(Zb) %/% 2, nrow(Zb))
bmax <- 0
for (i in chk) for (s in 1:NDIM) {
  G  <- Cdev[i, , , s]
  d2 <- rowSums(G^2)
  bmax <- max(bmax, abs(sum(9 * d2) + 9 * (sum(G %*% t(G)) - sum(d2)) - W[i, s]))
}
cat("max |brute-force (sum_g omega + coherence) - W| :", bmax, "\n")

# configuration held in each genre x respondent cell (rows in mfa_dat order)
cell_cfg <- matrix("simple_neg", nrow(Zb), 20, dimnames = list(NULL, genres))
pp <- Zb[, 1:20] == 1; cc <- Zb[, 21:40] == 1; vv <- Zb[, 41:60] == 1
cell_cfg[pp &  cc &  vv] <- "simple_pos"
cell_cfg[pp &  cc & !vv] <- "guilty"
cell_cfg[!pp & cc &  vv] <- "preacquired"
cell_cfg[pp & !cc &  vv] <- "pose"
cell_cfg[!pp & cc & !vv] <- "distanced"
cell_cfg[pp & !cc & !vv] <- "justified"
cell_cfg[!pp & !cc & vv] <- "distant"
stopifnot(all(sapply(setdiff(types, "n_complex"),
                     function(t) sum(cell_cfg == t) == sum(type_counts[[t]]))))

ant$Wloc1 <- Wloc[, 1]; ant$Wloc2 <- Wloc[, 2]; ant$Wloc3 <- Wloc[, 3]
ant$coh1  <- coh[, 1];  ant$coh2  <- coh[, 2];  ant$coh3  <- coh[, 3]

cat("\n== Localized antinomy vs cross-genre coherence (means) ==\n")
sm <- round(rbind(W = colMeans(W), localized = colMeans(Wloc),
                  coherence = colMeans(coh)), 2)
colnames(sm) <- paste0("dim", 1:NDIM)
print(sm)
ncc <- type_counts$n_complex
cat("corr(n_complex, W):    ", round(c(cor(ncc, W), total = cor(ncc, rowSums(W))), 3), "\n")
cat("corr(n_complex, Wloc): ", round(c(cor(ncc, Wloc), total = cor(ncc, rowSums(Wloc))), 3), "\n")
cat("bottom-third W3 but top-third localized:",
    sum(W[, 3] < quantile(W[, 3], 1 / 3) & Wloc[, 3] > quantile(Wloc[, 3], 2 / 3)), "\n")

exi <- which(rownames(ant) == "362")
cat("\n== Worked example (respondent 362): local vs coherence ==\n")
cat("W:", round(W[exi, ], 1), "| localized:", round(Wloc[exi, ], 1),
    "| coherence:", round(coh[exi, ], 1), "\n")
o <- order(-omega[exi, , 3])
print(data.frame(genre = genres[o], config = cell_cfg[exi, o],
                 omega3 = round(omega[exi, o, 3], 2))[1:5, ])

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

# table: Spearman correlations of type counts with MFA coords,
# aspect-disagreement scores, and genre-based complex-taste components
cm <- cor(type_counts, ant[, c("F1", "F2", "F3", "W1", "W2", "W3",
                               "Wloc1", "Wloc2", "Wloc3")],
          method = "spearman")
labs <- c("Simple taste ($+++$)", "Guilty pleasure ($++-$)",
          "Pre-acquired taste ($-++$)", "Taste pose ($+\\,-+$)",
          "Distanced consumption ($-+\\,-$)", "Justified abstention ($+\\,--$)",
          "Distant praise ($--+$)", "Simple non-taste ($---$)",
          "Total complex tastes")
fmt <- function(x) gsub("-", "$-$", sprintf("%.2f", x))
tl <- c(
  "\\footnotesize", "\\setlength{\\tabcolsep}{2pt}",
  "\\begin{tabular}{lccccccccc}", "\\toprule",
  " & \\multicolumn{3}{c}{MFA coordinates} & \\multicolumn{3}{c}{Aspect-disagreement} & \\multicolumn{3}{c}{Genre-based complex taste} \\\\",
  "\\cmidrule(lr){2-4}\\cmidrule(lr){5-7}\\cmidrule(lr){8-10}",
  " & Dim 1 & Dim 2 & Dim 3 & $W_1$ & $W_2$ & $W_3$ & $\\omega_1$ & $\\omega_2$ & $\\omega_3$ \\\\", "\\midrule")
for (i in seq_len(nrow(cm))) {
  tl <- c(tl, paste0(labs[i], " & ", paste(fmt(cm[i, ]), collapse = " & "),
                     " \\\\"))
}
tl <- c(tl, "\\bottomrule", "\\end{tabular}")
writeLines(tl, "manuscript/tables/tab-antinomy.tex")

# table: mean squared pairwise distances between partial points, dims 1-3
pcols <- c("dPC1", "dPV1", "dCV1", "dPC2", "dPV2", "dCV2", "dPC3", "dPV3", "dCV3")
pm  <- matrix(colMeans(ant[, pcols]), nrow = 3,
              dimnames = list(c("pc", "pe", "ce"), c("dim1", "dim2", "dim3")))
psh <- sweep(pm, 2, colSums(pm), "/")
print(round(pm, 2))
print(round(psh, 3))
plabs <- c("Preference--consumption", "Preference--evaluation",
           "Consumption--evaluation")
tlp <- c("\\begin{tabular}{lccc}", "\\toprule",
         " & Dim 1 & Dim 2 & Dim 3 \\\\", "\\midrule")
for (k in seq_len(3)) {
  cells <- sprintf("%.2f~(%.0f\\%%)", pm[k, ], 100 * psh[k, ])
  tlp <- c(tlp, paste0(plabs[k], " & ", paste(cells, collapse = " & "), " \\\\"))
}
tlp <- c(tlp, "\\midrule",
         paste0("$H \\cdot W_s$ (total) & ",
                paste(sprintf("%.1f", colSums(pm)), collapse = " & "), " \\\\"),
         "\\bottomrule", "\\end{tabular}")
writeLines(tlp, "manuscript/tables/tab-pairs.tex")

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
             modality = exd$modality[k + 1:3],
             panel = exd$panel[k + 1])
}))
pex <- ggplot(exd, aes(d, d3, color = modality, shape = modality)) +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60") +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  # solid connectors colored by aspect, as in fig-genre-map
  geom_segment(data = segex, aes(x, y, xend = xend, yend = yend, color = modality),
               linewidth = 0.5, alpha = 0.7,
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
  theme(panel.grid = element_blank())
ggsave("manuscript/figures/fig-worked-example.pdf", pex, width = 7, height = 3.8)

saveRDS(list(ant = ant, type_counts = type_counts, omega = omega,
             cell_cfg = cell_cfg, Dcoef = Dcoef),
        "output/antinomy_scores.rds")
cat("\nsaved output/antinomy_scores.rds\n")
cat("wrote manuscript/tables/tab-antinomy.tex and figures\n")
