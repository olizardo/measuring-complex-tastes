# 02-run-mfa.R
# Multiple Factor Analysis of complex tastes:
# 3 groups of 20 binary variables each (preference / consumption / evaluation)
# over 20 musical genres, one row per valid respondent.
#
# Groups are treated as categorical (MCA within each group), following the
# GDA tradition of Pagès, "Multiple Factor Analysis by Example Using R".
# MFA balances the three groups by weighting each group by the inverse of
# the first eigenvalue of its separate analysis, so no aspect dominates.
#
# MAIN ANALYSIS (2026-10-16): respondents who give a CONSTANT answer within an
# aspect block (all 20 liked or none, all listened to or none, all granted
# unambiguous high status or none) are treated as SUPPLEMENTARY individuals:
# excluded from the construction of the space, projected onto it afterward.
# Reading: a constant block pattern is a non-response pattern, not a
# substantive taste position. N active = 1,847; N supplementary = 412.

library(FactoMineR)

mfa_dat <- readRDS("data/mfa_input.rds")

# MFA's qualitative groups require factors; 0 = No, 1 = Yes
mfa_dat[] <- lapply(mfa_dat, function(x) factor(x, levels = c(0, 1)))

genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop",
            "blurb", "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")

groups <- list(
  Preference  = paste0("pref_", genres),
  Consumption = paste0("cons_", genres),
  Evaluation  = paste0("eval_", genres)
)

# -- straightliners: constant within at least one aspect block -----------------
is_const <- function(v) {
  rs <- rowSums(mfa_dat[v] == "1")
  rs == 0 | rs == 20
}
const_any <- Reduce("|", lapply(groups, is_const))
passive <- which(const_any)
cat(sprintf("Supplementary (straightline) respondents: %d of %d (active %d)\n",
            length(passive), nrow(mfa_dat), nrow(mfa_dat) - length(passive)))
print(sapply(groups, function(v) {
  rs <- rowSums(mfa_dat[v] == "1")
  c(all0 = sum(rs == 0), all20 = sum(rs == 20))
}))

# column indices in FactoMineR's block format
group_cols <- c(match(groups$Preference, names(mfa_dat)),
                match(groups$Consumption, names(mfa_dat)),
                match(groups$Evaluation, names(mfa_dat)))

res <- MFA(mfa_dat,
           group = c(20, 20, 20),
           type  = c("n", "n", "n"),
           name.group = c("Preference", "Consumption", "Evaluation"),
           ind.sup = passive,
           graph = FALSE)

# -- sign anchoring ------------------------------------------------------------
# Axis directions are SVD-arbitrary. Fix them for the whole pipeline so that
# the POSITIVE pole is, on every dimension:
#   D1 highbrow--popular: highbrow (classical/opera/big-band engagement)
#   D2 volume: more engagement (yes categories)
#   D3 musical-family contrast: Black/Latin popular musics + opera
#      (rap, reggae, Latin/salsa; vs the guitar-rock cluster: metal, indie,
#      contemporary rock) -- engagement-owned, evaluation near-inert
#   D4 status valuation: generous (granting unambiguous high status)
# Only coordinate-bearing elements are flipped (contrib/cos2/Lg/RV/eig are
# sign-invariant or non-coordinate). Scripts 05+ must apply the SAME flip.
flip <- c(-1, 1, 1, 1)

flip_cols <- function(M, f) {
  k <- seq_along(f)
  M[, k] <- sweep(M[, k, drop = FALSE], 2, f, "*")
  M
}
apply_flip <- function(res, f) {
  for (path in list(
    c("ind", "coord"), c("ind", "coord.partiel"),
    c("ind.sup", "coord"), c("ind.sup", "coord.partiel"),
    c("quali.var", "coord"), c("quali.var", "coord.partiel"), c("quali.var", "v.test"),
    c("group", "coord"), c("group", "correlation"),
    c("partial.axes", "coord"), c("partial.axes", "cor"),
    c("global.pca", "var", "coord"), c("global.pca", "var", "cor"),
    c("global.pca", "ind", "coord"), c("global.pca", "ind.sup", "coord"),
    c("global.pca", "quali.sup", "coord")
  )) {
    el <- res[[path]]
    if (is.null(el)) next
    res[[path]] <- flip_cols(el, f)
  }
  res
}
res <- apply_flip(res, flip)

# orientation checks (fail loudly if the anchor rule breaks)
cc <- res$quali.var$coord
stopifnot(
  cc["cons_opera_1", 1] > 0.5,        # D1 + = highbrow
  cc["cons_raphiphop_1", 1] < -1,     # D1 - = popular
  mean(cc[grep("^cons_.*_1$", rownames(cc)), 2]) > 0,   # D2 + = engagement
  cc["cons_raphiphop_1", 3] > 0.5,    # D3 + = rap/Latin side
  cc["cons_hvymtl_1", 3] < -0.5,      # D3 - = rock cluster
  cc["eval_raphiphop_1", 4] > 1.5     # D4 + = generous
)

saveRDS(res, "output/mfa_results.rds")
saveRDS(rownames(mfa_dat)[passive], "output/passive_ids.rds")

# --- key summaries -----------------------------------------------------------
cat("\n== Eigenvalues (first 5 dimensions) ==\n")
print(round(res$eig[1:5, ], 3))

cat("\n== Separate analyses (ACTIVE respondents only): first eigenvalue per group ==\n")
print(sapply(res$separate.analyses, function(a) a$eig[1, 1]))

cat("\n== RV coefficients between groups ==\n")
print(round(res$group$RV, 3))

cat("\n== Group contributions to first 4 dimensions (%) ==\n")
print(round(res$group$contrib[, 1:4], 1))
cat("\n== Lg values (group x dimension) ==\n")
print(round(res$group$Lg[, 1:4], 3))

cat("\n== Category contributions, dimension 1 (top 15) ==\n")
ct <- res$quali.var$contrib
ord <- order(-ct[, 1])
print(round(ct[ord[1:15], 1:4], 1))

cat("\n== Category coordinates, dimensions 1-4 (top 10 by abs coord on dim 1) ==\n")
cc <- res$quali.var$coord
ord2 <- order(-abs(cc[, 1]))
print(round(cc[ord2[1:10], 1:4], 2))
