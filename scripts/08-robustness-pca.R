# 08-robustness-pca.R
# Robustness check: MCA vs PCA as the within-group analysis of the MFA.
# The main analysis (script 02) uses type "n" (MCA) on the 20 binary
# indicators of each aspect block. For 0/1 data, MCA is a reweighted PCA
# of the same columns: the only difference is the column scaling
# (MCA up-weights rare categories by 1/sqrt(m(1-m))). This script runs the
# same MFA with type "c" (scaled PCA within groups) and compares eigenvalues,
# group weights, RV structure, individual coordinates, complex-taste scores,
# and antinomy shares. Writes output/robustness_pca.rds.

library(FactoMineR)

res <- readRDS("output/mfa_results.rds")
mfa_dat <- readRDS("data/mfa_input.rds")
ant <- readRDS("output/antinomy_scores.rds")$ant

# type "c" needs numeric columns; mfa_dat holds factors
num <- as.data.frame(lapply(mfa_dat, function(x) as.numeric(as.character(x))))

res_pca <- MFA(num, group = rep(20, 3), type = rep("c", 3),
               name.group = c("Preference", "Consumption", "Evaluation"),
               graph = FALSE)

# --- eigenvalues and separate-analysis first eigenvalues (group weights) -----
eig_tab <- rbind(MCA = res$eig[, 1], PCA = res_pca$eig[, 1])
lam1 <- rbind(MCA = sapply(res$separate.analyses, function(x) x$eig[1, 1]),
              PCA = sapply(res_pca$separate.analyses, function(x) x$eig[1, 1]))

# --- RV structure -------------------------------------------------------------
rv_mca <- res$group$RV[1:3, 1:3][lower.tri(res$group$RV[1:3, 1:3])]
rv_pca <- res_pca$group$RV[1:3, 1:3][lower.tri(res_pca$group$RV[1:3, 1:3])]
rv_tab <- rbind(MCA = rv_mca, PCA = rv_pca)
dimnames(rv_tab) <- list(c("MCA", "PCA"),
                         c("pref-cons", "pref-eval", "cons-eval"))

# --- individual coordinates, sign-matched (SVD signs are arbitrary) ----------
sgn <- sign(diag(cor(res$ind$coord[, 1:3], res_pca$ind$coord[, 1:3])))
cor_dim <- round(diag(cor(res$ind$coord[, 1:3],
                          sweep(res_pca$ind$coord[, 1:3], 2, sgn, "*"))), 3)

# --- complex-taste scores W1-W3 ------------------------------------------------
# partial points of the PCA run, positionally aligned (both analyses
# preserve the row order of mfa_dat; ant rownames are original df indices)
cpp <- res_pca$ind$coord.partiel
gns <- c("Preference", "Consumption", "Evaluation")
Pp <- lapply(gns, function(g) cpp[grepl(paste0("\\.", g, "$"), rownames(cpp)), 1:3])
Fs <- res_pca$ind$coord[, 1:3]
W_pca <- sapply(1:3, function(s)
  Reduce(`+`, lapply(Pp, function(m) (m[, s] - Fs[, s])^2)))
colnames(W_pca) <- c("W1", "W2", "W3")

# positional alignment is valid: ant rows are in res$ind$coord order
cor_W <- round(cor(ant[, c("W1", "W2", "W3")], W_pca), 3)

# --- antinomy share of projected partial inertia ------------------------------
tot <- sapply(1:3, function(s)
  Reduce(`+`, lapply(Pp, function(m) m[, s]^2)))
share_pca <- round(colMeans(W_pca / tot), 3)
share_mca <- round(colMeans(ant[, c("share1", "share2", "share3")]), 3)

out <- list(eigenvalues = eig_tab, lambda1_separate = lam1,
            rv = rv_tab, cor_dim = cor_dim, cor_W = cor_W,
            share_mca = share_mca, share_pca = share_pca)
saveRDS(out, "output/robustness_pca.rds")

cat("MCA vs PCA robustness check\n")
cat("\neigenvalues (dims 1-5):\n"); print(round(eig_tab, 3))
cat("\nseparate-analysis first eigenvalues (group weights):\n")
print(round(lam1, 3))
cat("\nRV coefficients (off-diagonal):\n"); print(round(rv_tab, 3))
cat("\ncorrelation of individual coordinates (dims 1-3, sign-matched):\n")
print(cor_dim)
cat("\ncorrelation of complex-taste scores (W1-W3):\n"); print(cor_W)
cat("\nantinomy share of projected partial inertia (MCA vs PCA):\n")
print(rbind(MCA = share_mca, PCA = share_pca))
