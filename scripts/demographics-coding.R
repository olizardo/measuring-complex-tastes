# demographics-coding.R
# Shared socio-demographic coding for scripts 07, 09, and 10. Every script
# builds its covariates here, so categories, reference levels, and cut points
# match across the regressions, the coherence models, and the omega
# correlations. `x` is the SSI data frame aligned to the analysis
# rows (haven labels removed), e.g. ssi[omega_indices, ].
#
# Coding (reference category first):
#   gender    Male (ref.), Female
#   race      White (ref.), Asian, Black, Hispanic, >1 race, Other
#   age6      18-29 (ref.), 30-39, 40-49, 50-59, 60-69, 70+
#   educ      HS or less (ref.), Some college, Bachelor's, Postgraduate
#   parentba  Parents no BA (ref.), Parents BA   (parented, NOT respondent's degree)
#   income4   <$25k (ref.), $25-49k, $50-74k, $75k+
#   sclass    Lower (ref.), Working, Middle, Upper (self-described class identity)
#   region    Northeast (ref.), Midwest, South, West

# Factor-valued covariates; missing values stay NA.
demographic_factors <- function(x) {
  educ <- rep(NA_character_, nrow(x))
  educ[which(x$nodipdeg == 1 | x$hsged == 1)] <- "HS or less"
  educ[which(x$somcol == 1 | x$aadeg == 1)] <- "Some college"
  educ[which(x$bach == 1)] <- "Bachelor's"
  educ[which(x$ma == 1 | x$docprof == 1)] <- "Postgraduate"

  sclass <- rep(NA_character_, nrow(x))
  sclass[which(x$lower == 1)] <- "Lower"
  sclass[which(x$working == 1)] <- "Working"
  sclass[which(x$middle == 1)] <- "Middle"
  sclass[which(x$high == 1)] <- "Upper"

  out <- data.frame(
    gender = factor(x$female, levels = c(0, 1), labels = c("Male", "Female")),
    race = relevel(factor(x$raceeth, levels = 1:6,
                          labels = c("Asian", "Black", "Hispanic", "White",
                                     ">1 race", "Other")), ref = "White"),
    age6 = cut(x$age, breaks = c(-Inf, 4, 6, 8, 10, 12, Inf),
               labels = c("18-29", "30-39", "40-49", "50-59", "60-69", "70+")),
    educ = factor(educ, levels = c("HS or less", "Some college",
                                   "Bachelor's", "Postgraduate")),
    parentba = factor(x$parented, levels = c(0, 1),
                      labels = c("Parents no BA", "Parents BA")),
    income4 = cut(x$income, breaks = c(-Inf, 3, 5, 8, Inf),
                  labels = c("<$25k", "$25-49k", "$50-74k", "$75k+")),
    sclass = factor(sclass, levels = c("Lower", "Working", "Middle", "Upper")),
    region = cut(x$region, breaks = c(0, 2, 4, 7, 9),
                 labels = c("Northeast", "Midwest", "South", "West")),
    row.names = rownames(x)
  )
  out
}

# Design matrix for the regressions and coherence models: factor columns with
# reference categories, plus numeric 0/1 class and education indicators.
demographic_design <- function(x) {
  f <- demographic_factors(x)
  lev <- function(v, l) as.numeric(v == l)
  bin <- function(v, l) factor(lev(v, l), levels = c(0, 1))
  data.frame(
    gender = f$gender,
    race = f$race,
    age6 = f$age6,
    educ_hsless = lev(f$educ, "HS or less"),
    educ_somecol = bin(f$educ, "Some college"),
    educ_bach = bin(f$educ, "Bachelor's"),
    educ_postgrad = bin(f$educ, "Postgraduate"),
    parentba = f$parentba,
    income4 = f$income4,
    sclass_lower = lev(f$sclass, "Lower"),
    sclass_working = bin(f$sclass, "Working"),
    sclass_middle = bin(f$sclass, "Middle"),
    sclass_upper = bin(f$sclass, "Upper"),
    region = f$region,
    row.names = rownames(x)
  )
}

# Every category as a 0/1 indicator (no reference dropped), for the Pearson
# correlations in script 09.
demographic_indicators <- function(x) {
  f <- demographic_factors(x)
  lev <- function(v, l) as.numeric(v == l)
  data.frame(
    woman = lev(f$gender, "Female"),
    educ_hsless = lev(f$educ, "HS or less"),
    educ_somecol = lev(f$educ, "Some college"),
    educ_bach = lev(f$educ, "Bachelor's"),
    educ_postgrad = lev(f$educ, "Postgraduate"),
    parentba = lev(f$parentba, "Parents BA"),
    sclass_lower = lev(f$sclass, "Lower"),
    sclass_working = lev(f$sclass, "Working"),
    sclass_middle = lev(f$sclass, "Middle"),
    sclass_upper = lev(f$sclass, "Upper"),
    age_18_29 = lev(f$age6, "18-29"),
    age_30_39 = lev(f$age6, "30-39"),
    age_40_49 = lev(f$age6, "40-49"),
    age_50_59 = lev(f$age6, "50-59"),
    age_60_69 = lev(f$age6, "60-69"),
    age_70 = lev(f$age6, "70+"),
    race_white = lev(f$race, "White"),
    race_asian = lev(f$race, "Asian"),
    race_black = lev(f$race, "Black"),
    race_hisp = lev(f$race, "Hispanic"),
    race_multi = lev(f$race, ">1 race"),
    race_other = lev(f$race, "Other"),
    income_lt25 = lev(f$income4, "<$25k"),
    income_25_49 = lev(f$income4, "$25-49k"),
    income_50_74 = lev(f$income4, "$50-74k"),
    income_75 = lev(f$income4, "$75k+"),
    region_ne = lev(f$region, "Northeast"),
    region_mw = lev(f$region, "Midwest"),
    region_s = lev(f$region, "South"),
    region_w = lev(f$region, "West"),
    row.names = rownames(x)
  )
}

# Shared analysis sample: respondents with every covariate observed.
demographic_keep <- function(x) {
  complete.cases(demographic_design(x))
}
