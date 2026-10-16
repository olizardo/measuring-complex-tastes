# AGENTS.md — Measuring Complex Tastes

Project: measuring "complex tastes" (Ma Xiangyu 2026, *Cultural Sociology*)
geometrically, using Multiple Factor Analysis (MFA) on data about 20 musical
genres from the SSI-2012 survey. Manuscript draft is synced to Overleaf.

**Updated 2026-10-16 (evening).** Completed second-pass editing: (a) rewrote
Operationalizing subsection as flowing prose (no bullet structure); (b) moved
RV/Lg/Contributions sections to come *after* Four Dimensions interpretation
(pedagogically: show results first, then verify statistical properties);
(c) integrated worked examples into Agreement/Disagreement and Pairwise
Disagreements subsubsections (no separate Individual Disagreement section);
(d) added plain-English explanations of Lg(h,MFA) and genre deviations;
(e) added RV and Contributions formulas (Equations 3–4) back to text;
(f) clarified S_h matrix footnote placement to RV section. Manuscript
compiles cleanly. Full session-by-session history archived to
`agents-archive-2026-10-16.md`. Current-fit numbers live in
`notes-passive-refit.md`. Nothing below changes any author-confirmed decision.

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
  partial points) is the **aspect-disagreement score** (see decision 13).
  Pairwise squared partial-point distances sum to H*W_s.

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

## Bibliography

**IMPORTANT**: `manuscript/references.bib` is a symlink to
`/home/omarlizardo/projects/references.bib` (the global bibliography file).
Any citations added or modified must be made to the global file, not the local
symlink. When syncing to Overleaf, the clone's copy must be a REGULAR FILE
(`cp -rL` or copy the global file explicitly — the absolute-path symlink
dangles there and bibtex breaks).

## Coding decisions (author-confirmed; do not change silently)

1. **Preference**: like = 1; dislike/neither/not familiar = 0 (unfamiliarity
   treated as non-liking).
2. **Consumption**: as collected (0/1).
3. **Evaluation v1** (superseded by 12): conjunctive — grad AND (mc OR uc).
   Old-coding results in git history.
4. **Sample**: complete cases on all 60 variables → **n = 2,259** of 2,276.
5. **Terminology**: the manuscript says "complex tastes," not "antinomies."
   `manuscript/main.tex` is stored reflowed, one paragraph-per-line. Modality
   phrasing is "preference, engagement, and evaluation" — not "feeling,
   doing, praising"; Ma's configuration names are kept as-is.
6. **Dimension 4 history**: explored → dropped (old fit, no clean reading) →
   restored under unambiguous coding (race η² 0.255) → removed (decision 17)
   → **returned as full main-text dimension under the passive refit
   (decision 19)**. The dim-4 numbers (race η² 0.255, racialized engagement
   contrast, cons reggae/Latin/rap/Blues-R&B vs metal/indie/controck/crold)
   are in the archive if needed for a reviewer response.
7. **"group" reserved for its sociological meaning**; MFA's variable groups
   called "blocks of variables" — then SUPERSEDED by decision 10.
8. **Figure designs (current)**: category maps on planes (D1,D2) and (D3,D4)
   (author request 2026-10-16; was d12+d14), two-panel composed, explicit
   axis titles, theme_minimal white backgrounds. fig-individuals,
   fig-supplementary, fig-dim4, fig-scree, fig-rv, fig-antinomy-map,
   fig-genre-segments: kept in repo, UNREFERENCED in main.tex (generate but
   don't reference). fig-worked-example is 2×2: rows = respondents 362/1881,
   shared D4 y-axis, left panel (D1,D4), right panel (D2,D4) — panel order
   fixed 2026-10-16 (was D2 left of D1, a pre-refit leftover).
9. **Age**: six groups (18–29 … 70+) collapsed from the 13 codebook bands
   (`age6`). fig-individuals used a sequential dark-blue ramp by age.
10. **Terminology v2**: "modality" purged everywhere (GDA technical sense =
    category of a categorical variable); the three blocks are "aspects (of
    taste)" throughout; bridging footnote defines the GDA sense, citing
    rouanet2000geometric-a44. Internal R variable names (`modality`) unchanged.
11. **Terminology**: "strict" purged; the evaluation measure is called "genre
    evaluation(s)" in prose. "Conjunctive" stays in the Measures description.
12. **Evaluation v3 (2026-10-09): "unambiguous high status" coding.**
    eval = 1 iff (grad AND NOT nocol) OR ((mc OR uc) AND NOT (lc OR wc)).
    Fixes the check-everything leak of the conjunctive coding (65 all-20
    respondents). Yes-rate 30.4% → 20.7%; agreement with conjunctive 72.5%.
    Old-fit geometry: RV(eval,pref/cons) 0.013/0.014; eval contribution to
    dim 3 83.9% (dim 3 essentially evaluation's own axis); dim-3 race
    anchoring DISAPPEARS (η² 0.082 → 0.004). Worked example changed
    1333 → 362. All main.tex numbers revised for this coding, then again for
    the passive refit (decision 19).
13. **Terminology (2026-10-09): "complex-taste score" label purged.** $W_s(i)$
    is the **aspect-disagreement (score)**; read strictly it is aspect
    dispersion, interpreted as complex taste because a profile whose aspects
    place the person in different locations cannot be summarized by any
    single taste position. Not configural complexity (ρ with config counts
    0.31/0.19/−0.06; worked example 362 is 94% coherence; all-yes respondents
    get W without configurations).
14. **Terminology (2026-10-09): ω = "genre-based complex taste"** (aggregate
    Σ_g ω_s(i;g) = "the genre-based component"); the cross term is
    cross-genre coherence, γ_s. Type-ω Spearman map (old fit): guilty
    .53/.43/−.22, pose .14/.23/.47, distant −.13/−.05/.38, simple_neg
    −.75/−.75/−.36, n_complex .71/.66/.18.
15. **Style (2026-10-10): minimize colons in manuscript prose.** No
    colon-prefixed elaborations ("X: y z") in running text; prefer separate
    sentences, "so that", "and", or em-dash appositives. Semicolon chains
    are best split. Applies to assistant-drafted prose.
16. **tab-antinomy replaced by fig-signatures heatmap** (signed Spearman,
    type_counts × F/W/ω per dimension, rows grouped by which aspect stands
    apart). GOTCHAS: (a) gap rows must carry DISTINCT labels matching factor
    levels from the start (patching "" after factor() → NA row printed);
    (b) facet_wrap needs `scales = "free_x"`. Diverging #08519C–white–#A63603,
    fixed limits [−1,1]; the paper's omega matrices use grey92 midpoints,
    R_MIN 0.15 outlines, top-axis angled labels (hjust = 0, vjust = −0.05 —
    see script 09).
17. **Dimension 4 was removed from the manuscript (2026-10-10) — REVERSED by
    decision 19** (dim 4 is back as a main-text dimension).
18. **sec:social REBUILT around demographics vs. DISAGREEMENT (2026-10-10).**
    Barycenter-position material deleted (files kept in repo unreferenced;
    script 05 still runs — script 07 reads its `sup`). Section titled "The
    Social Sources of Complex Tastes" carries BOTH labels
    (`\label{sec:social}\label{sec:who}`). Opens with position-vs-disagreement
    distinction (age η² 0.33 on position; W_s η² uniformly tiny). Author
    CONFIRMED their axis-first wording of the shares-vs-contributions
    sentence ("The first global axis is the extreme case, contributing only
    2.5% to the dimension yet carrying a third of the disagreement") — DO NOT
    re-repair it; the 2.5% supplier is evaluation but the author chose the
    axis subject three times.
19. **Passive-individuals MFA is the MAIN analysis (author-approved,
    2026-10-16).** The 412 respondents constant within ≥1 aspect block are
    SUPPLEMENTARY individuals in script 02 (`ind.sup = passive`; ids in
    `output/passive_ids.rds`); the old all-active fit survives only as the
    INVERTED script-11 sensitivity footnote. Dimensions in the new fit's rank
    order: **D1 highbrow–popular, D2 volume, D3 engagement divide
    (race η² 0.245), D4 status valuation**. Eigen 1.605/1.413/1.051/0.997;
    separate λ1 0.155/0.127/0.194 → weights 6.450/7.904/5.150;
    RV 0.353/0.014/0.015. Transposed MFA rebuilt on the 1,847 active rows.
    Worked examples 362/1881 recomputed (362 W4 155.7; 1881 W2 36.3, now a
    supplementary individual — projections). Structural novelty: consumption's
    separate axis ORDER swapped (cons ax1 = popular-weighted volume, loads
    −0.83 on D1), so the old "shared ladder" partial-axes narrative no longer
    holds; ω R² jumped to 0.222/0.079/0.201/0.030 (D1/D3 strongly socially
    structured). Full numbers: `notes-passive-refit.md` (workspace root).
    Old↔new: newD1↔oldD2 |0.89|, newD2↔oldD1 0.87, newD3↔oldD4 0.97,
    newD4↔oldD3 0.95; W2↔oldW1 0.94, W4↔oldW3 0.99.
20. **Manuscript restructuring (2026-10-16, afternoon).** Merged the standalone
    "Analytic Strategy" section (method-only) into Results for better pedagogical
    flow: now reads global construction → RV/Lg/Contributions on aspects →
    four dimensions interpreted → individual-level disagreement with worked
    examples → social sources. Deleted duplicate "Relationships Between Aspects"
    section; kept one integrated version after "Measuring How Much Individual
    Tastes Come Apart" (the old individual-level methodology). This solves the
    problem of readers seeing pure method for 15+ pages before any results. Also
    updated D3 label from "musical family" to "engagement divide" everywhere in
    plots (scripts 03, 04, 09) and renamed related fig-categories-d34 caption.

## Statistical caution: ω-demographics correlations (2026-10-14)

**All Pearson correlations in the ω-demographics figures and prose are point
estimates WITHOUT confidence intervals** (script 09, N = 2,259; SE ≈ 0.020
for r ≈ 0.10–0.20). Do NOT claim one correlation is "stronger" than another
without CIs, a formal test, or hedging language ("slightly", "comparable
to"). Conversely, small but stable differences across runs are reliable.
When in doubt: "X shows pattern A, with a similar/comparable/slightly
different pattern for Y."

## Pipeline (run in order, from project root)

| Script | Output | Notes |
|---|---|---|
| `scripts/01-prepare-mfa-data.R` | `data/mfa_input.rds` | 60 binary cols (pref_/cons_/eval_ prefixes) |
| `scripts/02-run-mfa.R` | `output/mfa_results.rds` | MFA `group=c(20,20,20)`, `type=c("n","n","n")`; 412 constant-within-block respondents passive (`ind.sup`), ids in `output/passive_ids.rds` |
| `scripts/03-figures.R` | scree, category maps d12+d34, RV heatmap; tab-eigen/rv/groups/genre-rates | several figs unreferenced |
| `scripts/04-antinomies.R` | `output/antinomy_scores.rds` + fig-configurations, fig-antinomy-map, fig-worked-example, fig-signatures, fig-genre-segments, fig-config-variation, tab-pairs | W scores, Ma's 8 configs, ω/γ decomposition (Dcoef, cell_cfg) |
| `scripts/05-supplementary.R` | `output/mfa_results_sup.rds`, `output/supplementary.rds` + fig-supplementary, tab-eta, tab-sup-coord | MUST keep running (script 07 reads `sup`); manuscript table/figure outputs UNREFERENCED; `sup$sup` is POSITION-indexed 1..2259, NOT original-index |
| `scripts/06-transposed-mfa.R` | `output/mfa_results_transposed.rds` + fig-genre-map-d12/d13, tab-genre-profile | manual MFA implementation (FactoMineR OOMs at this size); internals in archive |
| `scripts/07-regression.R` | `manuscript/tables/tab-regression.tex`, `tab-w-eta.tex` | OLS of W1–W4 (and ω/γ robustness) on demographics; education 4 categories + class 4 identities as indicator factors |
| `scripts/08-robustness-pca.R` | `output/robustness_pca.rds` | MCA-vs-PCA robustness (old fit) |
| `scripts/09-omega-demographics.R` | `fig-omega-demographics-dim1..4.pdf`, `fig-omega-demographics-genres-d1..4.pdf` | Pearson r of 16 demographic indicators with ω per genre; education 4 groups, class 4 identities, race indicators |
| `scripts/10-coherence-demographics.R` | `output/coherence_demographics.rds`, `output/coherence_eta_squared.csv`, `tab-coherence-eta.tex`, `tab-coherence-regression.tex` | γ_s vs demographics; tables UNREFERENCED, pending integration |
| `scripts/11-straightliner-sensitivity.R` | `output/straightliner_sensitivity.rds` | INVERTED now: refits with the 412 as ACTIVE (the old main fit) behind the §3.1 footnote |

R implementation gotchas (all fixed in scripts; keep them fixed):
- RDS columns are `haven_labelled` → `haven::zap_labels()` on load.
- FactoMineR `type="n"` requires actual `factor()` columns.
- Supplementary columns must live in a declared supplementary *group*
  (`num.group.sup`), not bare `quali.sup`. Supplementary category
  coordinates are NOT stored — compute as barycenters manually.
- `res$eig` has only 5 dims; `res$group$contrib` (not `contributions`);
  `res$group$Lg` is group×group (incl. MFA), NOT group×dimension.
- LaTeX fragments generated in R: escape `$` ("<$25k"), `&` ("Blues/R&B"),
  use `"\\\\"` for row terminators; `droplevels` before η²/tapply.
- **Transposed MFA** (script 06) is implemented manually — FactoMineR
  OOM-kills at 6,700+ factor columns. Internals validated to <1e-5
  (see archive: transformed columns, column weights, partial points, RV).
- `ant` (antinomy_scores.rds) inherits rownames from res$ind$coord —
  original df indices, NOT sequential positions. Index P/C/V/F and
  type_counts by position; ant by the same position.
- **MFA group weighting**: global per-column weight `(1−p_j)/(J·λ1g)`;
  group balancing factor = 1/λ1g; each group's max axial inertia in the
  global metric ≈ 1. λ1s are NOT the weights.
- `df[] <- lapply(df, f)` preserves rownames; `as.data.frame(lapply(...))`
  DROPS them (mfa_input rownames are the alignment keys).
- Quote `do.call` function names in shared-session contexts (a stray `c`
  vector once masked base::c).
- Script 07/10 table blocks: use `if (is.list(bk))` for block dispatch;
  backtick-quoted label keys must match actual coefficient names exactly.
- In R, `gcont/100*l3` recycles across ROWS not columns — use
  `sweep(gcont, 2, l3, "*")`.
- The 56/52/63% disagreement shares were the MEAN of individual W_s/T_s
  ratios, NOT the aggregate ratio (49/44/65) — don't conflate.
- Lg(h,h) = Σ_s λ_s² of the separate analysis in the global metric;
  Lg(h,MFA) = Σ_k Lg(h,k)/λ1(MFA). Magnitudes are normalization arithmetic —
  read as presence + rank order, not degree (floor ≈ 0.66 for any block).

## Reference numbers

OLD-FIT reference values (all-active fit; still needed for the script-11
sensitivity footnote): yes-rates 41.7/22.9/20.7%; eigen 1.509/1.178/0.982;
RV 0.321/0.013/0.014; dim readings D1 volume, D2 highbrow–popular, D3 status
valuation (eval-owned, 83.9% contribution, socially flat); η² age→D2 0.331;
mean n_complex 10.2, only 12 respondents with zero; mean local shares of W
29/48/23%; regression R² 0.051/0.018/0.020 (W) vs 0.084/0.078/0.033 (ω);
upper-class premium on all three ω dims; the W2-70+ premium is a coherence
effect (ω2 declines in every cohort — there is NO dim-3 age flip; an earlier
session's claim of one was an error).

CURRENT-FIT (passive-individuals) numbers: `notes-passive-refit.md`.
Manuscript dimension labels: D1 = highbrow–popular, D2 = volume,
D3 = musical-family contrast, D4 = status valuation.

Worked examples: **362** (likes 15 — NOT bwayst/musicals; listens 9; grants
18/20; W4 155.7 = 11.2 ω + 144.4 γ, 94% coherence; W1 7.0, W2 0.1) and
**1881** (likes 14, listens 13, grants 0/20; now a supplementary individual —
projected). Typology respondent **522** (likes 5, listens 4, evals 11;
W4 1.1 = 0.8 ω + 0.3 γ). Sample-mean row 8.3/4.6/4.1, ω4 1.4, γ +4.8.

## Manuscript & Overleaf sync

- `manuscript/main.tex` (article, natbib+plainnat, `references.bib`),
  compiled pdflatex→bibtex→pdflatex×2. All tables are `\input{tables/...}`
  fragments generated by scripts 03–07 — never edit numbers by hand.
- Workspace repo origin: `github.com/olizardo/measuring-complex-tastes`.
  Pushing to GitHub and syncing to Overleaf are separate operations.
- Overleaf: git bridge `https://git.overleaf.com/6ac5b9a54174d87d0d4c713a`,
  cloned at `overleaf/` (remote named `origin` in this clone — push is
  `git push origin HEAD:main`). Auth is token-based via Windows Credential
  Manager (`git credential approve`, target `git:https://git.overleaf.com`,
  username `git`); account passwords are rejected with 403.
  Sync workflow:
  1. `git -C overleaf pull --rebase origin main` FIRST. Always inspect
     incoming "Update on Overleaf." commits (`git log -p`) and re-apply their
     changes to the local tree BEFORE the copy step — the wholesale copy
     overwrites whatever web edits touched (this has bitten repeatedly).
  2. Copy manuscript (excluding build artifacts; use R
     `unlink`/`file.copy` in the Positron bash where rm/cp are unavailable),
     `cp -rL` for the references.bib symlink, scripts/*.R, and AGENTS.md.
  3. commit, push (`git push origin HEAD:main`).
  4. `git add overleaf` in the OUTER repo to record the refreshed gitlink.
  - After any script rerun that writes tables/figures, diff `manuscript/`
    against `overleaf/manuscript/` before declaring the sync done (a missed
    table file once broke the Overleaf compile).
  - Pushes get rejected when a web edit lands after the pull — re-pull.
  - Reruns of scripts rewrite ALL pdfs including unreferenced ones with
    timestamp-only byte noise — revert those, keep only intended changes.
  - `manuscript/.gitignore` paths are relative to its own location.
- Workspace-only files (not mirrored): `agents-archive-2026-10-16.md`,
  `mfa-book-crosscheck.md`, `notes-passive-refit.md`.

## Paper state & remaining steps

- Passive-individuals refit complete through Phase 3: manuscript restructured
  to four dimensions, §4.1/§3.2/§4.5/§4.7–4.9/appendix rewritten and audited,
  category maps on (D1,D2)+(D3,D4), script-09 dim-4 figure generated,
  worked-example panel order fixed 2026-10-16 (D1 now left of D2).
  Compiles ~42 pp., 0 undefined refs, pre-existing overfulls:
  tab-genre-profile (2.78pt) + two appendix headings (29.24pt, 10.42pt —
  trivially fixable by rewording if author wants).
- Flagged to author, unresolved: (a) §4.1 rewrite + new D3 reading need
  approval; (b) old dim-2 generous-evaluators clarification paragraph dropped
  in the rewrite (its arithmetic described the OLD D2) — decide whether a D4
  analog is wanted; (c) discussion's "dispersion ... orthogonal to social
  positions" is in tension with ω R² 22.2%/20.1% — defensible for total W
  (max 10%) but may need hedging.
- Remaining: author review; Overleaf sync of post-2026-10-16 changes;
  planned robustness footnote comparing evaluation codings (decisions 3/12);
  full intro/discussion prose; the [DRAFT] discussion sentence names
  sec:social twice (merged-section artifact — fix when writing discussion).
- Ma 2026a/2026b: `ma2026deep` (Socius) disambiguates all `ma2026tastes`
  citations as "Ma 2026b" — flagged to author.

## Key references

- Ma, X. 2026. "Tastes and Complex Tastes." *Cultural Sociology* 20(2):311–333.
- Ma, X. 2026. "On the Deep, Surprising, and Persistently Gendered Dynamics in
  Complex Music Tastes." *Socius*, doi 10.1177/23780231251410969 (no
  volume/article number yet — fill from published version).
- Pagès, J. 2014. *Multiple Factor Analysis by Example Using R*. CRC.
- Abdi, Williams & Valentin 2013. "Multiple factor analysis…" WIREs CS 5:149–179.
- Lizardo & Skiles 2012. SSI Cultural Tastes Survey [dataset].
- Le Roux & Rouanet GDA volumes (keys `rouanet2000geometric-a44`,
  `roux2004geometric-65c`).
