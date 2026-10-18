# 12-aggregate-regression.R
# OLS of the aggregate genre-based component Omega and the aggregate coherence
# component Gamma on the shared demographic covariates (scripts/demographics-coding.R),
# with the same predictors and sample as script 07. Both aggregates divide each
# dimension by the SD of omega_s over respondents, so Omega + Gamma equals the
# SD-scaled sum of W_s over dimensions 1-4. Holm correction runs across the
# coefficients of both models. Prints results and saves output/aggregate-regression.rds.

obj <- readRDS("output/antinomy_scores.rds")
ant <- obj$ant
omega_dim <- apply(obj$omega, c(1, 3), sum)
sd_omega <- apply(omega_dim, 2, sd)
gamma_dim <- as.matrix(ant[, paste0("coh", 1:4)])
w_dim <- as.matrix(ant[, paste0("W", 1:4)])

Omega <- rowSums(sweep(omega_dim, 2, sd_omega, "/"))
Gamma <- rowSums(sweep(gamma_dim, 2, sd_omega, "/"))
stopifnot(max(abs(Omega + Gamma - rowSums(sweep(w_dim, 2, sd_omega, "/")))) < 1e-8)

ssi <- readRDS("data/ssi2012_cleaned.rds") |> haven::zap_labels()
source("scripts/demographics-coding.R")
ssi_rows <- ssi[as.numeric(rownames(ant)), ]
keep <- demographic_keep(ssi_rows)
cat("Complete cases on demographics: N =", sum(keep), "of", nrow(ant), "\n")

dat <- cbind(data.frame(Omega = Omega, Gamma = Gamma, row.names = rownames(ant)),
             demographic_design(ssi_rows))[keep, ]

preds <- c("gender", "race", "age6",
           "educ_somecol", "educ_bach", "educ_postgrad",
           "parentba", "income4",
           "sclass_working", "sclass_middle", "sclass_upper",
           "region")
ys <- c("Omega", "Gamma")
fits <- lapply(ys, function(y) lm(reformulate(preds, y), data = dat))
names(fits) <- ys

cat("\n== R2 ==\n")
print(round(sapply(fits, function(m) summary(m)$r.squared), 3))

for (i in seq_along(fits)) {
  cat("\n== Partial F tests:", ys[i], "==\n")
  print(round(drop1(fits[[i]], test = "F"), 1))
}

cf <- lapply(fits, function(m) {
  s <- summary(m)$coefficients
  data.frame(term = rownames(s), b = s[, 1], se = s[, 2], p = s[, 4])
})
names(cf) <- ys
nonint <- cf[[1]]$term != "(Intercept)"
pm <- sapply(cf, function(d) d$p[nonint])
holm_m <- matrix(p.adjust(as.vector(pm), "holm"), nrow = nrow(pm))

res_tab <- do.call(rbind, lapply(seq_along(cf), function(j) {
  d <- cf[[j]][nonint, ]
  data.frame(outcome = ys[j], term = d$term,
             b = round(d$b, 3),
             ci_lo = round(d$b - 1.96 * d$se, 3),
             ci_hi = round(d$b + 1.96 * d$se, 3),
             p = round(d$p, 4),
             holm_p = round(holm_m[, j], 4))
}))
cat("\n== Coefficients (Holm across both models) ==\n")
print(res_tab, row.names = FALSE)
cat("\nUnadjusted p < .05:", sum(res_tab$p < .05), "of", nrow(res_tab),
    "; Holm-adjusted p < .05:", sum(res_tab$holm_p < .05), "\n")

saveRDS(list(fits = fits, table = res_tab, sd_omega = sd_omega),
        "output/aggregate-regression.rds")

# --- LaTeX table for Appendix D (single-line cells so the table fits one page) -
stars <- function(p) cut(p, c(-Inf, 0.001, 0.01, 0.05, Inf),
                         labels = c("$^{***}$", "$^{**}$", "$^{*}$", ""))
blocks <- list(
  c("gender", "Gender (ref.~man)"),
  c("race", "Race/ethnicity (ref.~White)"),
  c("age6", "Age (ref.~18--29)"),
  list(c("educ_somecol", "educ_bach", "educ_postgrad"), "Education (ref.~HS or less)"),
  c("parentba", "Parents' BA (ref.~no BA)"),
  c("income4", "Household income (ref.~\\$25k or less)"),
  list(c("sclass_working", "sclass_middle", "sclass_upper"), "Subjective class (ref.~lower)"),
  c("region", "Census region (ref.~Northeast)"))
var_labels <- c(
  genderFemale = "Woman",
  raceBlack = "Black", raceHispanic = "Hispanic", raceAsian = "Asian",
  `race>1 race` = "$>$1 race", raceOther = "Other",
  `age630-39` = "30--39", `age640-49` = "40--49", `age650-59` = "50--59",
  `age660-69` = "60--69", `age670+` = "70+",
  educ_somecol1 = "Some college", educ_bach1 = "Bachelor's", educ_postgrad1 = "Postgraduate",
  `parentbaParents BA` = "Yes",
  `income4$25-49k` = "\\$25--49k", `income4$50-74k` = "\\$50--74k", `income4$75k+` = "\\$75k+",
  sclass_working1 = "Working", sclass_middle1 = "Middle", sclass_upper1 = "Upper",
  regionMidwest = "Midwest", regionSouth = "South", regionWest = "West")

tl <- c("\\begin{tabular}{lcc}", "\\toprule", " & $\\Omega$ & $\\Gamma$ \\\\", "\\midrule")
for (bk in blocks) {
  terms_list <- if (is.list(bk)) bk[[1]] else bk[1]
  hdr <- if (is.list(bk)) bk[[2]] else bk[2]
  tl <- c(tl, paste0(hdr, " & & \\\\"))
  for (term_pattern in terms_list) {
    for (term in grep(paste0("^", term_pattern), cf[[1]]$term, value = TRUE)) {
      label <- var_labels[term]
      if (is.na(label)) label <- term
      row <- sapply(seq_along(cf), function(j) {
        dd <- cf[[j]]
        k <- match(term, dd$term)
        ci <- sprintf("$[%.2f, %.2f]$", dd$b[k] - 1.96 * dd$se[k], dd$b[k] + 1.96 * dd$se[k])
        dag <- if (holm_m[match(term, cf[[1]]$term[nonint]), j] < 0.05) "$^{\\dagger}$" else ""
        paste0(sprintf("$%.2f$ (%.2f)", dd$b[k], dd$se[k]), stars(dd$p[k]), dag, " ", ci)
      })
      tl <- c(tl, paste0("\\quad ", label, " & ", paste(row, collapse = " & "), " \\\\"))
    }
  }
  tl <- c(tl, "\\addlinespace")
}
r2row <- sprintf("%.3f", sapply(fits, function(m) summary(m)$r.squared))
tl <- c(tl,
        paste0("R$^2$ & ", paste(r2row, collapse = " & "), " \\\\"),
        paste0("$N$ & ", paste(rep(format(nrow(dat), big.mark = ","), 2), collapse = " & "), " \\\\"),
        "\\bottomrule", "\\end{tabular}")
writeLines(tl, "manuscript/tables/tab-aggregate-regression.tex")
