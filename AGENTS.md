# AGENTS.md — Measuring Complex Tastes

Project: measuring "complex tastes" (Ma Xiangyu 2026, *Cultural Sociology*) geometrically, using Multiple Factor Analysis (MFA) on 20 musical genres from the SSI-2012 survey. The manuscript draft is synced to Overleaf.

Status (2026-10-17): `manuscript/main.tex` compiles (42 pp. in a scratch build, no undefined references or citation warnings). `manuscript/main.pdf` has not been rebuilt, and nothing has been synced to Overleaf since the 2026-10-17 edits.

## Conceptual frame

- Ma (2026) distinguishes three modalities of taste: preference, consumption, and valuation. Complex tastes are configurations in which these disagree (guilty pleasure, pre-acquired taste, taste pose, distanced consumption, justified abstention, distant praise). The manuscript calls the three **aspects**.
- Method: MFA (Pagès 2014; Abdi et al. 2013) as geometric data analysis. Three groups of 20 binary variables (one per genre per aspect), balanced by inverse first-eigenvalue weights.
- Each respondent has one partial point per aspect, and the global point is their mean. Per dimension $s$: $\sum_h F_{sh}^2 = H F_s^2 + W_s$, where $W_s$ is the aspect-disagreement score (decision 13). Pairwise squared partial-point distances sum to $H W_s$.

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
8. **Figures**: category maps on planes (D1,D2) and (D3,D4). `fig-individuals`, `fig-dim4`, `fig-scree`, `fig-rv`, `fig-antinomy-map`, and `fig-genre-segments` are generated but unreferenced. `fig-worked-example` overlays respondents 362 and 1881 in two panels, (D1,D4) and (D2,D4), with segments from partials to global and a shared D4 y-scale. Partial-point numbers in prose are on the true FactoMineR partial scale (global = mean of partials).
9. **Age**: six groups (18–29 to 70+), collapsed from the 13 codebook bands (`age6`).
10. **Terminology**: "modality" is reserved for the GDA sense (a category of a categorical variable). The three blocks are "aspects of taste." Internal R names (`modality`) are unchanged.
11. **Terminology**: the evaluation measure is called "genre evaluation(s)" in prose.
12. **Evaluation coding (v3)**: eval = 1 iff (grad AND NOT nocol) OR ((mc OR uc) AND NOT (lc OR wc)). Yes-rate 20.7%. Earlier codings are in git history.
13. **Aspect-disagreement score** $W_s(i)$ measures aspect dispersion. It is interpreted as complex taste because a profile whose aspects place the person in different locations cannot be summarized by any single taste position. It is not configural complexity. Do not call it a "complex-taste score."
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

Table generation is done by scripts 03, 04, 06, 07, and 10. Never edit numbers in `manuscript/tables/` by hand.

## R and LaTeX gotchas

- Data: RDS columns are `haven_labelled`. Call `haven::zap_labels()` on load.
- FactoMineR: `type="n"` needs actual `factor()` columns. Supplementary columns must sit in a declared supplementary group (`num.group.sup`). Supplementary category coordinates are not stored; compute barycenters manually. `res$eig` has five dimensions. Use `res$group$contrib`. `res$group$Lg` is group × group, not group × dimension.
- `res$ind$coord` holds only the 1,847 active rows. Use `res$ind.sup$coord`, or `ant$F1`–`ant$F4`, for all 2,259.
- `ant` and `type_counts` inherit rownames from `res$ind$coord` (original df indices, not positions). Index them consistently.
- `blk` holds each aspect's additive contribution to the global coordinate ($F_{sh}/3$), not its partial point. True partial points are $3 \times$ `blk`.
- `df[] <- lapply(df, f)` keeps rownames; `as.data.frame(lapply(...))` drops them, and `mfa_input` rownames are the alignment keys.
- Quote `do.call` function names in shared sessions (a stray `c` vector once masked `base::c`).
- In R, `gcont / 100 * l3` recycles across rows. Use `sweep(gcont, 2, l3, "*")`.
- Eigenvalues: report separate λ1 to four decimals. Consumption is 0.1265, which gives weight 7.904; the three-decimal 0.127 gives 7.87.
- MFA weights: global column weight $(1-p_j)/(J\lambda_{1g})$; group balancing $1/\lambda_{1g}$. The λ1s are not the weights.
- Contributions (FactoMineR): a group's contribution is the sum of its 40 yes and no category contributions. Yes-only sums are about 60% of that. Category contribution is $100\, p_j f_{js}^2 / (J \lambda_{1h} \lambda_s^2)$.
- $\mathrm{Lg}(h,k) = \mathrm{tr}(S_h S_k)/N^2$, where $S_h$ includes the $1/\lambda_{1h}$ weight. $\mathrm{Lg}(h,\mathrm{MFA}) = \sum_k \mathrm{Lg}(h,k)/\lambda_1^{\mathrm{MFA}}$. Read Lg as presence and rank order, not degree (floor ≈ 0.66). Verified 2026-10-17: the MFA column of `res$group$Lg` equals the row sum of the three block Lg values divided by λ₁ (preference: 4.3782 / 1.605 = 2.7279).
- $S_h = X_h D_h X_h^\mathsf{T}$ is N × N (respondent similarity). RV compares similarity matrices and is not a rank statistic.
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
- Worked examples: **362** (likes 15; listens 9; grants 18/20; W4 155.7 = 11.2 ω + 144.4 γ, 93% coherence; W1 7.0; W2 0.1). **1881** (likes 14; listens 13; grants 0/20; supplementary individual; W2 36.29 = 5.3 ω + 31.0 γ, above the 99th percentile, so complex on D2 alone).
- Old all-active fit, for the script-11 footnote only: yes-rates 41.7 / 22.9 / 20.7%; eigenvalues 1.509 / 1.178 / 0.982; RV 0.321 / 0.013 / 0.014.

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

## Paper state and open items

Status (2026-10-17): the manuscript is edited for structure and style. The abstract and a Limitations subsection were added, the Introduction gained research questions and a roadmap, Appendix B has a configuration table, all colons in prose were removed, and hyperbole was removed.

Title (2026-10-17): "Measuring Complex Tastes through a Multiple Factor Analysis of Preferences, Consumption, and Evaluations in Musical Taste." The colon was removed to satisfy the no-colon rule.

Confirmed by the author (2026-10-17):
- The section heading "The Socio-Demographic Correlates of Complex Tastes" (`sec:social`) stays as it is.
- The survey mode is online.

Corrected 2026-10-17:
- The race η² sentence in the transposed section cites η² = 0.064 (`tab-w-eta`, W3). The earlier value of 0.25 had no table source; do not reintroduce it unless a table is generated.
- The γ4 vs global position correlation is r = 0.79 (rounded from 0.785).
- The Discussion revision note ("should be dropped") was removed. The claim that both first dimensions are visible across all three aspects is gone.

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
- Introduction engagement beyond Ma and Bourdieu. Candidates in the global bibliography, not yet cited: `peterson1996changing-967`, `warde2007understanding-43f`, and `lizardo2014omnivorousness-3f3`. Check each before citing.
- Limitations lacks the evaluation-coding robustness sentence (decision 12). Rerun the earlier codings from git history to get the numbers.
- The split-sample check for the transposed tD4 result is suggested in the text but has not been run.
- `ma2026deep` (Socius) disambiguates the `ma2026tastes` citations as "Ma 2026b." Flagged to author. The `ma2026deep-fb3` bib entry is uncited and kept.
- Overleaf sync of all 2026-10-16 and 2026-10-17 changes, and a rebuild of `main.pdf`.

Working files: `manuscript/to-do.md` lists only open items as of 2026-10-17. `manuscript-audit.md` (2026-10-13) predates the restructure; do not use it as a to-do list.

## Key references

- Ma, X. 2026. "Tastes and Complex Tastes." *Cultural Sociology* 20(2):311–333.
- Ma, X. 2026. "On the Deep, Surprising, and Persistently Gendered Dynamics in Complex Music Tastes." *Socius*, doi 10.1177/23780231251410969 (volume and article number to be filled in from the published version).
- Pagès, J. 2014. *Multiple Factor Analysis by Example Using R*. CRC.
- Abdi, Williams & Valentin 2013. "Multiple factor analysis…" *WIREs CS* 5:149–179.
- Lizardo & Skiles 2012. SSI Cultural Tastes Survey [dataset].
- Le Roux & Rouanet GDA volumes (keys `rouanet2000geometric-a44`, `roux2004geometric-65c`).
