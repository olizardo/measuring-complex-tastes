# 07-regression.R
# Who has complex tastes? OLS regressions of the geometric aspect-disagreement
# scores W_s(i) (script 04) on respondent demographics (scripts/demographics-coding.R), with
# categorical indicators for education and class (matching script 09 encoding),
# and robustness checks (log outcomes; pairwise disagreement components on
# dimension 3; genre-based components; cross-genre coherence components).
# Writes manuscript/tables/tab-regression.tex (partial effects) and
# manuscript/tables/tab-omega-regression.tex (genre-based components).

library(tidyverse)

ant <- readRDS("output/antinomy_scores.rds")$ant

ssi <- readRDS("data/ssi2012_cleaned.rds") |> haven::zap_labels()
omega_indices <- as.numeric(rownames(ant))

# Covariates use the shared coding in scripts/demographics-coding.R; respondents
# missing any covariate are dropped so every model shares one sample.
source("scripts/demographics-coding.R")
ssi_rows <- ssi[omega_indices, ]
keep <- demographic_keep(ssi_rows)
cat("Complete cases on demographics: N =", sum(keep), "of", nrow(ant), "\n")

dat <- cbind(ant[, c("W1", "W2", "W3", "W4",
                     "dPV1", "dCV1", "dPC1", "dPV2", "dCV2", "dPC2",
                     "dPV3", "dCV3", "dPC3", "dPV4", "dCV4", "dPC4",
                     "Wloc1", "Wloc2", "Wloc3", "Wloc4")],
             demographic_design(ssi_rows))[keep, ]

# Regression predictors: use education and class indicators instead of ordinal versions
preds <- c("gender", "race", "age6",
           "educ_somecol", "educ_bach", "educ_postgrad",
           "parentba", "income4",
           "sclass_working", "sclass_middle", "sclass_upper",
           "region")
ys <- c("W1", "W2", "W3", "W4")
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

# LaTeX-escape $ and use en-dashes in range labels
nice <- function(x) gsub("-", "--", gsub("\\$", "\\\\$", x))

# Map indicator variable names and coefficient names to readable labels
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

# Writes one coefficient table with a column per fitted model. Holm correction
# runs across every non-intercept coefficient in the table (96 for four models).
write_coef_table <- function(fits, col_labels, path) {
cf <- lapply(fits, function(m) {
  s <- summary(m)$coefficients
  data.frame(term = rownames(s), b = s[, 1], se = s[, 2], p = s[, 4])
})
nonint <- cf[[1]]$term != "(Intercept)"
pm <- sapply(cf, function(dd) dd$p[nonint])
holm_m <- matrix(p.adjust(as.vector(pm), "holm"), nrow = nrow(pm))
tl <- c("\\begin{tabular}{lcccc}", "\\toprule",
        paste0(" & ", paste(col_labels, collapse = " & "), " \\\\"), "\\midrule")
for (bk in blocks) {
  # list blocks carry a vector of indicator terms + a header; plain blocks are
  # c(term, header) character vectors
  if (is.list(bk)) {
    # Multi-indicator block (education or class)
    terms_list <- bk[[1]]
    hdr <- bk[[2]]
  } else {
    # Single-indicator block
    terms_list <- bk[1]
    hdr <- bk[2]
  }
  
  tl <- c(tl, paste0(hdr, " & & & \\\\"))
  
  for (term_pattern in terms_list) {
    # Find all coefficients matching this term pattern
    matching_terms <- grep(paste0("^", term_pattern), cf[[1]]$term, value = TRUE)
    
    for (term in matching_terms) {
      # Get readable label
      label <- var_labels[term]
      if (is.na(label)) label <- term
      
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
r2row <- sprintf("%.3f", sapply(fits, function(m) summary(m)$r.squared))
nrow_lab <- format(nrow(dat), big.mark = ",")
tl <- c(tl,
        paste0("R$^2$ & ", paste(r2row, collapse = " & "), " \\\\"),
        paste0("$N$ & ", paste(rep(nrow_lab, length(fits)), collapse = " & "), " \\\\"),
        "\\bottomrule", "\\end{tabular}")
writeLines(tl, path)
invisible(cf)
}

write_coef_table(fits, paste0("$W_", 1:4, "$"), "manuscript/tables/tab-regression.tex")


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

# --- pairwise disagreement outcomes: squared distance between each pair of
# aspects on each dimension (sums to 3 * W_s; Section "Pairwise Disagreements").
# Writes manuscript/tables/tab-pairs-social.tex (R^2 of demographic models).
pair_names <- c("dPC", "dPV", "dCV")
pair_labs <- c("Preference--consumption", "Preference--evaluation",
               "Consumption--evaluation")
pair_fits <- lapply(pair_names, function(p)
  lapply(1:4, function(s) lm(reformulate(preds, paste0(p, s)), data = dat)))
pair_r2 <- t(sapply(pair_fits, function(fl) sapply(fl, function(m) summary(m)$r.squared)))
w_r2 <- sapply(fits, function(m) summary(m)$r.squared)
cat("\n== Pairwise disagreement outcomes: R2 (rows pairs, columns dimensions) ==\n")
print(round(pair_r2, 3))
cat("W_s R2 for comparison:", round(w_r2, 3), "\n")
for (k in seq_along(pair_names)) {
  for (s in 1:4) {
    m <- pair_fits[[k]][[s]]
    sm <- summary(m)$coefficients
    sig <- sm[sm[, 4] < .05 & rownames(sm) != "(Intercept)", c(1, 4), drop = FALSE]
    cat("\n--", paste0(pair_names[k], s), "-- sig. predictors (p < .05):\n")
    print(round(sig, 3))
  }
}
pe <- c("\\begin{tabular}{lcccc}", "\\toprule",
        " & Dim 1 & Dim 2 & Dim 3 & Dim 4 \\\\", "\\midrule",
        paste0("$W_s$ (aspect disagreement) & ",
               paste(sprintf("%.3f", w_r2), collapse = " & "), " \\\\"),
        "\\midrule")
for (k in seq_along(pair_names)) {
  pe <- c(pe, paste0(pair_labs[k], " & ",
                     paste(sprintf("%.3f", pair_r2[k, ]), collapse = " & "),
                     " \\\\"))
}
pe <- c(pe, "\\bottomrule", "\\end{tabular}")
writeLines(pe, "manuscript/tables/tab-pairs-social.tex")

# --- robustness 3: genre-based components (Equation eq:genre) as outcomes ---------
# Wloc_s = omega, the genre-based complex-taste part of W_s -- isolates the
# configural component from the cross-genre coherence component.
cat("\n== Robustness: genre-based components Wloc1-Wloc4 ==\n")
ys_loc <- c("Wloc1", "Wloc2", "Wloc3", "Wloc4")
fits_loc <- lapply(ys_loc, function(y) lm(reformulate(preds, y), data = dat))
print(round(sapply(fits_loc, function(m) summary(m)$r.squared), 3))
for (i in seq_along(fits_loc)) {
  cat("\n--", ys_loc[i], "--\n")
  print(round(drop1(fits_loc[[i]], test = "F")[, "F value", drop = FALSE], 1))
  s <- summary(fits_loc[[i]])$coefficients
  sel <- grep("age6|parentba|sclass", rownames(s))
  print(round(s[sel, c(1, 2, 4)], 3))
}

write_coef_table(fits_loc, paste0("$\\omega_", 1:4, "$"),
                 "manuscript/tables/tab-omega-regression.tex")

# --- robustness 4: cross-genre coherence components (Equation eq:genre) -----------
# eq:genre is an identity, so coherence = W_s - Wloc_s exactly, and with the
# same predictors/sample the three model sets decompose additively:
# coef(W) = coef(Wloc) + coef(coherence). The coherence models therefore add
# no new estimates, only the explicit attribution of each W coefficient.
cat("\n== Robustness: coherence components coh1-coh4 ==\n")
for (s in 1:4) {
  dat[[paste0("coh", s)]] <- dat[[paste0("W", s)]] - dat[[paste0("Wloc", s)]]
}
ys_coh <- c("coh1", "coh2", "coh3", "coh4")
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
for (i in seq_along(ys)) {
  cw <- coef(fits[[i]]); cl <- coef(fits_loc[[i]]); cc <- coef(fits_coh[[i]])
  ok <- !is.na(cw) & !is.na(cl) & !is.na(cc)
  cat("dim", i, ":", max(abs(cw[ok] - cl[ok] - cc[ok])), "\n")
}

cat("\nfigures and tables written\n")
