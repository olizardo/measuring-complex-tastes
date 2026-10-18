# Checks the coordinate relations of an MFA fit (FactoMineR, all groups active,
# categorical inputs). Each dimension may carry a sign flip relative to the raw
# decomposition (script 02 flips reported coordinates), so the sign is chosen per
# dimension and must be the same for every row or category on that dimension.
#
# Tested relations:
#   (i)   column normalization: sum_j w_j V_js^2 = 1 for each dimension s
#   (ii)  category coordinates: f_js = lambda_s V_js sqrt((1 - p_j) / p_j)
#   (iii) individual coordinates: F_s(i) = sum_j x_ij w_j V_js
#
# The saved centred and scaled matrix is stored as 7-digit text, so the default
# tolerance is an absolute 1e-4 on the coordinates; exact fits reach about 1e-10.
check_mfa_coordinates <- function(res, tol = 1e-4) {
  Xc <- as.matrix(res$global.pca$call$X)
  w <- res$global.pca$call$col.w
  V <- res$global.pca$svd$V
  ev <- res$eig[, 1]
  dims <- seq_len(ncol(res$ind$coord))

  cats <- rownames(res$quali.var$coord)
  num <- intersect(cats, colnames(Xc))
  X <- matrix(as.numeric(Xc[, num]), nrow(Xc), dimnames = list(rownames(Xc), num))
  act <- rownames(res$ind$coord)
  k <- match(cats, num)
  # Share of respondents in each category, from the sign of its centred column
  p <- colMeans(X[act, num] > 0)[num][k]

  norm_err <- sapply(dims, function(s) abs(sum(w * V[, s]^2) - 1))

  f_rep <- res$quali.var$coord[, dims, drop = FALSE]
  f_pred <- sapply(dims, function(s) ev[s] * V[k, s] * sqrt((1 - p) / p))
  f_sign <- sapply(dims, function(s) if (sum((f_rep[, s] - f_pred[, s])^2) <= sum((f_rep[, s] + f_pred[, s])^2)) 1 else -1)
  f_err <- sapply(dims, function(s) max(abs(f_rep[, s] - f_sign[s] * f_pred[, s])))

  F_all <- rbind(res$ind$coord, res$ind.sup$coord)
  F_calc <- matrix(X[rownames(F_all), num] %*% (w * V[, dims, drop = FALSE]), nrow(F_all))
  F_rep <- F_all[, dims, drop = FALSE]
  i_sign <- sapply(dims, function(s) if (sum((F_rep[, s] - F_calc[, s])^2) <= sum((F_rep[, s] + F_calc[, s])^2)) 1 else -1)
  i_err <- sapply(dims, function(s) max(abs(F_rep[, s] - i_sign[s] * F_calc[, s])))

  out <- data.frame(
    dim = dims,
    lambda = round(ev[dims], 4),
    norm_error = signif(norm_err, 3),
    category_sign = f_sign,
    category_max_abs_error = signif(f_err, 3),
    individual_sign = i_sign,
    individual_max_abs_error = signif(i_err, 3)
  )
  if (!all(norm_err < tol) || !all(f_err < tol) || !all(i_err < tol)) {
    print(out)
    stop("MFA coordinate relations do not hold; see table above.")
  }
  out
}
