# 07-regression.R
# Who has complex tastes? OLS regressions of the geometric aspect-disagreement
# scores W_s(i) (script 04) on respondent demographics (script 05), with
# robustness checks (log outcomes; pairwise disagreement components on
# dimension 3; genre-based components; cross-genre coherence components).
# Writes the LaTeX table manuscript/tables/tab-regression.tex.

ant <- readRDS("output/antinomy_scores.rds")$ant
sup <- readRDS("output/supplementary.rds")$sup
stopifnot(nrow(ant) == nrow(sup))

# interpretable reference categories
sup$race <- relevel(sup$race, ref = "White")

dat <- cbind(ant[, c("W1", "W2", "W3", "dPV3", "dCV3", "dPC3",
                     "Wloc1", "Wloc2", "Wloc3")], sup)

preds <- c("gender", "race", "age6", "educ", "parentba",
           "income4", "sclass", "region")
ys <- c("W1", "W2", "W3")
fits <- lapply(ys, function(y) lm(reformulate(preds, y), data = dat))

cat("\n== R2 ==\n")
print(round(sapply(fits, function(m) summary(m)$r.squared), 3))

for (i in seq_along(fits)) {
  cat("\n== Partial F tests:", ys[i], "==\n")
  print(round(drop1(fits[[i]], test = "F"), 1))
}

# --- LaTeX table: unstandardized coefficients (se) for W1, W2, W3 ---------------
stars <- function(p) cut(p, c(-Inf, 0.001, 0.01, 0.05, Inf),
                         labels = c("$^{***}$", "$^{**}$", "$^{*}$", ""))

blocks <- list(
  c("gender", "Gender (ref.~male)"),
  c("race", "Race/ethnicity (ref.~White)"),
  c("age6", "Age (ref.~18--29)"),
  c("educ", "Education (ref.~no diploma)"),
  c("parentba", "Parents' BA (ref.~no BA)"),
  c("income4", "Household income (ref.~\\$25k or less)"),
  c("sclass", "Subjective class (ref.~lower)"),
  c("region", "Census region (ref.~Northeast)"))

cf <- lapply(fits, function(m) {
  s <- summary(m)$coefficients
  data.frame(term = rownames(s), b = s[, 1], se = s[, 2], p = s[, 4])
})
names(cf) <- ys

# LaTeX-escape $ and use en-dashes in range labels
nice <- function(x) gsub("-", "--", gsub("\\$", "\\\\$", x))

tl <- c("\\begin{tabular}{lccc}", "\\toprule",
        " & $W_1$ & $W_2$ & $W_3$ \\\\", "\\midrule")
for (bk in blocks) {
  v <- bk[1]; hdr <- bk[2]
  ref <- levels(dat[[v]])[1]
  lv <- setdiff(levels(dat[[v]]), c(ref, "Missing"))
  tl <- c(tl, paste0(hdr, " & & & \\\\"))
  for (l in lv) {
    term <- paste0(v, l)
    row <- sapply(cf, function(dd) {
      k <- match(term, dd$term)
      if (is.na(k) || is.na(dd$b[k])) return("--")
      paste0(sprintf("$%.2f$ (%.2f)", dd$b[k], dd$se[k]), stars(dd$p[k]))
    })
    tl <- c(tl, paste0("\\quad ", nice(l), " & ",
                       paste(row, collapse = " & "), " \\\\"))
  }
  tl <- c(tl, "\\addlinespace")
}
r2row <- sprintf("%.3f", sapply(fits, function(m) summary(m)$r.squared))
nrow_lab <- format(nrow(dat), big.mark = ",")
tl <- c(tl,
        paste0("R$^2$ & ", paste(r2row, collapse = " & "), " \\\\"),
        paste0("$N$ & ", paste(rep(nrow_lab, 3), collapse = " & "), " \\\\"),
        "\\bottomrule", "\\end{tabular}")
writeLines(tl, "manuscript/tables/tab-regression.tex")

# --- robustness 1: log-transformed outcomes -------------------------------------
cat("\n== Robustness: log outcomes ==\n")
fitlog <- lapply(ys, function(y)
  lm(reformulate(preds, paste0("log(", y, ")")), data = dat))
print(round(sapply(fitlog, function(m) summary(m)$r.squared), 3))
for (i in seq_along(fitlog)) {
  cat("\n-- log(", ys[i], ") partial F --\n")
  print(round(drop1(fitlog[[i]], test = "F")[, "F value", drop = FALSE], 1))
  b1 <- coef(fits[[i]]); b2 <- coef(fitlog[[i]])
  common <- intersect(names(b1), names(b2))
  cat("sign agreement with raw-W model:",
      round(mean(sign(b1[common]) == sign(b2[common]), na.rm = TRUE), 2), "\n")
}

# --- robustness 2: pairwise disagreement components on dimension 3 --------------
cat("\n== Pairwise disagreement outcomes (dimension 3) ==\n")
for (y in c("dPV3", "dCV3", "dPC3")) {
  m <- lm(reformulate(preds, y), data = dat)
  cat("\n--", y, "-- R2:", round(summary(m)$r.squared, 3), "\n")
  print(round(drop1(m, test = "F")[, "F value", drop = FALSE], 1))
  s <- summary(m)$coefficients
  cat("most significant coefficients:\n")
  print(round(s[order(s[, 4])[1:6], c(1, 2, 4)], 2))
}

# --- robustness 3: genre-based components (Equation eq:genre) as outcomes ---------
# Wloc_s = omega, the genre-based complex-taste part of W_s -- isolates the
# configural component from the cross-genre coherence component.
cat("\n== Robustness: genre-based components Wloc1-Wloc3 ==\n")
ys_loc <- c("Wloc1", "Wloc2", "Wloc3")
fits_loc <- lapply(ys_loc, function(y) lm(reformulate(preds, y), data = dat))
print(round(sapply(fits_loc, function(m) summary(m)$r.squared), 3))
for (i in seq_along(fits_loc)) {
  cat("\n--", ys_loc[i], "--\n")
  print(round(drop1(fits_loc[[i]], test = "F")[, "F value", drop = FALSE], 1))
  s <- summary(fits_loc[[i]])$coefficients
  sel <- grep("age6|parentba|sclass", rownames(s))
  print(round(s[sel, c(1, 2, 4)], 3))
}

# --- robustness 4: cross-genre coherence components (Equation eq:genre) -----------
# eq:genre is an identity, so coherence = W_s - Wloc_s exactly, and with the
# same predictors/sample the three model sets decompose additively:
# coef(W) = coef(Wloc) + coef(coherence). The coherence models therefore add
# no new estimates, only the explicit attribution of each W coefficient.
cat("\n== Robustness: coherence components coh1-coh3 ==\n")
for (s in 1:3) {
  dat[[paste0("coh", s)]] <- dat[[paste0("W", s)]] - dat[[paste0("Wloc", s)]]
}
ys_coh <- c("coh1", "coh2", "coh3")
fits_coh <- lapply(ys_coh, function(y) lm(reformulate(preds, y), data = dat))
print(round(sapply(fits_coh, function(m) summary(m)$r.squared), 3))
for (i in seq_along(fits_coh)) {
  cat("\n--", ys_coh[i], "--\n")
  print(round(drop1(fits_coh[[i]], test = "F")[, "F value", drop = FALSE], 1))
  s <- summary(fits_coh[[i]])$coefficients
  sel <- grep("age6|parentba|sclass", rownames(s))
  print(round(s[sel, c(1, 2, 4)], 3))
}
cat("\nadditivity check (max |coef(W) - coef(Wloc) - coef(coherence)|):\n")
for (i in 1:3) {
  cw <- coef(fits[[i]]); cl <- coef(fits_loc[[i]]); cc <- coef(fits_coh[[i]])
  ok <- !is.na(cw) & !is.na(cl) & !is.na(cc)
  cat("dim", i, ":", max(abs(cw[ok] - cl[ok] - cc[ok])), "\n")
}

cat("\nfigures and tables written\n")
