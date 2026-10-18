# AGENTS.md — Measuring Complex Tastes

Project: measuring "complex tastes" (Ma Xiangyu 2026, *Cultural Sociology*) geometrically, using Multiple Factor Analysis (MFA) on 20 musical genres from the SSI-2012 survey. The manuscript draft is synced to Overleaf.

Status (2026-10-18): `manuscript/main.tex` compiles in a scratch copy (43 pp., no undefined references or citations). Overleaf is synced through the latest 2026-10-18 sync commit (see `git -C overleaf log -1`), which follows web edits 63652b6, 0dc8a1b, f9fb449, and d562ac0 (all merged; see Paper state). The workspace `manuscript/main.pdf` is stale and predates these edits.

## Conceptual frame

- Ma (2026) distinguishes three modalities of taste: preference, consumption, and valuation. Complex tastes are configurations in which these disagree (guilty pleasure, pre-acquired taste, taste pose, distanced consumption, justified abstention, distant praise). The manuscript calls the three **aspects**.
- Method: MFA (Pagès 2014; Abdi et al. 2013) as geometric data analysis. Three groups of 20 binary variables (one per genre per aspect), balanced by inverse first-eigenvalue weights.
- Each respondent has one partial point per aspect, and the global point is their mean. Per dimension $s$: $\sum_h F_{sh}^2 = H F_s^2 + W_s$, where $W_s$ is the aspect-disagreement score (decision 13). Pairwise squared partial-point distances sum to $H W_s$.
- Coordinates are named by role (decision 31): partial point $F_{sh}(i)$, global position $F_s(i)$, category coordinate $f_{js}$, and standard coordinate $V_{js}$.

## Data

- Source: https://olizardo.github.io/SSI-2012/ (repo `olizardo/SSI-2012`, branch `master`).
- Survey mode: online (author-confirmed 2026-10-17). The codebook does not record the mode.
- `data/ssi2012_cleaned.rds` (2,276 × 404, haven-labelled); `data/ssi2012_cleaned_coded.csv`; `data/ssi2012_codebook_metadata.csv`; `data/mfa_input.rds` (analysis input; rownames are original df row indices, which are the alignment keys for demographics).
- 20 genres: classical, opera, jazz, bwayst, moodez, bband, crold, country, blueg, folk, hymgos, latspsal, raphiphop, blurb, reggae, toppop, controck, indalt, danclub, hvymtl.
- Variable stems: `{g}taste` (1 like, 2 dislike, 3 neither, 4 not familiar); `{g}lis` (0/1 listened past month); fan-perception binaries `{g}grad`, `{g}nocol`, `{g}lc/wc/mc/uc`; plus gender, race, and age.

## Bibliography

`manuscript/references.bib` is a symlink to `/home/omarlizardo/projects/references.bib`. Add or edit citations in the global file, not the local symlink. For Overleaf, the copy must be a regular file (`cp -rL`), or bibtex breaks.

## Coding and terminology decisions (author-confirmed; do not change silently)

Numbers 3, 6, 7, 16–18, and 20 were retired. The remaining numbers are kept so cross-references stay valid.

1. **Preference**: like = 1; dislike, neither, and not familiar = 0. Unfamiliarity is treated as non-liking.
2. **Consumption**: as collected (0/1).
4. **Sample**: complete cases on all 60 variables give n = 2,259 of 2,276. Demographic models use complete cases on their covariates (N = 2,258; decision 21).
5. **Terminology**: the manuscript says "complex tastes," not "antinomies." `main.tex` is stored with one paragraph per line. Use "preference, engagement, and evaluation," not "feeling, doing, praising." Keep Ma's configuration names.
8. **Figures**: category maps on planes (D1,D2) and (D3,D4). `fig-individuals`, `fig-dim4`, `fig-scree`, `fig-rv`, `fig-antinomy-map`, and `fig-genre-segments` are generated but unreferenced. `fig-worked-example` overlays respondents 362 and 1881 in the same space, two panels — (D1,D4) and (D2,D4) — with color = respondent, shape = aspect, segments from partials to global, and a shared D4 y-scale (free x). This layout is the 2026-10-16 committed design (outer 43482bc, Overleaf 8ee78a1); on 2026-10-17 the working tree had regressed to an older 2×2 row-per-respondent layout and was restored to it. Partial-point numbers in prose are on the true FactoMineR partial scale (global = mean of partials).
9. **Age**: six groups (18–29 to 70+), collapsed from the 13 codebook bands (`age6`).
10. **Terminology**: "modality" is reserved for the GDA sense (a category of a categorical variable). The three blocks are "aspects of taste." Internal R names (`modality`) are unchanged. In prose, response options are "categories" or "response categories." "Modalities" and "groups" appear only in the Section 3.1 footnote that explains GDA usage.
11. **Terminology**: the evaluation measure is called "genre evaluation(s)" in prose.
12. **Evaluation coding (v3)**: eval = 1 iff (grad AND NOT nocol) OR ((mc OR uc) AND NOT (lc OR wc)). Yes-rate 20.7%. Earlier codings are in git history.
13. **Aspect-disagreement score** $W_s(i)$ measures aspect dispersion. It is interpreted as complex taste because a profile whose aspects place the person in different locations cannot be summarized by any single taste position. It is not configural complexity. Terminology (author-chosen 2026-10-18): the dimensional approach is **geometric complex taste**, measured by $W_s(i)$ on each dimension. Ma's per-genre configuration approach is **categorical complex taste**; its total count $n_{\text{complex}}$ is the number of genres in six complex configurations. Use the two terms in prose. Do not use "geometric complex taste" for the categorical count. The claim that $W_s(i)$ measures complex taste is argued, not stipulated. The 2026-10-09 author request that removed the "complex-taste score" label is archived in `agents-archive-2026-10-16.md` (decision 13 there). The manuscript states that this interpretation lacks validation against an outside criterion (Limitations).
14. **ω = genre-based component**: $\sum_g \omega_s(i;g)$. The cross-genre term is coherence, $\gamma_s$, and $W_s = \omega_s + \gamma_s$ exactly.
15. **Style**: no colons in prose, headings, captions, or table notes. The ban was applied to the whole manuscript on 2026-10-17; colons remain only in code, `\label`, `\ref`, and URLs. Use separate sentences, "so that," "and," or em-dash appositives. Split semicolon chains.
18. **Style**: the author confirmed the axis-first wording of the shares-versus-contributions sentence in the social section ("The first global axis is the extreme case, contributing only 2.5% ... yet carrying a third of the disagreement"). Do not re-repair it.
19. **Passive-individuals MFA is the main analysis** (author-approved). The 412 respondents who are constant within at least one aspect block are supplementary individuals in script 02 (ids in `output/passive_ids.rds`). The all-active fit survives only in the script-11 footnote. Dimensions: **D1 highbrow–popular, D2 volume, D3 engagement divide, D4 status valuation**. Eigenvalues 1.605/1.413/1.051/0.997. Separate λ1 0.1550/0.1265/0.1942 give weights 6.450/7.904/5.150. RV 0.353/0.014/0.015. The transposed MFA uses the 1,847 active rows. Full numbers: `notes-passive-refit.md`.
21. **Socio-demographic coding** (shared helper `scripts/demographics-coding.R`): gender male (ref.)/female; race White (ref.) plus Asian, Black, Hispanic, >1 race, Other; age six groups (18–29 ref.); education four binary groups (HS or less ref.; some college; bachelor's; postgraduate); parents' BA; income four groups (<$25k ref.); class four identity indicators (lower ref.); census region (Northeast ref.). Complete cases, N = 2,258.
22. **Script 05 deleted** (the supplementary MFA projection of demographics). Its position η² results were removed. Position claims cite the literature only.
23. **Pairwise shares** (`tab-pairs`) are the mean over respondents of each pair's squared distance divided by that respondent's dimension total. Current PC/PE/CE shares: D1 24/34/42; D2 33/38/30; D3 28/32/40; D4 9/46/46. The ratio-of-sample-means definition differs (D4 PC 2% vs 9%). Any share quoted in prose must say which definition it uses.
24. **No new named respondents in prose without setup.** Use general patterns or the existing cases 362 and 1881.
25. **Figure 10** (`fig-signatures`, Appendix A) shows four score types per dimension, in this order: F_s, W_s, ω_s, γ_s. γ carries 85–89% of W's variance on each dimension, so the W row mostly reflects coherence.
26. **No evaluative lead-ins or hyperbole.** Avoid "interesting," "surprising," "striking," "crucial," "dramatically," "sharply," "primary source," "genuinely," "fundamentally," "routinely," "ubiquitous," "woven throughout," "overwhelms," "soars," and rhetorical "Why?" questions in running prose. Avoid "strong" and "strongly" for patterns unless a CI or effect size supports them; use "linked to" or "associated with" plus the measure. "Total count" (`n_complex`) is the number of genres (of 20) held in any of the six complex configurations; its mean is 10.2.
27. **Eight-genre display removed from the main text** (author request, 2026-10-17). `fig-omega-demographics-dim1..4` do not appear in `main.tex`. The Results point to Appendix C (`app:omega-genres`, `fig-omega-genres-d1..4`), which shows all 20 genres and 30 indicators. The 66 of 2,400 cells with |r| ≥ 0.15 are outlined there. Do not report a genre-level split of those cells, since the eight genres were chosen on the same data. Script 09 still generates the eight-genre PDFs, unreferenced.
28. **Regression tables in Appendix D** (`app:regression`, author request, 2026-10-17): `tab:regression`, `tab:coherence-regression`, `tab:w-eta`, `tab:coherence-eta`, `tab:pairs-social`. Coefficient cells show b (SE), stars (unadjusted), a Holm dagger, and a 95% CI. Holm correction runs across all 96 coefficients in each table. Coefficient tables are wrapped in `{\scriptsize\input{…}}`; `\resizebox` overflows the page.
29. **Abstract and Limitations** (added 2026-10-17, awaiting approval). The abstract states only verified numbers: RV 0.35 and 0.01, disagreement shares of 49–66%, demographics explaining at most 10% of total disagreement, and 12 of 96 coefficients surviving Holm. Transposed genre-level results are excluded from the abstract. Discussion §4.1 (Limitations) covers the online survey, the unweighted analysis, unfamiliarity coded as non-liking, the 412 supplementary respondents, the 20-genre transposed results, and the cross-sectional regressions.
30. **Introduction and structure** (2026-10-17). The Introduction has four research questions and a roadmap; Section 2 carries `sec:data`. Appendix B has `tab:configurations`, whose triples match script 04 (lines 18–20): guilty ++-, pre-acquired -++, taste pose +-+, distanced consumption -+-, justified abstention +--, distant praise --+. Mean genres per respondent: simple taste 0.85, simple non-taste 8.92, guilty pleasure 3.22, pre-acquired 0.10, taste pose 0.96, distanced 0.41, justified 3.31, distant 2.22; 12 respondents hold no complex configuration. `tab:rv`, `tab:partial-axes`, and all six listed equations are cited in the text.
31. **Coordinate terms** (2026-10-18). Use a role name with every coordinate. Partial point $F_{sh}(i)$ is person $i$'s position on dimension $s$ in aspect $h$. Global position $F_s(i)$ is the mean of the three partial points. Category coordinate $f_{js}$ is the mean global position of the respondents who give category $j$, and equals $\lambda_s V_{js}\sqrt{(1-p_j)/p_j}$ (verified on the saved object for all 120 categories, residual SD about $10^{-13}$, with the dimension-1 sign reversed in the stored output). Standard coordinate $V_{js}$ is the MFA column vector, normalized so that $\sum_j w_j V_{js}^2 = 1$ over 120 columns, and signed to match the reported coordinates. Do not use bare "coordinate" for these four. The transposed (genre-level) section uses "position."
32. **Genre decomposition notation** (2026-10-18). $a_{ighs} = (z_{igh}-p_{gh})\,\Delta_{ghs}$ is genre $g$'s contribution, through aspect $h$, to the global position on dimension $s$. So $\sum_g\sum_h a_{ighs} = F_s(i)$ and $F_{sh}(i) = H\sum_g a_{ighs}$. The deviation is $d_{ighs} = a_{ighs} - \frac{1}{H}\sum_{h'} a_{igh's}$, written inline with no $\bar a$ symbol. $\gamma_s(i) = 2H^2\sum_{g<g'}\sum_h d_{ighs}d_{ig'hs}$ is stated explicitly. $J$ and $\lambda_{1,h}$ are defined once in Section 3.1, and $\lambda_s$ is the global eigenvalue on dimension $s$. Retired symbols: $c_{ihs}$, $\bar a_{igs}$, $T_s(i)$, $m_c$ (now $p_j$), and $G$ (now $J$).

## Statistical caution

## Statistical caution

- Pearson correlations in the ω–demographics figures and prose are point estimates without CIs (script 09, N = 2,258; SE ≈ 0.021 at r ≈ 0.10–0.20). The grid has 2,400 correlations, so most |r| < 0.15 cells are noise-level. Do not call one correlation stronger than another without a CI or formal test. Use hedged comparisons ("comparable," "slightly different"). Differences that recur across runs are reliable.
- For OLS coefficients, give the CI and say whether the coefficient survives Holm correction in its table. Do not describe unadjusted-only results as reliable.

## Pipeline (run from project root)

| Script | Output | Notes |
|---|---|---|
| `scripts/01-prepare-mfa-data.R` | `data/mfa_input.rds` | 60 binary columns (`pref_`, `cons_`, `eval_` prefixes) |
| `scripts/02-run-mfa.R` | `output/mfa_results.rds` | MFA with `group=c(20,20,20)`, `type=c("n","n","n")`; 412 passive respondents (`ind.sup`); sign flip `c(-1,1,1,1)` applied to coordinate outputs only |
| `scripts/03-figures.R` | scree, category maps, RV heatmap; `tab-eigen`, `tab-rv`, `tab-groups`, `tab-genre-rates` | `tab-groups` λ1 at 4 dp |
| `scripts/04-antinomies.R` | `output/antinomy_scores.rds`; `fig-configurations`, `fig-antinomy-map`, `fig-worked-example`, `fig-signatures`, `fig-genre-segments`, `fig-config-variation`, `tab-pairs` | W, Ma's 8 configurations, ω/γ split; `tab-pairs` uses mean of individual shares (decision 23); to regenerate only the heatmap, rerun its signature block |
| `scripts/demographics-coding.R` | (sourced helper) | Shared coding for 07, 09, 10 (decision 21) |
| `scripts/06-transposed-mfa.R` | `output/mfa_results_transposed.rds`; `fig-genre-map-d12`, `fig-genre-map-d13`, `tab-genre-profile` | Manual MFA (FactoMineR runs out of memory at this size) |
| `scripts/07-regression.R` | `tab-regression.tex`, `tab-w-eta.tex`, `tab-pairs-social.tex` | OLS of W1–W4 on shared coding; log-outcome and pairwise robustness; Holm daggers and CIs (decision 28) |
| `scripts/08-robustness-pca.R` | `output/robustness_pca.rds` | MCA-vs-PCA robustness (old fit) |
| `scripts/09-omega-demographics.R` | `fig-omega-demographics-dim1..4.pdf` (unreferenced); `fig-omega-demographics-genres-d1..4.pdf` (Appendix C) | Pearson r of 30 indicators with ω per genre |
| `scripts/10-coherence-demographics.R` | `tab-coherence-regression.tex`, `tab-coherence-eta.tex` | γ vs demographics; same CI and Holm format as script 07 |
| `scripts/11-straightliner-sensitivity.R` | `output/straightliner_sensitivity.rds` | Refits with the 412 as active (the old main fit); feeds the §3.1 footnote |
| `scripts/12-aggregate-regression.R` | `output/aggregate-regression.rds`; `manuscript/tables/tab-aggregate-regression.tex` | OLS of Ω and Γ (SD-scaled sums over dimensions 1–4) on the shared demographics, own Holm family of 48 (Appendix D, Table 14) |
| `scripts/mfa-coordinate-checks.R` | (sourced helper) | `check_mfa_coordinates(res)`, called in script 02 after the sign flip. Checks column normalization, $f_{js} = \lambda_s V_{js}\sqrt{(1-p_j)/p_j}$, and individual coordinates $F_s(i) = \sum_j x_{ij} w_j V_{js}$ (absolute tolerance 1e-4; sign per dimension). Stops the run on failure |

Table generation is done by scripts 03, 04, 06, 07, and 10. Never edit numbers in `manuscript/tables/` by hand.

## R and LaTeX gotchas

- Data: RDS columns are `haven_labelled`. Call `haven::zap_labels()` on load.
- FactoMineR: `type="n"` needs actual `factor()` columns. Supplementary columns must sit in a declared supplementary group (`num.group.sup`). `res$quali.var$coord` holds the active categories' barycentres (the mean global position of their respondents), verified on FactoMineR 2.16. FactoMineR does not apply the book's $1/\sqrt{\lambda_s}$ scaling (Pagès pp. 52, 71–72). The relation $f_{js} = \lambda_s V_{js}\sqrt{(1-p_j)/p_j}$ holds with `res$global.pca$svd$V`, but the dimension-1 sign is reversed in the stored output. Compute supplementary categories' barycentres manually.
- `res$global.pca$call$X` has 180 columns: the 120 numeric indicators (`_0`/`_1`, stored as text) and 60 raw factor columns (labels such as `pref_classical_1`). Select the 120 by name and call `as.numeric`. `res$global.pca$svd$V` is normalized in the column metric, $\sum_j w_j V_{js}^2 = 1$ with `w = res$global.pca$call$col.w`, not in the Euclidean metric. `res$eig` has five dimensions. Use `res$group$contrib`. `res$group$Lg` is group × group, not group × dimension.
- `res$ind$coord` holds only the 1,847 active rows. Use `res$ind.sup$coord`, or `ant$F1`–`ant$F4`, for all 2,259.
- `ant` and `type_counts` inherit rownames from `res$ind$coord` (original df indices, not positions). Index them consistently. `ant$ant` (from `output/antinomy_scores.rds`) has 51 columns: global `F1`–`F4`, `W1`–`W4`, per-aspect squared deviations `Wp`/`Wc`/`We` (for example, `Wp4` is the squared distance of the preference partial point from the global position on Dimension 4), and the genre-based and coherence components `Wloc`/`coh`. Checked for respondent 362 on Dimension 4.
- `blk` holds each aspect's additive contribution to the global coordinate ($F_{sh}/3$), not its partial point. True partial points are $3 \times$ `blk`.
- `df[] <- lapply(df, f)` keeps rownames; `as.data.frame(lapply(...))` drops them, and `mfa_input` rownames are the alignment keys.
- Quote `do.call` function names in shared sessions (a stray `c` vector once masked `base::c`).
- In R, `gcont / 100 * l3` recycles across rows. Use `sweep(gcont, 2, l3, "*")`.
- Eigenvalues: report separate λ1 to four decimals. Consumption is 0.1265, which gives weight 7.904; the three-decimal 0.127 gives 7.87.
- Book normalization (verified 2026-10-18): with $u_k = V_k\sqrt{(1-p_k)/p_k}$, $\sum_k \frac{p_k}{J\lambda_{1g(k)}} u_{ks}^2 = 1$ on all five dimensions, the metric Pagès uses for the standard vectors (MCA $M_k = p_k/J$, times the MFA group weight $1/\lambda_1$). The relation $f = \lambda_s u$ then matches the book's $G = \sqrt{\lambda_s}u$ with $f = \sqrt{\lambda_s}G$. The λ1s are not the weights. Verified 2026-10-17 against `res$global.pca$call$col.w`: yes columns equal $(1-p)/(J\lambda_{1,h})$ and no columns equal $p/(J\lambda_{1,h})$, with ratios within 0.0002 of 1, using the separate λ1s 0.1550, 0.1265, and 0.1942.
- Genre-aspect contributions (script 04, section 3b; manuscript Section 3.3): $a_{ighs} = (z_{igh} - p_{gh})\,\Delta_{ghs}$, with $\Delta_{ghs} = [(1-p_{gh})V_{\text{yes},s} - p_{gh}V_{\text{no},s}]/(J\lambda_{1,h}\sqrt{p_{gh}(1-p_{gh})})$. Summing over genres and multiplying by $H$ gives the partial point $F_{sh}(i)$. The deviation is $d = a - \frac{1}{H}\sum_{h'} a$ over the three aspects, and $\omega_s(i;g) = H^2\sum_h d^2$. Also $\gamma_s(i) = 2H^2\sum_{g<g'}\sum_h d_{ighs}d_{ig'hs}$. The genre-level identity is exact (checked in R on random data, and script 04 checks it by brute force). Do not sum over the 120 columns. The yes and no columns of one genre-aspect form a single term.
- Contributions (FactoMineR): a group's contribution is the sum of its 40 yes and no category contributions. Yes-only sums are about 60% of that. Category contribution is $100\, p_j f_{js}^2 / (J \lambda_{1h} \lambda_s^2)$, where $f_{js}$ is the category coordinate (a barycentre).
- $\mathrm{Lg}(h,k) = \mathrm{tr}(S_h S_k)/N^2$, where $S_h$ includes the $1/\lambda_{1h}$ weight. $\mathrm{Lg}(h,\mathrm{MFA}) = \sum_k \mathrm{Lg}(h,k)/\lambda_1^{\mathrm{MFA}}$. Read Lg as presence and rank order, not degree (floor ≈ 0.66). Verified 2026-10-17: the MFA column of `res$group$Lg` equals the row sum of the three block Lg values divided by λ₁ (preference: 4.3782 / 1.605 = 2.7279).
- $S_h = X_h D_h X_h^\mathsf{T}$ is N × N (respondent similarity). RV compares similarity matrices and is not a rank statistic. $S_{ij}$ is a centered, rarity-weighted inner product, not a match count. Agreement on a genre adds to $S_{ij}$, disagreement subtracts, and rare answers carry the most weight. Do not describe it as counting matching answers or as disjointness.
- Disagreement shares in the manuscript are means of individual ratios (49/55/52/66). Aggregate ratios are 42/49/43/66. Do not mix them.
- Heatmaps: look up axis labels by key. A character score column must be a factor with levels set explicitly, because ggplot sorts alphabetically. Check with `ggplot_build(p)$layout$panel_params` and `pdftotext`. Gap rows need distinct labels matching factor levels from the start. `facet_wrap` needs `scales = "free_x"` when x varies by panel. Signed Spearman maps use #08519C–white–#A63603 with fixed limits [−1, 1].
- LaTeX fragments from R: escape `$` and `&`; use `"\\\\"` for row terminators; `droplevels` before η² or `tapply`.
- Regression table cells are `\shortstack{b (SE)stars†\\[CI]}`. Build Holm counts from full-precision `pm` and `holm_m` in the script environment, never from the rounded numbers in the .tex. Write `>` in labels as `$>$`.
- Regenerate one script's tables with `sys.source("scripts/07-regression.R", envir = new.env())` from the project root (or script 10). Both source `scripts/demographics-coding.R` relative to the root.

## Reference numbers (current)

- Demographic model R² (N = 2,258): W 0.044 / 0.036 / 0.100 / 0.019; ω 0.222 / 0.079 / 0.201 / 0.029; γ 0.035 / 0.035 / 0.070 / 0.018. Pairwise-distance R² range 0.017–0.091.
- W table: 26 unadjusted p < .05; 12 survive Holm: W1 ages 30–39, 40–49, 50–59, 60–69; W2 parents' BA and upper class; W3 Black, >1 race, 60–69, 70+, West; W4 upper class.
- Coherence table: 17 unadjusted; 6 survive Holm: γ1 ages 40–49 and 50–59; γ2 parents' BA and upper class; γ3 Black; γ4 upper class.
- Upper class on W4: b = 9.16, 95% CI [4.00, 14.32], Holm p ≈ .044. On W2: b = 4.54 [2.40, 6.68], of which 4.09 is coherence and 0.45 is genre-based.
- Log-outcome models (script 07 `fitlog`): upper class on log W2 β = 0.54 (p .007) and on log W4 β = 0.74 (p .002). W4 age 30–39 β = 0.20 (p .06); 40–49 β = 0.03 (p .80). Log W1 age 70+ β = +0.26 (p .01), a sign reversal.
- Configuration signatures (Spearman, N = 2,259; Figure 10): total count vs ω on D1–D4 0.61 / 0.58 / 0.63 / 0.24; vs W 0.17 / 0.28 / 0.18 / −0.11; vs F −0.40 / 0.66 / −0.13 / −0.01. Distant praise F4 0.69; taste pose F4 0.42; guilty pleasure F4 −0.40, ω1 0.50, ω3 0.47; simple non-taste F2 −0.79. Coherence: total count 0.01 / 0.21 / −0.07 / −0.12.
- Transposed space (genre level, 20 genres): tD1 vs distant praise +0.84, taste pose +0.59, guilty pleasure −0.79, distanced −0.82. tD2 vs simple non-taste +0.80, simple positive −0.81, pose −0.59, guilty −0.43, justified −0.40.
- Transposed tD4 vs Black share of liking audience: r = 0.75 [0.46, 0.90]; partial r = 0.78 [0.51, 0.91] given the liking rate (permutation p < .001). White share partial −0.63 [−0.84, −0.25]; White–Black share r = −0.77. Joint model: Black b = 14.8 (SE 4.9, p = .008); white b = −0.47 (p = .87). Listening-rate control: Black 0.75 [0.44, 0.90]. Leave-one-genre-out range 0.73–0.79 (raw), 0.76–0.82 (partial). Female share: raw r = 0.39; partial 0.37 [−0.10, 0.70] given liking rate; −0.18 given Black share. Mood/easy listening is an unexplained exception. These numbers came from ad hoc `executeCode` runs, not a pipeline script; a reproduction needs a new script.
- Gender: individual-level gender coefficients are not significant in any W or γ model; η² < 0.01.
- Worked examples: **362** (likes 15; listens 9; grants 18/20; W4 155.7 = 11.2 ω + 144.4 γ, 93% coherence; W1 7.0; W2 0.1; status-valuation complex on D4; global D4 position 4.236, which rounds to 4.24 and matches the saved object). **1881** (likes 14; listens 13; grants 0/20; supplementary individual; W2 36.29 = 5.3 ω + 31.0 γ, above the 99th percentile, so its largest disagreement is on D2, the volume dimension).
- Old all-active fit, for the script-11 footnote only: yes-rates 41.7 / 22.9 / 20.7%; eigenvalues 1.509 / 1.178 / 0.982; RV 0.321 / 0.013 / 0.014.
- Eigenvalue shares (verified 2026-10-17, `tab-eigen` and prose): 8.23 / 7.24 / 5.39 / 5.11%, first five 30.35%. Dimension 2 is 7.2448%, so the prose says 7.24%, not 7.25%.
- Yes-rate vs category-coordinate Spearman correlations (verified 2026-10-18): Dimension 2 is −0.47 across the 40 preference and consumption yes categories (moderate, not monotone); Dimension 4 is −0.96 across the 20 evaluation yes categories. Nine of 60 genre-aspect pairs have a yes rate above one half.
- Discriminant and stability checks (2026-10-18, exploratory; only the appendix sentence is in the manuscript). Spearman with n_complex, dimensions 1–4: W_s 0.17 / 0.28 / 0.18 / −0.11; ω_s 0.61 / 0.58 / 0.63 / 0.24; γ_s 0.01 / 0.21 / −0.07 / −0.12. Aggregate Ω = Σ_{s≤4} ω_s: Spearman 0.67, Pearson 0.58. Cumulative Spearman for dimensions 1, 1–2, 1–3, 1–4: 0.61, 0.69, 0.70, 0.67. Variances of ω_s are 0.50, 0.55, 0.44, 3.07 (SD 0.71, 0.74, 0.66, 1.75), so the unweighted sum is dominated by dimension 4. SD-scaled Ω (1–4): Spearman 0.71, Pearson 0.68; eigenvalue-scaled: 0.61 and 0.55. Correlations among the ω_s: ω1–ω3 0.91, ω1–ω2 0.48. Dimension 5 was computed with script 04's formula, which reproduces the saved ω_1–ω_4 exactly, but the author decided not to add it. ω_5 alone has Spearman 0.40 with the count, and adding it to Ω gives 0.64. Aggregate weighting (settled by the author, 2026-10-18): $\Omega_i = \sum_{s\le 4} \omega_s(i)/\mathrm{SD}_s$, where $\mathrm{SD}_s$ is the sample SD of $\omega_s$ over all 2,259 respondents (0.709, 0.742, 0.664, 1.753). It gives each dimension equal variance. Sequencing caveat: the unweighted and eigenvalue-scaled versions, and their correlations with the count, were computed and viewed before this choice, so the choice rests on the equal-variance rationale and should be reported alongside the unweighted version. The SD values come from `ant$omega` in `output/antinomy_scores.rds` (dimensions 1–4). The ω_5 code exists only in the session, not in a script.
- Aggregate regressions (script 12; Appendix D, Table 14; original scale, 2026-10-18). Sample N = 2,258, same covariates as script 07, Holm across the 48 coefficients of both models. R² is 0.099 for Ω and 0.039 for Γ. Ω survivors: Black 0.62, Hispanic 0.91, >1 race 1.69, ages 50–59 −1.09, 60–69 −1.56, 70+ −1.27, some college 0.57, parents' BA 0.50, upper class 1.50. Γ survivors: Black 3.38, upper class 10.47. Log(Ω) check (session only, not in script 12): R² 0.098, sign agreement 0.92. Upper class does not survive it (log b 0.126 [0.02, 0.23], Holm p = .25). Black, Hispanic, >1 race, ages 50–59, 60–69, and 70+, some college, and parents' BA do survive. Γ cannot be logged (8% of values are negative). The log result is not reported in the manuscript.
- Constant respondents: 2,259 − 1,847 = 412 are constant in at least one block. All 321 respondents with no evaluations are inside the 412.
- Yes is the rarer answer for 51 of 60 genre-aspect pairs. For nine pairs the yes rate exceeds 0.5, so the no category contributes more: preference classical 0.551, jazz 0.509, moodez 0.578, crold 0.731, blurb 0.530, toppop 0.568, controck 0.510; evaluation classical 0.668, opera 0.744. Do not claim that yes categories always contribute more.

## Manuscript and Overleaf sync

- `manuscript/main.tex`: article class, natbib with plainnat, `references.bib`. Compile pdflatex → bibtex → pdflatex × 2. Compile a scratch copy made with `cp -rL` to avoid overwriting tracked artifacts.
- Workspace repo: `github.com/olizardo/measuring-complex-tastes`. Pushing to GitHub and syncing to Overleaf are separate operations.
- Overleaf: git bridge `https://git.overleaf.com/6ac5b9a54174d87d0d4c713a`, cloned at `overleaf/`. Push with `git push origin HEAD:main`. Auth is a token in Windows Credential Manager (target `git:https://git.overleaf.com`, username `git`); account passwords are rejected.
- Sync steps:
  1. `git -C overleaf pull --rebase origin main` first. Inspect any incoming "Update on Overleaf" commits (`git log -p`) and reapply them locally before copying. The wholesale copy overwrites web edits.
  2. Copy `manuscript/` (excluding build artifacts), using `cp -rL` for `references.bib`, plus `scripts/*.R` and `AGENTS.md`.
  3. Commit and push.
  4. `git add overleaf` in the outer repo to record the new gitlink.
- After any script rerun, diff `manuscript/` against `overleaf/manuscript/`. A missed table file has broken the Overleaf compile before.
- Pushes can be rejected if a web edit lands after the pull. Pull again.
- Script reruns rewrite every PDF, including unreferenced ones, with timestamp-only byte changes. Revert those and keep only intended changes.
- `manuscript/.gitignore` paths are relative to its own directory.
- Workspace-only files (not mirrored to Overleaf): `notes-passive-refit.md`, `agents-archive-2026-10-16.md`, `mfa-book-crosscheck.md`.
- 2026-10-18: Overleaf 0dc8a1b changed the partial-point sentence, and that change was merged into the workspace. Overleaf 63652b6 changed the Section 3.3 paragraph that the workspace later rewrote. The rewrite supersedes it, so its paragraph break before the $\Delta$ display and its capitalised "Where" were not restored. Before copying `main.tex`, check `git -C overleaf log HEAD..origin/main` and reapply any new web edits. Web edits can arrive between syncs, so pull immediately before each copy (d562ac0 arrived after the previous sync).

## Paper state and open items

Status (2026-10-17): the manuscript is edited for structure and style. The abstract and a Limitations subsection were added, the Introduction gained research questions and a roadmap, Appendix B has a configuration table, all colons in prose were removed, and hyperbole was removed.

Status (2026-10-18): Section 3.2 defines category coordinates as barycentres and gives their relation to standard coordinates. Section 3.3 notation follows decision 32. Symbols and coordinate terms were audited (decisions 31 and 32). The Equation 7 explanation was shortened, and the Dimension 4 example and the following paragraph were trimmed. Overleaf is synced through the 2026-10-18 sync that followed web edit f9fb449.

Web edit f9fb449 (2026-10-18, author, made in Overleaf) was reviewed and merged. Fixes applied: three new colons removed; "as defined earlier" (inertia) replaced with an inline definition; the Section 5 pointer after the age-generation sentence now says Section 5 examines demographic characteristics rather than reporting position results; the Lg sentence now describes the similarity-matrix formula instead of an inner product with the MFA; the W paragraph's "geometric signature" claim reworded (decision 13); "cleanly" removed; "reflects" softened to "is consistent with"; the Dimension 2 rarity claim softened to "tends to." Open for the author: the jæger2023what-0c6 citation on the prestige-hierarchy sentence (its title questions the hierarchy); the changed `100 \times \, p_j` in the category-contribution equation (renders a visible ×); Lg described as "contributes" (rank-order reading pending, decision 20-era note); the RV footnote's "weighted overlap" wording.

Web edit d562ac0 (2026-10-18, author) was reviewed and merged. The author moved the pairs table (`tab:pairs`) into a new aggregation subsection of Section 3.3, added `sec:disagreement` and a worked-example subsection, and added the genre-decomposition display `eq:decompgenre`. Fixes applied after review: worked-example labels corrected (362 is status-valuation complex, 1881 is volume complex); "Agreggating" typo; a duplicate inertia footnote; the aggregation text merged into one paragraph; three prose colons and a lowercase "section" reference; "extremely" changed to "high"; "complex on … alone" changed to "most complex on"; "normal and not an exceptional feature" changed to "roughly as important as." Equation 5 (`eq:decomp`) now has $W_s(i)$ on the left, with $\sum_h F_{sh}(i)^2 - H F_s(i)^2$ as the second form, and the text refers to that second form for total variation. The 4.24 global position was checked against the saved object (4.236). Open for the author: the section heading "Comparison of the Geometric and Discrete Approach" still says "discrete" where the text now says "categorical"; the earlier open items (the jæger2023 citation, the `\times` in the category-contribution equation, Lg rank-order wording, and the RV footnote wording) remain.

Analysis and manuscript edits (2026-10-18, late). Equation 5 (`eq:decomp`) now has $W_s(i)$ on the left, with the identity as its second form. Section 3.3 has three subsections: disagreement on each dimension, a worked example, and aggregation (the pairs table `tab:pairs` sits in the aggregation subsection). The term geometric complex taste (introduction, Section 3.3, appendix comparison) is set against categorical complex taste (Ma's configurations). Limitations says the geometric measure is interpreted rather than validated against an outside criterion. The appendix comparison says the genre-local part of disagreement correlates with the configuration counts at 0.58 to 0.63 on dimensions 1–3 and at 0.24 on dimension 4, while coherence correlates at 0.21 or less in absolute value (the earlier 0.22 was corrected). The Figure 10 caption now says aspect-disagreement scores. Settled: the aggregate weighting (see Reference numbers). Open: run the discriminant regression and null model, run the split-half genre stability check, and find or collect outside criterion measures, since the 2012 codebook labels (404 variables, keyword search) contain no direct ambivalence or guilt items.

Open for the author (2026-10-18, after Table 14): the Table 14 note does not say that the upper-class effect on Ω is not robust to the log check, and the manuscript does not disclose that the SD weighting was chosen after the outcome correlations were viewed. The unweighted aggregate is not reported. The aggregate was pushed to Overleaf as written, and these two issues are still open.

Title (2026-10-17): "Measuring Complex Tastes." The author shortened the long title in Overleaf (commit 0ba9397), and the change was pulled into the workspace.

Confirmed by the author (2026-10-17):
- The section heading "The Socio-Demographic Correlates of Complex Tastes" (`sec:social`) stays as it is.
- The survey mode is online.

Corrected 2026-10-17:
- The race η² sentence in the transposed section cites η² = 0.064 (`tab-w-eta`, W3). The earlier value of 0.25 had no table source; do not reintroduce it unless a table is generated.
- The γ4 vs global position correlation is r = 0.79 (rounded from 0.785).
- The Discussion revision note ("should be dropped") was removed. The claim that both first dimensions are visible across all three aspects is gone.

Applied 2026-10-17 late evening (the author may revert any of these):
- RV description: $S_{ij}$ is a centered, rarity-weighted inner product, not a match count.
- Yes-category labeling claim restated, with the nine cells where the no category contributes more.
- "Comparable overall participation" changed to "Uneven overall participation also masks asymmetries across dimensions." The author had been asked about this wording, so revert it if unwanted.
- Dimension 3 caption names the diaspora genres, not "traditionally racialized genres."
- Dimension 4 sentence restored to "across genres' fans."
- Dimension 2 share is 7.24%.
- FactoMineR footnote: the MFA used FactoMineR, and the transposed analysis is a manual implementation.
- "120 indicator columns" wording, "how MFA is computed," and the colon after "shows" removed.
- Genre-based decomposition (Section 3.3) rewritten around genre-aspect contributions $a_{ighs}$, the three-aspect deviation, and the worked example ($78/9 \approx 8.67$).

Awaiting author approval (assistant-drafted):
- The Abstract and the Limitations subsection (decision 29). The abstract excludes the transposed genre-level findings.
- The transposed Dimension 4 reading (audience racial composition), the mood/easy-listening exception on tD4, and the Dimension 4 caption reading of `fig-genre-map-d14`.
- The genre-level gender sentence and the Discussion gender paragraph.
- The Dimension 4 decomposition paragraph in Results.
- The Figure 10 interpretive paragraph.
- The Lg rank-order reading.
- The §4.1 rewrite and the new engagement-divide (D3) reading.
- Whether to add a Dimension 4 analogue of the dropped dim-2 "generous evaluators" clarification.

Structure and content still open:
- Figure 3–4 now sits before the Dimension 2–4 text. Move it after the Dimension 4 paragraph, or keep it as the author's choice.
- The Dimension 3 paragraph no longer links to the race and ethnicity results (`sec:social`). Decide whether to restore the link.
- The workspace `manuscript/main.pdf` is stale; rebuild it (43 pp. in the 2026-10-18 scratch build).
- Resolved 2026-10-18: this file and `manuscript/main.tex` were committed in the outer repo and copied to Overleaf.
- Resolved 2026-10-18: the book's normalization of $u$ (see the MFA weights gotcha) and the $V$–$f$ relation. The relation was checked on the saved object and on a fresh simulated MFA (FactoMineR 2.16, agreement to about $10^{-6}$ or better). `scripts/mfa-coordinate-checks.R` now runs inside script 02. Script 02 itself has not been rerun since the check was added.
- Introduction engagement beyond Ma and Bourdieu. Candidates in the global bibliography, not yet cited: `peterson1996changing-967`, `warde2007understanding-43f`, and `lizardo2014omnivorousness-3f3`. Check each before citing.
- Limitations lacks the evaluation-coding robustness sentence (decision 12). Rerun the earlier codings from git history to get the numbers.
- The split-sample check for the transposed tD4 result is suggested in the text but has not been run.
- `ma2026deep` (Socius) disambiguates the `ma2026tastes` citations as "Ma 2026b." Flagged to author. The `ma2026deep-fb3` bib entry is uncited and kept.
- ~~Overleaf sync of all 2026-10-16 and 2026-10-17 changes, and a rebuild of `main.pdf`.~~ Done 2026-10-17 evening (Overleaf commit 681d1c1; main.pdf rebuilt, 40 pp.). Superseded 2026-10-17 late evening by Overleaf commits dadf250 and 460d224 (43 pp.; see the status line at the top).

Working files: `manuscript/to-do.md` lists only open items as of 2026-10-17. `manuscript-audit.md` (2026-10-13) predates the restructure; do not use it as a to-do list.

## Key references

- Ma, X. 2026. "Tastes and Complex Tastes." *Cultural Sociology* 20(2):311–333.
- Ma, X. 2026. "On the Deep, Surprising, and Persistently Gendered Dynamics in Complex Music Tastes." *Socius*, doi 10.1177/23780231251410969 (volume and article number to be filled in from the published version).
- Pagès, J. 2014. *Multiple Factor Analysis by Example Using R*. CRC.
- Abdi, Williams & Valentin 2013. "Multiple factor analysis…" *WIREs CS* 5:149–179.
- Lizardo & Skiles 2012. SSI Cultural Tastes Survey [dataset].
- Le Roux & Rouanet GDA volumes (keys `rouanet2000geometric-a44`, `roux2004geometric-65c`).
