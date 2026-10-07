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
  partial points) is the **antinomy score**. Pairwise squared partial-point
  distances sum to H*W_s.

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
   paragraph-per-line.
6. Dimension 4 was explored (category and individual maps) and deliberately
   left out of the manuscript: consumption-heavy, categories near the
   origin, weak social anchoring — no clean reading. Figures use dims 2–3
   only.

## Pipeline (run in order, from project root)

| Script | Output | Notes |
|---|---|---|
| `scripts/01-prepare-mfa-data.R` | `data/mfa_input.rds` | builds 60 binary cols (pref_/cons_/eval_ prefixes) |
| `scripts/02-run-mfa.R` | `output/mfa_results.rds` | FactoMineR MFA, `group=c(20,20,20)`, `type=c("n","n","n")` |
| `scripts/03-figures.R` | 4 figs + 4 LaTeX tables | scree, individuals, category map, RV heatmap; tab-eigen/rv/groups/genre-rates |
| `scripts/04-antinomies.R` | `output/antinomy_scores.rds` + fig-configurations, fig-antinomy-map, tab-antinomy | W scores, pairwise disagreements, Ma's 8 configs |
| `scripts/05-supplementary.R` | `output/mfa_results_sup.rds`, `output/supplementary.rds` + fig-supplementary, tab-eta, tab-sup-coord | demographics as supplementary group 4 |
| `scripts/06-transposed-mfa.R` | `output/mfa_results_transposed.rds` + fig-genre-map, tab-genre-profile | transposed MFA (genres as individuals, 3 modality groups of respondent-indicators) |

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
- Social anchoring (supplementary η²): dim 2 ← age 0.33 (18–29 −0.76 →
  60+ +0.97), education (No diploma −0.25 → Prof/PhD +0.59), subjective
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

## Paper state & remaining steps

- Written: abstract (from `complex taste abstract.docx`), intro (draft),
  data & measures, analytic strategy (incl. decomposition equation),
  results 4.1–4.6 (structure, RV, group contributions, antinomies, social
  sources, duality), discussion placeholder. ~19 pp. compiled.
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
