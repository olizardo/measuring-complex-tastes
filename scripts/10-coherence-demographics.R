#!/usr/bin/env Rscript
# 10-coherence-demographics.R
# Dimension-specific cross-genre coherence (gamma_s = W_s - Wloc_s, the
# coherence term of eq:genre) and demographics. Uses the SAME variable set and
# encoding as script 07 (and matching script 09): gender, race/ethnicity
# (ref. White), age in six groups (ref. 18-29), education as four category
# indicators (ref. HS-or-less), parents' BA, household income (ref. <$25k),
# subjective class as four identity indicators (ref. lower), census region
# (ref. Northeast).
#
# Outputs:
#   manuscript/tables/tab-coherence-regression.tex (OLS, gamma_1-3)
#   output/coherence_demographics.rds

library(tidyverse)
library(haven)

ant <- readRDS("output/antinomy_scores.rds")$ant
source("scripts/demographics-coding.R")

# Get the original SSI data to extract education and class as indicators
# (identical construction to script 07)
ssi <- readRDS("data/ssi2012_cleaned.rds") |> haven::zap_labels()
omega_indices <- as.numeric(rownames(ant))
ssi_rows <- ssi[omega_indices, ]

dat <- cbind(
  ant[, c("coh1", "coh2", "coh3", "coh4",
          "W1", "W2", "W3", "W4", "Wloc1", "Wloc2", "Wloc3", "Wloc4")],
  demographic_design(ssi_rows)
)

# Drop factor levels with zero members (e.g. an empty Missing category)
for (v in c("gender", "race", "age6", "income4")) {
  if (any(table(dat[[v]]) == 0)) dat[[v]] <- droplevels(dat[[v]])
}

# Sanity: coherence is the exact residual of the eq:genre identity
stopifnot(max(abs(dat$coh1 - (dat$W1 - dat$Wloc1))) < 1e-8,
          max(abs(dat$coh2 - (dat$W2 - dat$Wloc2))) < 1e-8,
          max(abs(dat$coh3 - (dat$W3 - dat$Wloc3))) < 1e-8,
          max(abs(dat$coh4 - (dat$W4 - dat$Wloc4))) < 1e-8)

# =============================================================================
# 1. Descriptive statistics
# =============================================================================
cat("\n===== COHERENCE DESCRIPTIVES =====\n\n")
desc <- tibble(
  dim = c("gamma_1", "gamma_2", "gamma_3", "gamma_4"),
  mean = c(mean(dat$coh1), mean(dat$coh2), mean(dat$coh3), mean(dat$coh4)),
  sd = c(sd(dat$coh1), sd(dat$coh2), sd(dat$coh3), sd(dat$coh4)),
  median = c(median(dat$coh1), median(dat$coh2), median(dat$coh3), median(dat$coh4)),
  min = c(min(dat$coh1), min(dat$coh2), min(dat$coh3), min(dat$coh4)),
  max = c(max(dat$coh1), max(dat$coh2), max(dat$coh3), max(dat$coh4)),
  pct_negative = c(mean(dat$coh1 < 0), mean(dat$coh2 < 0),
                   mean(dat$coh3 < 0), mean(dat$coh4 < 0))
)
print(desc, digits = 3)
cat("\nN =", nrow(dat), "\n")

# =============================================================================
# 2. Predictors (same encoding as script 07)
# =============================================================================

preds <- c("gender", "race", "age6",
           "educ_somecol", "educ_bach", "educ_postgrad",
           "parentba", "income4",
           "sclass_working", "sclass_middle", "sclass_upper",
           "region")


# =============================================================================
# 3. OLS regressions: coherence on demographics (same predictors as script 07)
# =============================================================================
cat("\n===== OLS: COHERENCE ON DEMOGRAPHICS =====\n")

ys_coh <- c("coh1", "coh2", "coh3", "coh4")

# Complete cases across the full predictor set (same criterion as script 07)
keep <- complete.cases(dat[, unique(c(ys_coh, preds))])
cat("Complete cases: N =", sum(keep), "of", nrow(dat), "\n")
dat_cc <- dat[keep, ]

fits_coh <- lapply(ys_coh, function(y) lm(reformulate(preds, y), data = dat_cc))

cat("\n== R2 ==\n")
print(round(sapply(fits_coh, function(m) summary(m)$r.squared), 3))

for (i in seq_along(fits_coh)) {
  cat("\n== Partial F tests:", ys_coh[i], "==\n")
  print(round(drop1(fits_coh[[i]], test = "F"), 1))
  cat("\n-- full coefficients:", ys_coh[i], "--\n")
  print(round(summary(fits_coh[[i]])$coefficients, 3))
}

# Context: R2 of W and Wloc on the same sample and predictors
fits_w <- lapply(c("W1", "W2", "W3", "W4"),
                 function(y) lm(reformulate(preds, y), data = dat_cc))
fits_loc <- lapply(c("Wloc1", "Wloc2", "Wloc3", "Wloc4"),
                   function(y) lm(reformulate(preds, y), data = dat_cc))
cat("\n== R2 comparison (same sample, same predictors) ==\n")
comp <- rbind(
  W = sapply(fits_w, function(m) summary(m)$r.squared),
  Wloc = sapply(fits_loc, function(m) summary(m)$r.squared),
  coherence = sapply(fits_coh, function(m) summary(m)$r.squared)
)
colnames(comp) <- c("dim1", "dim2", "dim3", "dim4")
print(round(comp, 3))
cat("\nNOTE: R2 is not additive across components (covariance between Wloc and",
    "\ncoherence terms); coefficient additivity is checked instead:\n")
for (i in seq_along(ys_coh)) {
  cw <- coef(fits_w[[i]]); cl <- coef(fits_loc[[i]]); cc <- coef(fits_coh[[i]])
  ok <- !is.na(cw) & !is.na(cl) & !is.na(cc)
  cat("dim", i, "max |coef(W) - coef(Wloc) - coef(coherence)|:",
      max(abs(cw[ok] - cl[ok] - cc[ok])), "\n")
}

# =============================================================================
# 4. LaTeX tables
# =============================================================================


# --- tab-coherence-regression.tex (mirrors tab-regression) ---------------------
stars <- function(p) cut(p, c(-Inf, 0.001, 0.01, 0.05, Inf),
                         labels = c("$^{***}$", "$^{**}$", "$^{*}$", ""))

blocks <- list(
  c("gender", "Gender (ref.~man)"),
  c("race", "Race/ethnicity (ref.~White)"),
  c("age6", "Age (ref.~18--29)"),
  list(c("educ_somecol", "educ_bach", "educ_postgrad"),
       "Education (ref.~HS or less)"),
  c("parentba", "Parents' BA (ref.~no BA)"),
  c("income4", "Household income (ref.~\\$25k or less)"),
  list(c("sclass_working", "sclass_middle", "sclass_upper"),
       "Subjective class (ref.~lower)"),
  c("region", "Census region (ref.~Northeast)"))

cf <- lapply(fits_coh, function(m) {
  s <- summary(m)$coefficients
  data.frame(term = rownames(s), b = s[, 1], se = s[, 2], p = s[, 4])
})
names(cf) <- ys_coh

# Holm correction across every non-intercept coefficient shown in the table
nonint <- cf[[1]]$term != "(Intercept)"
pm <- sapply(cf, function(dd) dd$p[nonint])
holm_m <- matrix(p.adjust(as.vector(pm), "holm"), nrow = nrow(pm))

var_labels <- c(
  genderFemale = "Woman",
  genderMissing = "Missing",
  raceBlack = "Black",
  raceHispanic = "Hispanic",
  raceAsian = "Asian",
  `race>1 race` = "$>$1 race",
  raceOther = "Other",
  raceMissing = "Missing",
  `age630-39` = "30--39",
  `age640-49` = "40--49",
  `age650-59` = "50--59",
  `age660-69` = "60--69",
  `age670+` = "70+",
  age6Missing = "Missing",
  educ_somecol1 = "Some college",
  educ_bach1 = "Bachelor's",
  educ_postgrad1 = "Postgraduate",
  `parentbaParents BA` = "Yes",
  `income4$25-49k` = "\\$25--49k",
  `income4$50-74k` = "\\$50--74k",
  `income4$75k+` = "\\$75k+",
  sclass_working1 = "Working",
  sclass_middle1 = "Middle",
  sclass_upper1 = "Upper",
  regionMidwest = "Midwest",
  regionSouth = "South",
  regionWest = "West"
)

tl <- c("\\begin{tabular}{lcccc}", "\\toprule",
        " & $\\gamma_1$ & $\\gamma_2$ & $\\gamma_3$ & $\\gamma_4$ \\\\", "\\midrule")
for (bk in blocks) {
  # list blocks carry a vector of indicator terms + a header; plain blocks are
  # c(term, header) character vectors
  if (is.list(bk)) {
    terms_list <- bk[[1]]; hdr <- bk[[2]]
  } else {
    terms_list <- bk[1]; hdr <- bk[2]
  }
  tl <- c(tl, paste0(hdr, " & & & \\\\"))
  for (term_pattern in terms_list) {
    matching_terms <- grep(paste0("^", term_pattern), cf[[1]]$term, value = TRUE)
    for (term in matching_terms) {
      label <- var_labels[term]
      if (is.na(label)) label <- gsub("\\$", "\\\\$", term)
      row <- sapply(seq_along(cf), function(j) {
        dd <- cf[[j]]
        k <- match(term, dd$term)
        if (is.na(k) || is.na(dd$b[k])) return("--")
        ci <- sprintf("$[%.2f, %.2f]$", dd$b[k] - 1.96 * dd$se[k],
                      dd$b[k] + 1.96 * dd$se[k])
        dag <- if (holm_m[match(term, cf[[1]]$term[nonint]), j] < 0.05) "$^{\\dagger}$" else ""
        paste0("\\shortstack{", sprintf("$%.2f$ (%.2f)", dd$b[k], dd$se[k]),
               stars(dd$p[k]), dag, "\\\\", ci, "}")
      })
      tl <- c(tl, paste0("\\quad ", label, " & ",
                         paste(row, collapse = " & "), " \\\\"))
    }
  }
  tl <- c(tl, "\\addlinespace")
}
r2row <- sprintf("%.3f", sapply(fits_coh, function(m) summary(m)$r.squared))
nrow_lab <- format(nrow(dat_cc), big.mark = ",")
tl <- c(tl,
        paste0("R$^2$ & ", paste(r2row, collapse = " & "), " \\\\"),
        paste0("$N$ & ", paste(rep(nrow_lab, length(ys_coh)), collapse = " & "), " \\\\"),
        "\\bottomrule", "\\end{tabular}")
writeLines(tl, "manuscript/tables/tab-coherence-regression.tex")

# =============================================================================
# 5. Save results
# =============================================================================

saveRDS(list(
  fits_coh = fits_coh, fits_w = fits_w, fits_loc = fits_loc,
  desc = desc,
  dat = dat_cc, preds = preds
), file = "output/coherence_demographics.rds")

cat("Saved: manuscript/tables/tab-coherence-regression.tex\n")
cat("Saved: output/coherence_demographics.rds\n")
cat("\n===== SCRIPT 10 COMPLETE =====\n")
