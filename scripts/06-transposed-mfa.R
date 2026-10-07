# 06-transposed-mfa.R
# The duality: genres as TARGETS of complex tastes.
#
# Transposed MFA: individuals = 20 genres; each modality group contains one
# binary variable per respondent (did respondent i like / listen to /
# attribute conjunctive high status to this genre). Groups remain the
# modalities, so the transposed analysis asks the same structural questions
# from the object side.
#
# Implementation: FactoMineR::MFA exhausts memory at this size (6,700+
# factor columns), so the MFA is implemented directly following the
# algorithm in Pagès (2014), replicating FactoMineR's exact construction
# for qualitative groups (transformed indicator table, ponderation
# weights, partial points, Lg/RV). The implementation is VALIDATED against
# the FactoMineR run of the respondent-level analysis (output/mfa_results.rds):
# eigenvalues, global coordinates, partial points, RV coefficients and
# group contributions reproduce to < 1e-2 (see VALIDATION below).
#
# Respondents whose answers are constant across all 20 genres within a
# modality (e.g., attribute high status to no genre) define variables with
# an empty category: zero inertia, no genre discrimination. They are
# dropped from the transposed groups; genre geometry is unchanged (their
# categories sit at the origin of the transformed space).

genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop",
            "blurb", "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")
gname3 <- c("Preference", "Consumption", "Evaluation")

# --- core: exact FactoMineR MFA construction for binary groups -----------------
mca_lambda1 <- function(X) {
  # first eigenvalue of the MCA of X (n x J binary), = sigma^2 of the CA of
  # the complete disjunctive table (validated: reproduces FactoMineR$eig)
  n <- nrow(X); J <- ncol(X)
  Z <- cbind(X, 1 - X)
  P <- Z / (n * J)
  p <- rowSums(P); q <- colSums(P)
  S <- (P - outer(p, q)) / sqrt(outer(p, q))
  svd(S)$d[1]^2
}

build_TW <- function(Zg, lambda1g) {
  # transformed indicator table and ponderation weights (FactoMineR MFA, type "n")
  m <- colMeans(Zg)
  Tg <- sweep(sweep(Zg, 2, m, "-"), 2, sqrt(m * (1 - m)), "/")
  w  <- (1 - m) / (lambda1g * (ncol(Zg) / 2))
  list(T = Tg, w = w)
}

mfa_manual <- function(Xlist, ncp = 5) {
  # Xlist: list of n x J binary matrices, one per group
  H <- length(Xlist)
  l1 <- sapply(Xlist, mca_lambda1)
  TW <- Map(build_TW,
            lapply(Xlist, function(X) cbind(X, 1 - X)), l1)
  Tall <- do.call(cbind, lapply(TW, `[[`, "T"))
  wall <- do.call(c, lapply(TW, `[[`, "w"))
  Tw <- sweep(Tall, 2, sqrt(wall), "*")
  sv <- svd(Tw)
  ncp <- min(ncp, ncol(Tall) - 1)
  lam <- sv$d[1:ncp]^2 / nrow(Tall)
  Fglob <- sv$u[, 1:ncp] %*% diag(sv$d[1:ncp])          # global coordinates
  colbounds <- cumsum(sapply(Xlist, ncol) * 2)
  starts <- c(1, colbounds[-length(colbounds)] + 1)
  Fpart <- lapply(seq_len(H), function(h) {             # partial points
    # axes in the original column metric: v_raw / sqrt(w) (FactoMineR svd$V)
    cols <- starts[h]:colbounds[h]
    H * (sweep(Tall[, cols], 2, sqrt(wall[cols]), "*") %*% sv$v[cols, 1:ncp])
  })
  funcLg <- function(x, y, px, py) {                    # verbatim funcLg (Gram form)
    xc <- sweep(x, 2, colMeans(x), "-") * rep(sqrt(px), each = nrow(x))
    yc <- sweep(y, 2, colMeans(y), "-") * rep(sqrt(py), each = nrow(y))
    sum(tcrossprod(xc) * tcrossprod(yc))
  }
  Lg <- matrix(NA, H, H)
  for (i in seq_len(H)) for (j in seq_len(H))
    Lg[i, j] <- funcLg(TW[[i]]$T, TW[[j]]$T, TW[[i]]$w, TW[[j]]$w)
  RV <- sweep(sweep(Lg, 2, sqrt(diag(Lg)), "/"), 1, sqrt(diag(Lg)), "/")
  contrib <- sapply(seq_len(H), function(h)
    100 * colSums(sv$v[starts[h]:colbounds[h], 1:ncp]^2))
  list(eig = lam, Fglob = Fglob, Fpart = Fpart, RV = RV, Lg = Lg,
       contrib = contrib, lambda1 = l1, sv = sv, wall = wall,
       colbounds = colbounds, starts = starts)
}

# --- data ----------------------------------------------------------------------
md <- readRDS("data/mfa_input.rds")

# per-genre configuration rates (Ma's eight types), all 2,259 respondents
types <- c("simple_pos", "guilty", "preacquired", "pose",
           "distanced", "justified", "distant", "simple_neg")
cfg <- sapply(genres, function(g) {
  p <- md[[paste0("pref_", g)]]; c <- md[[paste0("cons_", g)]]
  v <- md[[paste0("eval_", g)]]
  c(simple_pos = mean(p & c & v), guilty = mean(p & c & !v),
    preacquired = mean(!p & c & v), pose = mean(p & !c & v),
    distanced = mean(!p & c & !v), justified = mean(p & !c & !v),
    distant = mean(!p & !c & v), simple_neg = mean(!p & !c & !v))
})
rownames(cfg) <- types; colnames(cfg) <- genres

# drop constant respondent-variables per modality
keep <- function(pre) {
  M <- as.matrix(md[, grep(paste0("^", pre, "_"), names(md))])
  rs <- rowSums(M); rs > 0 & rs < 20
}
kp <- keep("pref"); kc <- keep("cons"); kv <- keep("eval")
cat("respondent-variables kept: pref", sum(kp), "cons", sum(kc),
    "eval", sum(kv), "of", nrow(md), "\n")

Xt_list <- list(
  Preference  = t(md[kp, paste0("pref_", genres)]),
  Consumption = t(md[kc, paste0("cons_", genres)]),
  Evaluation  = t(md[kv, paste0("eval_", genres)]))

# --- VALIDATION against FactoMineR (respondent-level analysis) ------------------
res_ref <- readRDS("output/mfa_results.rds")
Xo_list <- list(
  Preference  = as.matrix(md[, paste0("pref_", genres)]),
  Consumption = as.matrix(md[, paste0("cons_", genres)]),
  Evaluation  = as.matrix(md[, paste0("eval_", genres)]))
mo <- mfa_manual(Xo_list)
d_eig  <- max(abs(mo$eig - res_ref$eig[1:5, 1]))
d_glob <- max(abs(sweep(mo$Fglob, 2, sign(colSums(mo$Fglob * res_ref$ind$coord[, 1:5])), "*")
                  - res_ref$ind$coord[, 1:5]))
d_rv   <- max(abs(mo$RV - res_ref$group$RV[1:3, 1:3]))
d_ctb  <- max(abs(mo$contrib - t(res_ref$group$contrib[1:3, 1:5])))
rn0 <- rownames(res_ref$ind$coord.partiel)
d_part <- max(sapply(seq_along(gname3), function(h) {
  t0 <- res_ref$ind$coord.partiel[grepl(paste0("\\.", gname3[h], "$"), rn0), 1:5]
  max(abs(sweep(mo$Fpart[[h]], 2,
                sign(colSums(mo$Fpart[[h]] * t0)), "*") - t0))
}))
cat(sprintf("VALIDATION vs FactoMineR: eig %.2e | coords %.2e | partials %.2e | RV %.2e | contrib %.2e\n",
            d_eig, d_glob, d_part, d_rv, d_ctb))
stopifnot(d_eig < 1e-3, d_glob < 1e-2, d_part < 1e-2, d_rv < 1e-3, d_ctb < 1e-3)

# --- transposed MFA --------------------------------------------------------------
mt <- mfa_manual(Xt_list)
rownames(mt$Fglob) <- genres
for (h in seq_along(gname3)) rownames(mt$Fpart[[h]]) <- genres
saveRDS(mt, "output/mfa_results_transposed.rds")

cat("\n== Transposed eigenvalues (first 5) ==\n")
print(round(mt$eig, 3))
cat("\n== Separate MCA lambda1 per modality (transposed) ==\n")
print(round(mt$lambda1, 4))
cat("\n== RV coefficients between modalities, genre level ==\n")
print(round(mt$RV, 3))
cat("\n== Group contributions (dims 1-3, %) ==\n")
print(round(mt$contrib[, 1:3], 1))

# anchor signs: dim poles read from genre coordinates
Fg <- mt$Fglob[, 1:3]
cat("\n== Genre global coordinates (dims 1-3) ==\n")
print(round(Fg, 2))

cat("\n== Genre partial coordinates (dim 1) ==\n")
print(round(cbind(pref = mt$Fpart[[1]][, 1], cons = mt$Fpart[[2]][, 1],
                  eval = mt$Fpart[[3]][, 1]), 2))
cat("\n== Genre partial coordinates (dim 2) ==\n")
print(round(cbind(pref = mt$Fpart[[1]][, 2], cons = mt$Fpart[[2]][, 2],
                  eval = mt$Fpart[[3]][, 2]), 2))
cat("\n== Genre partial coordinates (dim 3) ==\n")
print(round(cbind(pref = mt$Fpart[[1]][, 3], cons = mt$Fpart[[2]][, 3],
                  eval = mt$Fpart[[3]][, 3]), 2))

cat("\n== Pearson correlations: configuration rates vs transposed dims ==\n")
cfgT <- as.data.frame(t(cfg))
print(round(cor(cfgT, Fg), 2))

cat("\n== Percentage of inertia (transposed) ==\n")
tot <- sum(mt$sv$d^2) / nrow(Xt_list[[1]])
print(round(100 * mt$eig / tot, 1))

# --- figure: genre map with modality partial points -----------------------------
library(ggplot2)
library(ggrepel)
gnames <- c("Classical", "Opera", "Jazz", "Broadway/Show", "Mood/Easy",
            "Big Band", "Classic Rock/Oldies", "Country", "Bluegrass", "Folk",
            "Hymns/Gospel", "Latin/Spanish/Salsa", "Rap/Hip-Hop", "Blues/R&B",
            "Reggae", "Top 40/Pop", "Contemporary Rock", "Indie/Alt Rock",
            "Dance/Club", "Heavy Metal")
glob <- data.frame(genre = gnames, d1 = Fg[, 1], d2 = Fg[, 2], d3 = Fg[, 3])
part <- do.call(rbind, lapply(seq_along(gname3), function(h)
  data.frame(genre = gnames, modality = gname3[h],
             d1 = mt$Fpart[[h]][, 1], d2 = mt$Fpart[[h]][, 2],
             d3 = mt$Fpart[[h]][, 3])))
mk <- function(panel, xg, yg, xp, yp) data.frame(
  panel = panel, genre = glob$genre, xg = glob[[xg]], yg = glob[[yg]],
  modality = part$modality, xp = part[[xp]], yp = part[[yp]])
plotdf <- rbind(mk("Dimensions 1-2", "d1", "d2", "d1", "d2"),
                mk("Dimensions 1-3", "d1", "d3", "d1", "d3"))
gglob <- rbind(
  data.frame(panel = "Dimensions 1-2", genre = glob$genre,
             x = glob$d1, y = glob$d2),
  data.frame(panel = "Dimensions 1-3", genre = glob$genre,
             x = glob$d1, y = glob$d3))
p9 <- ggplot() +
  geom_segment(data = plotdf, aes(x = xg, y = yg, xend = xp, yend = yp,
                                  color = modality),
               linewidth = 0.25, alpha = 0.6, show.legend = FALSE) +
  geom_point(data = plotdf, aes(xp, yp, color = modality), size = 1.6) +
  geom_point(data = gglob, aes(x, y), size = 1.8, color = "black") +
  ggrepel::geom_text_repel(data = gglob, aes(x, y, label = genre),
                           size = 2.4, segment.color = NA, max.overlaps = 30) +
  geom_hline(data = data.frame(panel = unique(plotdf$panel), y = 0),
             aes(yintercept = y), linetype = 2, color = "grey60") +
  geom_vline(data = data.frame(panel = unique(plotdf$panel), x = 0),
             aes(xintercept = x), linetype = 2, color = "grey60") +
  scale_color_manual(values = c(Preference = "#0072B2",
                                Consumption = "#D55E00",
                                Evaluation = "#009E73"), name = "Modality") +
  facet_wrap(~panel, scales = "free") +
  labs(x = NULL, y = NULL,
       title = "Genre map with modality partial points (transposed MFA)",
       subtitle = "Black points: genre compromise positions; colored points: modality partial points") +
  theme_minimal(base_size = 10) +
  theme(panel.grid.minor = element_blank(), legend.position = "top")
ggsave("manuscript/figures/fig-genre-map.pdf", p9, width = 7.2, height = 4.6)

# --- table: per-genre configuration profiles --------------------------------------
esc <- gsub("&", "\\\\&", gnames)
tl <- c(
  "\\begin{tabular}{lcccccccc}", "\\toprule",
  " & \\multicolumn{4}{c}{Complex configurations} & \\multicolumn{4}{c}{Simple} \\\\",
  "\\cmidrule(lr){2-5}\\cmidrule(lr){6-9}",
  "Genre & Guilty & Pre-acq. & Pose & Dist. & Justif. & Distant & $+++$ & $---$ \\\\",
  "\\midrule")
for (i in seq_along(gnames)) {
  vals <- cfg[, genres[i]]
  tl <- c(tl, paste0(esc[i], " & ",
    paste(sprintf("%.1f", round(100 * vals[c("guilty", "preacquired", "pose",
      "distanced", "justified", "distant", "simple_pos", "simple_neg")], 1)),
      collapse = " & "), " \\\\"))
}
tl <- c(tl, "\\bottomrule", "\\end{tabular}")
writeLines(tl, "manuscript/tables/tab-genre-profile.tex")
cat("figure and table written\n")
