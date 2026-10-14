# script 09: Genre-specific demographic patterns in omega (genre-based complex taste)
# Generates visualizations showing which demographic groups hold complex tastes
# concentrated in which genres

library(tidyverse)
library(ggplot2)
library(gridExtra)
library(ggrepel)

# Load data
ssi <- readRDS("data/ssi2012_cleaned.rds") |> haven::zap_labels()
mfa_results <- readRDS("output/antinomy_scores.rds")
ant <- mfa_results$ant
omega <- mfa_results$omega

# ant and omega rownames are the original SSI row indices (1-based)
omega_indices <- as.numeric(rownames(ant))

# Extract demographic variables for the complete cases only
# Note: indexing with numeric indices in R is 1-based
bach_sub <- ssi$bach[omega_indices] %in% 1
ma_sub <- ssi$ma[omega_indices] %in% 1
doc_sub <- ssi$docprof[omega_indices] %in% 1
lower_sub <- ssi$lower[omega_indices] %in% 1
working_sub <- ssi$working[omega_indices] %in% 1
middle_sub <- ssi$middle[omega_indices] %in% 1
high_sub <- ssi$high[omega_indices] %in% 1
white_sub <- ssi$white[omega_indices] %in% 1
black_sub <- ssi$black[omega_indices] %in% 1
hisp_sub <- ssi$hisp[omega_indices] %in% 1
asian_sub <- ssi$asian[omega_indices] %in% 1
multirace_sub <- ssi$multirace[omega_indices] %in% 1
otherrace_sub <- ssi$otherrace[omega_indices] %in% 1

demo_vars <- data.frame(
  row_index = omega_indices,
  parentba = as.numeric(bach_sub | ma_sub | doc_sub),
  sclass = ifelse(lower_sub, 1,
           ifelse(working_sub, 2,
           ifelse(middle_sub, 3,
           ifelse(high_sub, 4, NA)))),
  female = as.numeric(ssi$female[omega_indices]),
  age = as.numeric(ssi$age[omega_indices]),
  race = ifelse(white_sub, 0,
         ifelse(black_sub, 1,
         ifelse(hisp_sub, 2,
         ifelse(asian_sub, 3,
         ifelse(multirace_sub | otherrace_sub, 4, NA)))))
)

if (nrow(demo_vars) != dim(omega)[1]) {
  cat("ERROR: nrow(demo_vars) =", nrow(demo_vars), "!= dim(omega)[1] =", dim(omega)[1], "\n")
  stop("Dimension mismatch")
}

# Genre names (from MFA analysis)
genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband",
            "crold", "country", "blueg", "folk", "hymgos", "latspsal",
            "raphiphop", "blurb", "reggae", "toppop", "controck",
            "indalt", "danclub", "hvymtl")

# Compute correlations between ω scores and demographics
# omega is N × G × D (respondent, genre, dimension)
dim(omega)  # should be 2259 x 20 x 3

corr_list <- list()
for (d in 1:3) {
  # Extract ω for this dimension
  omega_d <- omega[, , d]  # 2259 x 20
  
  # Compute Pearson correlations with each demographic
  corrs <- data.frame(
    dimension = d,
    genre = rep(genres, 5),
    demographic = rep(c("Parents' Education", "Subjective Class", 
                        "Female", "Age", "Race/Ethnicity"), each = 20),
    correlation = c(
      sapply(1:20, \(g) cor(omega_d[, g], demo_vars$parentba, use = "complete")),
      sapply(1:20, \(g) cor(omega_d[, g], demo_vars$sclass, use = "complete")),
      sapply(1:20, \(g) cor(omega_d[, g], demo_vars$female, use = "complete")),
      sapply(1:20, \(g) cor(omega_d[, g], demo_vars$age, use = "complete")),
      sapply(1:20, \(g) cor(omega_d[, g], demo_vars$race, use = "complete"))
    )
  )
  corr_list[[d]] <- corrs
}

corr_data <- do.call(rbind, corr_list)
rownames(corr_data) <- NULL

# Select 8 key genres for the main visualization
key_genres <- c("opera", "classical", "raphiphop", "latspsal", "indalt",
                "bwayst", "bband", "hvymtl")

corr_main <- corr_data |>
  filter(genre %in% key_genres) |>
  mutate(
    genre = factor(genre, levels = key_genres),
    dimension = factor(dimension, labels = c("Dimension 1", "Dimension 2", "Dimension 3")),
    demographic = factor(demographic, 
                        levels = c("Parents' Education", "Subjective Class", 
                                  "Female", "Age", "Race/Ethnicity")),
    genre_display = recode(genre,
      opera = "Opera",
      classical = "Classical",
      raphiphop = "Rap/Hip-Hop",
      latspsal = "Latin/Salsa",
      indalt = "Indie Rock",
      bwayst = "Musicals",
      bband = "Big Band",
      hvymtl = "Heavy Metal"
    )
  )

# Create lollipop chart for main figure
p_main <- ggplot(corr_main, aes(x = demographic, y = correlation, color = correlation)) +
  geom_hline(yintercept = 0, color = "grey40", linetype = "solid", linewidth = 0.3) +
  geom_segment(aes(x = demographic, xend = demographic, y = 0, yend = correlation),
               linewidth = 1.2, alpha = 0.7) +
  geom_point(size = 4.5, stroke = 0.8, color = "white", show.legend = FALSE) +
  geom_point(aes(color = correlation), size = 3.5, show.legend = TRUE) +
  scale_color_gradient2(
    low = "#08519C", mid = "white", high = "#A63603",
    limits = c(-0.5, 0.5),
    guide = guide_colorbar(title = "Correlation (r)", barwidth = 8, barheight = 0.5)
  ) +
  facet_grid(genre_display ~ dimension, scales = "free_x") +
  coord_flip() +
  labs(
    x = NULL,
    y = "Pearson correlation with ω (genre-based complex taste)",
    title = "Which demographic groups concentrate complex tastes in which genres?",
    subtitle = "Lollipop length shows strength and direction of association"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "grey92", linewidth = 0.2),
    panel.grid.major.y = element_blank(),
    axis.text.x = element_text(size = 9),
    axis.text.y = element_text(size = 10, face = "bold"),
    strip.text.x = element_text(size = 10, face = "bold"),
    strip.text.y = element_text(size = 10, face = "bold", angle = 0),
    plot.title = element_text(size = 12, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 10, hjust = 0, color = "grey30"),
    legend.position = "bottom"
  )

ggsave("manuscript/figures/fig-omega-demographics.pdf", p_main,
       width = 14, height = 9, dpi = 300)
cat("✓ Saved fig-omega-demographics.pdf (lollipop chart, 8 key genres)\n")

# Create genre-by-demographic breakdown (supplementary visualization)
# Shows the top 5 genres for each demographic effect on each dimension
corr_all <- corr_data |>
  mutate(
    dimension = factor(dimension, labels = c("Dimension 1 (volume)", 
                                             "Dimension 2 (highbrow–popular)",
                                             "Dimension 3 (status valuation)")),
    demographic = factor(demographic,
                        levels = c("Parents' Education", "Subjective Class",
                                  "Female", "Age", "Race/Ethnicity")),
    abs_corr = abs(correlation)
  )

# For each demographic×dimension, get top 5 genres
top_genres <- corr_all |>
  group_by(demographic, dimension) |>
  arrange(desc(abs_corr)) |>
  slice_head(n = 5) |>
  ungroup() |>
  mutate(
    genre = factor(genre, levels = genres),
    genre_display = recode(genre,
      classical = "Classical", opera = "Opera", jazz = "Jazz",
      bwayst = "Musicals", moodez = "Mood/Easy Listening", bband = "Big Band",
      crold = "Classic Rock/Oldies", country = "Country", blueg = "Bluegrass",
      folk = "Folk", hymgos = "Hymns/Gospel", latspsal = "Latin/Salsa",
      raphiphop = "Rap/Hip-Hop", blurb = "Blues/R&B", reggae = "Reggae",
      toppop = "Top 40/Pop", controck = "Contemporary Rock", indalt = "Indie Rock",
      danclub = "Dance/Club", hvymtl = "Heavy Metal"
    )
  )

# Stacked bar chart (without tidytext dependency)
# Manually reorder genres within each demographic
top_genres_ord <- top_genres %>%
  mutate(
    genre_display = factor(genre_display),
    dem_dim = paste(demographic, dimension, sep = "_")
  ) %>%
  group_by(dem_dim) %>%
  mutate(genre_order = rank(-abs(correlation))) %>%
  ungroup() %>%
  mutate(
    genre_ordered = paste(genre_display, genre_order, dem_dim, sep = "_"),
    genre_ordered = factor(genre_ordered)
  )

p_genres <- ggplot(top_genres_ord, aes(y = fct_reorder(genre_display, -abs(correlation)),
                                        x = correlation, fill = as.factor(sign(correlation)))) +
  geom_col(color = "grey20", linewidth = 0.3) +
  geom_text(aes(label = sprintf("%.2f", correlation)),
            hjust = ifelse(top_genres_ord$correlation > 0, -0.2, 1.2),
            size = 3, fontface = "bold") +
  scale_fill_manual(values = c(`1` = "#A63603", `-1` = "#08519C"),
                   labels = c(`1` = "Positive", `-1` = "Negative"),
                   name = "Direction") +
  scale_x_continuous(expand = expansion(mult = c(0.15, 0.15))) +
  facet_grid(demographic ~ dimension, scales = "free", space = "free_y") +
  labs(
    x = "Pearson correlation with ω",
    y = NULL,
    title = "Genre-specific demographic patterns in complex taste",
    subtitle = "Top 5 genres by effect size for each demographic variable and dimension"
  ) +
  theme_minimal(base_size = 10) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "grey92", linewidth = 0.2),
    axis.text.x = element_text(size = 9),
    axis.text.y = element_text(size = 9, face = "bold"),
    strip.text = element_text(size = 10, face = "bold"),
    plot.title = element_text(size = 13, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 10, hjust = 0, color = "grey30"),
    legend.position = "bottom"
  )

ggsave("manuscript/figures/fig-omega-demographics-genres.pdf", p_genres,
       width = 14, height = 10, dpi = 300)
cat("✓ Saved fig-omega-demographics-genres.pdf (top-5 genres breakdown)\n")

# Create full supplementary heatmap (all 20 genres)
corr_hm <- corr_data |>
  pivot_wider(
    id_cols = c(genre, demographic),
    names_from = dimension,
    values_from = correlation
  ) |>
  mutate(genre = factor(genre, levels = genres))

# Reorder by max absolute correlation
genre_order <- corr_data |>
  group_by(genre) |>
  summarise(max_abs = max(abs(correlation))) |>
  arrange(desc(max_abs)) |>
  pull(genre)

corr_hm_ord <- corr_data |>
  mutate(
    genre = factor(genre, levels = genre_order),
    dimension = factor(dimension, labels = c("Dim 1", "Dim 2", "Dim 3"))
  )

p_hm <- ggplot(corr_hm_ord, aes(x = dimension, y = genre, fill = correlation)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = sprintf("%.2f", correlation)),
            size = 2.5, color = ifelse(abs(corr_hm_ord$correlation) > 0.25, "white", "grey20")) +
  scale_fill_gradient2(
    low = "#08519C", mid = "white", high = "#A63603",
    limits = c(-0.5, 0.5),
    guide = guide_colorbar(title = "Correlation (r)", barwidth = 1, barheight = 10)
  ) +
  facet_wrap(~ demographic, nrow = 1) +
  labs(
    x = NULL,
    y = NULL,
    title = "Demographic correlations with genre-based complex taste (ω): all 20 genres",
    subtitle = "Full correlation matrix; colors indicate effect strength and direction"
  ) +
  theme_minimal(base_size = 9) +
  theme(
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 8),
    strip.text = element_text(size = 10, face = "bold"),
    plot.title = element_text(size = 12, face = "bold", hjust = 0),
    plot.subtitle = element_text(size = 9, hjust = 0, color = "grey30"),
    panel.grid = element_blank(),
    legend.position = "right"
  )

ggsave("manuscript/figures/fig-omega-demographics-heatmap.pdf", p_hm,
       width = 16, height = 8, dpi = 300)
cat("✓ Saved fig-omega-demographics-heatmap.pdf (supplementary, all 20 genres)\n")

# Create summary statistics table
summary_stats <- corr_data |>
  group_by(demographic, dimension) |>
  summarise(
    mean_r = mean(correlation),
    max_r = max(correlation),
    min_r = min(correlation),
    max_abs_r = max(abs(correlation)),
    .groups = "drop"
  ) |>
  arrange(demographic, dimension)

cat("\n=== Summary: Effect Sizes by Demographic and Dimension ===\n")
print(summary_stats)

cat("\n=== Top 10 Strongest Effects Overall ===\n")
top10 <- corr_data |>
  mutate(abs_corr = abs(correlation)) |>
  arrange(desc(abs_corr)) |>
  slice_head(n = 10) |>
  select(demographic, genre, dimension, correlation) |>
  mutate(correlation = sprintf("%.3f", correlation))
print(top10)

cat("\n✓ Script 09 complete: omega-demographics visualizations generated\n")
