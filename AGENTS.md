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
7. **Terminology (author request, 2026-10-08): "group" is reserved for its
   sociological meaning.** MFA's variable groups are called "blocks of
   variables" (generic MFA mechanics) or "modalities" (the three blocks of
   this application) throughout main.tex; "group contributions" → "modality
   contributions" (with a parenthetical noting the MFA-literature term);
   tab-groups header row is "Modality". A bridging footnote in the Analytic
   Strategy tells readers the MFA literature calls these sets "groups"
   (cites pages2014mfa). "Age group" keeps its ordinary meaning.
   SUPERSEDED later the same day by decision 10: "modality" itself is now
   purged entirely; the three blocks are "aspects (of taste)".
8. Figure designs (current): individual factor map = single dims-2–3 panel,
   points colored by age group (referenced from the dim-2 paragraph with a
   pointer to the social-sources section); supplementary figure =
   demographic category barycenters ONLY on dims 2–3, no respondent cloud,
   axes spanning the category coordinates (the cloud otherwise compresses
   the barycenters near the origin); category map on dims 2–3 (switched
   from 1–2 at the author's request, 2026-10-07; prose figure references
   moved to the dim-2 sentence and the dim-3 η² discussion).
9. Age: six groups (18–29, 30–39, 40–49, 50–59, 60–69, 70+) collapsed from
   the 13 codebook age bands (codes 2–15; `age6`), used in fig-individuals
   and as the supplementary age variable (author request, 2026-10-07;
   replaces the earlier four-group `age4`). Supplementary figure legend
   uses readable variable names (Dark2 palette, no legend title, legend at
   bottom) — also author-requested, 2026-10-07. fig-individuals uses a
   sequential dark-blue ramp by age (`colorRampPalette(c("#6BAED6",
   "#08306B"))(6)`, alpha 0.4, size 0.75; author request 2026-10-07,
   replacing the earlier discrete Dark2 — discrete hues were illegible in
   the overplotted cloud). fig-categories darkened (no-points grey65,
   yes-points size 1.8, darker Okabe–Ito derivatives #08519C/#A63603/
   #006D2C), author request 2026-10-07. fig-antinomy-map recolored by the
   geometric W1 score (was: combinatorial n_complex count), 2026-10-07.
10. **Terminology v2 (author request, 2026-10-08): "modality" purged
    everywhere.** In MCA/GDA a "modality" (French *modalité*) is a category
    of a categorical variable — using it for the three blocks clashed with
    the technical sense. The blocks are now "aspects (of taste)" throughout
    main.tex, tables, and figure legends: "aspect contributions" (the
    MFA-literature parenthetical kept), tab-groups header "Aspect",
    fig-categories/fig-rv/fig-genre-map legends and titles "Aspect".
    "The rarest modalities" (the one GDA-sense usage) became "the rarest
    categories". The bridging footnote in the Analytic Strategy now also
    defines the GDA sense: modalities = the distinct values a categorical
    variable can take (yes/no), citing rouanet2000geometric-a44; the
    manuscript says "category" throughout. Intro theory wording also purged
    ("multimodality of taste" → "taste has multiple aspects"; "modalities
    of action" → "aspects of action"). Internal R variable names
    (`modality` in scripts 03/04/06) are unchanged — they never render into
    the manuscript.

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
| `scripts/08-robustness-pca.R` | `output/robustness_pca.rds` | MCA-vs-PCA robustness: same MFA with `type="c"` (scaled PCA within groups); compares eigenvalues, separate λ1 (group weights), RV, sign-matched individual coords, W-scores, antinomy shares |

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
- **MFA group weighting (verified 2026-10-08 from res$global.pca$call$col.w)**:
  FactoMineR's global per-column weight is `(1−p_j)/(J·λ1g)` (category mass
  p_j, J=20, λ1g = separate MCA first eigenvalue 0.200/0.155/0.484). The
  group-level balancing factor is exactly 1/λ1g (weight sums 5.004/6.452/
  2.064); each group's max axial inertia in the global metric ≈ 1. The λ1s
  are NOT the weights — the original tab-groups "Weight" column and §4.3
  text mislabeled them; fixed 2026-10-08.

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
- **Partial axes** (correlations of each group's separate-analysis axes with
  the global dims; tab-partial-axes, added 2026-10-08): dim 1 = consensus
  (pref/cons/eval ax1: 0.79/0.81/0.60); dim 2 carried by pref ax2 (−0.89)
  and cons ax2 (+0.89), no eval axis close; dim 3 = eval ax1 (−0.60, also
  +0.60 on dim 1) plus pref ax3 (+0.57) and cons ax3 (+0.60) — evaluation-
  led but not evaluation-alone.
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
- Workspace repo origin: `github.com/olizardo/measuring-complex-tastes`
  (the outer repo). Pushing to GitHub and syncing to Overleaf are separate
  operations — neither propagates to the other.
- Overleaf: git bridge `https://git.overleaf.com/6ac5b9a54174d87d0d4c713a`,
  cloned at `overleaf/` (re-cloned 2026-10-08 after the old checkout was
  lost; the token that lived in the old remote URL was moved to the Windows
  Credential Manager via `git credential approve` — target
  `git:https://git.overleaf.com`, username `git` — so Overleaf git auth now
  works for ALL projects on this machine, no per-repo token URLs needed.
  Overleaf git auth is token-only; account passwords are rejected with
  403). The Overleaf project mirrors this whole workspace.
  Sync workflow:
  1. `git -C overleaf pull --rebase origin main` FIRST (web edits appear as
     "Update on Overleaf." commits — always preserve them; author edits
     happened this way).
  2. `rm -rf overleaf/manuscript && cp -r manuscript overleaf/ && cp scripts/*.R overleaf/scripts/ && cp AGENTS.md overleaf/`
     (since 2026-10-08 the mirror's AGENTS.md is kept current too). NOTE:
     in the Positron-assistant bash (rtools) `rm`/`cp` are unavailable —
     use R (`unlink(recursive=TRUE)`, `file.copy(recursive=TRUE)`) instead.
     `cp -r manuscript` drags LaTeX build artifacts into the clone's
     working dir; they are gitignored (manuscript/.gitignore) and never
     committed — exclude them when copying from R.
  3. commit, push. (Watch for shell `&&` swallowing a failed pull's exit
     code when piped to `tail`.)
  4. `git add overleaf` in the OUTER repo records the new gitlink pointer
     (the clone is tracked as a gitlink; there is no .gitmodules) — commit
     that too, or the pointer goes stale.
- `manuscript/.gitignore` uses paths RELATIVE to its own location
  (`main.aux`, …) — earlier commit accidentally included build artifacts;
  these were removed in commit "Remove LaTeX build artifacts from repo".
- Last Overleaf sync: `abbe68e` (2026-10-08) — defines $H$ (number of
  aspects, = 3) in eq:decomp (author flagged capital H as unclear; now
  defined in both the partial-points sentence and the where-clause).
  Author web edit `b95a0e6` landed before the copy and was re-applied
  locally first: robustness footnote now says "the choice of MCA as the
  GDA analytic engine"; Lg sentence "expressed in the global space" (was
  "in the compromise"); third-question paragraph contrast rewritten as
  "Note that this is different from what the $Lg$ coefficient tells
  us. While... one decomposition across aspects." Only main.tex differed
  at copy time, so the sync was a single-file copy (no wholesale
  rm -rf/cp -r — which the assistant's auto mode now blocks). Outer repo
  commit `4b810a1` records both the fix and the gitlink. Previous sync:
  `bc48752` + follow-up `e6e3880` (2026-10-08) —
  terminology v2 per decision
  10 (modality→aspect purge, GDA modality footnote, Aspect table header and
  figure legends; no author web edits since `291c37f` at copy time, so
  nothing was clobbered; a later author web edit `4fecd3b` ("the three
  aspects of complex tastes" in the Analytic Strategy opening) landed the
  same evening, was pulled and adopted locally; `e6e3880` also refreshed
  the mirror's AGENTS.md, which is now part of every sync). Previous sync: commits `987dc96` + `291c37f`
  (2026-10-08) — terminology
  rewrite per decision 7 ("blocks of variables"/"modalities" throughout,
  bridging footnote, in-text definition of "modality" opening the Analytic
  Strategy, tab-groups header "Modality"). `291c37f` re-applied the author's
  web edit `27e880f` ("The third question is different:"), which the
  wholesale `cp -r` in `987dc96` had silently CLOBBERED. **Workflow lesson:
  after `pull --rebase`, always inspect the incoming "Update on Overleaf."
  commits (`git log -p`) and re-apply their changes to the local tree BEFORE
  the `rm -rf overleaf/manuscript && cp -r` step — the copy overwrites
  whatever the web edit touched.** Previous sync `64a7724` (2026-10-08) —
  fixed weight labeling (tab-groups now reports both λ1 and Weight (1/λ1) =
  5.004/6.452/2.064; §4.3 sentence quotes the true inverse weights) and
  added tab-partial-axes + §4.3 partial-axes paragraph (with technical
  footnote) after the Lg discussion. Previous sync `fa787d4` (2026-10-08) —
  aligned results
  echoes with the revised strategy wording (4.2 now echoes "redundant or
  partially independent"; 4.3 "On the third question" replaces "ownership
  question"). Previous sync `b3103ef` (2026-10-08) — sharpened the Lg vs
  group-contributions distinction in the strategy section (Lg = one number
  per group, absolute scale, unnormalized RV; contributions = one
  decomposition per dimension, sums to 100%) and added technical
  calculation footnotes for RV/Lg/contributions (configuration-matrix
  formulas, footnote style); author's misplaced "dominated by consumption"
  example moved from the Lg paragraph to the contributions paragraph.
  Previous sync `fdc7d3f` (2026-10-08) — corrected the two
  technical errors in the author's `6b7d3e5` web edit: weighting described
  as 1/λ1 (was "inverse square root"), Lg described as group-vs-compromise
  (was "each dimension"); pushed to Overleaf. Previous sync `6b7d3e5`
  (2026-10-08) — author's web edits
  adopted locally (strategy paragraph rewordings: "redundant or partially
  independent" RV justification, expanded Lg sentence, data-table sentence).
  Previous sync `d66751c` (2026-10-07) — results sections echo
  the strategy questions (4.2 RV opens with the same-structure question;
  4.3 opens with participation + ownership questions; Lg sentence reframed
  as the participation answer). Previous sync `f3268d7` (2026-10-07) — rewrote the
  quantities paragraph of the Analytic Strategy into three question-linked
  paragraphs (RV = same-structure question; Lg = participation-in-
  compromise question, definition corrected to group-vs-compromise; group
  contributions = which-modality-owns-each-dimension question); previous
  sync `6a7d1cb` (2026-10-07) — author's web rewrite of
  the Analytic Strategy opening (two paragraphs restructured into three:
  explicit data-table description, MCA step spelled out, RV/Lg/group-
  contribution sentences reworded); adopted locally, nothing to push
  (local tree was clean at `bab5c64`). Author text kept as-is including
  apparent typos ("----" for "---", "a give genre", missing period after
  the e.g. parenthetical) — flagged to user 2026-10-07, then fixed and
  pushed as `5e0afd7` (user request). Previous sync
  `bab5c64` (2026-10-07) — adopted author's web
  edits `8e4233f` (eq:decomp combinatorial sentence and worked-example
  combinatorial sentence converted to footnotes; new MCA rare-category
  sentence citing rouanet2000geometric-a44; dim-2 paragraph rewordings);
  darker fig-categories, sequential age ramp for fig-individuals, caption
  note, dim-3 preview sentence, \label{sec:contrib}, script 03 updates.
  Previous sync `bd62f47` (2026-10-07) — worked example
  (fig-worked-example + sec:strategy paragraph) and script 04 updates pushed;
  author's sec:who rewording ("geometric measuring of complex tastes")
  adopted locally. Previous sync `1a3ca58` (2026-10-07) — regression
  subsection
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
  Worse: a web edit that lands BEFORE our pull survives the rebase but is
  then silently overwritten by the wholesale `cp -r` of `manuscript/` —
  always diff the incoming web-edit commits and re-apply their changes to
  the local tree before copying (this happened with `27e880f`, fixed in
  `291c37f`).

## Paper state & remaining steps

- Written: abstract (from `complex taste abstract.docx`), intro (draft),
  data & measures, analytic strategy (data-table paragraph, two-step MFA
  description, three question-linked quantities paragraphs — RV, Lg, group
  contributions, each with a technical calculation footnote — decomposition
  equation, worked example), results 4.1–4.6 whose openings echo the three
  strategy questions (structure, RV, group contributions, antinomies,
  social sources, duality), discussion placeholder. ~19 pp. compiled.
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
- Strategy/results rewrite (2026-10-07/08, author request): quantities
  material of the strategy split into three question-linked paragraphs
  (RV = redundant-or-partially-independent question; Lg = participation-in-
  compromise — one number per group, absolute scale, Lg(h,k) =
  tr(S_h S_k)/√tr(S_h²), the unnormalized RV; contributions = which
  modality organizes each dimension, ctr(h,s) = Σ_j w_j f²_js/λ_s, sums to
  100% per dimension). Technical calculation footnotes added for all three
  quantities (configuration-matrix formulas, footnote style). Author's
  "dominated by consumption" example relocated from the Lg paragraph to
  the contributions paragraph. Results 4.2/4.3 openings echo the strategy
  questions ("first question … redundant or partially independent";
  "second and third questions posed above"; "On the third question").
  Category-map paragraph (4.1) gained a dim-3 preview sentence pointing
  to Section 4.3 (\label{sec:contrib}); Figure 4 caption notes "darker
  shades indicate older age groups."
- 2026-10-08 (pushed as `987dc96` + `291c37f`): terminology rewrite per
  decision 7 plus the modality definition; author's web edit `27e880f`
  ("The third question is different:") re-applied after the wholesale copy
  clobbered it.
- 2026-10-08 (terminology v2, per decision 10): modality→aspect purge
  across main.tex (38 prose occurrences; intro theory wording included),
  GDA definition of "modality" added to the bridging footnote, tab-groups
  header and fig legends/titles regenerated via scripts 03 and 06
  (transposed MFA re-validated against FactoMineR; all headline numbers
  unchanged; compiles at 24 pp.). Pushed as `bc48752` (plus `e6e3880`,
  AGENTS.md mirror refresh).
- 2026-10-08 (pushed as `64a7724`): fixed weight labeling — script 03
  tab-groups now reports both λ1 and Weight (1/λ1) (5.004/6.452/2.064), and
  the §4.3 sentence quotes the true inverse weights; new tab-partial-axes
  table + §4.3 partial-axes paragraph (with technical footnote) added after
  the Lg discussion; compiles at 24 pp. (pre-existing "Float too large"
  warning for tab-regression remains).
- Remaining: (a) robustness note comparing inclusive vs conjunctive
  evaluation codings (RV structure nearly identical: 0.057/0.062 vs
  0.049/0.060); (a2) DONE 2026-10-08: MCA-vs-PCA robustness footnote added
  to the strategy section after the MCA sentence (numbers from script 08).
  Was: candidate robustness footnote on MCA vs PCA: the same
  MFA with type="c" (scaled PCA within groups) was computed 2026-10-08 —
  eigenvalues 1.670/1.209/0.895, RV 0.32/0.05/0.07, individual coords
  ρ = 0.99/0.99/0.97 (sign-matched), W-scores ρ = 0.97/0.97/0.93,
  antinomy shares 51/52/62% — near-identical; the substantive difference
  is only MCA's rare-category upweighting (a feature for the paper's
  argument). Numbers now reproducible: `scripts/08-robustness-pca.R`
  writes `output/robustness_pca.rds` (2026-10-08); (b) full intro/discussion
  prose.

## Key references

- Ma, X. 2026. "Tastes and Complex Tastes." *Cultural Sociology* 20(2):311–333.
- Pagès, J. 2014. *Multiple Factor Analysis by Example Using R*. CRC.
- Abdi, Williams & Valentin 2013. "Multiple factor analysis…" WIREs CS 5:149–179.
- Lizardo & Skiles 2012. SSI Cultural Tastes Survey [dataset].
- Le Roux & Rouanet GDA volumes (added to `references.bib` by the author on
  Overleaf: keys `rouanet2000geometric-a44`, `roux2004geometric-65c`).
