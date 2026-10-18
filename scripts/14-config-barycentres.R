# 14-config-barycentres.R
# Genre-by-configuration positions in the common MFA space, for Ma's six complex
# configurations. For genre g and configuration c, two positions:
#   B_gcs  barycentre: mean global position F_s(i) of the respondents who hold c
#          for genre g (main text, Section 3.4). Respondent-level, so it includes
#          the contributions of the other genres among those respondents.
#   O_gcs  own contribution: sum over aspects h of (z_ch - p_gh) * Delta_ghs, the
#          genre's contribution through its three aspects (Appendix E). It depends
#          only on c, and summing over genres gives each respondent's position.
# Figures use the complex cells with at least CELL_MIN_N respondents, in configurations
# with at least CFG_MIN_CELLS such cells.
# Outputs: output/config-barycentres.{rds,csv} and four PDFs in manuscript/figures.

library(ggplot2)
library(ggrepel)

CELL_MIN_N <- 30    # minimum respondents for a genre x configuration cell to be plotted
CFG_MIN_CELLS <- 5  # a configuration panel is shown only if this many of its cells pass CELL_MIN_N
NDIM <- 4
flip <- c(-1, 1, 1, 1)  # same sign anchoring as script 02
label_seed <- 4721

genres <- c("classical", "opera", "jazz", "bwayst", "moodez", "bband", "crold",
            "country", "blueg", "folk", "hymgos", "latspsal", "raphiphop",
            "blurb", "reggae", "toppop", "controck", "indalt", "danclub", "hvymtl")
genre_display <- c(
  classical = "Classical", opera = "Opera", jazz = "Jazz", bwayst = "Musicals",
  moodez = "Mood/Easy", bband = "Big band", crold = "Oldies", country = "Country",
  blueg = "Bluegrass", folk = "Folk", hymgos = "Gospel", latspsal = "Latin",
  raphiphop = "Rap", blurb = "Blues", reggae = "Reggae", toppop = "Top 40",
  controck = "Cont. rock", indalt = "Indie", danclub = "Dance", hvymtl = "Metal"
)
cfg_levels <- c("+++", "++-", "-++", "+-+", "-+-", "+--", "--+", "---")
cx <- c("++-", "-++", "+-+", "-+-", "+--", "--+")
cx_lab <- c(
  "++-" = "Guilty pleasure (++-)", "-++" = "Pre-acquired (-++)",
  "+-+" = "Taste pose (+-+)", "-+-" = "Distanced consumption (-+-)",
  "+--" = "Justified abstention (+--)", "--+" = "Distant praise (--+)"
)

res <- readRDS("output/mfa_results.rds")
mfa_dat <- readRDS("data/mfa_input.rds")
ant <- readRDS("output/antinomy_scores.rds")$ant
passive_ids <- readRDS("output/passive_ids.rds")
active_ids <- setdiff(rownames(mfa_dat), passive_ids)
stopifnot(identical(rownames(ant), rownames(mfa_dat)))

Zb <- as.matrix(mfa_dat)
stopifnot(identical(colnames(Zb),
                    paste0(rep(c("pref", "cons", "eval"), each = 20), "_", rep(genres, times = 3))))
Fg <- as.matrix(ant[, paste0("F", 1:NDIM)])

# configuration held in each genre x respondent cell
yn <- function(a) ifelse(Zb[, paste0(a, "_", genres)] == 1, "+", "-")
CFG <- matrix(paste0(as.vector(yn("pref")), as.vector(yn("cons")), as.vector(yn("eval"))),
              nrow = nrow(Zb), dimnames = list(NULL, genres))

cells <- expand.grid(genre = genres, cfg = cfg_levels, stringsAsFactors = FALSE)
cells$n <- 0L
bary <- matrix(NA_real_, nrow(cells), NDIM)
for (k in seq_len(nrow(cells))) {
  hit <- CFG[, cells$genre[k]] == cells$cfg[k]
  cells$n[k] <- sum(hit)
  bary[k, ] <- colMeans(Fg[hit, , drop = FALSE])
}

# each genre's eight cells partition the sample, so count-weighted barycentres give the centre
cent <- sapply(genres, function(g) {
  k <- cells$genre == g
  colSums(cells$n[k] * bary[k, , drop = FALSE]) / sum(cells$n[k])
})
chk_centre <- max(abs(cent - colMeans(Fg)))
stopifnot(chk_centre < 1e-8, all(tapply(cells$n, cells$genre, sum) == nrow(Zb)))

# genre-aspect contributions, as in script 04 section 3b
gp <- res$global.pca
w <- gp$call$col.w[seq_len(120)]
Vl <- sweep(as.matrix(gp$svd$V)[seq_len(120), seq_len(NDIM), drop = FALSE], 2, flip, "*")
enm <- paste0(rep(c("pref", "cons", "eval"), each = 40),
              "_", rep(genres, each = 2, times = 3), "_", rep(0:1, times = 60))
stopifnot(identical(colnames(gp$call$X)[seq_along(enm)], enm))
pm <- colMeans(Zb[match(active_ids, rownames(mfa_dat)), ])
stopifnot(all(pm > 0 & pm < 1))
Delta <- array(0, c(length(genres), 3, NDIM))
for (h in 1:3) for (g in seq_along(genres)) {
  j1 <- 2 * (20 * (h - 1) + g)
  p <- pm[20 * (h - 1) + g]
  Delta[g, h, ] <- (w[j1] * Vl[j1, ] - w[j1 - 1] * Vl[j1 - 1, ]) / sqrt(p * (1 - p))
}
own <- t(sapply(seq_len(nrow(cells)), function(k) {
  g <- match(cells$genre[k], genres)
  Reduce(`+`, lapply(1:3, function(h) {
    z <- as.integer(substr(cells$cfg[k], h, h) == "+")
    (z - pm[20 * (h - 1) + g]) * Delta[g, h, ]
  }))
}))

# the genre contributions must sum to each respondent's global position
key <- paste(cells$genre, cells$cfg)
own_resp <- matrix(0, nrow(Zb), NDIM)
for (g in genres) own_resp <- own_resp + own[match(paste(g, CFG[, g]), key), , drop = FALSE]
chk_own <- max(abs(own_resp - Fg))
stopifnot(chk_own < 1e-8)

mix_cor <- sapply(1:NDIM, function(s) cor(bary[, s], own[, s]))

plot_k <- which(cells$cfg %in% cx & cells$n >= CELL_MIN_N)
cfg_cells <- table(cells$cfg[plot_k])
cfg_keep <- names(cfg_cells)[cfg_cells >= CFG_MIN_CELLS]
plot_k <- plot_k[cells$cfg[plot_k] %in% cfg_keep]
n_complex <- sum(cells$cfg %in% cx)
cat("Exactness checks: centre", signif(chk_centre, 2), "| own sum", signif(chk_own, 2), "\n")
cat("Complex cells:", n_complex, "| plotted (n >=", CELL_MIN_N, "):", length(plot_k),
    "| omitted:", n_complex - length(plot_k), "\n")
cat("Plotted cells by configuration:\n")
print(table(factor(cells$cfg[plot_k], levels = cx)))
cat("Cell size range over complex cells:", range(cells$n[cells$cfg %in% cx]), "\n")
cat("Correlation of barycentre with own contribution across all 160 cells, dims 1-4:",
    round(mix_cor, 3), "\n")

out <- cbind(cells,
             setNames(as.data.frame(bary), paste0("B", 1:NDIM)),
             setNames(as.data.frame(own), paste0("O", 1:NDIM)))
out$plotted <- seq_len(nrow(out)) %in% plot_k
saveRDS(list(cells = out, CELL_MIN_N = CELL_MIN_N, checks = c(centre = chk_centre, own = chk_own),
             mix_cor = mix_cor), "output/config-barycentres.rds")
out_r <- out
num <- vapply(out_r, is.numeric, logical(1))
num[names(num) == "n"] <- FALSE
out_r[num] <- lapply(out_r[num], round, 4)
write.csv(out_r, "output/config-barycentres.csv", row.names = FALSE)

cloud_plot <- function(pos, dims, xlab, ylab) {
  d <- data.frame(x = pos[plot_k, dims[1]], y = pos[plot_k, dims[2]],
                  lab = unname(genre_display[cells$genre[plot_k]]),
                  cfg_lab = factor(cx_lab[cells$cfg[plot_k]], levels = cx_lab))
  ggplot(d, aes(x = x, y = y, label = lab)) +
    geom_hline(yintercept = 0, colour = "grey60", linetype = "dashed", linewidth = 0.3) +
    geom_vline(xintercept = 0, colour = "grey60", linetype = "dashed", linewidth = 0.3) +
    geom_point(size = 0.8, colour = "grey25") +
    geom_text_repel(size = 2.2, colour = "grey15", box.padding = 0.35, point.padding = 0.15,
                    force = 4, force_pull = 0.3, max.time = 5, min.segment.length = 0,
                    segment.colour = "grey60", segment.size = 0.25, max.overlaps = Inf,
                    seed = label_seed) +
    facet_wrap(~ cfg_lab) +
    labs(x = xlab, y = ylab) +
    theme_minimal(base_size = 9) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_line(colour = "grey92", linewidth = 0.2),
          strip.background = element_blank(),
          strip.text = element_text(face = "bold", size = 8),
          panel.border = element_rect(colour = "grey80", fill = NA, linewidth = 0.3))
}
lab12 <- c("Dimension 1 (highbrow\u2013popular)", "Dimension 2 (volume)")
lab34 <- c("Dimension 3 (engagement divide)", "Dimension 4 (status valuation)")

ggsave("manuscript/figures/fig-config-barycentre-d12.pdf",
       cloud_plot(bary, c(1, 2), lab12[1], lab12[2]), width = 6.5, height = 5.6, device = cairo_pdf)
ggsave("manuscript/figures/fig-config-barycentre-d34.pdf",
       cloud_plot(bary, c(3, 4), lab34[1], lab34[2]), width = 6.5, height = 5.6, device = cairo_pdf)
ggsave("manuscript/figures/fig-config-own-d12.pdf",
       cloud_plot(own, c(1, 2), lab12[1], lab12[2]), width = 6.5, height = 5.6, device = cairo_pdf)
ggsave("manuscript/figures/fig-config-own-d34.pdf",
       cloud_plot(own, c(3, 4), lab34[1], lab34[2]), width = 6.5, height = 5.6, device = cairo_pdf)

# Group counts for each plotted cell: mean number of OTHER genres (focal genre excluded)
# that the cell's respondents like, listen to, or grant high status, with a percentile
# bootstrap over respondents. Baseline is the same count over the full sample.
BOOT_B <- 2000
set.seed(6183)
boot_means <- function(xm) colMeans(matrix(xm[sample.int(length(xm), length(xm) * BOOT_B, replace = TRUE)],
                                           nrow = length(xm)))
count_prefix <- c(liked = "pref", listened = "cons", granted = "eval")
total_cnt <- sapply(count_prefix, function(p) rowSums(Zb[, paste0(p, "_", genres)]))
grp_counts <- do.call(rbind, lapply(plot_k, function(k) {
  g <- cells$genre[k]
  mem <- CFG[, g] == cells$cfg[k]
  row <- data.frame(genre = g, cfg = cells$cfg[k], n = sum(mem),
                    B1 = bary[k, 1], B2 = bary[k, 2], B3 = bary[k, 3], B4 = bary[k, 4])
  for (m in names(count_prefix)) {
    x <- total_cnt[, m] - Zb[, paste0(count_prefix[m], "_", g)]
    ci <- quantile(boot_means(x[mem]), c(0.025, 0.975))
    row[[paste0(m, "_mean")]] <- mean(x[mem])
    row[[paste0(m, "_lo")]] <- unname(ci[1])
    row[[paste0(m, "_hi")]] <- unname(ci[2])
    row[[paste0(m, "_base")]] <- mean(x)
    row[[paste0(m, "_vs")]] <- if (ci[1] > mean(x)) "above" else if (ci[2] < mean(x)) "below" else "overlaps"
  }
  row
}))
write.csv(as.data.frame(lapply(grp_counts, function(x) if (is.numeric(x)) round(x, 3) else x)),
          "output/config-group-counts.csv", row.names = FALSE)
summ <- do.call(rbind, lapply(cfg_keep, function(k) {
  a <- grp_counts[grp_counts$cfg == k, ]
  data.frame(cfg = k, cells = nrow(a),
             liked_above = sum(a$liked_vs == "above"), liked_below = sum(a$liked_vs == "below"),
             listened_above = sum(a$listened_vs == "above"), listened_below = sum(a$listened_vs == "below"),
             granted_above = sum(a$granted_vs == "above"), granted_below = sum(a$granted_vs == "below"),
             B1_mean = mean(a$B1), B1_pos = sum(a$B1 > 0), B2_mean = mean(a$B2), B2_pos = sum(a$B2 > 0),
             B3_mean = mean(a$B3), B3_pos = sum(a$B3 > 0), B4_mean = mean(a$B4), B4_pos = sum(a$B4 > 0),
             liked_mean = mean(a$liked_mean), liked_base = mean(a$liked_base),
             listened_mean = mean(a$listened_mean), listened_base = mean(a$listened_base),
             granted_mean = mean(a$granted_mean), granted_base = mean(a$granted_base))
}))
cat("\nGroup counts by configuration (cells above/below sample baseline):\n")
print(summ, digits = 3, row.names = FALSE)
summ_out <- summ
num <- sapply(summ_out, is.numeric)
summ_out[num] <- lapply(summ_out[num], round, 3)
write.csv(summ_out, "output/config-group-summary.csv", row.names = FALSE)

# Individual-level and dimension 4 checks cited in the Section 3.4 text and Appendix E
gc <- res$group$contrib
stopifnot(identical(rownames(gc), c("Preference", "Consumption", "Evaluation")),
          abs(sum(gc[, "Dim.4"]) - 100) < 1e-6)
n_liked_all <- rowSums(Zb[, paste0("pref_", genres)])
n_listened_all <- rowSums(Zb[, paste0("cons_", genres)])
n_granted_all <- rowSums(Zb[, paste0("eval_", genres)])
plot_sd <- sapply(1:NDIM, function(s) c(bary = sd(bary[plot_k, s]), own = sd(own[plot_k, s]),
                                       other = sd(bary[plot_k, s] - own[plot_k, s])))
pre_n <- cells$n[cells$cfg == "-++"]
checks <- data.frame(
  statistic = c("spearman_D2_genres_liked", "spearman_D2_genres_listened", "spearman_D4_genres_granted",
                "evaluation_share_dim4_pct", "preference_share_dim4_pct", "consumption_share_dim4_pct",
                paste0("mix_cor_dim", 1:NDIM), paste0("sd_bary_dim", 1:NDIM),
                paste0("sd_own_dim", 1:NDIM), paste0("sd_other_dim", 1:NDIM),
                "complex_cells_total", "complex_cells_plotted",
                "preacquired_cells_min_n", "preacquired_cells_max_n"),
  value = c(cor(Fg[, 2], n_liked_all, method = "spearman"),
            cor(Fg[, 2], n_listened_all, method = "spearman"),
            cor(Fg[, 4], n_granted_all, method = "spearman"),
            gc["Evaluation", "Dim.4"], gc["Preference", "Dim.4"], gc["Consumption", "Dim.4"],
            mix_cor, plot_sd["bary", ], plot_sd["own", ], plot_sd["other", ],
            sum(cells$cfg %in% cx), length(plot_k), min(pre_n), max(pre_n))
)
checks$value <- round(checks$value, 3)
write.csv(checks, "output/config-text-checks.csv", row.names = FALSE)
cat("\nText checks:\n")
print(checks, row.names = FALSE)
