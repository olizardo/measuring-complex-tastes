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
passive_ids <- readRDS("output/passive_ids.rds")
active_ids <- setdiff(rownames(mfa_dat), passive_ids)
# main fit treats straightliners as supplementary individuals: their partial
# points are projections (ind.sup$coord.partiel), on the same scale and with
# the same per-genre decomposition, so all scores are computed for the full
# sample with a flag marking who was active in the construction.

genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop",
            "blurb", "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")

NDIM <- 4
flip <- c(-1, 1, 1, 1)  # same sign anchoring as script 02 (see there)

# --- 1. partial points by aspect (active + projected supplementary) -----------
cp <- rbind(res$ind$coord.partiel, res$ind.sup$coord.partiel)
id  <- sub("\\..*", "", rownames(cp))
grp <- sub(".*\\.", "", rownames(cp))
stopifnot(all(table(id) == 3))  # three stacked partial points per individual
# reorder stacked rows into mfa_dat row order (P, C, E within each id)
sp <- split(seq_along(id), id)
ord <- unlist(sp[rownames(mfa_dat)], use.names = FALSE)
stopifnot(length(ord) == 3 * nrow(mfa_dat))
cp <- cp[ord, , drop = FALSE]
id <- id[ord]; grp <- grp[ord]
stopifnot(identical(id, rep(rownames(mfa_dat), each = 3)))

P <- cp[grp == "Preference", 1:NDIM, drop = FALSE]
C <- cp[grp == "Consumption", 1:NDIM, drop = FALSE]
V <- cp[grp == "Evaluation", 1:NDIM, drop = FALSE]
colnames(P) <- colnames(C) <- colnames(V) <- paste0("Dim", 1:NDIM)
F <- rbind(res$ind$coord, res$ind.sup$coord)[rownames(mfa_dat), 1:NDIM, drop = FALSE]

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
  F1 = F[, 1], F2 = F[, 2], F3 = F[, 3], F4 = F[, 4],
  T1 = Tt[, 1], T2 = Tt[, 2], T3 = Tt[, 3], T4 = Tt[, 4],
  W1 = W[, 1], W2 = W[, 2], W3 = W[, 3], W4 = W[, 4],
  dPC1 = dPC[, 1], dPV1 = dPV[, 1], dCV1 = dCV[, 1],
  dPC2 = dPC[, 2], dPV2 = dPV[, 2], dCV2 = dCV[, 2],
  dPC3 = dPC[, 3], dPV3 = dPV[, 3], dCV3 = dCV[, 3],
  dPC4 = dPC[, 4], dPV4 = dPV[, 4], dCV4 = dCV[, 4]
)
ant$W_tot <- rowSums(W)
for (s in 1:NDIM) ant[[paste0("share", s)]] <- W[, s] / Tt[, s]
ant$active <- seq_len(nrow(mfa_dat)) %in% match(active_ids, rownames(mfa_dat))

# per-aspect decomposition of the score (Pages 2014, sec. 5.4): each
# aspect's partial point contributes its squared deviation from the
# global point; the three contributions sum to W_s
Wp <- (P - F)^2; Wc <- (C - F)^2; We <- (V - F)^2
stopifnot(max(abs(Wp + Wc + We - W)) < 1e-10)
for (s in 1:NDIM) {
  ant[[paste0("Wp", s)]] <- Wp[, s]
  ant[[paste0("Wc", s)]] <- Wc[, s]
  ant[[paste0("We", s)]] <- We[, s]
}

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
w  <- gp$call$col.w[seq_len(120)]
Vl <- as.matrix(gp$svd$V)[seq_len(120), seq_len(NDIM), drop = FALSE]
Vl <- sweep(Vl, 2, flip, "*")  # align loadings with script 02's sign anchoring
enm <- paste0(rep(c("pref", "cons", "eval"), each = 40),
              "_", rep(genres, each = 2, times = 3), "_", rep(0:1, times = 60))
stopifnot(identical(colnames(gp$call$X)[seq_along(enm)], enm))
Zb <- as.matrix(mfa_dat)
stopifnot(identical(colnames(Zb), paste0(rep(c("pref", "cons", "eval"), each = 20),
                                         "_", rep(genres, times = 3))))
# margins of the ACTIVE table (FactoMineR transforms supplementary rows with
# the same margins; verified numerically against global.pca$call$X)
pm <- colMeans(Zb[match(active_ids, rownames(mfa_dat)), ])
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
cat("\n== Genre-level decomposition: exactness checks (full sample incl. projections) ==\n")
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

for (s in 1:NDIM) {
  ant[[paste0("Wloc", s)]] <- Wloc[, s]
  ant[[paste0("coh", s)]]  <- coh[, s]
}

cat("\n== Localized antinomy vs cross-genre coherence (means) ==\n")
sm <- round(rbind(W = colMeans(W), localized = colMeans(Wloc),
                  coherence = colMeans(coh)), 2)
colnames(sm) <- paste0("dim", 1:NDIM)
print(sm)
ncc <- type_counts$n_complex
cat("corr(n_complex, W):    ",
    round(c(cor(ncc, W), total = cor(ncc, rowSums(W))), 3), "\n")
cat("corr(n_complex, Wloc): ",
    round(c(cor(ncc, Wloc), total = cor(ncc, rowSums(Wloc))), 3), "\n")
cat("bottom-third W4 but top-third localized:",
    sum(W[, 4] < quantile(W[, 4], 1 / 3) & Wloc[, 4] > quantile(Wloc[, 4], 2 / 3)), "\n")

exi <- which(rownames(ant) == "362")
cat("\n== Worked example (respondent 362): local vs coherence ==\n")
cat("W:", round(W[exi, ], 1), "| localized:", round(Wloc[exi, ], 1),
    "| coherence:", round(coh[exi, ], 1), "\n")
o <- order(-omega[exi, , 4])
print(data.frame(genre = genres[o], config = cell_cfg[exi, o],
                 omega4 = round(omega[exi, o, 4], 2))[1:5, ])
exi2 <- which(rownames(ant) == "1881")
cat("\n== Worked example (respondent 1881, supplementary): local vs coherence ==\n")
cat("W:", round(W[exi2, ], 1), "| localized:", round(Wloc[exi2, ], 1),
    "| coherence:", round(coh[exi2, ], 1), "\n")

# --- 4. relate antinomy scores and type counts to the MFA ----------------------
cat("\n== Distribution of configurations (per genre x respondent) ==\n")
print(round(colMeans(type_counts), 2))
cat("total complex tastes per respondent: mean",
    round(mean(type_counts$n_complex), 2), "\n")
cat("respondents with zero complex tastes:",
    sum(type_counts$n_complex == 0), "\n")

cat("\n== Geometric antinomy scores: summary ==\n")
print(round(summary(ant$W4), 3))
cat("mean disagreement share of partial inertia by dimension:\n")
print(round(colMeans(ant[, paste0("share", 1:NDIM)]), 3))

wshare <- function(s) {
  round(c(mean(ant[[paste0("Wp", s)]]), mean(ant[[paste0("Wc", s)]]),
          mean(ant[[paste0("We", s)]])) / mean(ant[[paste0("W", s)]]), 3)
}
cat("mean per-aspect shares of W_s (pref/cons/eval):\n")
print(rbind(dim1 = wshare(1), dim2 = wshare(2), dim3 = wshare(3), dim4 = wshare(4)))

cat("\n== Pair-level disagreement, dim 4 (correlations with dims) ==\n")
print(round(cor(ant[, c("dPC4", "dPV4", "dCV4")],
                ant[, paste0("F", 1:NDIM)], method = "spearman"), 2))

cat("\n== Spearman correlations: type counts vs MFA dimensions ==\n")
dims <- ant[, paste0("F", 1:NDIM)]
print(round(cor(type_counts, dims, method = "spearman"), 2))

cat("\n== Spearman correlations: type counts vs geometric antinomy scores ==\n")
wcols <- ant[, c(paste0("W", 1:NDIM), "W_tot")]
print(round(cor(type_counts, wcols, method = "spearman"), 2))

# --- 5. manuscript table and figures -------------------------------------------
library(ggplot2)
library(ggrepel)
ant$n_complex <- type_counts$n_complex

# figure: genre-specific tri-segment maps (kept in repo, not referenced in
# main.tex). For each genre, each aspect's yes and no answers place the
# respondent at the two endpoints of a segment in complex taste space,
# c_yes = Dcoef_ghs * (1 - p) and c_no = -Dcoef_ghs * p, so the mass-weighted
# barycenter sits at 0 and rare answers move further. Facets run down the
# highbrow-popular rung; arrows point toward the yes endpoint.
glab <- c("Classical", "Opera", "Jazz", "Broadway/Show", "Mood/Easy",
          "Big Band", "Classic Rock/Oldies", "Country", "Bluegrass", "Folk",
          "Hymns/Gospel", "Latin/Spanish/Salsa", "Rap/Hip-Hop", "Blues/R&B",
          "Reggae", "Top 40/Pop", "Contemporary Rock", "Indie/Alt Rock",
          "Dance/Club", "Heavy Metal")
stopifnot(length(glab) == length(genres))
rung  <- sapply(1:20, function(g)
  (Dcoef[g, 1, 1] * (1 - pm[g]) + Dcoef[g, 2, 1] * (1 - pm[20 + g])) / 2)
ord   <- order(-rung)
segdf <- do.call(rbind, lapply(ord, function(g) {
  pgh <- pm[c(g, 20 + g, 40 + g)]
  do.call(rbind, lapply(1:3, function(h) do.call(rbind, lapply(seq_len(NDIM), function(s) {
    data.frame(genre  = factor(glab[g], levels = glab[ord]),
               aspect = c("Preference", "Consumption", "Evaluation")[h],
               s = s,
               no  = -Dcoef[g, h, s] * pgh[h],
               yes =  Dcoef[g, h, s] * (1 - pgh[h]))
  }))))
}))
segdf$off <- unname(c(Preference = -0.24, Consumption = 0,
                      Evaluation = 0.24)[segdf$aspect])
lim  <- 1.08 * max(abs(c(segdf$no, segdf$yes)))
pseg <- ggplot(segdf) +
  geom_hline(yintercept = 0, color = "grey65", linewidth = 0.3) +
  geom_segment(aes(x = s + off, y = no, xend = s + off, yend = yes, color = aspect),
               linewidth = 0.8,
               arrow = arrow(length = unit(0.055, "in"), type = "closed")) +
  geom_point(aes(x = s + off, y = yes, color = aspect), size = 0.9,
             show.legend = FALSE) +
  scale_x_continuous(breaks = 1:4,
                     labels = c("Highbrow\u2013popular", "Volume",
                                "Engagement divide", "Status valuation")) +
  scale_y_continuous(limits = c(-lim, lim)) +
  scale_color_manual(values = c(Preference = "#0072B2", Consumption = "#D55E00",
                                Evaluation = "#009E73"), name = NULL) +
  facet_wrap(~genre, ncol = 5) +
  labs(x = NULL, y = "Contribution to the global position") +
  theme_minimal(base_size = 9) +
  theme(panel.grid.minor = element_blank(), legend.position = "bottom")
ggsave("manuscript/figures/fig-genre-segments.pdf", pseg, width = 10, height = 8)

# figure: geometric signatures of the configurations — Spearman
# correlations of the type counts with MFA coordinates,
# aspect-disagreement scores, and genre-based complex taste, as a signed
# heatmap (replaces the former tab-antinomy table). Rows are grouped by
# which aspect stands against the other two (evaluation-odd, consumption-
# odd, liking-odd), with the simple tastes and the total detached.
cm <- cor(type_counts, ant[, c(paste0("F", 1:NDIM), paste0("W", 1:NDIM),
                               paste0("Wloc", 1:NDIM), paste0("coh", 1:NDIM))],
          method = "spearman")
sigrows <- data.frame(
  key = c("guilty", "distant", "pose", "distanced", "preacquired",
          "justified", "", "simple_pos", "simple_neg", "", "n_complex"),
  # the blank separator rows need distinct labels to be distinct factor
  # levels — one and two spaces render blank on the axis
  lab = c("Guilty pleasure (++-)", "Distant praise (--+)",
          "Taste pose (+-+)", "Distanced consumption (-+-)",
          "Pre-acquired taste (-++)", "Justified abstention (+--)",
          " ", "Simple taste (+++)", "Simple non-taste (---)",
          "  ", "Total complex tastes"))
scols <- as.vector(t(outer(1:NDIM, c("F", "W", "Wloc", "coh"),
                           function(s, p) paste0(p, s))))
skeys <- paste0(rep(1:NDIM, each = 4), ".", rep(c("F", "W", "O", "G"), NDIM))
# labels are looked up by key, so they cannot drift out of step with the columns
score_label <- function(x) as.expression(lapply(x, function(k) {
  s <- as.integer(sub("\\..*", "", k))
  switch(sub(".*\\.", "", k), F = bquote(F[.(s)]), W = bquote(W[.(s)]),
         O = bquote(omega[.(s)]), G = bquote(gamma[.(s)]))
}))
ncol_sig <- 4 * NDIM
sig <- do.call(rbind, lapply(seq_len(nrow(sigrows)), function(r) {
  v <- if (sigrows$key[r] == "") rep(NA_real_, ncol_sig) else
    as.numeric(cm[sigrows$key[r], scols])
  data.frame(cfg = sigrows$lab[r], score = skeys, value = v)
}))
sig$cfg <- factor(sig$cfg, levels = rev(sigrows$lab))
sig$dim <- factor(rep(paste0("Dimension ", 1:NDIM),
                     each = 4, times = nrow(sigrows)),
                  levels = paste0("Dimension ", 1:NDIM))
sig$score <- factor(sig$score, levels = skeys)
psig <- ggplot(sig, aes(score, cfg, fill = value)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = ifelse(is.na(value), "", sprintf("%.2f", value)),
                color = abs(value) > 0.55), size = 3,
            show.legend = FALSE) +
  scale_color_manual(values = c(`FALSE` = "grey20", `TRUE` = "white"),
                     na.value = "grey20") +
  # same diverging scale as the omega-demographics matrices (script 09):
  # grey92 midpoint so near-zero cells read as tiles, colorbar legend below
  scale_fill_gradient2(low = "#A63603", mid = "grey92", high = "#08519C",
                       midpoint = 0, limits = c(-1, 1),
                       breaks = seq(-1, 1, 0.5), na.value = "white",
                       name = expression(rho),
                       guide = guide_colourbar(barwidth = 7, barheight = 0.8)) +
  scale_x_discrete(labels = score_label) +
  # free_x is required: each facet holds only its dimension's 4 scores,
  # otherwise all 9 x-levels appear in every panel and squeeze the tiles
  facet_wrap(~ dim, nrow = 1, scales = "free_x") +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 10) +
  theme(panel.grid = element_blank(), legend.position = "bottom",
        strip.text = element_text(face = "bold"),
        legend.title = element_text(size = 9),
        legend.text = element_text(size = 8))
ggsave("manuscript/figures/fig-signatures.pdf", psig, width = 10.5, height = 3.8)

# table: mean squared pairwise distances between partial points, dims 1-4;
# shares = each respondent's pair distance over their own dimension total
# (sum of the three pairs), averaged across respondents
pcols <- as.vector(t(outer(1:NDIM, c("dPC", "dPV", "dCV"),
                           function(s, p) paste0(p, s))))
pmm <- matrix(colMeans(ant[, pcols]), nrow = 3,
              dimnames = list(c("pc", "pe", "ce"), paste0("dim", 1:NDIM)))
psh <- sapply(1:NDIM, function(s) {
  d <- as.matrix(ant[, paste0(c("dPC", "dPV", "dCV"), s)])
  colMeans(sweep(d, 1, rowSums(d), "/"))
})
dimnames(psh) <- dimnames(pmm)
print(round(pmm, 2))
print(round(psh, 3))
plabs <- c("Preference--consumption", "Preference--evaluation",
           "Consumption--evaluation")
tlp <- c("\\begin{tabular}{lccccc}", "\\toprule",
         paste0(" & ", paste(paste0("Dim ", 1:NDIM), collapse = " & "),
                " \\\\"), "\\midrule")
for (k in seq_len(3)) {
  cells <- sprintf("%.2f~(%.0f\\%%)", pmm[k, ], 100 * psh[k, ])
  tlp <- c(tlp, paste0(plabs[k], " & ", paste(cells, collapse = " & "), " \\\\"))
}
tlp <- c(tlp, "\\midrule",
         paste0("$H \\cdot W_s$ (total) & ",
                paste(sprintf("%.1f", colSums(pmm)), collapse = " & "), " \\\\"),
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

# figure: individual map dim 1 x dim 4; the 20% most complex respondents
# (highest W1) highlighted over the full cloud (UNREFERENCED in main.tex).
hi80 <- ant$W1 >= quantile(ant$W1, .8)
p7 <- ggplot(ant, aes(F1, F4)) +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60") +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  geom_point(data = ant[!hi80, ], color = "grey70", size = 0.6, alpha = 0.45) +
  geom_point(data = ant[hi80, ], aes(color = "Top 20% most complex (W1)"),
             size = 0.8, alpha = 0.75) +
  scale_color_manual(values = c("Top 20% most complex (W1)" = "#D95F02"),
                     name = NULL) +
  labs(x = "Dimension 1 (highbrow vs popular)",
       y = "Dimension 4 (status valuation)") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(), legend.position = "top")
ggsave("manuscript/figures/fig-antinomy-map.pdf", p7, width = 5.5, height = 4)

# figure: worked examples — partial points of two contrasting respondents,
# used as running examples throughout Section "Measuring Complex Tastes
# Geometrically". Both respondents are plotted in the SAME space, one
# panel per plane: left pairs the status-valuation axis (dim 4, vertical
# in both panels) with the highbrow-popular axis (dim 1, the horizontal
# axis of the paper's first category map), right with the volume axis
# (dim 2). Color distinguishes respondents and shape marks the aspect,
# so the distance between the two respondents — and the orientation of
# each one's aspect triangle — is directly visible. The y scale is
# shared across panels (both planes use dim 4); only x is free.
# NOTE: 1881 is a supplementary (projected) individual in the main fit —
# their partial points come from ind.sup$coord.partiel.
#   362: high engagement + generous valuation (likes 15, listens 9,
#        grants 18); high-W4 respondent holding guilty-pleasure,
#        taste-pose, and distant-praise configurations.
#   1881: high engagement + withholding valuation (likes 14, listens 13,
#        grants none); nearly the same rung as 362 on dim 1, reached by
#        opposite materials.
exr <- c("362", "1881")
rlab <- c("362: grants 18 of 20", "1881: grants none")
ex <- match(exr, rownames(ant))
stopifnot(!any(is.na(ex)))
mods <- c("Preference", "Consumption", "Evaluation", "Global")
pane_dims <- c(1, 2)  # x-dimension of each panel (y is always dim 4)
panes <- c("Dimension 1 (highbrow\u2013popular)",
           "Dimension 2 (volume)")
exd <- do.call(rbind, lapply(seq_along(ex), function(r) {
  do.call(rbind, lapply(seq_along(panes), function(s) {
    data.frame(
      respondent = factor(rlab[r], levels = rlab),
      aspect = factor(mods, levels = mods),
      d = c(P[ex[r], pane_dims[s]], C[ex[r], pane_dims[s]],
            V[ex[r], pane_dims[s]], F[ex[r], pane_dims[s]]),
      d4 = c(P[ex[r], 4], C[ex[r], 4], V[ex[r], 4], F[ex[r], 4]),
      panel = factor(panes[s], levels = panes))
  }))
}))
# each (respondent, panel) block holds 3 partial points then the global
segex <- do.call(rbind, lapply(split(exd, interaction(exd$respondent,
                                                     exd$panel, drop = TRUE)),
                               function(b) {
  data.frame(x = b$d[1:3], y = b$d4[1:3],
             xend = b$d[4], yend = b$d4[4],
             respondent = b$respondent[1], panel = b$panel[1])
}))
# overplotting fix: the two respondents nearly coincide near the origin of
# the right panel (their preference/consumption partials and globals all sit
# at x ~ 3-3.5, y ~ -1-0). Orange (1881) is drawn HOLLOW (fill = NA, colored
# outline) so coincident blue points remain visible; blue (362) is solid.
# Requires fill-capable shapes (21/22/23/24), which also keeps the
# aspect-shape encoding unchanged.
pex <- ggplot(exd, aes(d, d4, color = respondent, fill = respondent, shape = aspect)) +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60", linewidth = 0.3) +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60", linewidth = 0.3) +
  # solid connectors colored by respondent, linking partials to the global
  geom_segment(data = segex,
               aes(x, y, xend = xend, yend = yend, color = respondent),
               linewidth = 0.6, alpha = 0.8,
               inherit.aes = FALSE, show.legend = FALSE) +
  geom_point(size = 3.6, stroke = 0.7) +
  geom_text_repel(aes(label = aspect), size = 3, segment.color = NA,
                  show.legend = FALSE, box.padding = 0.6,
                  point.padding = 0.4, seed = 3, fontface = "bold") +
  facet_wrap(~panel, scales = "free_x", nrow = 1) +
  scale_color_manual(values = c("#0072B2", "#D55E00"), name = "Respondent") +
  scale_fill_manual(values = c("#0072B2", NA), guide = "none") +
  scale_shape_manual(values = c(Preference = 21, Consumption = 24,
                                Evaluation = 22, Global = 23),
                     name = "Aspect") +
  # fill-capable shapes render hollow legend keys (fill guide is suppressed);
  # override back to the solid black keys of the previous version
  guides(shape = guide_legend(override.aes = list(fill = "black", color = "black"))) +
  labs(x = NULL, y = "Dimension 4 (status valuation)") +
  theme_minimal(base_size = 11) +
  theme(panel.grid = element_blank(),
        strip.text = element_text(face = "bold", size = 10),
        axis.text = element_text(size = 9),
        legend.position = "top",
        legend.title = element_text(size = 9, face = "bold"),
        legend.text = element_text(size = 9),
        axis.title.y = element_text(size = 10, face = "bold"))
ggsave("manuscript/figures/fig-worked-example.pdf", pex, width = 9, height = 4.5)

saveRDS(list(ant = ant, type_counts = type_counts, omega = omega,
             cell_cfg = cell_cfg, Dcoef = Dcoef),
        "output/antinomy_scores.rds")
cat("\nsaved output/antinomy_scores.rds\n")

## fig-config-variation: within-configuration variation in the W scores
## (appendix app:config-variation)
cfg_cols <- c("simple_pos", "guilty", "preacquired", "pose", "distanced",
              "justified", "distant", "simple_neg")
cfg_labs <- c(simple_pos = "Simple taste", guilty = "Guilty pleasure",
              preacquired = "Pre-acquired taste", pose = "Taste pose",
              distanced = "Distanced consumption", justified = "Justified abstention",
              distant = "Distant praise", simple_neg = "Simple non-taste")
dim_labs <- c(W1 = "Highbrow vs popular", W2 = "Volume",
              W3 = "Engagement divide", W4 = "Status valuation")
cv <- do.call(rbind, lapply(cfg_cols, function(cl) {
  hold <- type_counts[[cl]] > 0
  cbind(config = cfg_labs[cl],
        do.call(rbind, lapply(paste0("W", 1:4), function(w)
          data.frame(dim = dim_labs[w],
                     mean = mean(ant[[w]][hold]),
                     sd = sd(ant[[w]][hold])))))
}))
cv$config <- factor(cv$config, levels = unname(cfg_labs))
cv$dim <- factor(cv$dim, levels = unname(dim_labs))
pcv <- ggplot(cv, aes(config, mean)) +
  geom_col(fill = "grey60", color = "grey30", linewidth = 0.3) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),
                width = 0.35, linewidth = 0.5) +
  facet_wrap(~ dim, ncol = 2, scales = "free_x") +
  labs(x = NULL, y = "Mean aspect-disagreement score") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
        strip.text = element_text(face = "bold", size = 10))
ggsave("manuscript/figures/fig-config-variation.pdf", pcv, width = 9, height = 7)
cat("wrote fig-config-variation\n")

cat("wrote manuscript tables and figures\n")
