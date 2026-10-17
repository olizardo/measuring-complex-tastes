# 11-straightliner-sensitivity.R
# INVERTED sensitivity analysis (2026-10-16): the MAIN analysis (script 02)
# now treats the 412 respondents constant within at least one aspect block as
# SUPPLEMENTARY ("passive") individuals. This script computes the old
# all-active fit and compares it against the main passive fit, to back the
# robustness footnote in main.tex (section 3.1).
#
# Expected: RV structure unchanged; first two dimensions recovered but with
# swapped rank order; the status-valuation axis recovered but displaced from
# third to fourth place.

suppressPackageStartupMessages({
  library(FactoMineR)
  library(haven)
})

mfa_in <- readRDS("data/mfa_input.rds")
mfa_in[] <- lapply(mfa_in, zap_labels)  # [] <- preserves rownames (original df indices)

blocks <- list(
  pref = grep("^pref_", names(mfa_in), value = TRUE),
  cons = grep("^cons_", names(mfa_in), value = TRUE),
  eval = grep("^eval_", names(mfa_in), value = TRUE)
)
stopifnot(lengths(blocks) == c(20, 20, 20))

# -- identify straightliners --------------------------------------------------
is_const <- function(v) {
  rs <- rowSums(mfa_in[v])
  rs == 0 | rs == 20
}
const_any <- Reduce("|", lapply(blocks, is_const))
passive <- which(const_any)

cat(sprintf("Straightline respondents (constant in >= 1 block): %d of %d\n\n",
            length(passive), nrow(mfa_in)))
print(sapply(blocks, function(v) {
  rs <- rowSums(mfa_in[v])
  c(all0 = sum(rs == 0), all20 = sum(rs == 20))
}))

# -- fits ----------------------------------------------------------------------
dat <- mfa_in
dat[] <- lapply(dat, factor)

all_rows <- seq_len(nrow(dat))
act <- setdiff(all_rows, passive)

sep_lambda1 <- function(rows, v) MCA(dat[rows, v], graph = FALSE)$eig[1, 1]
lambda_full <- vapply(blocks, function(v) sep_lambda1(all_rows, v), numeric(1))
lambda_pass <- vapply(blocks, function(v) sep_lambda1(act, v), numeric(1))

# MAIN fit = passive (script 02); sensitivity fit = all-active
res_main <- readRDS("output/mfa_results.rds")
res_full <- MFA(dat, group = c(20, 20, 20), type = rep("n", 3),
                name.group = c("pref", "cons", "eval"),
                graph = FALSE)

# -- comparisons ----------------------------------------------------------------
cat("\n== Eigenvalues (main passive vs sensitivity all-active) ==\n")
print(round(cbind(main_passive = res_main$eig[1:4, 1],
                  sens_active  = res_full$eig[1:4, 1]), 3))

cat("\n== Separate MCA lambda1 (balancing-weight input) ==\n")
print(round(rbind(main_passive = lambda_pass, sens_active = lambda_full), 3))

cat("\n== RV coefficients (pref-cons, pref-eval, cons-eval) ==\n")
print(round(rbind(
  main_passive = c(res_main$group$RV[1, 2], res_main$group$RV[1, 3], res_main$group$RV[2, 3]),
  sens_active  = c(res_full$group$RV[1, 2], res_full$group$RV[1, 3], res_full$group$RV[2, 3])
), 3))

cat("\n== Cross-dimension coordinate correlations, main passive 1-4 (rows) x all-active 1-5 (cols) ==\n")
C <- cor(res_main$ind$coord[, 1:4],
         res_full$ind$coord[rownames(res_main$ind$coord), 1:5])
dimnames(C) <- list(paste0("main", 1:4), paste0("active", 1:5))
print(round(C, 3))

# -- W scores from partial points ------------------------------------------------
# FactoMineR stacks coord.partiel per individual: rows "id.aspect" (3 per
# individual), so W_s(i) = sum_h (F_sh - mean_h F_sh)^2 within each id block.
Wmat <- function(P) {
  id <- sub("\\..*$", "", rownames(P))
  sp <- split(seq_len(nrow(P)), id)
  W <- t(vapply(sp, function(ix) {
    M <- P[ix, , drop = FALSE]
    colSums(sweep(M, 2, colMeans(M), "-")^2)
  }, numeric(ncol(P))))
  dimnames(W) <- list(names(sp), paste0("W", seq_len(ncol(P))))
  W
}
Tfun <- function(P) {
  id <- sub("\\..*$", "", rownames(P))
  sp <- split(seq_len(nrow(P)), id)
  T <- t(vapply(sp, function(ix) colSums(P[ix, ]^2), numeric(ncol(P))))
  dimnames(T) <- list(names(sp), paste0("T", seq_len(ncol(P))))
  T
}

W_main <- Wmat(rbind(res_main$ind$coord.partiel, res_main$ind.sup$coord.partiel))
W_full <- Wmat(res_full$ind$coord.partiel)
T_full <- Tfun(res_full$ind$coord.partiel)[rownames(W_full), ]
T_main <- Tfun(rbind(res_main$ind$coord.partiel, res_main$ind.sup$coord.partiel))[rownames(W_main), ]

cat("\n== Cross-dimension W correlations, main passive 1-4 (rows) x all-active 1-5 (cols) ==\n")
Wx <- cor(W_main[rownames(W_full), 1:4], W_full[, 1:5])
dimnames(Wx) <- list(paste0("mainW", 1:4), paste0("activeW", 1:5))
print(round(Wx, 3))

cat("\n== Mean individual disagreement share W_s / T_s (manuscript measure) ==\n")
sh_main <- colMeans(W_main[, 1:4] / T_main[, 1:4])
sh_act3 <- colMeans(W_full[, 1:3] / T_full[, 1:3])
sh_sens <- c(sh_act3, rep(NA_real_, 1))  # pad: active fit reports only 3 dims
print(round(rbind(main_passive = sh_main, sens_active = sh_sens), 3))

# -- save ------------------------------------------------------------------------
saveRDS(list(
  passive_ids      = rownames(mfa_in)[passive],
  block_counts     = sapply(blocks, function(v) {
    rs <- rowSums(mfa_in[v])
    c(all0 = sum(rs == 0), all20 = sum(rs == 20))
  }),
  eigen            = cbind(main_passive = res_main$eig[1:4, 1],
                           sens_active  = res_full$eig[1:4, 1]),
  sep_lambda1      = rbind(main_passive = lambda_pass, sens_active = lambda_full),
  rv               = rbind(main_passive = c(res_main$group$RV[1, 2], res_main$group$RV[1, 3], res_main$group$RV[2, 3]),
                           sens_active  = c(res_full$group$RV[1, 2], res_full$group$RV[1, 3], res_full$group$RV[2, 3])),
  coord_crosscor   = C,
  W_crosscor       = Wx,
  shares           = rbind(main_passive = sh_main,
                           sens_active  = sh_sens),
  W_full           = W_full,
  W_main           = W_main
), "output/straightliner_sensitivity.rds")
cat("\nSaved output/straightliner_sensitivity.rds\n")
