# script 09: Genre-specific demographic patterns in omega (genre-based complex taste)
# Generates visualizations showing which demographic groups hold complex tastes
# concentrated in which genres

library(tidyverse)
library(ggplot2)

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
# Cleaner demographic extraction using case_when

demo_vars <- tibble(
  row_index = omega_indices,
  parentba = as.numeric(
    (ssi$bach[omega_indices] == 1) | 
    (ssi$ma[omega_indices] == 1) | 
    (ssi$docprof[omega_indices] == 1)
  ),
  age = as.numeric(ssi$age[omega_indices]),
  gender = as.numeric(ssi$female[omega_indices]),  # 1=Female, 0=Male
  sclass = case_when(
    ssi$lower[omega_indices] == 1 ~ "Lower class",
    ssi$working[omega_indices] == 1 ~ "Working class",
    ssi$middle[omega_indices] == 1 ~ "Middle class",
    ssi$high[omega_indices] == 1 ~ "Upper class",
    TRUE ~ NA_character_
  ),
  race = case_when(
    ssi$white[omega_indices] == 1 ~ "White",
    ssi$black[omega_indices] == 1 ~ "Black",
    ssi$hisp[omega_indices] == 1 ~ "Hispanic",
    ssi$asian[omega_indices] == 1 ~ "Asian",
    (ssi$multirace[omega_indices] == 1) | (ssi$otherrace[omega_indices] == 1) ~ "Multirace/Other",
    TRUE ~ NA_character_
  )
)

# Validation checks
stopifnot(nrow(demo_vars) == nrow(ant), 
          nrow(demo_vars) == dim(omega)[1])
stopifnot(all(demo_vars$row_index == as.numeric(rownames(ant))))
cat("✓ Demographic extraction validated: N =", nrow(demo_vars), "\n")

# Genre names (from MFA analysis)
genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband",
            "crold", "country", "blueg", "folk", "hymgos", "latspsal",
            "raphiphop", "blurb", "reggae", "toppop", "controck",
            "indalt", "danclub", "hvymtl")

genre_display <- c(
  classical = "Classical",
  opera = "Opera",
  jazz = "Jazz",
  bwayst = "Musicals",
  moodez = "Mood/Easy Listening",
  bband = "Big Band",
  crold = "Classic Rock/Oldies",
  country = "Country",
  blueg = "Bluegrass",
  folk = "Folk",
  hymgos = "Hymns/Gospel",
  latspsal = "Latin/Salsa",
  raphiphop = "Rap/Hip-Hop",
  blurb = "Blues/R&B",
  reggae = "Reggae",
  toppop = "Top 40/Pop",
  controck = "Contemporary Rock",
  indalt = "Indie Rock",
  danclub = "Dance/Club",
  hvymtl = "Heavy Metal"
)

dim_labels <- c(
  "Dimension 1 (volume)",
  "Dimension 2 (highbrow–popular)",
  "Dimension 3 (status valuation)"
)

# ============================================================================
# STEP 2: COMPUTE EFFECT SIZES (CORRELATIONS AND CENTERED MEANS)
# ============================================================================

compute_effects <- function(omega_d, demo_var, demo_name, is_continuous = TRUE) {
  # omega_d: N x G matrix (respondents × genres for one dimension)
  # demo_var: vector of length N (continuous or categorical)
  # demo_name: character name of demographic
  # is_continuous: if TRUE, use Pearson r; if FALSE, compute centered means
  
  if (is_continuous) {
    # Pearson correlations
    corr <- sapply(1:ncol(omega_d), function(g) {
      cor(omega_d[, g], demo_var, use = "complete.obs")
    })
    
    tibble(
      genre = colnames(omega_d),
      demographic = demo_name,
      effect_size = corr,
      type = "correlation"
    )
  } else {
    # Categorical: compute mean ω per category, center at grand mean
    unique_cats <- na.omit(unique(demo_var))
    
    results <- lapply(unique_cats, function(cat) {
      cat_mean <- colMeans(omega_d[demo_var == cat, , drop = FALSE], na.rm = TRUE)
      grand_mean <- colMeans(omega_d, na.rm = TRUE)
      centered <- cat_mean - grand_mean
      
      tibble(
        genre = colnames(omega_d),
        demographic = paste0(demo_name, ": ", cat),
        effect_size = centered,
        type = "centered_mean"
      )
    })
    
    do.call(rbind, results)
  }
}

# Loop over dimensions
corr_list <- list()

for (d in 1:3) {
  omega_d <- omega[, , d]  # N x G matrix for this dimension
  colnames(omega_d) <- genres
  
  # Continuous variables: parentba, age, gender
  cont_results <- rbind(
    compute_effects(omega_d, demo_vars$parentba, "Parents' Education", is_continuous = TRUE),
    compute_effects(omega_d, demo_vars$age, "Age", is_continuous = TRUE),
    compute_effects(omega_d, demo_vars$gender, "Gender (Female)", is_continuous = TRUE)
  )
  
  # Categorical variables: subjective class, race/ethnicity
  cat_results <- rbind(
    compute_effects(omega_d, demo_vars$sclass, "Class", is_continuous = FALSE),
    compute_effects(omega_d, demo_vars$race, "Race/Ethnicity", is_continuous = FALSE)
  )
  
  all_results <- rbind(cont_results, cat_results) |>
    mutate(dimension = dim_labels[d])
  
  corr_list[[d]] <- all_results
}

corr_data <- do.call(rbind, corr_list) |>
  mutate(
    dimension = factor(dimension, levels = dim_labels),
    genre = factor(genre, levels = genres),
    genre_display = recode_factor(genre, !!!genre_display)
  )

cat("✓ Effect sizes computed: ", nrow(corr_data), "rows\n")

# ============================================================================
# STEP 3: BUILD MAIN FIGURE (fig-omega-demographics)
# ============================================================================
# 8 key genres × 5 demographic groupings × 3 dimensions
# Each cell: horizontal bars for different demographic categories

# Define key genres to highlight (those mentioned in prose)
key_genres <- c("raphiphop", "indalt", "danclub", "classical", "opera", 
                "bwayst", "bband", "latspsal")

# Prepare data for main figure: 
# Aggregate continuous vars + all categorical breakdown
main_data <- corr_data |>
  filter(genre %in% key_genres) |>
  mutate(
    # Simplify demographic labels for compact display
    demographic = case_when(
      str_detect(demographic, "^Parents") ~ "Parents' Educ",
      str_detect(demographic, "^Age$") ~ "Age",
      str_detect(demographic, "^Gender") ~ "Gender",
      str_detect(demographic, "^Class: ") ~ str_remove(demographic, "^Class: "),
      str_detect(demographic, "^Race") ~ str_remove(demographic, "^Race/Ethnicity: "),
      TRUE ~ demographic
    ),
    demographic = factor(demographic, 
                        levels = c("Parents' Educ", "Age", "Gender",
                                  "Lower class", "Working class", "Middle class", "Upper class",
                                  "White", "Black", "Hispanic", "Asian", "Multirace/Other"))
  ) |>
  arrange(dimension, genre_display, demographic)

# Create the integrated main figure with facet_grid
# Rows = dimensions, Columns = genres; within each cell, demographic bars
p_main <- ggplot(main_data, 
                 aes(y = fct_rev(demographic), x = effect_size, 
                     fill = ifelse(effect_size > 0, "positive", "negative"))) +
  # Bars
  geom_col(width = 0.75, color = "grey20", linewidth = 0.4) +
  # Value labels on bars
  geom_text(aes(label = sprintf("%.2f", effect_size)),
            hjust = ifelse(main_data$effect_size > 0, -0.15, 1.15),
            size = 2.8, fontface = "bold", color = "grey10", family = "sans") +
  # Zero line
  geom_vline(xintercept = 0, color = "grey40", linewidth = 0.5) +
  # Color scale
  scale_fill_manual(
    values = c(positive = "#2C5CA3", negative = "#C84E34"),
    guide = "none"
  ) +
  # Fixed x scale for cross-demographic comparison
  scale_x_continuous(limits = c(-0.35, 0.35), expand = expansion(mult = 0.1)) +
  # Facet: dimension rows × genre columns
  facet_grid(dimension ~ genre_display, scales = "free_y", space = "free_y") +
  # Labels
  labs(
    x = "Effect size",
    y = NULL,
    title = NULL
  ) +
  # Theme
  theme_minimal(base_size = 10) +
  theme(
    # Grid
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "grey90", linewidth = 0.25),
    # Axes
    axis.text.y = element_text(size = 9, face = "bold", hjust = 1, margin = margin(r = 3)),
    axis.text.x = element_text(size = 9, color = "grey40"),
    axis.title.x = element_text(size = 10, face = "bold", margin = margin(t = 5)),
    # Facets
    strip.text.x = element_text(size = 10, face = "bold", margin = margin(b = 3)),
    strip.text.y = element_text(size = 10, face = "bold", angle = 0, hjust = 0),
    # Overall
    plot.margin = margin(t = 5, r = 5, b = 5, l = 5),
    panel.spacing.y = unit(0.3, "lines")
  )

# Save main figure
ggsave("manuscript/figures/fig-omega-demographics.pdf", p_main,
       width = 8.5, height = 6.5, dpi = 300, device = "pdf")
cat("✓ Saved fig-omega-demographics.pdf (main: 8 key genres, 5 demographics, 3 dims)\n")

# ============================================================================
# STEP 4: BUILD SUPPLEMENTARY FIGURE (fig-omega-demographics-genres)
# ============================================================================
# All 20 genres, full demographic breakdown, as a heatmap

# For heatmap: use continuous effect sizes for all
heatmap_data <- corr_data |>
  select(dimension, genre, genre_display, demographic, effect_size) |>
  # Simplify demographic labels (same as main figure)
  mutate(
    demographic = case_when(
      str_detect(demographic, "^Parents") ~ "Parents' Educ",
      str_detect(demographic, "^Age$") ~ "Age",
      str_detect(demographic, "^Gender") ~ "Gender",
      str_detect(demographic, "^Class: ") ~ str_remove(demographic, "^Class: "),
      str_detect(demographic, "^Race") ~ str_remove(demographic, "^Race/Ethnicity: "),
      TRUE ~ demographic
    )
  )

# Create three heatmaps, one per dimension
for (d in 1:3) {
  dim_label <- dim_labels[d]
  dim_data <- heatmap_data |>
    filter(dimension == dim_label) |>
    # Reorder for sensible genre grouping
    mutate(genre_display = fct_reorder(genre_display, as.numeric(genre)))
  
  p_heat <- ggplot(dim_data, aes(x = demographic, y = genre_display, fill = effect_size)) +
    # Tiles
    geom_tile(color = "white", linewidth = 0.3) +
    # Value labels (only for |effect| > 0.10 to avoid clutter)
    geom_text(aes(label = ifelse(abs(effect_size) > 0.10, 
                                 sprintf("%.2f", effect_size), "")),
              size = 2.5, color = "grey20", family = "sans") +
    # Diverging color scale
    scale_fill_distiller(
      palette = "RdBu",
      limits = c(-0.4, 0.4),
      oob = scales::squish,
      name = "Effect size",
      guide = guide_colorbar(title.position = "top", title.hjust = 0.5,
                            barwidth = 12, barheight = 0.5)
    ) +
    # Labels
    labs(x = "Demographic category", y = "Genre", title = dim_label) +
    # Theme
    theme_minimal(base_size = 9) +
    theme(
      # Grid
      panel.grid = element_blank(),
      # Axes
      axis.text.x = element_text(size = 9, angle = 45, hjust = 1, face = "bold"),
      axis.text.y = element_text(size = 9),
      axis.title = element_text(size = 10, face = "bold"),
      # Title
      plot.title = element_text(size = 11, face = "bold", hjust = 0.5),
      # Legend
      legend.position = "top",
      legend.title = element_text(size = 9, face = "bold"),
      legend.text = element_text(size = 8),
      # Overall
      plot.margin = margin(t = 5, r = 5, b = 5, l = 5)
    )
  
  # Save individual heatmap
  filename <- paste0("manuscript/figures/fig-omega-demographics-heatmap-dim", d, ".pdf")
  ggsave(filename, p_heat, width = 10, height = 8, dpi = 300, device = "pdf")
  cat("✓ Saved", filename, "\n")
}

# Combine all three heatmaps into one supplementary figure
# (For appendix: stack vertically or place side-by-side as needed)
cat("✓ Heatmap generation complete (3 supplementary dimension-specific PDFs)\n")

# ============================================================================
# STEP 5: CONSOLE SUMMARY
# ============================================================================

cat("\n=== SUMMARY: Effect Sizes by Demographic ===\n")
summary_by_demo <- corr_data |>
  group_by(demographic) |>
  summarise(
    n_genres = n_distinct(genre),
    mean_effect = mean(effect_size, na.rm = TRUE),
    sd_effect = sd(effect_size, na.rm = TRUE),
    max_effect = max(abs(effect_size), na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(max_effect))
print(summary_by_demo)

cat("\n=== TOP 15 STRONGEST EFFECTS (by absolute magnitude) ===\n")
top_effects <- corr_data |>
  mutate(abs_effect = abs(effect_size)) |>
  arrange(desc(abs_effect)) |>
  slice_head(n = 15) |>
  select(dimension, genre_display, demographic, effect_size) |>
  mutate(effect_size = sprintf("%.3f", effect_size))
print(top_effects)

cat("\n✓ Script 09 complete: omega-demographics visualizations generated\n")
cat("  - Main figure: fig-omega-demographics.pdf (8 genres × 5 demographics × 3 dims)\n")
cat("  - Supplementary: fig-omega-demographics-heatmap-dim[1-3].pdf (20 genres, full breakdown)\n")
