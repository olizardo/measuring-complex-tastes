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
   **SUPERSEDED 2026-10-09 by decision 12.**
12. **Evaluation v3 (author request, 2026-10-09): "unambiguous high
    status" coding.** The fan-perception items are check-all-that-apply, so
    the conjunctive coding passed check-everything respondents (65 had
    eval = 20/20), which clumped the evaluation categories and leaked
    21.6% of eval's contribution into Dim 1. New coding: eval = 1 iff
    (grad AND NOT nocol) OR ((mc OR uc) AND NOT (lc OR wc)) — an
    unambiguous high-status signal in at least one domain. Yes-rate
    30.4% → 20.7%; agreement with conjunctive 72.5%; all-20 eval
    respondents 65 → 5. Full pipeline (scripts 01–08) rerun; manuscript
    numbers revised throughout. Key geometry changes: RV(eval,pref/cons)
    0.049/0.060 → 0.013/0.014; eval contribution to dim 1 21.6% → 2.5%,
    to dim 3 40.6% → 83.9%; dim 3 is now essentially the evaluation
    aspect's own axis (eval leading partial axis +0.91); race anchoring
    of dim 3 DISAPPEARS (η² 0.082 → 0.004) — dim 3 is socially flat
    (max η² 0.011); race now weakly anchors dim 2 (η² 0.048, Hispanic
    −0.42/Black −0.26/White +0.16). Worked-example respondent changed:
    rowname 1333 → 362 (highest W3 among guilty+pose+distant holders;
    likes 15, listens 9, evaluates 18; W1 0.8/3%, W2 13.5/60%,
    W3 133.1/76%).
13. **Terminology (author request, 2026-10-09): "complex-taste score" label
    purged.** $W_s(i)$ is now called the **aspect-disagreement (score)** on
    dimension $s$ throughout main.tex (prose, footnotes, figure and table
    captions; 11 hyphenated uses plus pre-existing "aspect disagreement"
    phrases). The eq:decomp paragraph replaces the old stipulation ("We
    call $W_s(i)$ the individual's complex-taste score") with an explicit
    interpretive move: $W_s(i)$ read strictly is the individual's
    aspect-disagreement on dimension $s$ — how much the person's position
    depends on which aspect is consulted — and we interpret that
    disagreement as complex taste because a profile whose aspects place
    the person in different locations cannot be summarized by any single
    taste position. "Complex taste space" (the global MFA structure) and
    "complex tastes" (the concept) are unchanged; script comments (04/08)
    still say "complex-taste score" but never render. Rationale: the score
    is literally aspect dispersion, not configural complexity (ρ with
    config counts 0.31/0.19/−0.06; worked example 362 is 94% coherence;
    all-yes respondents get W without configurations).
14. **Terminology + table (author request, 2026-10-09): ω renamed
    "genre-based complex taste"; tab-antinomy gains ω columns.** The
    aggregate Σ_g ω_s(i;g) is "the genre-based component"; per-genre
    ω_s(i;g) is introduced in the eq:genre where-clause as the
    respondent's genre-based complex taste and "the geometric expression
    of holding a complex configuration in that genre". Replaces
    "localized antinomy/antinomies", "the localized component",
    "genre-local part/dispersion" throughout main.tex (eq:genre
    paragraph, worked example, 4.4, sec:who robustness paragraph).
    Leftover "antinomy shares" in the robustness footnote →
    "aspect-disagreement shares" (decision-5 cleanup). tab-antinomy
    (script 04) now has 9 columns F1–3/W1–3/ω1–3, group headers "MFA
    coordinates / Aspect-disagreement / Genre-based complex taste" —
    the old "Complex-taste scores" header was a decision-13 leak, fixed;
    \footnotesize + tabcolsep 2pt required for fit (overflows by 83pt at
    \small, 27pt at \footnotesize/3pt). 4.4 signatures paragraph gains
    the config→ω map sentence (guilty 0.53/0.43 on ω1/ω2; pose 0.47,
    distant praise 0.38 on ω3; non-taste −0.75; simple-taste ω3 0.57 =
    margin residue). Full type-ω Spearman map (script-04 console):
    simple_pos .19/.35/.57, guilty .53/.43/−.22, preacquired
    .21/.26/.25, pose .14/.23/.47, distanced .29/.25/.03, justified
    .27/.16/−.18, distant −.13/−.05/.38, simple_neg −.75/−.75/−.36,
    n_complex .71/.66/.18; dim-free Σω ↔ n_complex 0.61.
4. Sample: complete cases on all 60 variables → **n = 2,259** of 2,276.
5. Terminology (author preference): the manuscript says "complex tastes,"
   not "antinomies." Table 3
   (tab-groups) is kept and the group-contributions figure was dropped as
   redundant. `manuscript/main.tex` is stored reflowed, one
   paragraph-per-line. Modality phrasing is "preference, engagement, and
   evaluation" — not "feeling, doing, praising"; Ma's configuration names
   (guilty pleasure, distant praise, taste pose, …) are kept as-is.
   The $W_s(i)$ "complex-taste score" label was SUPERSEDED 2026-10-09 by
   decision 13.
6. Dimension 4 was explored (category and individual maps) and deliberately
   left out of the manuscript: consumption-heavy, categories near the
   origin, weak social anchoring — no clean reading. Figures use dims 2–3
   only. PARTIALLY SUPERSEDED 2026-10-09: under the unambiguous-status
   coding dim 4 gained a strong race anchor (η² 0.255; old coding 0.171)
   and a clean reading — racialized engagement contrast, reggae/Latin/rap/
   Blues-R&B engagement (cons +0.77/+0.67/+0.52/+0.45) vs the rock–country
   cluster (metal −0.74, indie −0.62, controck −0.61, crold −0.45).
   λ4 = 0.788 (52% of λ1); aspect contributions cons 57%/pref 37%/eval 6%;
   partial axes pref ax3 +0.83, cons ax3 +0.93; other demographics ≤0.03;
   r(dim4, n likes) −0.005, r(n listens) −0.08 (not a volume artifact).
   Now in the manuscript as a supplementary paragraph in sec:social with
   fig-dim4 (category map dims 2×4, fig-categories design); tab-eta and
   tab-sup-coord extended to d4; script 05 computes dims 1–4 throughout
   (supplementary.rds cc/eta now include d4; script 07 reads only sup$sup,
   unaffected). Compiles at 26 pp.
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
   fig-worked-example two-panel since 2026-10-08 (author-approved after
   discussion): left = dims 1–3, right = dims 2–3 (the plane of the
   paper's other maps), shared dim-3 y-axis, free x-scales, facet
   strips label the dimensions; 7x3.8in, .9\linewidth in main.tex.
   Dim-2 prose sentence references the right panel; caption reports
   W1/W2/W3. Also 2026-10-08: technical footnote added after the
   pairwise-distance sentence in the eq:decomp paragraph (d²_s(h,k) =
   (F_sh − F_sk)²; sum = H·W_s), and main-text sentence states the
   sum-to-H·W_s identity.
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

11. **Terminology (author request, 2026-10-08): "strict" purged.** The
    evaluation measure is called "genre evaluation(s)" in prose, not
    "strict status attributions" (the author found "strict" confusing;
    status attribution is simply how evaluation is measured — whether the
    respondent thinks others think highly of the genre's fans). Eight
    occurrences replaced (Measures bullet definition sentence removed;
    worked example, 4.1 dim-1 and dim-3-preview sentences, 4.3
    every-one-of-twenty sentence, pair-decomposition sentence, 4.5
    "evaluation pole", configurations discussion). Unqualified "status
    attributions" survives in two explanatory sentences (§4.2 RV
    discussion, §4.6 duality) — kept as plain English, not the label.
    "Conjunctive" stays in the Measures/data-section coding description.

## Pipeline (run in order, from project root)

| Script | Output | Notes |
|---|---|---|
| `scripts/01-prepare-mfa-data.R` | `data/mfa_input.rds` | builds 60 binary cols (pref_/cons_/eval_ prefixes) |
| `scripts/02-run-mfa.R` | `output/mfa_results.rds` | FactoMineR MFA, `group=c(20,20,20)`, `type=c("n","n","n")` |
| `scripts/03-figures.R` | 4 figs + 4 LaTeX tables | scree, individuals, category map, RV heatmap; tab-eigen/rv/groups/genre-rates |
| `scripts/04-antinomies.R` | `output/antinomy_scores.rds` + fig-configurations, fig-antinomy-map, fig-worked-example, tab-antinomy, tab-pairs | W scores, pairwise disagreements, Ma's 8 configs |
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

## Current headline results (unambiguous-status eval coding, 2026-10-09)

- Yes-rates: preference 41.7%, consumption 22.9%, evaluation 20.7%
  (unambiguous-status standard is the least-affirmed aspect).
- Eigenvalues: λ1 = 1.509 (9.6%), λ2 = 1.178 (7.5%), λ3 = 0.982 (6.2%);
  first 5 dims = 32.5%.
- **RV coefficients** (central result): P–C 0.321; P–E 0.013; C–E 0.014 —
  evaluation is essentially perfectly independent of preference and
  consumption.
- Dimension readings (signs are SVD-arbitrary — re-anchor pole claims to the
  category coordinates after ANY re-run):
  - Dim 1 = general affirmation, now carried by liking/listening only
    (pref_yes +0.57, cons_yes +0.83; eval_yes mean only +0.29, range
    +0.03 Broadway to +0.53 rap).
  - Dim 2 = highbrow (+: big band +0.98, opera +0.86, Broadway +0.84,
    classical/bluegrass +0.73) vs popular (−: rap cons −0.91/pref −0.84,
    indie −0.84, metal −0.78, dance/club −0.75, reggae −0.63).
  - Dim 3 = status valuation, evaluation-owned: all 20 eval "yes"
    categories positive (mean +1.12; range +0.20 opera to +1.87 rap);
    ordered by rarity — granting status to popular-genre fans is the
    distinctive position, granting it to consecrated-genre fans is nearly
    universal. Pref/cons "yes" categories collapse near the origin on
    dim 3. Eval contributes 83.9% to dim 3 (8.0/8.1% for pref/cons);
    2.5% to dim 1, 11.0% to dim 2. Separate λ1s: 0.200/0.155/0.234
    (weights 5.004/6.452/4.277).
- **Partial axes**: dim 1 = pref/cons ax1 (0.84/0.86), eval ax1 only 0.19;
  dim 2 = pref ax2 (−0.87) + cons ax2 (+0.89) + eval ax2 (+0.35);
  dim 3 = eval ax1 (+0.91), pref/cons ax3 negligible (−0.14/−0.11) —
  dim 3 is evaluation's own axis.
- Social anchoring (supplementary η²): dim 2 ← age 0.331 (18–29 −0.74 →
  70+ +1.23), education 0.053 (No diploma −0.26 → Prof/PhD +0.67),
  subjective class 0.055 (upper +0.39), race 0.048 (Hispanic −0.42,
  Black −0.26, White +0.16), income 0.016; dim 3 SOCIALLY FLAT (max η²
  0.011, all barycenters within ±0.2) — the race gradient on dim 3 is
  GONE under the new coding; dim 1 weak (max η² 0.026, education
  concentrated at bottom: No diploma −0.39, HS −0.24, then +0.05..+0.13).
- Antinomies: mean 10.2/20 genres per respondent in complex configurations;
  only 12 respondents have zero. Justified 3.3, guilty 3.2, distant 2.2,
  pose 1.0, distanced 0.4, pre-acquired 0.1, simple_neg 8.9. Antinomy
  dispersion ≈ 56/52/63% of projected partial inertia (dims 1–3).
  n_complex ↔ W1 ρ = 0.31 (W_tot 0.27), W2 0.19, W3 −0.06. Pair-level
  dim-3 decomposition: dPV3 ρ = +0.16, dCV3 +0.14 (weakly concentrated
  at the status-granting pole). Config signatures: distant praise +0.79
  on dim 3; guilty −0.25 dim 2 / −0.24 dim 3; justified −0.33 dim 3;
  pose 0.22/0.34/0.37.
- **Genre-level decomposition (added 2026-10-09; script 04 section 3b)**:
  each partial point is exactly H·Σ_g c_ighs with per-genre contribution
  c = Δ_ghs·(z−p), Δ = (w_yes·V_yes − w_no·V_no)/√(p(1−p)) from the global
  PCA (F = X·diag(col.w)·svd$V; NOTE svd.triplet stores V/√w, so the weights
  enter linearly, not as √w). With d_ighs = c minus the genre's 3-aspect
  mean (center per GENRE — centering on the respondent's overall mean
  inflates the local part; first-pass numbers with that bug were 53/85/34%
  local shares), W_s(i) = Σ_g ω_s(i;g) + 2H²Σ_{g<g'}Σ_h d d', ω = H²Σ_h d².
  Mean local shares of W: 29/48/23% (dims 1–3); coherence 71/52/77%.
  Worked example 362: W3 133.1 = 8.5 local (max cell 1.0, a pose in
  latspsal) + 124.6 coherence (94%); W1 0.8 = 2.4 local + (−1.6) coherence
  (cancellation). corr(n_complex, Wloc) 0.69/0.63/0.17 vs corr(n_complex, W)
  0.44/0.18/0.08 — the localized part is the geometric counterpart of the
  combinatorial measure (ω renamed "genre-based complex taste"
  2026-10-09, decision 14). 196 respondents in bottom-third W3 but top-third
  localized (masked complexity). Script 04 saves omega (2259×20×3),
  cell_cfg (per-cell config labels), Dcoef in antinomy_scores.rds; ant gains
  Wloc1–3, coh1–3 columns (script 07 unaffected). Manuscript: new paragraph
  + Equation eq:genre in the Measuring Complex Taste at the Individual
  Level subsection (defines genre-local dispersion and cross-genre
  coherence); worked-example paragraph gains the 362 split (8.5 vs 94%
  coherence) after the combinatorial footnote. Spearman version of the
  localized-combinatorial link: corr(n_complex, Wloc) 0.71/0.66/0.18
  (dims 1–3) vs 0.31/0.19/−0.06 for W. Results 4.4 gains a paragraph
  after the divergence discussion reporting the 29/48/23% local shares
  and the 196 bottom-third-W3/top-third-localized respondents (9%).
  Compiles at 26 pp., no undefined refs.
- Author web edit `2bc1c30` (2026-10-09, adopted before the sync):
  Analytic Strategy opening ("like this one, namely"); RV subsection
  sentence split + new citation jæger2024from-a4b (Jæger & Larsen 2024,
  added to references.bib) + "more likely" rewording; worked example
  "In the second dimension (right panel...)" phrasing (my genre-split
  sentences re-inserted before it); 4.1 figure-reference rewordings
  ("As Figure~\ref{fig:categories12} shows" ×2, fig:categories now cited
  only in the 4.1 opening; the Bourdieu 1984 citation was DROPPED from
  the dim-2 paragraph — author's edit, flagged to author); Partial Axes
  and Composition subsections restructured (tab-partial-axes floated
  before Partial Axes; balancing-weights sentence moved to a footnote;
  new interpretation sentences; Composition split into several
  paragraphs); 4.4 opening "provide/cover" rewording.
- Regression (sec:who): R² 0.052/0.020/0.021. W1: parents' BA +1.32***,
  upper class +3.67***, >1 race +2.51**, age decline (−1.09 → −2.09).
  W2: only 70+ +0.63*. W3: upper class +7.70***, age +2.04..+2.73*,
  Hispanic +1.89*, Associate −3.79*. Log robustness: parentba F 5.2,
  sclass 2.3, gender F 11.8 (women lower log-W1). Pairwise dim-3:
  dPV3/dCV3 ← upper class (F 3.9/4.9); dPC3 ← parentba (15.2) + sclass
  (9.3). Localized-component robustness (added 2026-10-09, script 07
  robustness 3 + new final sec:who paragraph): ω models R²
  0.085/0.080/0.033; upper-class premium on ALL THREE dims (+0.25/
  +0.25/+0.58, p = .002/.002/.005 — incl. dim 2, where W2 shows none);
  parentba on ω1/ω2 (+0.10/+0.11***); age: ω3 RISES (+0.24..+0.48, same
  direction as W3) while ω1/ω2 decline; the W2 70+ premium (+0.63) is a
  coherence effect — ω2 declines with age in every cohort (−0.08..−0.28,
  all significant). WARNING for future sessions: an earlier assistant
  reply misread the ω3 age coefficient as NEGATIVE (−0.48, confused with
  n_complex's −0.54) and told the author there was a dim-3 age flip —
  there is NOT; the real flip is dim 2 (W2 vs ω2).
- **Interpretive quantities now in the manuscript (2026-10-09)**:
  (1) 4.4 dimension-readings sentence covers all three scores (W1 =
  liking vs listening, eval near-inert on dim 1: partial sd 0.46 vs
  2.07/2.11; W2 = rung placement on the shared ladder; W3 = attribution
  reach beyond a positionless engagement profile) + W3 footnote (behaves
  partly like a squared position score: cor(W3,|F3|) 0.72 vs 0.37 for
  W2; mean W3 = 5.7 among grant-none, 156 among grant-all-20);
  (2) pair-share sentence in 4.4 after the dim-3 pair-level sentence:
  dim-2 pairwise shares pref-cons 18%/pref-eval 35%/cons-eval 47%,
  cor(pref,cons partials on dim 2) 0.73 vs 0.09/0.06 with eval — new
  \label{sec:rv} on the Independence subsection supports the ref;
  (3) toy-contrast paragraph after eq:genre where-clause (single-genre
  complex taste vs twenty aligned per-genre tilts reaching the same
  total disagreement from opposite materials);
  (4) pairwise-decomposition paragraph gains the Ma mapping: each of the
  six complex configurations = one aspect standing against the other two
  (guilty/distant = evaluation odd; pose/distanced = consumption odd;
  pre-acquired/justified = liking odd), so the pair distances indicate
  which aspect is standing apart;
  (5) new tab-pairs (script 04, after tab-antinomy): mean squared pair
  distances on dims 1–3 with within-dimension shares — P–C 4.31/1.50/
  0.38 (33/18/2%), P–E 4.37/2.89/8.15 (33/35/49%), C–E 4.50/3.91/8.15
  (34/47/49%); totals 13.2/8.3/16.7 = 3·mean W_s; dim-3 P–C share 2%
  quoted in the 4.4 pair-share sentence, which also gains the dim-1
  contrast sentence (equal thirds → no aspect stands apart on the
  affirmation axis; liking vs listening around a near-inert eval point,
  unlike dims 2–3 where evaluation is the odd aspect out).
- **Duality (transposed MFA, genres as targets)**: genre-level RVs
  P–C 0.92, P–V 0.53, C–V 0.49 vs 0.32/0.01/0.01 individual level.
  Transposed dims: λ1 = 2.27 (14.6%), λ2 = 1.95 (12.5%). Constant
  respondent-variables dropped: 83/84/326 (eval constant includes the
  5 all-1 respondents). Dim 2 = configuration axis: positive pole =
  actively-held genres (simple_pos ρ +0.77, pose +0.55, guilty +
  justified +0.44): crold +3.7, moodez +2.0, country +1.8, toppop +
  classical +1.3; negative pole = simple-non-taste genres (ρ −0.73):
  rap −1.7, reggae −1.5, latspsal/metal −1.3, plus opera −1.2 (58.9%
  distant praise). Dim 1: negative = status-without-engagement genres
  (classical −3.6, opera −3.0, bwayst −2.1; distant ρ −0.82, pose
  −0.58), positive = guilty/distanced targets (crold, toppop, rap,
  controck; ρ +0.75/+0.80). Partial points dim 3: classical/opera eval
  partials +2.3 vs pref/cons ~+1.0/−0.0; country eval −0.8 vs
  pref/cons −3.1/−4.1.
- Robustness (MCA vs PCA, script 08): eigen 1.504/1.188/0.997 vs
  1.509/1.178/0.982; RV 0.32/0.013/0.015; coord ρ 0.98/0.97/0.84;
  W ρ 0.96/0.89/0.77; shares 56/53/61 vs 56/52/63.

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
- 2026-10-09 (later): fig-scree dropped from main.tex as redundant with
  tab-eigen (author request; same pattern as fig-rv) — `fig:scree` was
  never referenced in prose. fig-scree still generated by script 03 (file
  kept in repo, unreferenced). Then: new fig-categories12 added — category
  map on dims 1–2 in the fig-categories design (script 03 block after
  fig-categories, seed 17), supporting the 4.1 opening paragraph
  (`fig:categories12` referenced from its first sentence; figure env placed
  after that paragraph). Compiles at 26 pp.
- 2026-10-09 (later): figure restyling to white backgrounds (author request,
  prompted by the grey panel on the new fig-categories12): fig-categories,
  fig-categories12, fig-dim4, fig-individuals now use theme_minimal
  (panel.grid.minor blank, legend right); fig-worked-example connectors
  changed from dashed grey to solid aspect-colored segments (linewidth 0.5,
  alpha 0.7, fig-genre-map style) with panel.grid removed. Script 03/04/05
  blocks updated. GOTCHA: FactoMineR ind$coord.partiel is stacked PER
  INDIVIDUAL (rownames "362.pref", "362.cons", "362.eval"; row =
  3*(i-1)+h), not by group — a session-side reconstruction initially
  grabbed group-stacked rows and produced wrong coordinates; script 04's
  own P/C/V/F extraction is correct. Author web edit `ab16e48` (\footnotesize
  on the worked-example caption) re-applied locally. Compiles at 26 pp.
- Last Overleaf sync: `09a234f` (2026-10-09, later) — the 4.4 pair-share
  sentence gains the dim-1 contrast sentence: disagreement splits almost
  evenly across the three pairs on the affirmation axis (no aspect
  stands apart; liking vs listening around a barely moving eval point),
  unlike dims 2–3 where evaluation is the odd aspect out. Compiles at
  29 pp. Previous sync: `2497b8f` (2026-10-09, later) — two additions to the
  pairwise-decomposition material: (1) strategy paragraph after the
  d² footnote gains the Ma mapping sentence (each complex configuration
  = one aspect standing against the other two; pair distances indicate
  which aspect stands apart); (2) new tab-pairs (script 04 block after
  tab-antinomy; 3×3 mean squared pair distances + within-dimension
  shares; totals = H·mean W_s) placed after fig-antinomy-map, referenced
  from the 4.4 pair-share sentence, which gains the dim-3 clause (P–C
  share 2%). Compiles at 29 pp., no undefined refs.
  Previous sync: `124289b` (2026-10-09, later) — four clarifying
  additions (author request): toy-contrast paragraph after the eq:genre
  where-clause; 4.4 dimension-readings sentence extended to W1
  ("inherits its interpretation from its dimension"); 4.4 pair-share
  sentence (dim-2 shares 18/35/47, pref-cons partial r 0.73, new
  sec:rv label); W3 position-admixture footnote (cor 0.72 vs 0.37,
  grant-none 5.7 vs grant-all 156). Compiles at 29 pp., no undefined
  refs (two small pre-existing overfulls remain).
  Previous sync: `e6b9103` (2026-10-09, later) — ω renamed "genre-based
  complex taste" per decision 14: eq:genre where-clause names the first term;
  all "localized antinomy/component" wording replaced in eq:genre paragraph,
  worked example, 4.4, sec:who; "antinomy shares" → "aspect-disagreement
  shares" in the robustness footnote; tab-antinomy gains ω1–ω3 columns
  (9 cols, \footnotesize/2pt fit; stale "Complex-taste scores" header fixed);
  4.4 signatures paragraph gains the config→ω map sentence + margin-residue
  clause; caption updated. Script 04 table block rewritten. Compiles at
  28 pp. Previous sync: `005906f` (2026-10-09, later) — localized-component
  robustness added to sec:who as its final paragraph: same OLS models with
  the genre-localized component Σ_g ω_s(i;g) (the combinatorial-signal part
  of the score) as outcome; R² 0.085/0.080/0.033; upper-class premium on all
  three dims (incl. dim 2 where W2 shows none); parentba on ω1/ω2; age:
  ω3 rises like W3, ω2 declines across every cohort — the W2 70+ premium
  (+0.63) is a coherence effect. Script 07 gains robustness 3 (Wloc1–3
  models; dat gains Wloc columns; tab-regression.tex unchanged).
  CAUTION: the assistant's earlier summary of these results to the author
  contained a sign error (claimed a dim-3 age flip) — corrected before the
  paragraph was written; paragraph numbers verified against script output.
  Compiles at 27 pp., no undefined refs.
  Previous sync: `e60b577` (2026-10-09, later) — one sentence added
  to the 4.4 opening paragraph distinguishing the two disagreement readings:
  W2 = aspects disagreeing about rung placement on the shared highbrow–popular
  ladder; W3 = status attributions reaching further down the genre hierarchy
  than an engagement profile with no position on that axis (evaluation is
  nearly the only aspect that varies on dim 3: partial sds 0.69/0.70/2.75;
  cor(W3,|F3|) 0.72 vs 0.37 for W2; pairwise dim-2 shares pref-cons 18%,
  eval pairs 82%, dominated by cons–eval 47%). Compiles at 27 pp.
  Previous sync: `e0b7952` (2026-10-09, later) — "complex-taste
  score" label purged per decision 13: eq:decomp paragraph replaces the
  "We call W_s(i) the complex-taste score" stipulation with the explicit
  interpretive sentence (aspect-disagreement read strictly; disagreement
  interpreted as complex taste because no single taste position summarizes
  the profile); all 11 other label uses (robustness footnote, pairwise
  footnote, eq:genre paragraph, 4.4 prose, fig-antinomy-map caption,
  tab-antinomy + tab-regression captions, sec:who prose) now say
  "aspect-disagreement score" or $W_s(i)$. No web edits since `448a39e`
  (pull was clean); two-file copy (main.tex + AGENTS.md). Compiles at
  26 pp., no undefined refs (pre-existing tab-regression float warning).
  Previous sync: `448a39e` (2026-10-09, later) — genre-level
  decomposition of the complex-taste score: new Equation eq:genre +
  defining paragraph (per-genre contributions, genre-local dispersion
  ω, cross-genre coherence) in the Measuring Complex Taste at the
  Individual Level strategy subsection; worked-example paragraph gains
  the 362 split (W3 133.1 = 8.5 local, max cell a latspsal pose at 1.0,
  94% coherence); new results 4.4 paragraph after the divergence
  discussion (29/48/23% local shares; Spearman corr(n_complex, Wloc)
  0.71/0.66/0.18 vs 0.31/0.19/−0.06 for W; 196 bottom-third-W3/
  top-third-localized respondents, 9%); script 04 section 3b computes
  the decomposition (exactness checks ~1e-15; antinomy_scores.rds gains
  omega/cell_cfg/Dcoef, ant gains Wloc1–3/coh1–3). Merged author web
  edit `2bc1c30` BEFORE copying (adopted as local base; my two
  insertions re-applied on top): strategy opening rewording, RV
  subsection sentence split + jæger2024from-a4b citation (references.bib
  entry adopted), worked-example "In the second dimension (right
  panel...)" phrasing, 4.1 figure-reference rewordings, Partial Axes +
  Composition subsection restructuring (tab-partial-axes floated
  earlier, balancing weights moved to a footnote, new interpretation
  sentences), 4.4 opening rewording. NOTE: the author's edit DROPPED
  the \citep{bourdieu1984distinction} from the dim-2 paragraph —
  author's choice, flagged to them. Also: earlier conversation
  first-pass local shares (53/85/34%) used a WRONG centering (respondent
  overall mean, not per-genre aspect mean) — corrected numbers are
  29/48/23%; see the genre-decomposition bullet under Current headline
  results. Compiles at 26 pp., no undefined refs. Previous sync:
  `d348520` (2026-10-09) — full prose revision
  (author request: "less stilted and robotic... clearer and more
  conversational") applied throughout main.tex: cut throat-clearing
  openers ("Accordingly, for the global MFA analysis, we consider..."),
  nominalized/passive constructions, and over-qualified sentences; no
  numbers, citation keys, labels, \ref targets, or \input paths changed
  (verified by diffing the sorted multiset of numeric tokens and of
  label/ref/cite/input commands against the pre-revision text — both
  identical). Also fixed a stale detail: the worked-example caption still
  said "Dashed segments connect each partial point to the compromise"
  from before the `897803f` restyle switched those connectors to solid
  aspect-colored lines; caption now matches. MERGE NOTE: a web edit
  (`6170dc9`, landed between the prose-revision draft and this sync)
  restructured the aspect-independence/partial-axes/composition region
  (new subsection "Independence or Redundancy Among Complex Taste
  Aspects" merging the RV + near-orthogonality paragraphs; "Partial Axes"
  moved before "Composition of the Dimensions of Complex Taste Space";
  RV table floated earlier) — adopted verbatim (not reflowed into the
  rest of the draft's voice, since it was the author's own just-made
  edit) and the surrounding paragraphs polished to match. Compiles at
  26 pp., no undefined refs. Previous sync: `897803f` (2026-10-09) — white-figure restyle +
  worked-example connectors (see note above). One author web edit since
  `348896c` (`ab16e48`, \footnotesize on the worked-example caption),
  re-applied locally before the copy. Previous sync: `348896c` (2026-10-09) — merged 20 author web-edit
  commits (`5d039e2..89ce214`): Analytic Strategy restructured into five
  \subsections (Constructing the Global Complex Taste Space; Independence
  or Redundancy of Aspects of Complex Tastes; Interpretation of Complex
  Taste Space Dimensions; Composition of Complex Taste Space Dimensions;
  Measuring Complex Taste at the Individual Level); Measures description
  list converted to prose; "Overall Structure of the Complex Taste Space";
  "coherent interpretation of the first three dimensions" opening; RV
  footnote rewritten (complex-taste motivation); ctr footnote moved to the
  contributions paragraph end; pairwise-distance material reworded with
  d²(i)_{s,pc/pe/ce} notation; worked-example sentence reworded + configs
  footnote moved to the W2 sentence; "conducted in R" sentence moved into
  a footnote at the eigenvalue paragraph. Re-apply method: adopted the
  Overleaf main.tex as the local base (the web edits did not touch the
  scree figure or 4.1 opening structure my local changes modified), then
  re-applied locally: fig:scree env removed; fig:categories12 reference
  added to the new "coherent interpretation" sentence; fig:categories12
  figure env inserted after the 4.1 opening paragraph. Author edits did
  not touch AGENTS.md. Compiles at 26 pp., no undefined refs. Previous
  sync: `5d039e2` (2026-10-09) — dim-4 supplementary section:
  script 05 extended to dims 1–4 (tab-eta and tab-sup-coord gain a Dim 4
  column; new fig-dim4 = category map on dims 2×4 in the fig-categories
  design; supplementary.rds cc/eta now include d4), new paragraph in
  sec:social reading dim 4 as a racialized engagement contrast (race
  η² 0.255; Black +0.98 vs White −0.30; reggae/Latin/rap/Blues-R&B cons
  +0.77/+0.67/+0.52/+0.45 vs metal/indie/controck/crold −0.74/−0.62/−0.61/
  −0.45; eval flat), fig:dim4 environment, captions updated to "first four
  MFA dimensions". Decision 6 marked partially superseded in AGENTS.md.
  No author web edits since `0fdead3` — nothing to re-apply. Compiles at
  26 pp., no undefined refs. Previous sync: `60d3145` (2026-10-09).
- Previous sync: `0f3b436` (2026-10-08) — three batched changes:
  (1) technical footnote on the pairwise-distance decomposition
  (d²_s(h,k) = (F_sh − F_sk)²; the three distances sum to H·W_s) plus a
  main-text sentence stating the sum-to-H·W_s identity; (2) two-panel
  fig-worked-example (dims 1–3 left, dims 2–3 right, shared dim-3
  y-axis), caption/prose updated, script 04 now loads ggrepel; (3) "strict"
  purged per decision 11 — "genre evaluation(s)" throughout, Measures
  definition sentence removed. Author web edit `3572d4c` landed before
  the copy and was re-applied locally first: "On the first
  (horizontal) dimension" in the worked example, "(for their rarity)"
  after "the most extreme consumption affirmations" in 4.1 (its
  context still contained "strict" — superseded by decision 11 at
  copy). Rerun of script 04 regenerated fig-antinomy-map,
  fig-configurations, antinomy_scores.rds with byte-only differences
  (values verified identical; reverted rather than committed).
  Outer repo commit records the same changes plus the gitlink.
  Previous sync: `abbe68e` (2026-10-08) — defines $H$ (number of
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

- Reconciliation sync (2026-10-08, later): found the local tree BEHIND the
  Overleaf clone (decisions 10–11 work had been committed from the clone
  side in `abbe68e`/`0f3b436` plus web edit `3572d4c`, never copied back to
  the local tree). Copied manuscript/ sources, figures, tables, scripts,
  and AGENTS.md from the clone into the workspace; the only local-only
  script differences were comment wording. Reverse fix: the clone's
  tracked `data/mfa_input.rds` and `output/mfa_results.rds` were stale
  OLD-CODING (inclusive-OR) binaries uploaded from the web on Oct 7
  (`bd6fbf1`) — replaced with the current conjunctive-coding versions from
  the workspace. Lesson: syncs must go both ways — after a clone-side
  commit, copy back into the workspace so the trees never diverge.

- GitHub update (2026-10-08, after the reconciliation): origin/main was 6
  commits ahead of local (7e30198..58b87fc — the same decisions-10/11 work,
  committed to the outer repo in an earlier session but never fetched into
  this checkout; local had diverged at 47f927a). Since the local tree was
  already the reconciled state, rebased by soft-reset onto origin/main and
  recommitted the true increment (AGENTS.md note, refreshed gitlink →
  58e1401, regenerated mfa_results_transposed.rds) as ae0572f; pushed.
  The pre-reset local history is preserved on branch
  `backup-pre-gh-reconcile` (47f927a) — safe to delete once confirmed.

- Sync `47cecc2`/`7507174` (2026-10-09): dropped fig-rv (RV heatmap) as
  redundant with tab-rv (Table 3); §4.2 now cites the table only
  (author request). A web edit `63b8036` landed mid-sync and was briefly
  clobbered by the copy; restored in `7507174`. That web edit: the author
  rewrote the dim-3 forward reference themselves ("...status-valuation
  axis, opposing the evaluation aspect to both the preference and
  consumption aspects." — replacing the Section-4.3 pointer sentence), and
  reworded §4.2 ("complex taste idea"; "form a structurally independent
  aspect of taste that people's likes and actions cannot recover";
  "empirically distinct from their preference and consumption profiles").
  Compiles at 24 pp., no undefined refs. fig-rv still generated by script 03
  (file kept in repo, just unreferenced).

- Sync `0108a31`/`c10aed7` (2026-10-09): redesigned fig-antinomy-map per
  author request — the old viridis W1-colored map read as "one big purple
  blob" (2,259 overplotted points). New design: grey translucent cloud for
  all respondents, orange points marking the top 20% (quintile) of W1;
  the highlighted points blanket the plane, visualizing the ρ≈0.01/0.02
  null result. Script 04 p7 rewritten; prose sentence and caption updated.
  Author web edit `4fd2b19` landed mid-sync ("Operationalizing Complex
  Tastes" → "Measuring Complex Tastes"; "We measure complex tastes
  geometrically, as the dispersion…") and was briefly clobbered by the
  copy; re-applied in `c10aed7`.

- Sync `482564c`/`49287ea` (2026-10-09): moved tab-antinomy (Spearman
  correlations of Ma's eight configurations with MFA dims and W-scores)
  from Appendix A into §4.4, immediately after the geometric-vs-
  combinatorial divergence paragraph, together with its interpreting
  paragraph (first sentence reworded to follow the divergence discussion:
  "The configuration counts themselves have distinct geometric
  signatures…"). Divergence-paragraph citation now "(Table~\ref{tab:antinomy})"
  only. Appendix keeps definitions + fig-configurations. Compiles at
  25 pp., no undefined refs.

- Coding change + full revision sync (2026-10-09, later): adopted the
  "unambiguous high status" evaluation coding (decision 12) — eval = 1 iff
  (grad & !nocol) | ((mc|uc) & !(lc|wc)) — because the check-all-that-apply
  perception items let check-everything respondents pass the conjunctive
  standard (65 all-20 eval respondents), clumping the eval categories and
  leaking 21.6% of eval into Dim 1. Reran scripts 01–08; revised every
  number in main.tex (measures, robustness footnote, worked example →
  respondent 362, §4.1–4.6, appendix prevalence). Headline shifts: RV
  P–E/C–E 0.05/0.06 → 0.013/0.014; eval contrib dim1 21.6% → 2.5%, dim3
  40.6% → 83.9% (dim 3 is now essentially the evaluation aspect's own
  axis); dim-3 race anchoring GONE (η² 0.082 → 0.004, dim 3 socially
  flat); race now weakly anchors dim 2 (Hispanic −0.42/Black −0.26/
  White +0.16); λ1 1.51 (9.6%). Web edit `91291b8` (author restructured
  the partial-axes passage: new \subsection{Partial Axes}, two
  paragraphs, footnote dropped, "evaluation-dominant but not exclusively
  evaluative" → re-applied with NEW numbers; also "The two measurement
  approaches") landed mid-sync and was briefly clobbered; merged in the
  same commit. Overleaf `60d3145`; compiles at 25 pp., no undefined refs.
  tab-groups Weight column updated (eval weight 4.277, λ1 0.234).
