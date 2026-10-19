# 15-audience-shares.R
# Black, Hispanic, and female shares of each genre's liking audience: among
# respondents who like genre g (taste == 1, decision 1), the share who are Black,
# Hispanic, or female. Race and gender come from the shared coding in
# scripts/demographics-coding.R. The sample is the 2,259 complete cases on the 60 MFA
# variables (rows of data/mfa_input.rds, as in script 01). A respondent with missing
# race or gender is excluded from the corresponding share only. Saves
# output/audience-shares.csv and prints the table, sorted by Black share.
#
# Second part: across the 20 genres, correlations between each audience share and the
# matching genre-level coefficient from script 13 (Black vs White, Hispanic vs White,
# woman vs man). Also reports partial correlations controlling for each genre's overall
# liking rate, with Fisher-z intervals that treat genres as independent (they are not,
# since respondents answer several genres). Saves output/audience-correlations.csv.
# Requires output/genre-omega-regression.csv (script 13).

genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop", "blurb",
            "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")
stopifnot(length(genres) == 20)

mfa <- readRDS("data/mfa_input.rds")
stopifnot(nrow(mfa) == 2259)
ssi <- readRDS("data/ssi2012_cleaned.rds") |> haven::zap_labels()
source("scripts/demographics-coding.R")
ssi_rows <- ssi[as.numeric(rownames(mfa)), ]
stopifnot(nrow(ssi_rows) == 2259)

dem <- demographic_factors(ssi_rows)
black <- dem$race == "Black"
hispanic <- dem$race == "Hispanic"
female <- dem$gender == "Female"
sample_black <- mean(black, na.rm = TRUE)
sample_hispanic <- mean(hispanic, na.rm = TRUE)
sample_female <- mean(female, na.rm = TRUE)

audience <- function(g) {
  like <- ssi_rows[[paste0(g, "taste")]] %in% 1
  ok_race <- like & !is.na(black)
  ok_gender <- like & !is.na(female)
  data.frame(genre = g,
             n_like = sum(like),
             n_like_race = sum(ok_race),
             n_like_gender = sum(ok_gender),
             black_share = mean(black[ok_race]),
             hispanic_share = mean(hispanic[ok_race]),
             female_share = mean(female[ok_gender]),
             sample_black = sample_black,
             sample_hispanic = sample_hispanic,
             sample_female = sample_female)
}

out <- do.call(rbind, lapply(genres, audience))
out <- out[order(-out$black_share), ]
rownames(out) <- NULL
write.csv(out, "output/audience-shares.csv", row.names = FALSE)

cat("Sample: Black", round(sample_black, 3), " Hispanic", round(sample_hispanic, 3),
    " female", round(sample_female, 3), "\n")
print(transform(out, black_share = round(black_share, 3),
                hispanic_share = round(hispanic_share, 3),
                female_share = round(female_share, 3)),
      row.names = FALSE)

cf <- read.csv("output/genre-omega-regression.csv")
coef_for <- function(term) {
  x <- cf[cf$term == term, ]
  x$b[match(out$genre, x$genre)]
}
liking_rate <- out$n_like / nrow(ssi_rows)
partial_r <- function(x, y) {
  cor(residuals(lm(x ~ liking_rate)), residuals(lm(y ~ liking_rate)))
}
# Fisher-z interval; df = n - 3 for raw r, n - 4 for partial r (n = 20 genres)
fisher_ci <- function(r, df) tanh(atanh(r) + c(-1.96, 1.96) / sqrt(df))

pairs <- list(black = list(share = out$black_share, term = "raceBlack"),
              hispanic = list(share = out$hispanic_share, term = "raceHispanic"),
              female = list(share = out$female_share, term = "genderFemale"))
cors <- do.call(rbind, lapply(names(pairs), function(k) {
  x <- pairs[[k]]$share
  y <- coef_for(pairs[[k]]$term)
  r <- cor(x, y)
  pr <- partial_r(x, y)
  raw_ci <- fisher_ci(r, 17)
  part_ci <- fisher_ci(pr, 16)
  data.frame(group = k, r = r, ci_lo = raw_ci[1], ci_hi = raw_ci[2],
             partial_r = pr, partial_ci_lo = part_ci[1], partial_ci_hi = part_ci[2])
}))
cors$liking_rate_vs_share <- c(cor(liking_rate, out$black_share),
                               cor(liking_rate, out$hispanic_share),
                               cor(liking_rate, out$female_share))
write.csv(cors, "output/audience-correlations.csv", row.names = FALSE)
print(cors, digits = 2, row.names = FALSE)
