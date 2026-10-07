# 03-figures.R
# Publication figures for the complex-tastes manuscript.
# Writes PDFs to manuscript/figures/.

library(ggplot2)
library(ggrepel)

res <- readRDS("output/mfa_results.rds")
dir.create("manuscript/figures", showWarnings = FALSE, recursive = TRUE)

theme_set(theme_minimal(base_size = 10))

# --- Figure 1: scree plot ----------------------------------------------------
eig <- as.data.frame(res$eig[, ])
names(eig) <- c("lambda", "pct", "cum")
eig$dim <- seq_len(nrow(eig))
p1 <- ggplot(eig, aes(factor(dim), lambda, group = 1)) +
  geom_col(fill = "grey75", color = "grey40", linewidth = 0.2) +
  geom_line(linewidth = 0.4) +
  geom_point(size = 1.6) +
  geom_text(aes(label = sprintf("%.1f%%", pct)), vjust = -0.7, size = 2.6) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(x = "Dimension", y = "Eigenvalue",
       title = "Scree plot: eigenvalues of the MFA",
       subtitle = "Labels: percentage of variance explained") +
  theme(panel.grid.minor = element_blank())
ggsave("manuscript/figures/fig-scree.pdf", p1, width = 5, height = 3.4)

# --- Figure 2: individual factor map -----------------------------------------
ind <- as.data.frame(res$ind$coord[, 1:2])
names(ind) <- c("dim1", "dim2")
p2 <- ggplot(ind, aes(dim1, dim2)) +
  geom_point(alpha = 0.12, size = 0.5, color = "grey25") +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60") +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  labs(x = "Dimension 1", y = "Dimension 2",
       title = "Individual factor map (MFA dimensions 1-2)",
       subtitle = "n = 2,259 valid respondents") +
  theme(panel.grid.minor = element_blank())
ggsave("manuscript/figures/fig-individuals.pdf", p2, width = 5, height = 4)

# --- Figure 3: category map ---------------------------------------------------
cc <- as.data.frame(res$quali.var$coord[, 1:2])
names(cc) <- c("dim1", "dim2")
cc$name <- rownames(cc)
cc$modality <- ifelse(grepl("^pref_", cc$name), "Preference",
                 ifelse(grepl("^cons_", cc$name), "Consumption", "Evaluation"))
cc$yes <- grepl("_1$", cc$name)
cc$genre <- sub("^(pref|cons|eval)_", "", cc$name)
# "no" categories shown in light grey for reference
p3 <- ggplot(cc, aes(dim1, dim2)) +
  geom_hline(yintercept = 0, linetype = 2, color = "grey60") +
  geom_vline(xintercept = 0, linetype = 2, color = "grey60") +
  geom_point(data = subset(cc, !yes), color = "grey80", size = 0.9) +
  geom_point(data = subset(cc, yes), aes(color = modality), size = 1.5,
             alpha = 0.9) +
  ggrepel::geom_text_repel(data = subset(cc, yes),
                           aes(label = genre, color = modality), size = 2.4,
                           segment.color = NA, max.overlaps = 25,
                           show.legend = FALSE) +
  scale_color_manual(values = c(Preference = "#0072B2",
                                Consumption = "#D55E00",
                                Evaluation = "#009E73")) +
  labs(x = "Dimension 1", y = "Dimension 2",
       color = "Modality",
       title = "Category map: 'yes' categories by taste modality",
       subtitle = "Grey points: 'no' categories") +
  theme(panel.grid.minor = element_blank())
ggsave("manuscript/figures/fig-categories.pdf", p3, width = 6, height = 5)

# --- Figure 4: group contributions by dimension --------------------------------
gc <- as.data.frame(res$group$contrib[, 1:3])
gc$group <- rownames(gc)
gcl <- reshape(gc, direction = "long", varying = 1:3, v.names = "contrib",
               times = paste0("Dim ", 1:3), timevar = "dim", idvar = "group")
gcl$dim <- factor(gcl$dim, levels = paste0("Dim ", 1:3))
gcl$group <- factor(gcl$group, levels = c("Preference", "Consumption", "Evaluation"))
p4 <- ggplot(gcl, aes(dim, contrib, fill = group)) +
  geom_col(position = position_dodge(), color = "grey30", linewidth = 0.2) +
  scale_fill_manual(values = c(Preference = "#0072B2",
                               Consumption = "#D55E00",
                               Evaluation = "#009E73")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(x = NULL, y = "Contribution to dimension (%)", fill = "Modality",
       title = "Group contributions to the first three MFA dimensions") +
  theme(panel.grid.minor = element_blank(),
        legend.position = "top")
ggsave("manuscript/figures/fig-group-contrib.pdf", p4, width = 5, height = 3.4)

# --- Figure 5: RV coefficient heatmap (3x3) ------------------------------------
rv <- res$group$RV
rv <- rv[c("Preference", "Consumption", "Evaluation"),
         c("Preference", "Consumption", "Evaluation")]
rvdf <- data.frame(
  g1 = rep(rownames(rv), 3),
  g2 = rep(colnames(rv), each = 3),
  rv = as.vector(rv))
rvdf$g1 <- factor(rvdf$g1, levels = c("Preference", "Consumption", "Evaluation"))
rvdf$g2 <- factor(rvdf$g2, levels = rev(c("Preference", "Consumption", "Evaluation")))
p5 <- ggplot(rvdf, aes(g1, g2, fill = rv)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.2f", rv)), size = 3.2) +
  scale_fill_gradient(low = "#F5F5F5", high = "#2166AC", limits = c(0, 1)) +
  coord_fixed() +
  labs(x = NULL, y = NULL, fill = "RV",
       title = "RV coefficients between taste modalities") +
  theme(panel.grid = element_blank(),
        axis.text.x = element_text(angle = 30, hjust = 1))
ggsave("manuscript/figures/fig-rv.pdf", p5, width = 4, height = 3.6)

# --- LaTeX tables -------------------------------------------------------------
dir.create("manuscript/tables", showWarnings = FALSE, recursive = TRUE)

# eigenvalues
eig5 <- res$eig[1:5, ]
tab <- cbind(
  Dimension = sprintf("$%d$", 1:5),
  Eigenvalue = sprintf("%.3f", eig5[, 1]),
  Pct = sprintf("%.1f", eig5[, 2]),
  Cum = sprintf("%.1f", eig5[, 3]))
writeLines(c(
  "\\begin{tabular}{lccc}", "\\toprule",
  "Dimension & Eigenvalue & \\% variance & Cumulative \\% \\\\", "\\midrule",
  paste0(apply(tab, 1, paste, collapse = " & "), " \\\\"), "\\bottomrule", "\\end{tabular}"),
  "manuscript/tables/tab-eigen.tex")

# RV coefficients
rvm <- res$group$RV[c("Preference", "Consumption", "Evaluation", "MFA"),
                    c("Preference", "Consumption", "Evaluation", "MFA")]
rlines <- c(
  "\\begin{tabular}{lcccc}", "\\toprule",
  " & Preference & Consumption & Evaluation & MFA \\\\", "\\midrule")
for (i in seq_len(nrow(rvm))) {
  rlines <- c(rlines, paste0(rownames(rvm)[i], " & ",
    paste(sprintf("%.3f", rvm[i, ]), collapse = " & "), " \\\\"))
}
rlines <- c(rlines, "\\bottomrule", "\\end{tabular}")
writeLines(rlines, "manuscript/tables/tab-rv.tex")

# group structure: weight, contributions, Lg with MFA
w <- sapply(res$separate.analyses, function(a) a$eig[1, 1])
gcont <- res$group$contrib[1:3, 1:3]
gLg <- res$group$Lg[1:3, "MFA"]
gnames <- c("Preference", "Consumption", "Evaluation")
glines <- c(
  "\\begin{tabular}{lccccc}", "\\toprule",
  " & & \\multicolumn{3}{c}{Contributions (\\%)} & \\\\",
  "\\cmidrule(lr){3-5}",
  "Group & Weight & Dim 1 & Dim 2 & Dim 3 & $Lg$ with MFA \\\\",
  "\\midrule")
for (i in 1:3) {
  glines <- c(glines, paste0(gnames[i], " & ", sprintf("%.3f", w[i]), " & ",
    paste(sprintf("%.1f", gcont[i, ]), collapse = " & "), " & ",
    sprintf("%.2f", gLg[i]), " \\\\"))
}
glines <- c(glines, "\\bottomrule", "\\end{tabular}")
writeLines(glines, "manuscript/tables/tab-groups.tex")

# genre-level yes rates
genres <- c("Classical", "Opera", "Jazz", "Broadway/Show", "Mood/Easy",
            "Big Band", "Classic Rock/Oldies", "Country", "Bluegrass", "Folk",
            "Hymns/Gospel", "Latin/Spanish/Salsa", "Rap/Hip-Hop", "Blues/R&B",
            "Reggae", "Top 40/Pop", "Contemporary Rock", "Indie/Alt Rock",
            "Dance/Club", "Heavy Metal")
gshort <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop",
            "blurb", "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")
md <- mfa_dat_raw <- readRDS("data/mfa_input.rds")
rates <- sapply(gshort, function(g) c(
  pref = mean(md[[paste0("pref_", g)]]),
  cons = mean(md[[paste0("cons_", g)]]),
  eval = mean(md[[paste0("eval_", g)]])))
rl2 <- c(
  "\\begin{tabular}{lccc}", "\\toprule",
  "Genre & Preference & Consumption & Evaluation \\\\", "\\midrule")
for (i in seq_along(gshort)) {
  gname <- gsub("&", "\\\\&", genres[i])
  rl2 <- c(rl2, paste0(gname, " & ",
    paste(sprintf("%.1f", rates[, i] * 100), collapse = " & "), " \\\\"))
}
rl2 <- c(rl2, "\\midrule",
  paste0("Overall & ", paste(sprintf("%.1f", rowMeans(rates) * 100), collapse = " & "),
         " \\\\"), "\\bottomrule", "\\end{tabular}")
writeLines(rl2, "manuscript/tables/tab-genre-rates.tex")

cat("figures written:\n")
cat(paste(" ", list.files("manuscript/figures", full.names = TRUE)), sep = "\n")
cat("tables written:\n")
cat(paste(" ", list.files("manuscript/tables", full.names = TRUE)), sep = "\n")
