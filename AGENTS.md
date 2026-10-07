# AGENTS.md — Measuring Complex Tastes

Project: measuring "complex tastes" (Ma Xiangyu 2026, *Cultural Sociology*)
geometrically, using Multiple Factor Analysis (MFA) on data about 20 musical
genres from the SSI-2012 survey. Manuscript draft is synced to Overleaf.

## Conceptual frame

- Ma (2026) distinguishes three modalities of taste: **preference** (feel),
  **consumption** (do), **valuation** (praise). Complex tastes = configurations
  with antinomies among modalities (guilty pleasure, pre-acquired taste, taste
  pose, distanced consumption, justified abstention, distant praise).
- Method: MFA (Pagès, *Multiple Factor Analysis by Example Using R*; Abdi et
  al. 2013 WIREs) as GDA. Three groups of 20 binary variables (one per genre
  per modality), balanced by inverse-first-eigenvalue weights.
- Key geometric device: each individual has one *partial point* per group;
  global point = mean of partials. Per dimension s:
  `sum_h F_sh^2 = H*F_s^2 + W_s`, where `W_s` (within-individual dispersion of
  partial points) is the **antinomy score** (manuscript language:
  **complex-taste score** — see coding decision 5). Pairwise squared
  partial-point distances sum to H*W_s.

## Data

- Source: https://olizardo.github.io/SSI-2012/ — repo `olizardo/SSI-2012`
  (**branch `master`**; the `omarlizardo` name 404s).
- Files in `data/`: `ssi2012_cleaned.rds` (2,276 × 404, haven-labelled),
  `ssi2012_cleaned_coded.csv`, `ssi2012_codebook_metadata.csv` (codebook),
  `mfa_input.rds` (analysis input; rownames = original df row indices — use
  these to align demographics or other additions).
- 20 genres (uniform naming): classical, opera, jazz, bwayst, moodez, bband,
  crold, country, blueg, folk, hymgos, latspsal, raphiphop, blurb, reggae,
  toppop, controck, indalt, danclub, hvymtl.
- Variable stems: `{g}taste` (1=like, 2=dislike, 3=neither, 4=not familiar),
  `{g}lis` (0/1 listened past month), fan-perception binaries `{g}grad`,
  `{g}nocol`, `{g}lc/wc/mc/uc`, plus gender/race/age chars.

## Coding decisions (author-confirmed; do not change silently)

1. **Preference**: like = 1; dislike/neither/not familiar = 0 (unfamiliarity
   treated as non-liking).
2. **Consumption**: as collected (0/1).
3. **Evaluation**: CONJUNCTIVE — typical fan is college-educated **AND**
   (middle OR upper class). Originally the inclusive OR version; changed at
   the author's request. Old-coding results are in git history; a robustness
   footnote comparing both codings is a planned addition.
4. Sample: complete cases on all 60 variables → **n = 2,259** of 2,276.
5. Terminology (author preference): the manuscript says "complex tastes,"
   not "antinomies"; $W_s(i)$ is the "complex-taste score." Table 3
   (tab-groups) is kept and the group-contributions figure was dropped as
   redundant. `manuscript/main.tex` is stored reflowed, one
   paragraph-per-line. Modality phrasing is "preference, engagement, and
   evaluation" — not "feeling, doing, praising"; Ma's configuration names
   (guilty pleasure, distant praise, taste pose, …) are kept as-is.
6. Dimension 4 was explored (category and individual maps) and deliberately
   left out of the manuscript: consumption-heavy, categories near the
   origin, weak social anchoring — no clean reading. Figures use dims 2–3
   only.
7. Figure designs (current): individual factor map = single dims-2–3 panel,
   points colored by age group (referenced from the dim-2 paragraph with a
   pointer to the social-sources section); supplementary figure =
   demographic category barycenters ONLY on dims 2–3, no respondent cloud,
   axes spanning the category coordinates (the cloud otherwise compresses
   the barycenters near the origin); category map on dims 2–3 (switched
   from 1–2 at the author's request, 2026-10-07; prose figure references
   moved to the dim-2 sentence and the dim-3 η² discussion).
8. Age: six groups (18–29, 30–39, 40–49, 50–59, 60–69, 70+) collapsed from
   the 13 codebook age bands (codes 2–15; `age6`), used in fig-individuals
   and as the supplementary age variable (author request, 2026-10-07;
   replaces the earlier four-group `age4`). Supplementary figure legend
   uses readable variable names (Dark2 palette, no legend title, legend at
   bottom) — also author-requested, 2026-10-07. fig-individuals uses a
   discrete Dark2 palette and drops the single missing-age respondent (no
   NA legend entry), 2026-10-07. fig-antinomy-map recolored by the
   geometric W1 score (was: combinatorial n_complex count), 2026-10-07.

## Pipeline (run in order, from project root)

| Script | Output | Notes |
|---|---|---|
| `scripts/01-prepare-mfa-data.R` | `data/mfa_input.rds` | builds 60 binary cols (pref_/cons_/eval_ prefixes) |
| `scripts/02-run-mfa.R` | `output/mfa_results.rds` | FactoMineR MFA, `group=c(20,20,20)`, `type=c("n","n","n")` |
| `scripts/03-figures.R` | 4 figs + 4 LaTeX tables | scree, individuals, category map, RV heatmap; tab-eigen/rv/groups/genre-rates |
| `scripts/04-antinomies.R` | `output/antinomy_scores.rds` + fig-configurations, fig-antinomy-map, fig-worked-example, tab-antinomy | W scores, pairwise disagreements, Ma's 8 configs |
| `scripts/05-supplementary.R` | `output/mfa_results_sup.rds`, `output/supplementary.rds` + fig-supplementary, tab-eta, tab-sup-coord | demographics as supplementary group 4 |
| `scripts/06-transposed-mfa.R` | `output/mfa_results_transposed.rds` + fig-genre-map, tab-genre-profile | transposed MFA (genres as individuals, 3 modality groups of respondent-indicators) |
| `scripts/07-regression.R` | `manuscript/tables/tab-regression.tex` | OLS of W1–W3 (and dPV3/dCV3 robustness) on demographics; reads output of 04 + 05 (05 now saves `sup` in supplementary.rds) |

R implementation gotchas (all fixed in scripts; keep them fixed):
- RDS columns are `haven_labelled` → `haven::zap_labels()` on load.
- FactoMineR `type="n"` requires actual `factor()` columns.
- Supplementary columns must live in a declared supplementary *group*
  (`num.group.sup = 4`), not bare `quali.sup` (MFA requires groups to cover
  all columns). Supplementary category coordinates are NOT stored by
  FactoMineR for supplementary groups — compute as barycenters (mean of
  members' `res$ind$coord`) manually.
- `res$eig` has only 5 dims; `res$group$contrib` (not `contributions`);
  `res$group$Lg` is group×group (incl. MFA), NOT group×dimension.
- LaTeX fragments generated in R: escape `$` in category labels ("<$25k"),
  `&` in genre names ("Blues/R&B"), and use `\\` (R: `"\\\\"`) for row
  terminators; drop empty factor levels (`droplevels`) before η²/tapply.
- **Transposed MFA**: `FactoMineR::MFA` OOM-kills at this size (6,700+
  factor columns) — script 06 implements the MFA manually, replicating
  FactoMineR's exact type-"n" construction (validated: eig/coords/partials/
  RV/contributions reproduce to <1e-5). Key internals: transformed columns
  `(Z − m)/√(m(1−m))`, column weights `(1−m)/(λ1g·Jg)`, partial points
  `H·(T√w)·v_raw` (FactoMineR stores `svd$V = −v_raw/√w`), RV = normalized
  Lg (funcLg = ‖weighted-centered cross-product‖²_F). Respondents constant
  within a modality (all-0/all-20; 83 pref, 84 cons, 663 eval) are dropped
  from the transposed groups — their categories sit at the origin, so genre
  geometry is unchanged.
- `ant` (output/antinomy_scores.rds) inherits rownames from res$ind$coord —
  original df indices, NOT sequential positions; which.max(ant$W3) returns
  a position whose rowname differs (365 vs 380). Index P/C/V/F, md, and
  type_counts by position; ant by the same position.

## Current headline results (conjunctive coding)

- Yes-rates: preference 41.7%, consumption 22.9%, evaluation 30.3%
  (conjunctive standard is the least-affirmed modality).
- Eigenvalues: λ1 = 1.667 (12.3%), λ2 = 1.193 (8.8%); first 5 dims = 37.9%.
- **RV coefficients** (central result): P–C 0.32; P–E 0.05; C–E 0.06 —
  evaluation is geometrically independent of preference and consumption.
- Dimension readings (signs are SVD-arbitrary — re-anchor pole claims to the
  category coordinates after ANY re-run):
  - Dim 1 = general affirmation (all "yes" categories positive).
  - Dim 2 = highbrow (+: opera/classical/big band/Broadway) vs popular
    (−: rap, dance/club, indie, metal, reggae).
  - Dim 3 = status valuation: all 20 eval "yes" categories on one side
    (mean −0.63); positive pole = consecrated-genre consumption
    (opera +0.90, reggae +0.65). Eval contributes 40.6% to dim 3.
- Social anchoring (supplementary η²): dim 2 ← age 0.35 (six groups:
  18–29 −0.76 → 70+ +1.23), education (No diploma −0.25 → Prof/PhD +0.59), subjective
  class; dim 3 ← race 0.083 (Black +0.55 vs White −0.19), self-described
  upper class +0.68, but education ~absent (0.008); dim 1 socially flat.
- Antinomies: mean 9.6/20 genres per respondent in complex configurations;
  only 19 respondents have zero. Justified abstention 2.8, distant praise
  2.6, guilty pleasure 2.2, pose 1.5 per person. Antinomy dispersion ≈
  51/51/62% of projected partial inertia (dims 1–3). n_complex ↔ W1
  ρ = 0.58 but ~0 with W2/W3 — geometric vs combinatorial antinomy align on
  engagement, diverge on hierarchical placement.
- **Duality (transposed MFA, genres as targets)**: genre-level RVs are
  HIGH — P–C 0.92, P–V 0.77, C–V 0.73 — the mirror image of the individual
  level. Modality disagreement lives within individuals, not in divergent
  audience structures. Transposed dims: λ1 = 2.31 (13.2%), λ2 = 2.13
  (12.1%). Dim 2 = configuration axis: negative pole = guilty-pleasure
  targets (classic rock −3.8, top 40 −2.5, country −2.0; guilty ρ = −0.90),
  positive pole = distant-praise targets (opera +2.3, folk +1.4, bluegrass
  +1.3; distant ρ = +0.59). Dim 1 = devoted-minority vs generalized
  non-engagement. Partial points: consecrated genres' evaluation partials
  displaced positive on dim 3 (classical +2.6 vs ~+1.0), country reverse.

## Manuscript & Overleaf sync

- `manuscript/main.tex` (article, natbib+plainnat, `references.bib`),
  compiled with pdflatex→bibtex→pdflatex×2 (~16 pp.). All tables are
  `\input{tables/...}` fragments generated by scripts 03–05 — never edit
  numbers by hand.
- Overleaf: git bridge `https://git.overleaf.com/6ac5b9a54174d87d0d4c713a`,
  cloned at `overleaf/`. The Overleaf project mirrors this whole workspace.
  Sync workflow:
  1. `git -C overleaf pull --rebase origin main` FIRST (web edits appear as
     "Update on Overleaf." commits — always preserve them; author edits
     happened this way).
  2. `rm -rf overleaf/manuscript && cp -r manuscript overleaf/ && cp scripts/*.R overleaf/scripts/`
  3. commit, push. (Watch for shell `&&` swallowing a failed pull's exit
     code when piped to `tail`.)
- `manuscript/.gitignore` uses paths RELATIVE to its own location
  (`main.aux`, …) — earlier commit accidentally included build artifacts;
  these were removed in commit "Remove LaTeX build artifacts from repo".
- Last Overleaf sync: commit `1a3ca58` (2026-10-07) — regression subsection
  `sec:who` ("Who Has Complex Tastes?") + tab-regression + scripts 05/07.
  Previous sync `060b5cb` same day: restructure: section
  4.4 leads with the geometric measure, combinatorial material moved to
  Appendix A (`app:configurations`); fig-antinomy-map recolored by W1;
  RV heatmap diagonal omitted; duality justification paragraph added to
  4.6. Previous syncs same day: `1fa7b8e` (fig-individuals Dark2 palette,
  NA dropped), `33ad5cd` (category
  map switched to dims 2–3 with readable genre labels; six-group `age6`
  classification in fig-individuals and the supplementary analysis (tab-eta,
  tab-sup-coord, prose numbers updated); supplementary figure restyled
  (Dark2 palette, readable legend names, no title, legend at bottom).
  Pushes to Overleaf get
  rejected whenever a web edit lands after our pull — always re-pull first.

## Paper state & remaining steps

- Written: abstract (from `complex taste abstract.docx`), intro (draft),
  data & measures, analytic strategy (incl. decomposition equation),
  results 4.1–4.6 (structure, RV, group contributions, antinomies, social
  sources, duality), discussion placeholder. ~19 pp. compiled.
- Restructure (2026-10-07, author request): paper's point is the geometric
  approach — section 4.4 now leads with the geometric operationalization;
  all combinatorial material (prevalence paragraph, fig-configurations,
  tab-antinomy, signatures paragraph) moved to new `\appendix` section
  "The Combinatorial Measure" (`app:configurations`) before the
  bibliography. Main text keeps the geometric dispersion paragraph, the
  W1-colored map, and the divergence result (ρ = 0.58 with n_complex on
  dim 1, ~0 on dims 2–3). Duality section (4.6) still uses configuration
  rates for genre targets — kept as part of the geometric analysis.
- Worked example added to Analytic Strategy (2026-10-07): running example
  after eq:decomp is respondent rowname 1333 (ant position 1318) — highest
  W3 among respondents holding guilty+pose+distant configurations. Dim-1
  partials all same side (W1 = 1.9, 10% of inertia) vs dim-3 evaluation
  partial opposite side (W3 = 28.7, 94%); 13 complex configurations (1
  guilty = jazz, 8 poses, 3 distant praise, 1 justified). Toy figure
  `fig-worked-example` referenced from the example paragraph. NOTE: the
  overall max-W3 respondent (rowname 380, position 365) is an all-yes
  respondent with ZERO complex configurations — its geometric disagreement
  reflects modality margin differences, not configural complexity.
- Duality justification paragraph (2026-10-07): added to 4.6 explaining
  why the transposed MFA is necessary — CA duality broken by MCA + group
  weighting; category coordinates = audience composition vs genres as
  objects; analysis-specific group weights; genre-level RV/partial points
  don't exist in the respondent-level fit.
- Regression subsection (2026-10-07): new `sec:who` "Who Has Complex
  Tastes?" between the social-sources and duality sections; script 07
  fits OLS of W1/W2/W3 on the eight demographics (tab-regression).
  Headline: social patterning of disagreement is weak (R² 0.040/0.031/
  0.022) vs strong patterning of position (age η² = 0.35). W1: parents'
  BA +0.92, upper class +3.56, age decline; W2: age-only effect
  (−0.52…−1.01, 70+ ≈ 0); W3: race only (>1 race +1.94, Asian −1.50 vs
  White). Robust to log outcomes; dPV3/dCV3 predicted by race only,
  dPC3 by parentba + sclassUpper.
- Remaining: (a) robustness note comparing inclusive vs conjunctive
  evaluation codings (RV structure nearly identical: 0.057/0.062 vs
  0.049/0.060); (b) full intro/discussion prose.

## Key references

- Ma, X. 2026. "Tastes and Complex Tastes." *Cultural Sociology* 20(2):311–333.
- Pagès, J. 2014. *Multiple Factor Analysis by Example Using R*. CRC.
- Abdi, Williams & Valentin 2013. "Multiple factor analysis…" WIREs CS 5:149–179.
- Lizardo & Skiles 2012. SSI Cultural Tastes Survey [dataset].
- Le Roux & Rouanet GDA volumes (added to `references.bib` by the author on
  Overleaf: keys `rouanet2000geometric-a44`, `roux2004geometric-65c`).
