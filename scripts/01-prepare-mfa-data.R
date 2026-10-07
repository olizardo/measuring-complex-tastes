# 01-prepare-mfa-data.R
# Build the 60-column MFA input: 20 genres x 3 taste modalities
# (preference = like, consumption = listened past month,
#  evaluation = typical fan perceived as high status)
#
# Coding decisions (per author):
#   preference : like = 1; dislike / neither / not familiar = 0
#   consumption: listened = 1 (as collected)
#   evaluation : typical fan is college grad AND (middle OR upper class) = 1
# Sample: complete cases on all 60 variables ("valid respondents")

library(dplyr)

df <- readRDS("data/ssi2012_cleaned.rds")
df[] <- lapply(df, function(x) if (haven::is.labelled(x)) haven::zap_labels(x) else x)

genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop",
            "blurb", "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")

stopifnot(length(genres) == 20)

# --- preference: like vs everything else ------------------------------------
pref_raw <- paste0(genres, "taste")
pref <- setNames(as.data.frame(lapply(df[pref_raw], function(x) as.integer(x == 1))),
                 paste0("pref_", genres))

# --- consumption: listened in past month ------------------------------------
lis_raw <- paste0(genres, "lis")
cons <- setNames(as.data.frame(lapply(df[lis_raw], function(x) as.integer(x))),
                 paste0("cons_", genres))

# --- evaluation: typical fan is high status ---------------------------------
# high status = college graduate AND (middle class OR upper class)
status_raw <- paste0(rep(genres, each = 3), rep(c("grad", "mc", "uc"), times = 20))
eval_high <- lapply(genres, function(g) {
  grad <- df[[paste0(g, "grad")]] == 1
  clas <- rowSums(df[, paste0(g, c("mc", "uc"))], na.rm = TRUE) > 0
  as.integer(grad & clas)
})
eval_high <- setNames(as.data.frame(eval_high), paste0("eval_", genres))
# propagate item-level missingness (fan vars share the same 2 missing rows)
for (g in genres) {
  eval_high[[paste0("eval_", g)]][is.na(df[[paste0(g, "grad")]])] <- NA
}

mfa_dat <- cbind(pref, cons, eval_high)

n_before <- nrow(mfa_dat)
mfa_dat <- mfa_dat[complete.cases(mfa_dat), ]
n_after <- nrow(mfa_dat)

saveRDS(mfa_dat, "data/mfa_input.rds")

cat(sprintf("rows: %d -> %d complete cases\n", n_before, n_after))
cat(sprintf("columns: %d (3 groups x 20)\n", ncol(mfa_dat)))
cat("\nOverall yes-rates by modality:\n")
data.frame(
  preference = mean(as.matrix(mfa_dat[, paste0("pref_", genres)])),
  consumption = mean(as.matrix(mfa_dat[, paste0("cons_", genres)])),
  evaluation = mean(as.matrix(mfa_dat[, paste0("eval_", genres)]))
) |> print()
