# script 09: Genre-specific demographic patterns in omega (genre-based complex taste)
# Generates visualizations showing which demographic groups hold complex tastes
# concentrated in which genres
#
# Design (2026-10-14 revision): all demographic effects are Pearson correlations on a
# single shared scale -- continuous variables entered as measured; subjective class as
# its 1-4 ordinal scale; race/ethnicity as category indicators (White reference shown
# for context). Figures are colored-value matrices: every cell prints its correlation,
# color (the paper's #08519C--white--#A63603 diverging palette, as in fig-signatures)
# highlights the strong cells. Position/number encoding, not color intensity, carries
# the information -- the effects are small (max |r| ~ 0.43) and color-only maps go gray.

library(tidyverse)
library(ggplot2)
library(patchwork)

# Load data
ssi <- readRDS("data/ssi2012_cleaned.rds") |> haven::zap_labels()
mfa_results <- readRDS("output/antinomy_scores.rds")
ant <- mfa_results$ant
omega <- mfa_results$omega

# ant and omega rownames are the original SSI row indices (1-based)
omega_indices <- as.numeric(rownames(ant))

# ============================================================================
# STEP 1: EXTRACT DEMOGRAPHICS FOR COMPLETE CASES
# ============================================================================

demo_vars <- tibble(
  row_index = omega_indices,
  parentba = as.numeric(
    (ssi$bach[omega_indices] == 1) |
    (ssi$ma[omega_indices] == 1) |
    (ssi$docprof[omega_indices] == 1)
  ),
  age = as.numeric(ssi$age[omega_indices]),
  gender = as.numeric(ssi$female[omega_indices]),  # 1 = woman, 0 = man
  sclass_num = case_when(
    ssi$lower[omega_indices] == 1 ~ 1,
    ssi$working[omega_indices] == 1 ~ 2,
    ssi$middle[omega_indices] == 1 ~ 3,
    ssi$high[omega_indices] == 1 ~ 4,
    TRUE ~ NA_real_
  ),
  white = as.numeric(ssi$white[omega_indices] == 1),
  black = as.numeric(ssi$black[omega_indices] == 1),
  hisp = as.numeric(ssi$hisp[omega_indices] == 1),
  asian = as.numeric(ssi$asian[omega_indices] == 1),
  otherrace = as.numeric(
    (ssi$multirace[omega_indices] == 1) | (ssi$otherrace[omega_indices] == 1)
  )
)

# Validation
stopifnot(nrow(demo_vars) == nrow(ant), nrow(demo_vars) == dim(omega)[1])
stopifnot(all(demo_vars$row_index == as.numeric(rownames(ant))))
cat("Demographic extraction validated: N =", nrow(demo_vars), "\n")

# Genre names (MFA column order) and display names
genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband",
            "crold", "country", "blueg", "folk", "hymgos", "latspsal",
            "raphiphop", "blurb", "reggae", "toppop", "controck",
            "indalt", "danclub", "hvymtl")

genre_display <- c(
  classical = "Classical", opera = "Opera", jazz = "Jazz",
  bwayst = "Musicals", moodez = "Mood/Easy", bband = "Big band",
  crold = "Oldies", country = "Country", blueg = "Bluegrass",
  folk = "Folk", hymgos = "Gospel", latspsal = "Latin",
  raphiphop = "Rap", blurb = "Blues", reggae = "Reggae",
  toppop = "Top 40", controck = "Cont. rock", indalt = "Indie",
  danclub = "Dance", hvymtl = "Metal"
)

# Demographic rows, in manuscript prose order (education, class, age, gender, race)
demo_rows <- c("parentba", "sclass_num", "age", "gender",
               "white", "black", "hisp", "asian", "otherrace")
demo_labels <- c(
  parentba = "Parents' educ.",
  sclass_num = "Class scale",
  age = "Age",
  gender = "Woman",
  white = "White",
  black = "Black",
  hisp = "Hispanic",
  asian = "Asian",
  otherrace = "Multirace/Other"
)

dim_labels <- c("Dimension 1 (volume)", "Dimension 2 (highbrow-popular)",
                "Dimension 3 (status valuation)")

# ============================================================================
# STEP 2: COMPUTE PEARSON CORRELATIONS (ALL ON ONE SHARED SCALE)
# ============================================================================

corr_list <- list()
for (d in 1:3) {
  omega_d <- omega[, , d]
  colnames(omega_d) <- genres

  block <- lapply(demo_rows, function(v) {
    r <- sapply(genres, function(g) {
      cor(omega_d[, g], demo_vars[[v]], use = "complete.obs")
    })
    tibble(dimension = dim_labels[d], demographic = demo_labels[v],
           genre = genres, r = r)
  })
  corr_list[[d]] <- bind_rows(block)
}

corr_data <- bind_rows(corr_list) |>
  mutate(
    dimension = factor(dimension, levels = dim_labels),
    genre = factor(genre, levels = genres),
    genre_short = recode_factor(genre, !!!genre_display)
  )
cat("Correlations computed:", nrow(corr_data), "cells; max |r| =",
    sprintf("%.2f", max(abs(corr_data$r))), "\n")

# Shared diverging palette (matches fig-signatures) with data-matched limits
R_LIM <- max(0.45, max(abs(corr_data$r)) + 0.02)
low_col <- "#A63603"; high_col <- "#08519C"

# Heatmap-matrix builder. Two explicit orientations (no aes indirection):
#   mk_demo_rows():  rows = demographics, cols = genres (main figure)
#   mk_genre_rows(): rows = genres, cols = demographics (supplementary)
fmt_r <- function(r) ifelse(abs(r) < 0.005, "0.00", sprintf("%.2f", r))

# cells with |r| at or above this threshold get a dark outline, so the key
# patterns stand out against the printed values (author request, 2026-10-14)
R_MIN <- 0.15

matrix_theme <- function() theme_minimal(base_size = 8) + theme(
  panel.grid = element_blank(),
  axis.title = element_blank(),
  axis.ticks = element_blank(),
  plot.title = element_text(size = 9.5, face = "bold", hjust = 0.5),
  plot.margin = margin(2, 2, 2, 2)
)

mk_demo_rows <- function(data, y_labels = TRUE, text_size = 2.1) {
  ggplot(data, aes(x = genre_short,
                   y = factor(demographic, levels = rev(demo_labels)),
                   fill = r)) +
    geom_tile(color = "white", linewidth = 0.4) +
    geom_tile(data = ~ subset(.x, abs(r) >= R_MIN), fill = NA,
              color = "grey20", linewidth = 0.9) +
    geom_text(aes(label = fmt_r(r), color = abs(r) > 0.30),
              size = text_size, show.legend = FALSE) +
    scale_color_manual(values = c(`TRUE` = "white", `FALSE` = "grey15")) +
    scale_fill_gradient2(low = low_col, mid = "grey92", high = high_col,
                         midpoint = 0, limits = c(-R_LIM, R_LIM),
                         name = "Pearson r",
                         guide = guide_colourbar(barwidth = 7, barheight = 0.8)) +
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_discrete(expand = c(0, 0)) +
    matrix_theme() +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4, size = 7),
      axis.text.y = if (y_labels) element_text(size = 8) else element_blank(),
      legend.position = "bottom",
      legend.title = element_text(size = 8),
      legend.text = element_text(size = 7)
    )
}

mk_genre_rows <- function(data, y_labels = TRUE, x_labels = TRUE, text_size = 1.8) {
  ggplot(data, aes(x = factor(demographic, levels = demo_labels_supp),
                   y = genre_short, fill = r)) +
    geom_tile(color = "white", linewidth = 0.4) +
    geom_tile(data = ~ subset(.x, abs(r) >= R_MIN), fill = NA,
              color = "grey20", linewidth = 0.9) +
    geom_text(aes(label = fmt_r(r), color = abs(r) > 0.30),
              size = text_size, show.legend = FALSE) +
    scale_color_manual(values = c(`TRUE` = "white", `FALSE` = "grey15")) +
    scale_fill_gradient2(low = low_col, mid = "grey92", high = high_col,
                         midpoint = 0, limits = c(-R_LIM, R_LIM),
                         name = "Pearson r",
                         guide = guide_colourbar(barwidth = 7, barheight = 0.8)) +
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_discrete(expand = c(0, 0)) +
    matrix_theme() +
    theme(
      axis.text.x = if (x_labels) element_text(angle = 90, hjust = 1, vjust = 0.4,
                                               size = 7) else element_blank(),
      axis.text.y = if (y_labels) element_text(size = 7.5) else element_blank(),
      legend.position = "bottom",
      legend.title = element_text(size = 9),
      legend.text = element_text(size = 8)
    )
}

dim_titles <- c("Dimension 1\n(volume)", "Dimension 2\n(highbrow-popular)",
                "Dimension 3\n(status valuation)")

# ============================================================================
# STEP 3: MAIN FIGURES -- 8 key genres, one figure per dimension (2026-10-14)
# The combined three-panel version was split at the author's request, matching
# the treatment of the supplementary twenty-genre matrices. Rows = 9
# demographics, columns = 8 key genres.
# ============================================================================

key_genres <- c("raphiphop", "indalt", "danclub", "classical", "opera",
                "bwayst", "bband", "latspsal")

for (i in seq_along(dim_labels)) {
  d <- corr_data |>
    filter(dimension == dim_labels[i], genre %in% key_genres) |>
    mutate(genre_short = factor(genre_short, levels = genre_display[key_genres]))
  p_i <- mk_demo_rows(d, y_labels = TRUE, text_size = 2.5) +
    ggtitle(dim_titles[i])
  fname <- sprintf("manuscript/figures/fig-omega-demographics-dim%d.pdf", i)
  ggsave(fname, p_i, width = 4.6, height = 3.2, dpi = 300)
  cat("Saved", basename(fname), "(9 demographics x 8 key genres)\n")
}

# The combined three-panel version is replaced by the three per-dimension
# figures; remove it so no stale file lingers in the repo.
unlink("manuscript/figures/fig-omega-demographics.pdf")

# ============================================================================
# STEP 4: SUPPLEMENTARY FIGURES -- one full matrix per dimension (2026-10-14)
# The combined three-panel heatmap was unreadable (cell text ~1pt after the
# .95\linewidth downscale) and showed only 7 of 9 demographics. Splitting one
# figure per dimension lets every cell print large enough to read, and ALL
# nine demographic variables are shown as columns (no omissions).
# ============================================================================

demo_labels_supp <- demo_labels  # all nine demographics, no omissions

for (i in seq_along(dim_labels)) {
  d <- corr_data |> filter(dimension == dim_labels[i])
  p_i <- mk_genre_rows(d, y_labels = TRUE, x_labels = TRUE, text_size = 3.0) +
    ggtitle(dim_titles[i]) +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4, size = 9),
      axis.text.y = element_text(size = 9),
      plot.title = element_text(size = 11.5, face = "bold", hjust = 0.5)
    )
  # Height 5.8in: the manuscript's \linewidth is 6.53in, so width=\linewidth
  # scales the figure up by 1.36x and a taller figure (plus caption) overflows
  # the ~9in \textheight. 5.8 x 1.36 = ~7.9in leaves room for the caption.
  fname <- sprintf("manuscript/figures/fig-omega-demographics-genres-d%d.pdf", i)
  ggsave(fname, p_i, width = 4.8, height = 5.8, dpi = 300)
  cat("Saved", basename(fname), "(20 genres x 9 demographics)\n")
}

# ============================================================================
# STEP 5: CONSOLE SUMMARY (number cross-check for the prose)
# ============================================================================

cat("\n=== Prose cross-check values ===\n")
chk <- corr_data |>
  filter(genre %in% c("raphiphop", "latspsal", "opera", "bwayst", "bband",
                      "indalt", "danclub", "classical", "hymgos", "hvymtl")) |>
  select(dimension, genre_short, demographic, r) |>
  mutate(r = sprintf("%.2f", r)) |>
  arrange(dimension, demographic, genre_short)
print(chk, n = 135)

cat("\nScript 09 complete.\n")
