# 02-run-mfa.R
# Multiple Factor Analysis of complex tastes:
# 3 groups of 20 binary variables each (preference / consumption / evaluation)
# over 20 musical genres, one row per valid respondent.
#
# Groups are treated as categorical (MCA within each group), following the
# GDA tradition of Pagès, "Multiple Factor Analysis by Example Using R".
# MFA balances the three groups by weighting each group by the inverse of
# the first eigenvalue of its separate analysis, so no aspect dominates.

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

# column indices in FactoMineR's block format
group_cols <- c(match(groups$Preference, names(mfa_dat)),
                match(groups$Consumption, names(mfa_dat)),
                match(groups$Evaluation, names(mfa_dat)))

res <- MFA(mfa_dat,
           group = c(20, 20, 20),
           type  = c("n", "n", "n"),
           name.group = c("Preference", "Consumption", "Evaluation"),
           graph = FALSE)

saveRDS(res, "output/mfa_results.rds")

# --- key summaries -----------------------------------------------------------
cat("\n== Eigenvalues (first 5 dimensions) ==\n")
print(round(res$eig[1:5, ], 3))

cat("\n== Separate analyses: first eigenvalue per group (group weights) ==\n")
print(sapply(res$separate.analyses, function(a) a$eig[1, 1]))

cat("\n== RV coefficients between groups ==\n")
print(round(res$group$RV, 3))

cat("\n== Group contributions to first 3 dimensions (%) ==\n")
print(round(res$group$contrib[, 1:3], 1))
cat("\n== Lg values (group x dimension) ==\n")
print(round(res$group$Lg[, 1:3], 3))

cat("\n== Category contributions, dimension 1 (top 15) ==\n")
ct <- res$quali.var$contrib
ord <- order(-ct[, 1])
print(round(ct[ord[1:15], 1:3], 1))

cat("\n== Category coordinates, dimension 1 (top 10 by abs coord) ==\n")
cc <- res$quali.var$coord
ord2 <- order(-abs(cc[, 1]))
print(round(cc[ord2[1:10], 1:2], 2))
