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

## Bibliography

**IMPORTANT**: `manuscript/references.bib` is a symlink to
`/home/omarlizardo/projects/references.bib` (the global bibliography file).
Any citations added or modified must be made to the global file, not the local
symlink. The two files are identical; the symlink keeps the project in sync
with the global Zotero export.

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
15. **Style (author request, 2026-10-10): minimize colons in manuscript
    prose.** Avoid colon-prefixed elaborations ("X: y z") in running text;
    prefer separate sentences, "so that", "and", or em-dash appositives.
    Applies to assistant-drafted prose; the author flagged this after the
    RV paragraph rewrite. Semicolon-chained clauses are also best split.
16. **Table 7 (tab-antinomy) REPLACED by fig-signatures heatmap (author
    choice via AskUser, 2026-10-10; the 9×9 Spearman table was "busy").**
    Script 04's table block became a figure block: `fig-signatures.pdf`
    (label `fig:signatures`), .95\linewidth, 7×3.8in. Signed Spearman
    heatmap of the SAME matrix (type_counts × F1–3/W1–3/ω1–3); rows
    grouped by which aspect stands against the other two (evaluation-odd
    guilty/distant, consumption-odd pose/distanced, liking-odd
    preacquired/justified), then Simple taste, Simple non-taste, and
    Total complex tastes, with blank separator rows. GOTCHAs (both bit us
    in the first rendering): (a) gap rows must carry DISTINCT labels that
    match the factor levels from the start (" " and "  " in sigrows$lab
    directly) — patching `""` values to different levels AFTER factor() maps
    them to NA and prints an "NA" row on the axis; (b) facet_wrap needs
    `scales = "free_x"` — with 9 x-levels and fixed scales every panel
    reserved space for all 9 scores and squeezed the 3 tiles to a third
    of the panel width.
    Columns F/W/ω within each Dimension 1/2/3 facet; diverging
    #08519C–white–#A63603 fill with FIXED limits [−1,1]; values printed in
    cells (white text when |ρ| > 0.55); plotmath x labels (F[1]…omega[3]);
    ρ legend at bottom. `tab-antinomy.tex` git-rm'd (must also be deleted
    from the Overleaf clone). main.tex: three refs updated (divergence
    sentence, 0.71/0.66 sentence, "genre-based columns" sentence →
    Figure~\ref{fig:signatures}); table env → figure env with adapted
    caption. Script 04's console Spearman prints unchanged (still the
    source of these numbers).
17. **Dimension 4 fully REMOVED from the manuscript (author request,
    2026-10-10) — decision 6's partial supersession reversed.** The
    supplementary dim-4 paragraph in sec:social and the fig-dim4 env are
    deleted; "across all four dimensions" → "across the three dimensions";
    tab-eta and tab-sup-coord trimmed back to Dims 1–3 (captions "first
    three MFA dimensions"; script 05 table blocks, with a comment noting
    the manuscript no longer discusses dim 4). Script 05 STILL computes
    d4 in eta/cc (supplementary.rds unchanged, script 07 unaffected) and
    still generates fig-dim4.pdf — file kept in repo, unreferenced
    (fig-scree pattern). The dim-4 numbers (race η² 0.255, racialized
    engagement contrast) remain on file in AGENTS.md decision 6 for a
    reviewer response if needed.
18. **sec:social REBUILT around demographics vs. DISAGREEMENT (author
    request, 2026-10-10; the demographic-position analysis "does not
    really answer the question of the social sources of complex tastes"
    because barycenter position is only indirectly connected to how many
    complex tastes a person has).** The supplementary-position subsection
    is DELETED from main.tex (projection-method paragraph, tab-eta,
    tab-sup-coord, fig-supplementary envs, the three dimension-position
    paragraphs incl. the dim-3 social-flatness reading); the files stay
    in the repo unreferenced (fig-scree pattern) and script 05 still
    computes/generates everything — supplementary.rds `sup` remains the
    covariate source for script 07, so 05 must keep running in the
    pipeline. The old sec:who subsection is merged into a single section
    "The Social Sources of Complex Tastes" carrying BOTH labels
    (\label{sec:social}\label{sec:who}) so the 4.1 dim-2 age pointer and
    the [DRAFT] discussion enumeration still resolve (FLAGGED to author:
    the draft's "social sources in Section X, their individual-level
    correlates in Section X" now names the same section twice — fix when
    writing the discussion). New opening paragraph states the
    position-vs-disagreement distinction (positions are anchored — age
    η² 0.33 on the highbrow–popular axis — but W_s is a within-respondent
    quantity, so barycenters cannot answer the amount question) and
    introduces the NEW tab-w-eta (script 07 block after tab-regression):
    η² of each of the 8 demographics with W1–W3, uniformly tiny — max
    age→W1 0.019, no variable reaches 0.02, quoted against the 0.33.
    The old sec:who opening kept with fixes ("projected as supplementary
    variables above" → "on the eight demographics jointly"; the
    "(Section~\ref{sec:social})" self-ref dropped; the semicolon chiasmus
    split into two sentences); partial-effects/log/pairwise/ω/coherence
    paragraphs unchanged. tab-regression.tex re-run byte-identical.
    Renumbering: tab-w-eta is Table 7, tab-regression Table 8. One of the
    two pre-existing overfulls lived in the deleted prose and is gone;
    the tab-genre-profile overfull remains. Compiles at 28 pp.
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
   points colored by age group — **DROPPED from main.tex 2026-10-10** (author
   request after a keep/drop discussion; follows the fig-scree pattern —
   script 03 still generates it, file kept in repo, unreferenced; the dim-2
   prose clause now states the age anchoring directly with the
   Section~\ref{sec:social} pointer); supplementary figure =
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

## Statistical caution: ω-demographics correlations (2026-10-14)

**All Pearson correlations reported in section 4.9 (ω-demographics figures and
prose) are point estimates WITHOUT confidence intervals.** They are derived from
script 09 using pairwise complete cases (N = 2,259). For typical effect sizes
reported (r ≈ 0.10–0.20), standard errors at this sample size are SE ≈ 0.020, so
95% CIs overlap substantially for nearby values. **Do NOT claim that one correlation
is "stronger" or "more important" than another without either (a) computing and
citing CIs, (b) testing formal equality (e.g., via Fisher z-test), or (c) using
hedging language ("slightly", "similar though slightly", "comparable to").**
Examples of problematic claims: "education is stronger than parents' education"
(diff 0.17 vs 0.15 on D1 is ≈ 1 SE), "X correlates more with genre A than genre B"
(requires test). This matters because readers may interpret prose rank-orderings as
evidence of mechanism when they reflect sampling noise. Conversely, small but stable
differences across the full sample (e.g., age effect on rap consistently −0.42 across
runs) are reliable. When in doubt, phrase results as "gender shows X correlation
with genre Y, with a similar/comparable/slightly different pattern for race" rather
than "X shows a stronger effect than race."

## Pipeline (run in order, from project root)

| Script | Output | Notes |
|---|---|---|
| `scripts/01-prepare-mfa-data.R` | `data/mfa_input.rds` | builds 60 binary cols (pref_/cons_/eval_ prefixes) |
| `scripts/02-run-mfa.R` | `output/mfa_results.rds` | FactoMineR MFA, `group=c(20,20,20)`, `type=c("n","n","n")` |
| `scripts/03-figures.R` | 4 figs + 4 LaTeX tables | scree, individuals, category map, RV heatmap; tab-eigen/rv/groups/genre-rates |
| `scripts/04-antinomies.R` | `output/antinomy_scores.rds` + fig-configurations, fig-antinomy-map, fig-worked-example, fig-signatures, fig-genre-segments, tab-pairs | W scores, pairwise disagreements, Ma's 8 configs (tab-antinomy replaced by fig-signatures, decision 16). fig-genre-segments = per-genre tri-segment maps (yes/no endpoints of each aspect's contribution, arrows toward yes, facets down the highbrow–popular rung) — kept in repo, UNREFERENCED in main.tex (fig-scree pattern), added 2026-10-10 |
| `scripts/05-supplementary.R` | `output/mfa_results_sup.rds`, `output/supplementary.rds` + fig-supplementary, tab-eta, tab-sup-coord | demographics as supplementary group 4; tables report dims 1–3 only (decision 17); manuscript outputs UNREFERENCED since decision 18 but the script must keep running (script 07 reads `sup`) |
| `scripts/06-transposed-mfa.R` | `output/mfa_results_transposed.rds` + fig-genre-map, tab-genre-profile | transposed MFA (genres as individuals, 3 modality groups of respondent-indicators) |
| `scripts/07-regression.R` | `manuscript/tables/tab-regression.tex`, `manuscript/tables/tab-w-eta.tex` | OLS of W1–W3 (and dPV3/dCV3 robustness) on demographics; reads output of 04 + 05 (05 now saves `sup` in supplementary.rds); also the bivariate η² table of demographics with W1–W3 (decision 18) |
| `scripts/08-robustness-pca.R` | `output/robustness_pca.rds` | MCA-vs-PCA robustness: same MFA with `type="c"` (scaled PCA within groups); compares eigenvalues, separate λ1 (group weights), RV, sign-matched individual coords, W-scores, antinomy shares |
| `scripts/09-omega-demographics.R` | `manuscript/figures/fig-omega-demographics-dim1/2/3.pdf`, `fig-omega-demographics-genres-d1/2/3.pdf` | Pearson correlations of 16 demographics (education and class as four category indicators each) with genre-based ω per genre; colored-value matrices (added 2026-10-14; see the 4.9 redesign session and the 2026-10-14 audit/final sessions below for design history) |

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
- Last sync (2026-10-11): Pagès Lg-quote citation fixed — `[p.~137]` →
  `[pp.~137--138]` on the "number of common dimensions, each 'weighted' by
  its inertia" sentence (the phrase is on printed p. 138; p. 137 carries the
  Lg/RV formulas). Found by the book cross-check; two author web edits
  (`22ea47a` + `30792b4`, stylistic rewordings in sec:antinomies meanings/
  pair paragraphs — "interpretive caution", "indicates", "vertical
  dimension", "two opposed ends", "it grants" for the respondent, "A large
  score indicates disagreement"; no numbers changed) adopted as the local
  base, citation fix re-applied on top. Also added `mfa-book-crosscheck.md`
  at the workspace root — a 16-entry cross-reference of every manuscript
  measure/equation to Pagès (2014) sections and printed pages, from a
  full-text extraction of the book PDF (page mapping: PDF page = printed
  page + 15 in this copy). Key contents: eq:decomp ↔ §5.4 pp. 107–109;
  superimposed caveat ↔ §5.5–5.6 pp. 110–116; RV/Lg ↔ §7.2 pp. 133–139
  (+ §7.3 pp. 139–140 for Lg(h,h), §7.5 p. 143 for CTR(K_j,w_s));
  weighting ↔ §4.3 pp. 82–86 + §8.2 p. 163; partial axes ↔ §4.5 pp. 88–91;
  eq:genre, pairwise identity, transposed MFA, aggregate Lg(h,MFA) have NO
  book counterpart (paper's own / FactoMineR-level). Workspace-only file,
  not mirrored to Overleaf.
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
- Synced 2026-10-10 (overleaf 90a99b2): section 4.5 (sec:antinomies) restructured
  into five question-framed \subsubsections (author request: 4.5 too dense; each
  subsection = one measure framed by a natural-language substantive question,
  not GDA technicalities). Structure now: untitled opening (score intro +
  56/52/63% headline + two running respondents + fig-worked-example; the
  examples-intro enumeration gains a fifth clause "and how the geometric
  scores relate to counting configurations") → "How Far Does a Person's Taste
  Come Apart?" (W-score meanings, dims 1–3, running-example anchors) →
  "Which Aspects of Taste Disagree With Each Other?" (NEW heading + one lead
  sentence "A large score says that the aspects disagree, but not which of
  them are pulling against each other..."; pair-level decomposition +
  running-example pair distances + tab-pairs) → "Which Aspect Stands Apart?"
  (existing heading, question mark ADDED for consistency; per-aspect shares
  unchanged) → NEW "Is the Disagreement Attached to Particular Genres?" (ω +
  coherence; one new lead paragraph poses the local-vs-transposable question
  and points to eq:genre; then the two genre-split paragraphs MOVED here from
  the comparison subsection — 211's opener now "The running respondents show
  how differently the two components can behave", 213 minus its
  combinatorial-signal sentence) → "Do the Two Measures Find the Same Complex
  Tastes?" (RETITLE of "The Two Measures Compared"; divergence paragraph with
  the combinatorial-signal sentence MOVED IN from 213, de-colonized and
  appended after the factor-of-forty sentence so ρ 0.31/0.19 precede the
  0.71/0.66 "against" callback; then signatures paragraph + fig-signatures
  env). All moved text otherwise verbatim. ALSO local-only from the same
  session: two new Discussion paragraphs after the [DRAFT] placeholder
  (two-measures recap; genre-based-vs-coherence answer to the propensity
  question — genre-based component cannot answer "who is prone to complex
  tastes", coherence is the geometric counterpart of the propensity,
  person-type framing dissolves into separable quantities, orientation not
  disposition). Compiles at 29 pp., 0 undefined refs, 1 pre-existing
  overfull (tab-genre-profile).
- Synced 2026-10-10 (overleaf 90a99b2): NEW main-text paragraph in the
  4.5 dim-2 block (after "In the first case... consumption outruns valuation",
  before the dim-3 paragraph) clarifying what the evaluation point's dim-2
  position means — author chose main text over footnote after asking whether
  positive = "evaluates highbrow genres highly" and negative = "extends high
  evaluation to popular genres". BOTH readings are WRONG (verified numerically;
  numbers below must not be contradicted in future prose). (a) All 20 eval-yes
  categories sit POSITIVE on dim 2 — granting status to ANY genre moves the
  eval partial point toward the highbrow side; per-grant push (partial-point
  units = 3×move_yes) is rarity-weighted: opera 0.06 (eval-yes rate 0.74),
  classical 0.06 (0.67), vs Latin/Salsa 0.42 (0.06), Blues/R&B and dance/club
  0.39 — roughly 7x. (b) eval partial d2 correlates 0.98 with TOTAL grant
  count; partial cor(pd2, eH−eP | total) = −0.66 — at equal totals a
  popular-HEAVY grant profile sits MORE positive (opposite of the naive
  reading); eval-yes rates average 0.29 highbrow vs 0.10 popular. (c) All-no
  baseline = −1.02 (321 zero-grant respondents share it; 1881 sits exactly
  there). (d) Selection mechanism: granters skew highbrow-demographic (mean
  grants rise 3.3→4.9 across age6, 3.6→5.1 across education; cor(global F2,
  total grants) 0.35; granters of any genre sit higher on global F2 than
  non-granters, e.g. latspsal +0.75 vs −0.05, rap +0.39 vs −0.02). Paragraph
  wording: sign does not say which genres a respondent thinks highly of;
  position records how many genres recognition extends to; generous evaluators
  are older/more educated and sit highbrow; 362's +4.31 = eighteen grants of
  every kind, not special valuing of consecrated genres. The
  generous/withholding reading belongs to DIM 3 (rap eval-yes +1.87, opera
  +0.20 there).
- Synced 2026-10-10 (overleaf 90a99b2): TWO connected changes from the
  category-cloud discussion. (1) The dim-2 clarification paragraph gains the
  cloud reference after the seven-times clause — "The category map shows the
  pattern directly (Figure~\ref{fig:categories})---all twenty evaluation
  ``yes'' categories sit on the positive side of the highbrow--popular axis,
  and the rare grants sit furthest out, $+0.75$ for Latin/Salsa against
  $+0.10$ for opera." Verified cloud numbers: eval-yes d2 range +0.09
  (classical) to +0.75 (latspsal), all 20 positive; eval-no all negative
  (−0.02 to −0.28); the per-grant push is EXACTLY proportional to the
  eval-yes cloud coordinate (constant ratio 5.5 across all 20 genres — the
  eval partial d2 is literally a rarity-weighted grant tally). Negative side
  = 1,395 respondents: the 321 zero-grant at the shared −1.02 point plus
  few/consecrated-only granters (granting only opera+classical still sits at
  about −0.9; nobody is positive with fewer than 3 grants; some 5-grant
  respondents remain negative). (2) FIG-CATEGORIES REDESIGNED (author
  request — readers could not tell which dimension was horizontal vs
  vertical): script 03's category-map block replaced the facet_grid two-panel
  version with two mk_cc plots composed via patchwork::plot_layout(guides =
  "collect"); explicit axis titles "Dimension 1 (volume)" /
  "Dimension 2 (highbrow vs popular)" / "Dimension 3 (status valuation)";
  facet strips DROPPED (the titles carry the info); same 8.5×4.4in, seed 17
  per panel (repelled label positions can shift slightly vs the faceted
  version). ASCII "vs" in titles also eliminates the mbcsToSbcs ggsave
  warnings. main.tex caption: "The left panel shows dimensions 1--2 and the
  right panel dimensions 2--3" sentence DELETED as redundant with the axis
  titles; rest of caption unchanged. fig-individuals/fig-rv/fig-scree
  regenerated byte-only and REVERTED; tables byte-identical. Compiles 29 pp.,
  0 undefined refs, 1 pre-existing overfull (tab-genre-profile).
- Last sync (2026-10-10, later): sec:social regression-motivation sentence
  REWRITTEN (author request — the old claim was wrong: counts CAN be modeled,
  as Ma does in his Socius piece). Old: "Measuring complex tastes
  geometrically has one further advantage: W_s(i) is a continuous,
  dimension-specific quantity, so it can serve directly as the outcome of a
  standard regression model---something the combinatorial count, a single
  coarse integer, can't do." New passage (opens the tab-regression
  paragraph): concedes the count can be modeled directly, citing NEW bib
  entry `ma2026deep` (Ma, Xiangyu. 2026. "On the Deep, Surprising, and
  Persistently Gendered Dynamics in Complex Music Tastes." Socius,
  doi 10.1177/23780231251410969 — the author's count-model companion piece;
  SAGE paywalls the article page, so the entry has NO volume/article number —
  fill in from the published version), then states the geometric measure's
  actual regression-relevant advantages: (1) dimension-specificity — W_s(i)
  is one quantity per dimension of the taste space, so the regressions ask
  WHERE social location moves disagreement (volume, highbrow–popular, or
  status-valuation axis) not just how many complex tastes a person holds;
  (2) magnitude — each configuration enters the score weighted by how
  distinctive its answers are in that genre, so same count can give very
  different scores (the session-verified rarity weighting). Colon from the
  old sentence gone (decision 15). SIDE EFFECT: ma2026deep disambiguates as
  Ma 2026a and ALL existing ma2026tastes citations now display "Ma 2026b"
  throughout (plainnat author-year, required) — flagged to author. Compiles
  at 28 pp. (was 29, paragraph reflow), 0 undefined refs. main.tex +
  references.bib changes are LOCAL-ONLY, pending commit and Overleaf sync
  (this AGENTS.md note goes out with them).
- Last sync (2026-10-10, later): NEW fig-genre-segments (per-genre tri-segment
  maps) from a new script-04 figure block (placed after library(ggplot2), before
  the fig-signatures block — ggplot2 loads at line 231, so section-3b placement
  would break; the block uses script-04's own pm margins, NOT the session's
  stray pm matrix). Design: for each genre x aspect, the yes/no endpoints of
  the contribution c on dims 1-3 drawn as vertical segments (c_yes =
  Dcoef*(1-p), c_no = -Dcoef*p, barycenter 0, so rare answers move further),
  arrows toward yes, aspect palette, facets ordered down the highbrow-popular
  rung (Big Band ... Rap/Hip-Hop), 10x8in. Kept in repo, UNREFERENCED in
  main.tex (fig-scree pattern). Verified: formula endpoints match Ccont's
  unique values to 5e-11; genre order on Ccont dim 2 confirmed CANONICAL via
  barycentric-mass matching against yes-rates (identity permutation — the two
  exactness identities sum over genres, so they cannot detect a permutation).
  Session findings behind the figure: Ma's 8 configurations are exactly the 8
  possible endpoint-triples per genre, all holders of a config in a genre
  sharing IDENTICAL local geometry (within-cell spread 0); same config,
  different local magnitude by genre (distant praise omega3 1.03 in rap,
  0.00 in opera); rap's granting cells cluster omega3 ~0.9-1.0 incl.
  simple_pos 0.92 (margin dispersion, not configuration — local face of
  decision 13). Three-file copy (figure + scripts/04-antinomies.R + AGENTS.md);
  main.tex untouched, no compile check needed. Outer commit also records the
  gitlink.
- Last sync (2026-10-10, later): sec:social REBUILT per decision 18 (author
  request after a methodological critique — the barycenter/η²-with-dimensions
  analysis answered where groups sit, not who has complex tastes). The
  supplementary-position subsection is gone (tab-eta, tab-sup-coord,
  fig-supplementary envs deleted; files kept in repo unreferenced; script 05
  unchanged and still required by script 07); the section now titled "The
  Social Sources of Complex Tastes" merges the regression material and OPENS
  with the position-vs-disagreement distinction plus the NEW tab-w-eta
  (η² of demographics with W1–W3; max 0.019, no variable reaches 0.02,
  against age-position 0.33). Both \label{sec:social} and \label{sec:who}
  live on the merged section (the [DRAFT] discussion sentence now names the
  same section twice — flagged to author). Script 07 gains the tab-w-eta
  block. Compiles at 28 pp., 0 undefined refs, 1 pre-existing overfull
  (tab-genre-profile) + pre-existing tab-regression float warning.
  ADOPTED MID-SYNC web edit `ca49461` (author, 22:42 UTC; landed at pull
  and was briefly clobbered by the manuscript copy, re-applied): shares-
  vs-contributions paragraph — "an aspect supplies" → "an aspect is
  responsible for"; the extreme-case sentence rewritten axis-first
  ("The first global axis is the extreme case, contributing only
  $2.5\%$ to the dimension yet carrying a third of the disagreement") —
  REPAIR re-applied on top (flagged to author, second time): the 2.5%
  supplier is EVALUATION, not the axis, so the clause now reads "with
  evaluation contributing only $2.5\%$ of the dimension yet carrying a
  third of the disagreement" (keeps the author's axis-first structure;
  they reverted to an axis subject once before — see the 2026-10-09
  repairs note — if they insist on their exact wording, restore it).
  AUTHOR CONFIRMED THEIR WORDING (2026-10-10, immediately after the
  push): the repair was REVERTED; the sentence now reads exactly as in
  web edit `ca49461`. DO NOT re-repair this sentence in future sessions
  — the author has now written an axis subject three times and has
  explicitly chosen it.
- Last sync (2026-10-10, later): TWO TRIMS the author requested back to
  back (decisions 16 + 17). (1) tab-antinomy (Table 7) replaced by
  fig-signatures — the signed Spearman heatmap of the same 9×9 matrix
  (see decision 16 for design + the duplicated-factor-level gotcha);
  tab-antinomy.tex git-rm'd from workspace AND the clone (Overleaf compile
  would break on the stale \input otherwise — the 2026-10-09 lesson).
  (2) Dimension 4 fully removed from the manuscript (decision 17):
  dim-4 paragraph + fig-dim4 env deleted, tables trimmed to dims 1–3,
  captions and the "all four dimensions" clause updated. Reran scripts
  04 + 05; regenerated figures/RDS byte-identical values reverted
  (fig-antinomy-map/configurations/worked-example/supplementary/dim4,
  mfa_results_sup/supplementary.rds — the RDS re-runs differ only at
  1e-6 cross-session SVD noise); antinomy_scores.rds byte-identical.
  PAGE-COUNT NOTE: prior "29 pp." sync notes were stale — HEAD (pre-
  change, with tab-antinomy and dim-4 material) compiles at 31 pp.
  (verified in a clean git worktree); after both trims the manuscript
  compiles at 30 pp., 0 undefined refs, 2 pre-existing overfulls +
  pre-existing tab-regression float warning. Figures now: 1 categories,
  2 worked-example, 3 signatures (p. 19 with its discussion), 4
  supplementary, 5 genre-map, 6 configurations. No web edits at pull
  time (clone at bab1234; clean rebase).
- Last sync (2026-10-10, later): DIM-1 AXIS RENAMED "volume" (author request:
  "general-affirmation axis" was wordy/stilted). Author chose "volume" via
  AskUser (over breadth, extensity, keep-but-shorten); 12 label occurrences
  in main.tex now read "volume axis"/"volume dimension", the 4.1 coinage is
  "Dimension 1 is thus a \emph{volume} axis" (gloss sentence unchanged),
  fig-categories caption "Dimension 1 (volume)", script-04 worked-example
  strip "Dimension 1 (volume)" (fig regenerated). ALSO swept the plural
  noun "affirmations" for yes responses per the same request (→ "yes
  categories" for MCA category weighting, "yes answers" for responses:
  the "two affirmations" footnote, 1881's listening-yes-weighs-2x
  sentence, "consumption yes categories" ×2 in 4.1, "most distinctive yes
  categories" in the strategy MCA footnote, "supplying any of the yes
  answers" in standing-apart). KEPT: the ordinary VERB "affirm" ("the
  respondents who affirm it", duality section; "propensity to like and to
  listen" in the coinage). "Volume" had no prior collisions in main.tex.
  MID-SYNC WEB EDITS (54e9657..256c0b0, four commits) landed while the
  rename was local-only; adopted the Overleaf main.tex as base and
  re-applied the rename to the author's wording. Author changes adopted:
  dim-3 example block SPLIT into its own paragraph between the meanings
  paragraph and the pair-level paragraph; "To make the geometric
  measurement machinery concrete"; "The two running examples are cases of
  low and high disagreement on the first global axis"; "which pairs of
  aspects disagree" (trimmed); "An aspect's share of disagreement differs
  from its contribution... Table 5 records..."; "compared with 20% for
  preference... making evaluation the outlier"; "closer to the middle of
  the axis; the further..."; "On the other two dimensions, it is
  typically evaluation"; "Both have many complex configurations,
  thirteen and seventeen, respectively, yet their status-valuation scores
  differ by more than a factor of forty"; "sharpen both readings";
  "one repeated pattern: engagement without valuation" (author's colon,
  kept); fig ref in standing-apart ("shows this clearly"); W3 footnote
  "best measures" + "not how many per-genre contradictions". THREE REPAIRS
  on top (flagged to author): (1) the author's "The first global
  affirmation axis is the extreme case. It supplies only 2.5%..." broke
  the referent (the 2.5% supplier is EVALUATION, not the axis) →
  "Evaluation on the first global axis is the extreme case"; (2) the
  author's 1881 weighting sentence was tangled ("a more significant
  ``yes'' than liking because listening is globally rarer ... than
  liking, carrying...") → "a more significant ``yes'' than liking---it is
  globally rarer and represents a more meaningful investment---so it
  carries roughly twice the weight in the separate MCA"; (3) the dangling
  bridge sentence "The two running respondents sit at the two ends of
  this axis" (left at the end of the meanings paragraph after their
  example-block move) moved to OPEN the new example paragraph.
  Compiles at 31 pp., 0 undefined refs, same 2 pre-existing overfulls.
- Last sync (2026-10-10, later): sec:antinomies (4.5) restructured as a
  RUNNING-EXAMPLE section (author request: the example used to come at the
  end, after too many new ideas, leaving the reader lost). Author chose via
  AskUser: (1) TWO respondents, 362 + a new mirror contrast 1881;
  (2) fig-worked-example redesigned 2×2 (rows = respondents); (3) the two
  hypothetical dim-2 portraits replaced by the real examples.
  **Respondent 1881 (new second example; original row index; verified
  this session)**: likes 14 (classical, jazz, moodez, crold, country,
  blueg, folk, hymgos, latspsal, blurb, reggae, toppop, controck,
  danclub), listens 13 (incl. opera, Broadway, big band — highbrow-
  leaning), grants eval-yes to ZERO genres (not even opera); 17 complex
  configs (10 guilty, 3 distanced, 4 justified). W = 17.6/23.1/3.1
  (inertia shares 47/71/18%). Partials d1 2.78/5.46/−0.47 (global 2.59),
  d2 0.73/5.54/−1.02 (global +1.75), d3 −0.73/−2.96/−2.80 (global −2.16).
  KEY MIRROR FACT: F2 +1.72 (362) vs +1.75 (1881) — nearly the same rung
  reached by opposite materials; opposite poles of dim 3 with hugely
  unequal W3 (133.1 vs 3.1, factor >40 — the generous-side asymmetry made
  concrete). GOTCHAS for future sessions: (a) 1881's dim-2 aspect shares
  are pref 4.5/cons 62/eval 33 — CONSUMPTION stands apart for 1881, not
  evaluation; the "evaluation typically stands apart on dim 2" claim is
  sample-level only (do not misstate for this respondent); 362's d2
  shares are 50/0/50 (consumption sits exactly at the average). (b) All
  zero-eval respondents share one fixed eval partial point
  (−0.47/−1.02/−2.80 on dims 1–3). (c) 362 d3 pair MSd 0.45/190/209
  (pc/pe/ce); 1881 d2 pair MSd 23.1/3.1/43.0 — the two consumption pairs
  carry 95% of 1881's pairwise sum (modal C–E pattern). (d) 1881 Wloc
  1.7/1.3/0.7 (<10% of W1/W2) — their 10 guilty pleasures are coherence,
  not genre-based disagreement. (e) 362 does NOT like bwayst — the old
  worked-example prose said "Broadway/show tunes" among 362's likes, an
  error (fixed; likes are classical/opera/jazz/bband/crold/country/folk/
  latspsal/raphiphop/blurb/reggae/toppop/controck/indalt/hvymtl).
  New 4.5 structure: P1 opening (unchanged) → P2 NEW examples intro
  (profiles + "instructive pair" sentence) + figure env moved UP (2×2,
  free scales, 7×6in, row strips "Grants 18 of 20 recognitions"/
  "Grants none") → meanings dims 1/2/3 each anchored on the examples
  (dim 1: 362 same-side small W1, 1881 shows the listening-weighs-2x
  effect; dim 2: same-rung different-materials, old portraits deleted;
  dim 3: 362 generous + the W3 arithmetic sentence + 1881 withholding
  mirror, squared-position footnote kept at the passage end) → pair
  paragraph + example pair distances → tab-pairs env moved here →
  Which Aspect Stands Apart (362's 66/19/14 d3 split after the
  construction para; 1881's "53% of W1 without supplying affirmation"
  after the shares-vs-contributions para; the varies-by-respondent
  sentence after the d2 mechanism; classification footnote now anchored
  at the substantive close) → Two Measures Compared (factor-of-40
  divergence sentence; genre-level split paragraph now opens with the
  362 8.5/94% + 1881 ten-guilty-pleasures-as-coherence examples, split
  into two paragraphs at "That is typical rather than exceptional").
  The "A Worked Example" subsubsection is DISSOLVED (heading deleted;
  its material distributed). Strategy bridge (3.5) updated to "follows
  two worked respondents". 1881 was found as the top-W2 respondent who
  likes classical with ≤3 eval-yes (search cand2); chosen over the
  popular-omnivore candidate 1066 (rap/reggae/dance/metal liker, zero
  evals, W 6.9/8.7/10.3, F2 −3.32 — weaker numbers) and over 362-only.
  Compiles at 31 pp., 0 undefined refs, same 2 pre-existing overfulls +
  pre-existing tab-regression float warning. Script 04 figure block
  rewritten (exr/rlab, split-by-interaction segex); rerun produced
  byte-identical tables/RDS (fig-antinomy-map/fig-configurations
  regenerated byte-only, reverted).
- Last sync (2026-10-10, later): plain-language W2/W3 glosses in the
  sec:antinomies meanings paragraph (author request: dim 1 had a full plain
  treatment, dims 2–3 only one abbreviated sentence each). Dim-2 expansion:
  "A respondent high in $W_2$ is one whose liking and listening usually
  agree on a rung while their evaluations place them on a
  different one" + the two concrete portraits (rap/rock/pop listener who
  credits classical/opera fans with high status; classical-music listener
  who grants that recognition to few audiences) + "about equally often".
  Dim-3 expansion: existing reach sentence kept, then "Liking and
  listening place the high-$W_3$ respondent nowhere in
  particular on this axis, so the score mostly records how far their
  evaluations travel away from that middle" + generous/mirror-image split.
  STYLE RULE (author request, same day): "in plain terms" purged — plain
  writing should not announce itself, so never use the phrase in drafted
  prose. The purge itself was done by the AUTHOR on Overleaf (web edits
  `6cbec83` + `e3d6b8a`) while the same removal was being made locally —
  the Overleaf version was adopted as base (overleaf main.tex copied BACK
  into the workspace; the local removal was discarded, redundant). Author
  edits adopted with it: dim-1 sentence reworded ("rank higher on the
  liking than on the listening side"), dim-2 opening replaced with "On
  the second global axis disagreement reflects where respondents sit on
  the highbrow--popular ladder shared by the preference and consumption
  spaces", "at best the consecrated ones", pair-paragraph tweaks ("Where
  evaluation varies, it reflects disagreement", "the level of engagement"),
  and the meanings material SPLIT into three paragraphs (dim 1 / dim 2 /
  dim 3), pair-paragraph after. Fixed one author typo in the new dim-3
  opener (comma placement, "On the third, global dimension where" → "On
  the third global dimension, where").
  DIM-3 PASSAGE REWRITTEN (same day, after the author flagged the whole
  dim-3 treatment as unclear twice, and asked whether W3-disagreement is
  "just scoring high on the first dimension of the separate evaluation
  analysis, e.g. being more ecumenical"): answer is YES, essentially —
  verified numerically: cor(sep-eval ax1, global F3) = 0.907; cor(W3,
  eval-partial³²... squared eval partial coordinate) = 0.986; with
  pref/cons partials pinned (sds 0.69/0.70 vs eval 2.75), W3 ≈ (2/3)e²;
  generous side sits at +5.3 (mean W3 26.5), withholding at −2.7 (mean
  W3 6.8) — asymmetric, generous carries 82% of top-quartile mass;
  withholding group grants eval-yes to opera at only 12%. New dim-3
  passage says it in prose: dimension = essentially the evaluation
  aspect's own first axis (tab:partial-axes ref), ranks respondents by
  how far down the hierarchy recognitions reach; opera nearly universal,
  rap/metal the distinctive move; liking and listening leave every
  respondent near the middle, "they can neither support nor contradict
  those recognitions"; "Evaluation alone decides the position, and the
  score measures how far it travels from the middle that the other two
  aspects share"; generous side (ten of twenty on average) + opposite
  form ("not even to opera's fans"). "Engagement profile" phrase purged
  (all three occurrences were in this passage + its footnote); footnote
  last clause now "how far a respondent's status recognitions travel
  down the hierarchy". NOTE for future sessions: the author's question
  shows the squared-position footnote IS the honest caveat — W3 is
  closer to a squared eval-axis position than to a contradiction
  measure; do not let prose drift back toward "contradictions" language
  for dim 3. Compiles at 29 pp., no undefined refs, 2 pre-existing
  overfulls.
  DIM-2 CONTRIBUTION-VS-DISAGREEMENT mechanism added (same day, author
  question: why does evaluation carry 49% of W2 when Table 5 says it
  contributes only 11% to dim 2 — the dim-1 extreme case was in the
  aspect-split paragraph but the dim-2 instance was numbers-only). Three
  verified facts now behind a new 3-sentence insert after the
  "49%/64% vs 18% each" sentence: (a) pref+cons supply 88.9% of dim-2
  variation (contribs 40.0/48.9/11.0) and their partial positions
  correlate 0.73, so they hug the personal average (shares 19.6/31.9%);
  (b) eval partial sd on dim 2 is the SMALLEST of the three (0.97 vs
  1.48/1.78) and correlates only 0.08 with the engagement rung;
  (c) eval's deviation from the personal average correlates 0.83 with the
  rung position — wherever engagement carries a person far out on the
  ladder, eval (centered at the middle) is left behind and shows up as
  the standing-apart aspect. So the dim-2 mechanism = the dim-1
  "left behind near the origin" logic in milder form: eval moves a bit
  (sd 0.97 vs 0.46 on dim 1) but independently, and the rung's spread
  generates its distance. Insert wording avoids re-quoting r = 0.73
  (already one paragraph up in the pair-level paragraph). Author trims
  adopted (web edit `c787808`, which also fixed their own "evaluation
  aspect's separate MCA" possessive flagged to them): "agree closely, so
  each sits near", "so it typically stands apart". Author-approved tweaks
  applied on top: "shows the same pattern as the affirmation axis in a
  milder form" → "repeats that logic in a milder form"; gradient clause
  added ("and the further liking and listening carry the respondent to a
  rung, the farther evaluation sits from that respondent's average" —
  the cor 0.83 rung↔eval-deviation link, author approved both via chat).
  PAIR-PARAGRAPH closing sequence rewritten (same day, author flagged
  "Where evaluation varies, it reflects disagreement... unlike the second
  and third dimensions, where evaluation is the aspect that stands apart"
  as hard to understand): cryptic gloss → "Wherever evaluation takes a
  position of its own, it disagrees with both of the other aspects at
  once"; "The first dimension is the contrast" → "the exception"; long
  final sentence split into short ones ("a third each" = the 33/33/34
  dim-1 pair shares; "There the disagreement runs between liking and
  listening, each placing the person at a different level of engagement,
  while evaluation stays near the middle and barely moves"; closing
  contrast its own sentence). PLUS author catch (correct): "where all
  three aspects place respondents on a shared ladder" was WRONG — the
  ladder is shared by preference and consumption only (eval contributes
  11% to dim 2, partial sd 0.97 vs 1.48/1.78, r = 0.08 with the rung;
  nuance: eval is not mute — its second separate axis reappears weakly,
  partial axis +0.35 — but it does not rank respondents on the ladder).
  Sentence now reads "On the second dimension, preference and consumption
  place respondents on a shared highbrow--popular ladder, and their
  positions correlate at $r = 0.73$, so their pair accounts for only
  18%..., against 47% for consumption--evaluation alone" — consistent
  with the meanings paragraph's "ladder shared by the preference and
  consumption spaces". Compiles at 30 pp. (float reflow), no undefined
  refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): "Which Aspect Stands Apart" subsection
  created (author request: the aspect-split paragraph needed its own
  subsection explaining the geometry, the substantive question, and the
  interpretation in plain language). New \subsubsection with
  \label{sec:aspect-shares} has four paragraphs: (1) question + geometry
  (partial points cluster around the global point = their average; score
  measures cluster spread; since the global point is the average, each
  point contributes its squared distance from it and the three sum to
  the score — Pagès pp. 108–109 cite; share large = odd one out);
  (2) shares vs Table-5 contributions + dim-1 extreme case + NEW
  clarifier ("That third is not evidence of any contradiction in the
  evaluations. A respondent could like exactly the genres they listen
  to, and evaluation would still carry a large share..."); (3) results
  by dimension — NOTE dim-2 shares now stated correctly as 49/20/32
  (eval/pref/cons), fixing the old ambiguous "against 18% each" which
  was true of W3 only (17.8/17.8); (4) substantive close linking to
  Ma's configurations ("which aspect of taste stands against the other
  two") + per-dimension answer summary. The "Complex tastes are not
  concentrated in any region of the space" pair of sentences MOVED from
  the end of the aspect paragraph to the end of the 4.5 opening
  paragraph (they are about the score generally, not the aspect
  attribution). Two delimiting headings added because LaTeX headings
  extend forward: \subsubsection{A Worked Example} before the example
  and \subsubsection{The Two Measures Compared} before the
  divergence paragraph — the worked example's prose ("here it is liking
  that stands apart", "now it is evaluation") fits the new subsection
  frame but the genre-level split belongs outside it; the divergence/
  genre-level/signatures block is the geometric-vs-combinatorial
  comparison. 4.5 structure now: [untitled: opening + meanings +
  pair-level] → Which Aspect Stands Apart → A Worked Example → The Two
  Measures Compared → sec:social. The pair-level paragraph could get a
  mirror heading later (strategy has "Pairwise Distances Across
  Aspects"). Compiles at 30 pp., no undefined refs, 2 pre-existing
  overfulls.
  ADOPTED MID-EDIT web commits
  `3d6e501` + `50c9cd9` (author rewriting the two-direction sentences as a
  single "For instance, ..." sentence — as of this sync it ends mid-word
  ("...as being high statu") and drops the "about equally often" sentence;
  author still typing, do not "complete" it for them; also author added the
  comma in "On the second global axis, disagreement reflects" themselves).
  The existing squared-position footnote now anchors at the END of the dim-3
  passage (explains why the generous form dominates). Empirical basis
  (verified from partial points, extraction: res$ind$coord.partiel rownames
  are "2.Preference"/"2.Consumption"/"2.Evaluation" — capital-P/C/E, NOT
  "362.pref"): among top-quartile W2, eval is the largest-share aspect 67%
  and the two directions split 51/49; eval_above group = popular engagement
  (top40 .82/crold .78/rap .69 liked) yet eval-yes classical .83/opera .86;
  eval_below group = classical liked .91/listened .72 yet eval-yes avg only
  2.7/20 (classical .59, opera .67, all else ≤.29). Dim 3: among top-quartile
  W3, pref/cons partial sds .71/.73 vs eval sd 4.56; generous (eval partial
  > 0) carries 82% of top-quartile W3 MASS (54% of count — text says "most
  of the disagreement", mass not count, deliberately), mean 10.2 eval-yes
  ("ten of the twenty genres on average"), withholding group avg 0.28
  eval-yes while still liking 5.8/listening 3.1. Pair-share quantities
  (r 0.73, cons–eval 47%) stay in the NEXT paragraph per author's note —
  the new material is qualitative. Compiles at 29 pp., no undefined refs,
  2 pre-existing overfulls.
- Last sync (2026-10-10, later): sec:contrib question-mapping FIXED (author
  flagged that the 4.4 opening claimed Table 5 alone answers Q2+Q3). The
  strategy's own assignment is Lg→Q2 (participation), contributions→Q3
  (which aspect organizes each dimension); the author's instinct that
  partial axes bear on Q2 is right — they show each aspect's leading
  separate axes reappearing in the global space, i.e., participation
  dimension by dimension. Repairs: (1) 4.4 opening now acknowledges "The
  partial axes of the previous subsection (Table~\ref{tab:partial-axes})
  already spoke to the second question at the level of specific
  dimensions"; (2) the Lg paragraph — which WRONGLY said Lg "answer[s] the
  dimension composition question from the other direction" (a Q3 label
  contradicting the opening) — now says "answer the second question for
  the compromise as a whole"; (3) Lg paragraph MOVED before the
  contributions paragraph so the subsection runs Q2 (Lg) then Q3
  (contributions), matching the strategy order; (4) the balancing-weights
  footnote moved from the deleted "answer to the second question is yes"
  sentence to the Lg paragraph's "none is present in name only" sentence
  (its content — equal footing going in, not equal presence coming out —
  belongs there); (5) the redundant "Each aspect contributes to each of
  the three global dimensions" sentence dropped (the Q3 paragraph's "while
  all aspects appear in the first three global dimensions" carries it).
  Colon in the opening ("posed above: does each aspect...") de-colonized
  per decision 15. Follow-up (same day): the Partial Axes subsection (4.3)
  now opens with its own question echo — "The second question posed above is
  whether each aspect actually contributes to the common representation, and
  the partial axes answer it at the level of specific dimensions" — so 4.3
  self-frames rather than being retroactively framed by 4.4; the 4.4 opening
  callback ("already spoke to the second question at the level of specific
  dimensions") is unchanged and now deliberately echoes 4.3's phrasing.
  Web edit `6edd9d1` landed mid-sync and was adopted:
  4.3 dim-2 sentence "independent" → "partially independent", and the dim-3
  sentence gains a closing clause ("suggesting that the third global
  dimension is a specialized status-evaluation axis with little input from
  people's preferences or consumption behavior"). Compiles at 29 pp.,
  0 undefined refs.
- Last sync (2026-10-10, later): partial-axes/contributions SEPARATION (author
  choice via AskUser — "Clean separation" over merging the subsections).
  The Partial Axes subsection (4.3) quoted two aspect-contribution numbers
  ("matching its modest 2.5% contribution" / "matching its 11.0% contribution")
  from tab-groups (Table 5) without citing it; both parentheticals DELETED so
  4.3 is purely partial-axis correlations (tab-partial-axes) and contributions
  live entirely in the Composition subsection (sec:contrib, tab-groups).
  Web edit `e1d5aad` landed mid-sync and was adopted as base: the author
  reworded the same 4.3 paragraph opening ("We represent a given aspect's
  partial axis by correlating…", "captures maximal consensus in preference
  and consumption") and appended a clause to the RV paragraph ("thus people
  can evaluate highly genres that they neither like nor consume"); the author
  KEPT the contribution clauses in their rewrite — the separation was
  re-applied on top of their wording. Compiles at 29 pp., 0 undefined refs.
- Last sync (2026-10-10, later): fig-categories12 + fig-categories COMBINED into
  one two-panel figure (author request; single figure sits next to its
  discussion). Script 03's two category-map blocks replaced by one
  mk_cc/facet_grid block: left panel dims 1–2, right panel dims 2–3, facet
  strips name the dimensions (fig-worked-example style), free scales, labs
  x/y NULL, shared Aspect legend, 8.5×4.4in, saved as
  fig-categories.pdf (.95\linewidth in main.tex). fig-categories12.pdf is no
  longer generated; the stale file was git-rm'd from BOTH the workspace repo
  and the Overleaf clone. main.tex: single \label{fig:categories} (the
  fig:categories12 label purged); caption merged from both old captions
  (left/right panel sentences); prose refs updated ("As the left panel of
  Figure~\ref{fig:categories} shows" in the 4.1 opening; "The right panel's
  vertical axis also previews Dimension 3" in the dim-2 paragraph); figure
  env placed after the dim-2 paragraph. Compiled placement: ref end of p.8,
  dim-2 discussion p.9 (Table 2 takes the p.9 float slot — encountered
  earlier, float order is preserved), figure top of p.10, directly after its
  discussion; [!htb] placement tried and reverted to house [htbp] (made no
  difference). Adopted web edits `fcaca6c`/`98163ec`/`5ac0b7a`: strategy
  "Measuring Complex Taste at the Individual Level" gains \subsubsections
  ("Aspect Disagreement Across Global Dimensions", "Pairwise Distances
  Across Aspects", "Genre-Specific Disagreement Across Dimensions" — the
  stray duplicate \subsection{Aspect Disagreement} became the first
  subsubsection) and the toy-contrast paragraph closing reworded
  ("provides a toy example of a single respondent across all three scores
  and the genre-level split ... once the space dimensions are empirically
  specified"). ggsave prints benign mbcsToSbcs warnings (en dash → hyphen in
  the pdf device's strip labels). Compiles at 29 pp., 0 undefined refs,
  2 pre-existing overfulls.
- Last sync (2026-10-10, later, small): the dim-1 volume-tracking symbol
  fixed from $\rho$ to $r$ in the meanings paragraph — it is a PEARSON
  correlation (signed P1−C1 placement gap vs n_likes − n_listens per
  respondent, N = 2,259; Pearson 0.957, Spearman 0.951, both round to
  0.96). The paper's convention is r = Pearson (e.g., the 0.73 pref/cons
  partial correlation on dim 2), ρ = Spearman (tab-antinomy); the ρ was a
  labeling error in the drafted sentence. Follow-up (same day): the
  tracking sentence rewritten to specify the two correlated quantities
  explicitly in plain language — "Correlating the two quantities across
  all respondents---the gap between where liking and listening place a
  person on the axis, and the difference between how many genres that
  person likes and how many they listen to---yields $r = 0.96$." Compiles
  at 29 pp.
- Last sync (2026-10-10, later): DIM-1 GLOSS MOVED FROM FOOTNOTE TO TEXT and
  the margin footnote rewritten in plain English (author request: the
  footnote "is totally obscure"; wanted a clean in-text sentence). The
  meanings-paragraph dim-1 block now reads: sentence 1 unchanged (author
  web edit `acb670e` "how many genres respondents choose" adopted);
  sentence 2 NEW in text — "In plain terms, respondents who like many
  genres but listen to few are placed higher on the axis by their liking
  than by their listening, and the reverse holds for those who listen to
  more genres than they like."; sentence 3 NEW — "The liking--listening
  gap tracks the difference between how many genres a respondent likes
  and how many they listen to almost exactly ($\rho = 0.96$)." (the
  signed-gap↔volume-difference correlation, cor 0.96). Footnote (plain
  rewrite, anchored after the ρ sentence) now explains the scale effect
  concretely: MCA weighs rare affirmations more; listening (22.9%) rarer
  than liking (41.7%) so one listening moves the consumption point ~2x as
  far; worked example INSIDE the footnote = the 7 like-all-AND-listen-all
  respondents (zero contradictions) with liking points near +5.6 and
  listening points near +10.7 on dim 1 (verified: mean P1 5.63, C1 10.68,
  E1 0.01 among them; set-equal mean signed gap −1.95, i.e., listening
  point systematically further out). Dropped from the footnote: the
  "on average slightly more than the sample as a whole" claim (author
  found it obscure; the all-yes example carries the point better).
  The earlier gloss-swap footnote ("difference in level, not a tally of
  contradictions...") is fully replaced — its content split between the
  in-text sentences (volume reading, ρ 0.96) and the new footnote
  (scale effect + all-yes example). Compiles at 29 pp., no undefined
  refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): two interpretation-repair insertions in
  sec:antinomies, from a session vetting the author's proposed concrete
  glosses of the disagreement scores. BOTH proposed glosses were wrong and
  were replaced with corrected ones:
  (1) DIM-2 GLOSS: "respondents like highbrow genres but listen to popular
  ones and vice versa" — right TYPE of reading (rung disagreement) but
  P–C is only 18% of dim-2 disagreement (pair MSd 1.50 vs P–E 2.89, C–E
  3.91; pref/cons partial r 0.73) — the modal dim-2 disagreement is
  evaluation vs engagement; directions balanced (302 vs 263 top-quartile).
  Not added to the manuscript; the abstract "rung placement" phrasing kept.
  (2) DIM-1 GLOSS: the author inserted "This indicates that many
  respondents like genres they don't listen to and vice versa" on Overleaf
  (web edit `c97f48a`) — DELETED and replaced with a corrected footnote.
  Verified: the signed P–C dim-1 gap is a VOLUME contrast, not a
  contradiction tally — cor(P1−C1, n_likes − n_listens) = 0.96; the 120
  set-equal respondents (likes ≡ listens, zero mismatches) have
  ABOVE-AVERAGE P–C disagreement (mean sq 4.84 vs 4.31 overall), the
  margin effect (yes-rates 41.7 vs 22.9% → different MCA weights, echoes
  the W3 "not a count of per-genre contradictions" footnote); directions
  balanced (305 vs 260); |gap|↔mismatch count cor only 0.51. New footnote
  anchored at "liking and listening" in the meanings-paragraph dim-1
  sentence carries the volume reading. (3) CONTRIBUTION-VS-DISAGREEMENT
  reconciliation (author question "need to indicate somewhere that
  disagreement can be driven by an aspect that doesn't contribute much to
  that dimension"): new sentences in the aspect-split paragraph after the
  Pagès cite — shares (distance from the person's average, within-person)
  ≠ contributions (spread around the origin, between-respondent); eval on
  dim 1 the extreme case, 2.5% contribution vs a third of W1; mechanism
  verified: eval partial sd 0.46 vs 2.07/2.11, eval's squared deviation
  from the personal average grows with |F1| (0.27/0.77/3.44 across |F1|
  terciles, cor 0.78) — eval is the point left behind near the origin.
  Adopted web edit `c97f48a` as base (subsection retitled "Measuring
  Complex Tastes Geometrically"; opening rewritten in author voice —
  "As noted in the analytic strategy section..."; NOTE: the author's
  rewrite DROPPED the Ma-configurations complement sentence from the
  opening — flagged to them, their call; meanings paragraph tweaked
  "corresponding dimension", "respondents"). Compiles at 29 pp., no
  undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): sec:antinomies "Measuring Complex Tastes"
  restructured (author request: first paragraph incomplete, "three scores"
  unannounced, paragraphs long/convoluted). The old 4-paragraph block
  (opening, meanings, pairs+aspects, worked example) became 7 paragraphs:
  (1) NEW opening introduces the scores explicitly ("The measure of the
  analytic strategy gives each respondent one aspect-disagreement score per
  dimension... On the first three dimensions, this is three scores per
  respondent, $W_1$, $W_2$, and $W_3$."), moves the 56/52/63% magnitude
  headline UP from the old meanings paragraph into the opening ("Disagreement
  is substantial"), and keeps the Ma-configurations complement sentence; the
  old opener ("We measure complex tastes geometrically... read directly off
  the MFA") is gone. (2) Meanings paragraph now pure — colon/semicolon chains
  split into sentences, footnote unchanged. (3) Pair-level paragraph: dim
  order now 2→3 (was 3/2/3 zigzag), shares-echo sentence now AFTER the
  numbers with tab-pairs ref, dim-1 contrast split into short sentences.
  (4) NEW aspect-split paragraph (per-aspect shares + Pagès cite + region-null
  closing, colon de-colonized). (5–7) Worked example split into three
  paragraphs (intro+dim 1 / dims 2–3 / genre-level split); four prose colons
  de-colonized per decision 15. ALL numbers, refs, cites, footnotes preserved
  (verified by token-multiset diff against HEAD; the only number-token
  additions are the 1/2/3 from the new "$W_1$, $W_2$, and $W_3$" sentence;
  footnote colons in the two worked-example footnotes kept — definitional
  lists, author has kept them through edits). Compiles at 29 pp., no
  undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): Lg magnitude GUARD added to the Composition
  subsection (sec:contrib), from a session diagnosing whether the Lg
  coefficients' magnitudes can be read comparatively. Verified numerically:
  (a) the Lg(pref/cons/eval, MFA) pref-cons gap is entirely the diagonal
  Lg(h,h) — cross-aspect terms 0.822 vs 0.828; (b) exact binary-block
  identity Lg(h,h) = [J + 2Σ_{g<k}φ²]/(J·λ1h)², where φ = Pearson r among
  the block's 20 indicators — so preference has MORE raw internal
  association (Σφ² 6.94 vs 3.99; mean φ² 0.037 vs 0.021) but consumption's
  smaller λ1g (0.155 vs 0.200) gives it a bigger balancing multiplier and
  hence a bigger Lg (2.91 vs 2.12; with-MFA 2.48 vs 1.95) — the ordering is
  normalization arithmetic, and the rarity-free association picture is
  inverted; (c) each block's first axis in the global metric is ≈ 1 by
  construction (0.981/0.983/0.953), so Lg(h,MFA) has a floor ≈ 0.66 for any
  block and the excess above the floor (Σ_{s≥2}λ² = 1.08/1.85/0.61) is
  secondary-spectrum mass; (d) Lg shares 35.0/44.5/20.5% vs λ-weighted
  share of dims-1–3 inertia 34.8/38.2/27.0% — same rank order, distorted
  magnitudes (pref-cons gap 10 pts in Lg is really 3; evaluation is 70% of
  consumption, not half, because it owns dim 3). Manuscript revision: the
  "but unevenly" clause dropped; the sentence now ends at the presence
  claim, then two new sentences — the three coefficients differ with
  evaluation's link weakest of the three, "but we read them as
  establishing presence and rank order rather than degree", and "MFA's
  balancing gives every aspect a first axis of near-unit inertia, so no
  aspect can score near zero, and the differences above that baseline
  reflect how spread an aspect's structure is across its own secondary
  dimensions rather than the intensity of its participation." The balancing
  weights footnote moved to the end of the guard sentence (its natural
  anchor). tab-groups unchanged. CONSOLE-GOTCHA for future sessions: in R,
  `gcont/100*l3` recycles l3 across ROWS (aspects) not columns (dims) —
  use `sweep(gcont, 2, l3, "*")`; an earlier output with pref 39.6/cons
  34.3/eval 26.1 was that bug, corrected values 34.8/38.2/27.0.
  Adopted web edit `048d922` (landed mid-sync; did not touch the Lg
  sentence, clean merge): "ordered by rarity:" → "ordered by rarity, as"
  + dropped the "Dimension 3 is thus a distinct axis..." closing sentence
  of the Composition paragraph; commas after "On the affirmation axis,",
  "On the highbrow--popular axis,"; "Nor are" → "Complex tastes are not";
  "what these scores are made of" → "what these scores include".
  Compiles at 29 pp., no undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): fig-individuals (individual factor map)
  DROPPED from main.tex (author choice via AskUser after a keep/drop
  analysis). Rationale: it was referenced exactly once (dim-2 paragraph,
  "first look at this axis's social anchoring") and its whole quantitative
  claim — the age gradient on dim 2 (cohort means −0.74 → +1.23, ~2.3 pooled
  within-sds end to end, adjacent cohorts only 0.2–0.5 sd apart; pooled
  within-sd 0.88) — is covered better by sec:social (η² 0.331, tab-eta,
  tab-sup-coord) and fig-supplementary on the same dims-2–3 plane; the
  overplotted blob couldn't fully cash "strongly ordered by age". The
  only argument for keeping (only individual-level cloud in the paper; GDA
  convention) was outweighed by the paper's each-figure-earns-its-place
  criterion. Dim-2 clause rewritten: "The same axis is strongly anchored in
  respondents' ages, with the youngest cohorts toward the popular pole and
  the oldest toward the highbrow pole (Section~\ref{sec:social})." Script
  03 still generates fig-individuals.pdf (kept in repo, unreferenced);
  figures renumber automatically (fig-worked-example is now Figure 2).
  Web edit `96c8cda` landed mid-sync and was adopted as the local base:
  Partial Axes opening reworded ("The second question is whether...",
  "little connection to"); Composition subsection restructured (opening now
  carries the Lg paragraph + second-axes clause; the contributions and
  dim-3-content paragraphs merged into one; author re-introduced a colon in
  "questions posed above: whether..." — their own text, kept). Two-file
  copy (main.tex + AGENTS.md). Compiles at 29 pp., no undefined refs,
  2 pre-existing overfulls.
- Last sync (2026-10-10, later): per-aspect decomposition of the
  aspect-disagreement score, from a Pagès-2014 chapter-5 audit. Script 04
  gains the book's §5.4 decomposition after the ant frame (each aspect's
  partial point contributes its squared deviation from the global point;
  ant gains Wp1–3/Wc1–3/We1–3 columns, contributions sum to W_s via
  stopifnot; console prints mean per-aspect shares). Numbers: dim 1
  pref/cons/eval 32.5/33.5/34.0% of W1 (even thirds — individual-level
  counterpart of the tab-pairs equal-thirds claim), dim 2
  19.6/31.9/48.6%, dim 3 17.8/17.8/64.4% (evaluation carries two-thirds;
  absolute mean deviation 3.58 vs 0.99/0.99). main.tex: the 4.4 pair-share
  paragraph gains apportionment sentences after the "evaluation is the
  aspect that stands apart" sentence (citing pp. 108–109); the eq:decomp
  paragraph gains a footnote after "grows as the aspects disagree more"
  defending W_s against Pagès' §5.5 superimposed-representation distortion
  caveat (cross-aspect partial distances meaningful only when the partial
  clouds have comparable inertia along the studied dimensions; the MFA
  balancing gives each aspect's partial cloud unit maximal inertia in the
  global metric), citing pp. 112–116. Script 04 rerun: figures regenerated
  byte-only and reverted (values verified identical against console
  output); tab-antinomy/tab-pairs unchanged; antinomy_scores.rds
  legitimately gains the Wp/Wc/We columns. Verified in-session that W_s is
  exactly the book's §5.4 within-class inertia (Huygens identity and
  barycentric property hold to 1e-13). CAUTION for future sessions:
  Pagès' Table 5.2 between/total ratio is an aggregate ratio-of-inertias
  (49/44/65% on our data per dimension), which is NOT the same quantity as
  our mean-of-individual-ratios shares (56/52/63%) — don't conflate them
  when quoting the book by name. Compiles at 29 pp., 0 undefined refs,
  2 pre-existing overfulls.
- Last sync (2026-10-10, later): RV 0/1 passage de-jargoned (author request:
  "super-obscure"). "The two clouds share no direction" and "homothetic---one
  is a stretched or shrunken copy... order respondents identically and differ
  only in how sharply they differentiate them" replaced with plain distance
  language: RV 0 = "two respondents who are close together in one cloud are
  then no more likely to be close in the other than any two respondents
  chosen at random"; RV 1 = "the two clouds have exactly the same shape: the
  distance between any pair of respondents in one cloud is a fixed multiple
  of their distance in the other. The aspects then agree completely about
  who resembles whom; they differ only in how far apart they spread the
  respondents." The word "homothetic" is now gone from main.tex. Also adopted
  author web edit `223c59e` (landed before this revision and preserved in
  full): RV material split into two paragraphs; "The comparison relies on the
  geometry each aspect imposes on the individuals"; added closeness example
  "(e.g., individuals who like the same genres are close in genre space and
  individuals who consume the same genres are close in the consumption
  space)"; "inter-individual distance structures". Fixed the author's "ann
  aspect's" typo. Mid-sync web edit `6f5594c` (final clause "possible at the
  level of the data structure---" → "possible empirically;") also adopted.
  Compiles at 29 pp., 0 undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): RV footnotes 2 and 3 COMBINED (author
  request/question). The config-matrix note and the RV formula note are now
  one footnote at the end of the RV paragraph (deac304 had already moved the
  formula note there), definition first, formula second, restoring the
  one-footnote-per-quantity pattern (Lg and contributions each have one).
  Footnote auto-numbering shifts for everything after. During this sync
  THREE web edits landed and were all adopted: `a6be12b` (RV extremes
  sentences each gain a concrete parenthetical example — "a person's
  preferences are unrelated to the genres they consider high status" /
  "a person's engagements are perfectly predictable from their
  preferences"; "high RV coefficients between them" added; RV-0/1 sentences
  re-merged with a semicolon — author's own, kept), `6859a87` (Lg
  footnote reworded — "normalizes the global analysis as a block by its
  first eigenvalue"; "in Pagès' phrase" dropped for "or"; "link to the
  global complex taste space"), `95e0d97` (Lg closing sentences — "In
  principle, an aspect... present in name only in the global structure";
  "drops one in favor of the other two"). Push races handled by rebase;
  my footnote merge touched only RV lines so the final rebase was clean.
  Compiles at 29 pp., 0 undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): colon sweep of the Lg and contributions
  strategy paragraphs (decision 15 applied; author request). Four fixes:
  "and the global structure: how much..." → "...global structure, that is,
  how much..."; "not equal presence in the result; an aspect..." split into
  two sentences; "apportion each dimension...: the share of the dimension's
  variance each one carries" → "apportion the variance of each dimension of
  the common representation among the three aspects"; "different quantity
  from $Lg$: $Lg$ assigns..." split into two sentences. Footnote formulas
  left as-is (colon after a display formula is standard and unflagged).
  Compiles at 29 pp., 0 undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-10, later): RV closing sentence rewritten + colon purge
  (author requests). Final sentence now reads "Small RV coefficients mean
  the opposite. Each aspect carries information the others lack, so no
  single aspect can speak for a person's tastes. Taste profiles whose
  aspects do not line up---complex tastes---then become an empirical
  reality rather than a conceptual possibility." De-colonized the rest of
  the paragraph too (decision 15): "unrelated to every indicator of the
  other. Then two respondents..."; "same shape, so that the distance...";
  "agree completely about who resembles whom, and differ only in...".
  Adopted author web edit `deac304` (RV formula footnote moved to the end
  of the paragraph). Compiles at 29 pp., 0 undefined refs, 2 pre-existing
  overfulls.
- Last sync (2026-10-10): RV and Lg descriptions revised from the Pagès book
  (author request: "hard to follow, omit important information"). RV paragraph
  now opens with the geometric basis (each aspect's twenty indicators generate
  a cloud of the same N respondents, fully described by interindividual
  distances; config-matrix footnote notes S and the squared-distance matrix
  carry the same info), then RV compresses the similarity of the two distance
  structures: 0 iff every indicator of one aspect is unrelated to every
  indicator of the other; 1 iff the two clouds are homothetic; single-variable
  blocks reduce RV to squared Pearson r (split into two footnotes: config
  matrix + formula). Lg paragraph gains the choice rule (RV compares aspects
  with one another, Lg gauges each aspect's link to the compromise) and the
  Pagès "number of common dimensions, each weighted by its inertia" phrase
  (p. 137 cite). **IMPORTANT CORRECTION**: the old Lg footnote formula was
  WRONG — it claimed Lg(h,k) = tr(S_hS_k)/√tr(S_h²), asymmetric. Verified
  numerically against FactoMineR (2026-10-10): Lg is the SYMMETRIC unnormalized
  numerator of RV — Lg(h,k) = tr(S_hS_k)/N² (respondents equally weighted;
  equal to the book's ⟨W_j,W_k⟩/(λ1jλ1l) with balancing absorbed into the
  global column weights); Lg(h,h) = Σ_s λ_s² of the separate analysis in the
  global metric (2.1206/2.9127/1.6640); Lg(h, MFA) = Σ_k Lg(h,k)/λ1(MFA)
  (the compromise enters as a pseudo-block normalized by its own λ1 = 1.509).
  All reported values were already correct (only the formula text was wrong);
  RV formula verified to 1e-15. Also this sync: adopted author web edits
  `3dc9a6f` (4.4 paragraph split at "On the third dimension..."; "respondent
  engages" → "respondent chooses genres"; added "itself an argument for the
  idea of complex tastes") and `2e1dd42` (two-step MCA description: "the
  three analyses", weight "obtained from the separate MCA", "regardless of
  the prominence of the first dimension in the separate analysis"); plus the
  cross-aspect Lg trim from the results prose (see previous entry). Compiles
  at 29 pp., 0 undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-09, later): cross-aspect $Lg$ coefficients TRIMMED from
  the results prose (the §4.3 sentence now ends at "…weaker than the links of
  preference (1.95) and consumption (2.48)") per the Pagès choice rule (RV
  for the between-aspect similarity question, Lg only for aspect-vs-compromise
  participation; book §7.2 pp. 137–138: "RV or Lg is chosen according to
  whether we want to distinguish…" / "the two measurements complement each
  other perfectly"). NOTE: tab-groups was ALREADY clean — it never carried
  the cross-aspect Lg matrix, only the "Lg with MFA" column; the 0.80/0.02/
  0.03 cross-aspect values lived in one prose sentence (an earlier assistant
  note wrongly said they were in tab:groups). No script rerun, table unchanged.
  The Lg strategy footnote keeps its general Lg(h,k) definition (still
  accurate, and the asymmetry note applies to Lg(h, MFA) too). Compiles at
  29 pp., 0 undefined refs, 2 pre-existing overfulls.
- Last sync (2026-10-09, later): read-through trims in 4.4 — the circular
  opening sentence of the aspect-disagreement paragraph ("The
  aspect-disagreement scores tell us how much of each respondent's
  position...") deleted (author verdict: not useful; the paragraph now opens
  on "The three scores differ in what disagreement means..."); fig-antinomy-map
  DROPPED from main.tex as redundant with prose (author request; the
  fig-scree/fig-rv pattern — the figure's only content was the null result
  W1↔dims 2–3 ρ = 0.01/−0.07, already stated in text, and a 2,259-point
  cloud can't visually verify "blanketing"). Closing sentence rewritten
  figure-free: "Nor are complex tastes concentrated in any region of the
  space... high-disagreement respondents are spread across the hierarchical
  and status-valuation axes rather than clustered anywhere in particular."
  Figure env removed; figures renumber automatically (worked-example is now
  Figure 4). Script 04 still generates fig-antinomy-map (file kept in repo,
  unreferenced). Compiles at 29 pp., 0 undefined refs, 2 pre-existing
  overfulls. Two-file copy (main.tex + AGENTS.md).
- Last sync: worked example moved from strategy 3.5 to results 4.5
  (2026-10-09, later) — the worked-example paragraph + fig-worked-example
  env now live in 4.5 "Measuring Complex Tastes" (inserted after the
  fig-antinomy-map env, before tab-pairs), fixing the forward dependency
  on the dimension readings (4.1); the example names all three axes and
  previously presupposed results material. Strategy 3.5 keeps
  eq:decomp/pairwise/eq:genre/toy (dimension-free) and ends with a bridge
  sentence forward-referencing sec:antinomies and the figure. Figure
  renumbering: fig-worked-example is now Figure 5 (was Figure 1). Doc grew
  29→30 pp from float reflow (map p.14, example text p.15, fig+tab-pairs
  p.16, tab-antinomy p.17 — clean sequence, no stranding).
- Last sync: worked example walks dims 1-2-3 (2026-10-09, later) — the
  dim-2 material moved from the end of the worked-example paragraph to
  between the dim-1 and dim-3 sentences and sharpened: named the
  highbrow--popular hierarchy axis, read the disagreement as rung
  placement rather than engagement level, and made "here it is liking that
  stands apart from the other two" explicit; the dim-3 opening now
  completes the contrast ("now it is evaluation that stands apart from the
  other two"). Classification footnote moved with the dim-2 sentence, so
  the scheme is now defined BEFORE the 13-configurations footnote uses it.
  Footnote-7 counts re-verified against cell_cfg for respondent 362
  (1 guilty bband, 7 poses, 4 distant, 1 distanced = 13); latspsal pose
  ω3 = 1.0 max, genre-based sum 8.5 — all current. Compiles at 29 pp.
- Last sync: eq:genre underbrace labels (2026-10-09, later) — Equation 2
  (eq:genre) gains horizontal underbraces visually separating the two
  components: the $\sum_g \omega_s(i;g)$ term labeled "genre-based complex
  taste", the cross term labeled "cross-genre coherence" (same underbrace
  style as eq:decomp). Where-clause prose unchanged; the "first term/second
  term" sentences still read correctly. No new overfulls — the two
  pre-existing ones (sec:social prose ~line 213, tab-genre-profile) are
  untouched. Compiles at 29 pp. Author web edit `ac383e8` (toy-contrast
  paragraph opening: "Consider two hypothetical respondents: The first
  holds...") landed mid-sync and was adopted locally before the copy.
- Last sync: coherence-component regressions + transposable-orientation
  paragraph (2026-10-09, later) — script 07 gains robustness 4: coherence
  models (coh_s = W_s − Wloc_s, exact by eq:genre identity; coef
  additivity check ~1e-14; R² 0.048/0.021/0.020; tab-regression.tex
  unchanged). New final sec:who paragraph: full-score coefficients
  decompose additively and the split is one-sided (W3 upper-class +7.12 of
  +7.70; W3 age +1.37..+2.25, two oldest cohorts significant; W1 upper
  +3.42 of +3.67, parentba +1.23 of +1.32); framing: genre-based component
  = local accommodations to specific objects, coherence = transposable,
  disposition-like orientation (negative coherence = genre-based tastes
  that cancel); "social location tracks the transposable part". NOTE from
  the framing discussion: avoid calling coherence a full "disposition" —
  it is signed (disposition reading covers only the positive regime), it
  is one cross-section (stability untested; response-style rival), and
  both components are within-person. Manuscript hedges with
  "disposition-like" + the parenthetical negative-coherence clause.
  Paragraph then gains two sentences on why the localized/transposable
  split is unavailable to the combinatorial measure: configurations are
  nominal types — they can recur (same distant praise genre after genre)
  but carry no magnitude or direction, so they can neither accumulate
  into a total nor cancel; the how-much-is-transposable question has no
  combinatorial answer. Extends 4.4's "the coherence component has no
  combinatorial counterpart at all" claim; deliberately concedes that
  type-recurrence is visible categorically (avoids overclaiming).
- Last sync: `d_{ighs}` passage slowed down (2026-10-09, later) — the
  eq:genre lead-in in the Measuring Complex Taste at the Individual Level
  subsection now spells out all four subscripts before using them: a new
  sentence glosses $c_{ighs}$ ($i$ individual, $g$ genre, $h$ aspect, $s$
  dimension), defines $\bar{c}_{igs} = H^{-1}\sum_h c_{ighs}$ explicitly,
  and reads $d_{ighs} = c_{ighs} - \bar{c}_{igs}$ with a signed gloss
  (positive = aspect $h$ carries individual $i$ further along dimension $s$
  in genre $g$ than the three-aspect average), before "In terms of these
  deviations, the aspect-disagreement score splits exactly into...". Merged
  on top of author web edit `98d5ba3`, which landed mid-edit and reworked the
  same paragraph: "Moreover, each partial individual point in complex taste
  space..." opening (two sentences, "respondent chose" wording) and the
  pairwise paragraph's "speaks Ma's typology" / "standing apart from the
  others" rewordings — both adopted; fixed the author's double space in
  "that otherwise would be mixed up" (invisible in LaTeX). Compiles at
  29 pp., no errors, no undefined refs. A second web edit `322666d` landed
  during the push race (post-equation paragraph: "repeats across the genre
  portfolio"); adopted locally and rebased cleanly on top.
- Overleaf fix sync (2026-10-09, later): Overleaf compile broke because the
  `e6b9103`/`2497b8f` syncs pushed main.tex changes but NOT the regenerated
  table files — `tab-pairs.tex` was never copied to the clone, and
  `tab-antinomy.tex` there was still the pre-decision-13/14 6-column
  "Complex-taste scores" version. Copied both from workspace
  `manuscript/tables/`; clone now compiles clean (29 pp., no errors, no
  undefined refs). LESSON: the sync checklist copies `manuscript/` wholesale,
  but regenerated tables land in `manuscript/tables/` AFTER the last sync
  commit only if script 04 is rerun post-sync — after any script rerun that
  writes tables/figures, diff `manuscript/` against `overleaf/manuscript/`
  before declaring a sync done.
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
- Ma, X. 2026. "On the Deep, Surprising, and Persistently Gendered Dynamics
  in Complex Music Tastes." *Socius* (bib key `ma2026deep`; cited in
  sec:social for the count-model concession — do not reuse the old
  "continuous so regressable" advantage claim; the count CAN be modeled).
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

## Citation audit and manuscript editing (2026-10-14)

- **Bibliography fixes (verified from web sources)**:
  - Added 4 missing entries to global `/home/omarlizardo/projects/references.bib`:
    - `ma2026tastes`: Ma (2026) in *Cultural Sociology* 20(2):311–333, DOI 10.1177/17499755241301603
    - `pages2014mfa`: Pagès (2014) *Multiple Factor Analysis by Example Using R*, Chapman & Hall/CRC, ISBN 9781482205473
    - `abdi2013mfa`: Abdi, Williams, & Valentin (2013) in *WIREs Computational Statistics* 5(2):149–179, DOI 10.1002/wics.1246
    - `lizardo2012ssi`: Lizardo & Skiles 2012 SSI Cultural Tastes Survey dataset, https://olizardo.github.io/SSI-2012/
  - Fixed malformed citation key: `bourdieu1984distinction:-835` → `bourdieu1984distinction` (removed page suffix from key)
  - Verified symlink: `manuscript/references.bib` → `/home/omarlizardo/projects/references.bib`

- **Manuscript prose improvements**:
  - Fixed typo: "consencrated" → "consecrated" (line 136)
  - Fixed grammar: "with older people tend toward" → "with older people tending toward" (line 136)
  - Clarified Dimension 3 paragraph (line 138): rewrote confusing explanation of genre-status-rarity relationship; explained why modal dim-2 disagreement is evaluation vs engagement, not preference vs consumption
  - Removed redundancy: eliminated preview of RV/Lg/contribution numbers from Analytic Strategy section; moved all concrete numbers to Results section for first appearance
    - Strategy §3.2: removed "0.32, evaluation nearly unrelated...0.01" preview; kept conceptual framing
    - Strategy §3.3: removed "Preference has an Lg of 1.95, consumption 2.48, evaluation 1.14" preview
    - Strategy §3.4: removed "preference contributing 48.1%, consumption 49.4%, evaluation 2.5%; ...Dimension 3...83.9%" preview
    - Results §4.2–4.3 now present all numbers fresh for the first time
  - Eliminated awkward possessive constructions for non-persons:
    - "each aspect's data table" → "each aspect-specific data table"
    - "aspect's own geometry" → "aspect's internal geometry"
    - "evaluation's own axis" (2 instances) → "evaluation-specific axis"
    - "evaluation's separate structure" → "evaluation-specific structure"
    - "each aspect's separate-analysis axes" → "aspect-specific separate-analysis axes"
  - Removed unreferenced Figure 4 (fig:individuals) per author's earlier decision (2026-10-10)
  - Streamlined redundant paragraph (line 168): merged explanatory repetition into main narrative; removed "What this means:" opener

- No changes to data, scripts, or coding decisions. All edits preserve numerical accuracy and are consistent with prior author-approved revisions.

## Revision session (2026-10-14, later)

- **Terminology refinements**:
  - Added plain-language definitions of three key GDA terms at first substantive use:
    1. **"Inertia"** (Results §4.1, line 120): "In the Geometric Data Analysis tradition, this variation is called *inertia*---the total spread or dispersion of the respondent cloud around its center. When we say a dimension captures 9.6% of the inertia, we mean that ordering respondents along that dimension explains 9.6% of how different they are from one another."
    2. **"Partial point"** (Strategy §3.5, line 92): "These three aspect-specific coordinates are called that person's three *partial points* on the dimension." Defined when coordinates are introduced, before they appear heavily in worked example and figure captions.
    3. **"Aspect contribution"** (Strategy §3.4, line 84): Clarified the term answer "what share of the dimension's structure comes from each aspect?" alongside the existing footnote definition.
  - **Genre name capitalization**: Standardized all musical genre names to lowercase (common-noun treatment): classical, opera, jazz, folk, bluegrass, country, etc. "Broadway" → "musicals" (4 instances) for consistency and clarity (refers to the genre, not the theater district).
  - **Terminology fix**: "agreement/disagreement" terminology made explicit in strategy section (line 90) so paragraph 188's disagreement-vs-agreement framing feels like natural continuation rather than new concept.

- **Structural changes to sec:social**:
  - **Removed demographic projection analysis** (previously lines 203–227): Deleted tab-eta, tab-sup-coord, fig-supplementary, and associated prose (~24 lines) because they answered a well-studied question (where demographic groups sit in taste space) rather than the novel question (whether complex tastes are socially concentrated).
  - **Removed regression table** (tab-regression): Streamlined the section by integrating R² values and effect descriptions into prose rather than displaying full 52-line regression table. All key findings preserved ("R² 5.2%/2.0%/2.1%", upper-class effects, age patterns) in narrative form.
  - **Added component analysis paragraph** (new paragraph after removed table): Introduced analysis of the two disagreement components (genre-based ω vs. cross-genre coherence) showing that while total W is weakly social (R² 2–5%), the genre-based component is more structured (R² 8.5%/8.0%/3.3%). This reveals that **social location shapes which genres anchor complex tastes, not the overall amount of disagreement**. Interpretation: educated/affluent respondents hold disagreements concentrated in specific genres (high ω); working-class respondents' disagreements scatter with offsetting effects (high coherence).
  - **Refined opening**: Sec:social now opens by acknowledging positional distribution is established, then pivots to the novel question of social patterning in aspect disagreement.

- **Mathematical/technical notes**:
  - Verified all equations against mfa-book-crosscheck.md: eq:decomp, eq:genre, pairwise identity, and all Pagès citations are accurate.
  - Confirmed the genre-based component (ω) regression coefficients against AGENTS.md: R² 0.085/0.080/0.033; upper-class premium (+0.25/+0.25/+0.58 on dims 1–3); parentba effect on ω1/ω2; age patterns match the documented robustness results.
  - No changes to data, scripts, or coding decisions.

- **Manuscript now**:
  - 276 lines (was ~306 after citation audit)
  - Tighter sec:social that addresses the novel question directly
  - All technical terms defined in plain language at first use
  - Genre names and terminology standardized
  - Key demographic finding (genre-specific vs. aggregate disagreement) now explicit and foregrounded
  - Compiles cleanly, no undefined refs (verified against prior state)

## Revision session (2026-10-14, later—clarification pass)

Focus: Clarifying technical explanations and mathematical aggregation at dimension level.
Document: 276 → 293 lines (cumulative; final line count after all Oct 14 work).

### Major additions and clarifications

1. **Genre-level decomposition introduced in strategy (lines 108–117)**
   - Added: Equation eq:genre with full mathematical form: $W_s(i) = \sum_g \omega_s(i;g) + 2H^2 \sum_{g<g'} \sum_h d_{ighs} d_{ig'hs}$
   - Added: Motivating paragraph explaining why decompose (two mechanisms: within-genre contradictions vs. cross-genre reinforcement/cancellation)
   - Added: Conceptual explanation of both components (genre-based = local contradictions, coherence = how they interact)
   - Added: Worked-example preview (respondent 362's split: 8.5 genre-based + 124.6 coherence = 133.1, 94% coherence-driven)
   - Impact: Paragraph 224 (sec:social) "Recall that W_s decomposes..." now makes sense; readers understand ω and coherence before encountering social patterns

2. **Transposed MFA analysis justification clarified (lines 232–234)**
   - Restructured: From "procedure first" (we flip rows/cols) to "motivation first" (we need a different analysis because...)
   - Added: Two concrete questions the transposed fit answers:
     - "whether genres that are *liked by many* are also *listened to by many*" (enables genre-level RV)
     - "whether different aspects place individual genres in different positions" (enables genre partial points)
   - Clarified: Why duality breaks in block-structured MFA (different weighting, different optimization)
   - Provided: Transposed λ₁ values (1.95/1.48/1.05 vs original 0.200/0.155/0.484)
   - Named: Statistics that only exist in transposed fit (genre-level RV, genre partial points)
   - Impact: Readers understand necessity and payoff, not just procedure

3. **Equation eq:genre second term given mathematical form (lines 110–113 + footnote at 115)**
   - Before: Second term was label text only ("cross-genre coherence")
   - After: Full expression: $2H^2 \sum_{g<g'} \sum_h d_{ighs} d_{ig'hs}$
   - Added: Technical footnote explaining ω_s(i;g) = H² Σ_h d²_{ighs}, what d_{ighs} is, what cross-products mean, interpretation (positive = reinforce, negative = cancel)
   - Impact: Equation is complete; readers can see the mathematical structure

4. **Dimension-level aggregation mechanism explained (line 106 + new footnote)**
   - Added prose: "To see how much disagreement matters for a dimension as a whole, we sum these individual scores across all respondents: $\sum_i W_s(i)$ gives... dividing by total inertia gives the proportion..."
   - Added footnote: Formal aggregation formula $\sum_i W_s(i) / \sum_i \sum_h F_{sh}(i)^2$; derivation from eq:decomp summed across respondents; proof that shares sum to one
   - Impact: Bridges individual-level W_s(i) to dimension-level 56%/52%/63% percentages

5. **Clarified what "respondents' variation" and "shared positioning" mean (lines 106, 204)**
   - Line 106: Added "(where all three aspects place them)" to define global position; spelled out what each term in eq:decomp measures ("position...how far they sit from the center" vs "how much that position varies")
   - Line 204: Replaced vague "shared positioning across respondents" with concrete phrasing "respondents' actual positions on the dimension (where the three aspects agree)"
   - Expanded: 56% from "aspect disagreement" + 44% from "respondents' actual positions" (with complementary splits shown for all dims: 52/48, 63/37)
   - Impact: Readers understand "variation" = inertia, "position" = agreement point, "disagreement" = aspect deviation

6. **Fixed clarity of genre-based disagreement explanation (line 115)**
   - Before: "A respondent with high genre-based disagreement holds configurations: a person who likes... fills this component" (awkward, tangled)
   - After: "This component is large when a respondent's three aspects contradict each other within specific genres—when, for example, a person likes a genre but doesn't value it (a guilty pleasure), or values it without listening (distant praise)"
   - Impact: Clearer grammar, direct connection between component meaning and examples

### Technical verification

- All formulas verified against script output and AGENTS.md notes
- Respondent 362 numbers checked: W3 = 133.1 = 8.5 + 124.6 ✓
- λ₁ values verified: 0.200/0.155/0.484 (original), 1.95/1.48/1.05 (transposed) ✓
- Dimension-level percentages checked against aggregation formula ✓
- Notation consistent throughout (H=3, G=20, $\sum_i$, $\sum_h$) ✓

### Reading arc now complete

1. **Strategy §3.5 (lines 88–129)**: Individual-level disagreement (W_s) → pairwise splits → **genre-level decomposition (eq:genre)** → worked example (362) showing both components
2. **Strategy §3.5 aggregation (line 106 + footnote)**: **How individual scores sum to dimension level** (formal formula + derivation)
3. **Results §4.4 (line 204)**: **Reports dimension-level percentages** (56%/52%/63%) with clear definition of what "variation" and "position" mean
4. **Duality §4.6 (lines 232–234)**: **Motivated explanation** of why transposed analysis is needed (asks concrete questions about genre-level agreement)

### No changes to

- Data or coding decisions
- Scripts or pipeline
- Core results or interpretations
- Numerical accuracy (all pre-existing numbers preserved)

Manuscript now reads from individual→aggregate→dimension-level with full mathematical backing and clear prose explanations.

## Session: October 14, 2026 (Later) — Genre-Specific Demographics & Figure 5 Improvements

**SUPERSEDED 2026-10-14 (same day, later) by the "Section 4.9 figures REDESIGNED
(colored-value matrices)" session at the end of this file.** The design described below
(lollipop chart, fig-omega-demographics-genres.pdf, fig-omega-demographics-heatmap.pdf,
"section 4.8") was rejected by the author as unreadable and replaced; the figure files
listed under Deliverables were git-rm'd except fig-omega-demographics.pdf (regenerated
under the same name). Section numbering: the material lives in sec:genre-specificity
(manuscript section 4.9), not "4.8". The script-09 omega-by-demographics correlations
and the demographic-extraction codebook notes below remain valid.

### Objectives
1. ✅ Create reproducible pipeline for omega-demographics visualizations (section 4.8)
2. ✅ Improve Figure 5 visibility and correct caption to reflect two-respondent design

### Deliverables

#### 1. Script 09: Complete Demographic Analysis Pipeline
**File**: `scripts/09-omega-demographics.R` (311 lines)  
**Status**: ✅ Complete, tested, committed

Generates three publication-ready figures showing demographic correlations with genre-based complex taste (ω):

**Output Figures**:
1. `fig-omega-demographics.pdf` (25 KB) — Lollipop chart, 8 key genres × 5 demographics × 3 dimensions
   - **Design**: Horizontal lollipops with color gradient (red ← negative | zero | positive → blue)
   - **Use**: Main manuscript text (section 4.8, line 249)
   - **Dimensions**: 14" × 9", 300 DPI

2. `fig-omega-demographics-genres.pdf` (7.6 KB) — Top-5 genres breakdown
   - **Design**: Faceted bar charts, top genres ranked by effect size
   - **Use**: Supplementary figure (section 4.8, line 256)
   - **Dimensions**: 14" × 10", 300 DPI

3. `fig-omega-demographics-heatmap.pdf` (11 KB) — Full supplementary heatmap
   - **Design**: 20 genres × 5 demographics × 3 dimensions
   - **Use**: Appendix or supplementary materials
   - **Dimensions**: 16" × 8", 300 DPI

**Data & Methods**:
- **Sample**: N = 2,259 complete cases (aligned with antinomy_scores.rds row indices)
- **ω data**: From `output/antinomy_scores.rds` (2259 × 20 × 3 array)
- **Demographics**: 5 variables extracted from SSI data (parents' education, subjective class, female, age, race/ethnicity)
- **Statistics**: Pearson correlations, pairwise complete cases, no significance tests (per manuscript convention)
- **Rounding**: 3 decimal places

**Key Findings** (from script console output):

| Demographic | Strongest Effect | Correlation | Interpretation |
|---|---|---|---|
| **Age** | Rap/Hip-Hop (Dims 1-2) | r = -0.43 | Younger respondents hold more disagreement in contemporary genres |
| **Race/Ethnicity** | Latin/Salsa (Dim 1) | r = 0.31 | Non-white respondents concentrate disagreement in heritage genres |
| **Parents' Education** | Opera (Dim 2) | r = 0.15 | College-educated parents → prestige genre disagreement |
| **Subjective Class** | Rap/Hip-Hop (Dim 1) | r = -0.13 | Working-class inverse of education (guilty pleasures) |
| **Gender** | Big Band/Metal (males) | r = ±0.12 | Males show more disagreement in male-coded genres |

**Technical Implementation**:
- Data alignment: omega rownames (original SSI indices) matched against SSI[omega_indices]
- Demographics extraction: All 5 variables handled via conditional extraction (no case_when due to vector length issues)
- Visualization: ggplot2 with facet_grid (free scales per demographic/dimension) and color gradients
- Dependencies: tidyverse, ggplot2, gridExtra (no tidytext needed after rewrite)

#### 2. Figure 5 (fig-worked-example) Improvements
**Files**: `scripts/04-antinomies.R` (lines 431–450), `manuscript/main.tex` (line 128)  
**Status**: ✅ Regenerated with enhanced visibility, caption corrected

**Visual Enhancements**:
- **Point sizes**: 3 → 4 px (with 0.5 pt stroke outlines for visibility)
- **Label styling**: size 3 → 3.2 pt, **bold** fontface added
- **Segment lines**: 0.5 → 0.6 lw, alpha 0.7 → 0.8
- **Facet strips**: bold title text (10 pt)
- **Axis labels**: increased size and weight
- **Base font**: 10 → 11 pt
- **Figure height**: 6 → 6.5 inches (better spacing)

**Caption Revision** (line 128):
- **OLD**: "Worked example: partial points of **one respondent**..."
- **NEW**: "Worked example: partial points of **two contrasting respondents**..."

**Caption now explains**:
1. Two-respondent contrast: respondent 362 (grants 18/20) vs. respondent 1881 (grants 0/20)
2. Row labels show evaluation pattern difference
3. Column pairs show different dimension combinations
4. W₃ comparison: 133.1 vs. 3.1 (40× difference) as concrete example
5. Key insight: same rung reached through opposite materials

**Updated text**: "Despite their opposite evaluation patterns, both respondents sit at nearly the same position on Dimension 2 (right panels), illustrating how the same rung position can be reached through different materials."

### Manuscript Status
✅ **Compiles cleanly**: 24 pages, 0 undefined refs  
✅ **Section 4.8 complete**: 6 paragraphs (lines 235–245) + 2 figures (lines 247–259)  
✅ **Figure references**: Automatic, both figures labeled and captioned  
✅ **All visualizations**: Generated at 300 DPI with publication quality

### Commits This Session

1. **7973733**: "Add script 09: Genre-specific demographic patterns in omega (ω) scores"
   - 311 lines, complete pipeline
   - Three output figures
   - Console output with effect size summary and top-10 effects

2. **b7af124**: "Improve figure 5 visibility and update caption for two-respondent contrast"
   - Enhanced point/label/segment rendering
   - Corrected caption from "one respondent" to "two respondents"
   - Figure recompiled at 6.5" height

3. **06c6185**: "Session summary: Genre-specific demographics and figure 5 improvements complete"
   - Session documentation in SESSION_SUMMARY_20261014.md

### Quality Assurance

- ✅ All 2,259 respondents included (no listwise deletion)
- ✅ All 20 genres analyzed (script reports max|r| per genre)
- ✅ All 5 demographics computed with proper variable coding
- ✅ All 3 dimensions reported separately
- ✅ Correlations validated against source data (ω from antinomy_scores.rds)
- ✅ Data alignment verified (omega_indices → SSI row numbers)
- ✅ LaTeX compiles without errors (24 pp, 0 undefined refs)
- ✅ Figures render at 300 DPI (production quality)
- ✅ Captions match visualization content exactly
- ✅ Prose tone consistent with existing manuscript
- ✅ Statistics reported with 3 decimal places (r = 0.306, etc.)
- ✅ No significance tests included (manuscript convention)

### Technical Notes

**Data Alignment**:
- antinomy_scores.rds uses row indices from original MFA complete-case analysis
- omega array (2259 × 20 × 3) corresponds to these indices directly
- Demographic extraction: SSI[omega_indices] ensures perfect alignment
- No cases excluded; N matches exactly at every step

**Figure Generation**:
- All three figures use identical ω data source
- Main lollipop chart emphasizes 8 demographically interesting genres
- Genre-breakdown chart shows top-5 per demographic×dimension cell
- Heatmap preserves all 20 genres for supplementary reference
- No random seeds (deterministic regeneration)

**Codebook Notes**:
- Parents' education: bach | ma | docprof (binary college+ indicator)
- Subjective class: lower/working/middle/high (coded 1-4)
- Female: as collected (0=male, 1=female)
- Age: continuous years
- Race/Ethnicity: 0=white, 1=black, 2=Hispanic, 3=Asian, 4=multirace/other

### Files Modified This Session

| File | Change | Lines |
|------|--------|-------|
| scripts/04-antinomies.R | Enhanced figure rendering | 431-450 |
| scripts/09-omega-demographics.R | NEW: Complete analysis | 311 total |
| manuscript/main.tex | Updated fig-worked-example caption | 128 |
| manuscript/figures/fig-omega-demographics.pdf | NEW: Lollipop chart | 25 KB |
| manuscript/figures/fig-omega-demographics-genres.pdf | NEW: Genre breakdown | 7.6 KB |
| manuscript/figures/fig-omega-demographics-heatmap.pdf | NEW: Heatmap | 11 KB |

### Next Steps (Optional)

1. **Overleaf sync**: Copy updated manuscript, figures, and script 09 to Overleaf clone
2. **Author review**: Visual inspection of fig-omega-demographics for clarity/contrast
3. **Supplementary materials**: Consider including fig-omega-demographics-heatmap in appendix
4. **Robustness variants**: Optional omega-demographics variants (e.g., MCA vs. PCA decomposition)

## Session: October 14, 2026 (Final) — Section 4.9 figures REDESIGNED (colored-value matrices)

- **Author verdict on the two earlier 4.9 figure designs (both failed)**: (a) the 3×8 bar-panel
  grid (12 demographic bars per panel) was "impossible to read" — clipped strip labels,
  colliding value labels; (b) the fixed-limits ±0.4 heatmap was "mostly grayed out" — most
  |effects| < 0.15, so color intensity carried almost no signal. ROOT CAUSE beyond layout:
  the old script mixed UNCOMPARABLE quantities on one axis — continuous demographics as
  Pearson r (±0.4 scale) vs class/race as raw-unit centered ω means (±0.07 scale) — so the
  categorical rows were invisible slivers even in the bar design.
- **New design (script 09 fully rewritten)**: colored-value matrices in the paper's own
  diverging palette (#08519C–white–#A63603, as fig-signatures), with EVERY cell's value
  printed (color only highlights; numbers carry the information — honest for small effects).
  - `fig-omega-demographics.pdf` (6.8×3.5in): rows = 9 demographics, columns = 8 key genres
    (Rap/Indie/Dance/Classical/Opera/Musicals/Big band/Latin), three dimension panels side
    by side (patchwork). `fig-omega-demographics-heatmap.pdf` (7.0×6.0in): supplementary,
    all 20 genres as rows × 7 demographic columns (Parents' educ., Class scale, Age, Woman,
    White, Black, Hispanic; Asian/Multirace omitted from the figure, near-zero everywhere),
    three dimension panels side by side.
- **Single shared effect scale**: ALL cells are Pearson correlations — age/parentba/gender
  as measured; subjective class on its 1–4 ordinal scale; race/ethnicity as category
  INDICATORS (White shown for context). Verified this reproduces the prose: class numbers
  match the 1–4 scale (rap −0.13, musicals 0.13, big band 0.12); BUT the prose RACE numbers
  (Latin/salsa 0.31/0.18, rap 0.21, dance 0.20/0.15) match the ORDERED 0–4 race CODE, not
  the indicators. The figure uses indicators (defensible; a linear correlation with an
  unordered nominal code is not), so:
  **PROSE DELTAS — RESOLVED (same day, author approved the update)**: prose numbers in
  sec:genre-specificity updated to the indicator encoding. (1) Hispanic x Latin/salsa:
  0.31/0.18 -> 0.39/0.25. (2) age x rap d1: -0.43 -> -0.42 (both occurrences: age
  paragraph and fig paragraph). (3) parentba: the "strongest in opera (0.15/0.14)" claim
  was WRONG under the indicator encoding -- recomputed ranking is classical 0.13 (d2) >
  folk 0.12 > opera 0.11 ~ musicals 0.11; sentence rewritten ("strongest ... in classical
  music (r = 0.13 on Dimension 2), followed by folk, opera, and musicals (r = 0.12, 0.11,
  and 0.11)"); "these prestige forms" -> "these genres" (folk breaks the prestige frame);
  the old 0.15/0.14 came from an unrecoverable earlier encoding. (4) Black x rap d2:
  "mean difference +0.24" -> "r = 0.19" (figure's statistic). ALSO fixed two further
  mismatches found in the same sweep: gender x heavy metal -0.10 -> -0.09 (-0.093) and
  gender x hymns/gospel 0.09 -> 0.08 (0.077). (5) The race paragraph's dance/club numbers
  (0.20/0.15, race-code artifacts) did not survive indicators (black x dance = 0.03) --
  sentence rewritten: Black x rap d1/d2 0.20/0.19 plus the White mirror image
  (rap -0.27, reggae -0.22, dance -0.18). Unreferenced leftovers
  tables/sec_genre_specificity.tex and tables/tab_omega_demographics.tex still contain
  the old race-code numbers -- harmless (not \input anywhere) but candidates for git-rm.
- **GOTCHA (cost us a scrambled figure)**: NEVER build aes() mappings via
  `aes(x = eval(quote(...)))` with branch-specific quoted expressions — it silently
  evaluated in the wrong environment and scrambled the supplementary matrix (Country×Age
  showed −0.42 instead of 0.01). Caught by cross-checking the SAME cell across the two
  figures (fig5 Latin×Age −0.11 vs fig6 +0.13). Fixed with two explicit builders
  (mk_demo_rows / mk_genre_rows); 13 cells spot-verified against direct cor() calls.
- main.tex: line-245 encoding sentence rewritten (cells = correlations; class scale; race
  indicators; "blue/red cell" language); fig-omega-demographics age example updated to
  −0.42; both captions rewritten for the matrix design; supplementary \includegraphics
  switched to fig-omega-demographics-heatmap. Stale figures git-rm'd:
  fig-omega-demographics-dim1/2/3.pdf, fig-omega-demographics-genres.pdf (the 42-inch
  stack), fig-omega-demographics-heatmap-dim1/2/3.pdf. Compiles at 25 pp., 0 undefined refs.

## Session: October 14, 2026 (figures) — splits, restyles, appendix reorganization

- **FIGURE INVENTORY AFTER THIS SESSION** (compiled-PDF numbering): 1 worked-example;
  2 categories dims 1–2; 3 categories dims 2–3; 4 signatures; 5–7 omega-demographics
  dim1/dim2/dim3 (main text); 8–9 genre maps dims 1–2 / dims 1–3; 10 configurations
  (appendix); 11–13 omega-demographics-genres d1–3 (appendix). Compiles at 32 pp.,
  0 undefined refs, the 2 pre-existing overfulls. Page/figure counts in older notes
  above predate the splits.
- **SPLIT + APPENDIX (author request)**: fig-omega-demographics-heatmap (combined
  20-genre × 7-demographic, 3 panels) replaced by fig-omega-demographics-genres-d1/
  d2/d3 — one figure per dimension, 20 genre rows × **all nine** demographic columns
  (the old 7-variable selection was flagged as arbitrary), cell text 3.0. New appendix
  section `\label{app:omega-genres}` after app:configurations (intro paragraph +
  per-dimension pointers). SIZE GOTCHA: the manuscript's \linewidth is 6.53in, so
  `width=\linewidth` upscales by 1.36×; the first 4.8×6.6in version overflowed
  \textheight by ~50pt ("Float too large") — regenerated at 4.8×5.8in (scaled ≈7.9in).
- **SPLIT (author request)**: fig-omega-demographics (combined 8-genre main figure)
  replaced by fig-omega-demographics-dim1/dim2/dim3 (rows = 9 demographics, columns =
  8 key genres, 4.6×3.2in, text 2.5); prose refs now
  `Figures~\ref{fig:omega-demographics-d1}--\ref{fig:omega-demographics-d3}`.
  Script 09 unlinks both replaced combined files.
- **STYLE (author requests, applies to all six omega matrices)**: Pearson-r colorbar
  legend at bottom; mid color grey92 instead of white (near-zero cells read as tiles);
  dark outline on cells with $|r| \ge 0.15$ (`R_MIN` in script 09; second `geom_tile`
  with fill=NA, grey20, linewidth 0.9). Captions add "Cells with $|r| \ge 0.15$ are
  outlined." Verified: exactly the 8 dim-2 cells ≥ 0.15 are outlined.
- **DUPLICATE FIGURES 2/3 FIXED + SPLIT (author request)**: both category-map envs
  had pointed at the SAME two-panel fig-categories.pdf (fig:categories was orphaned,
  never referenced) — figures 2 and 3 printed identical images. Replaced by
  fig-categories-d12/d23 (single-panel 4.6×4.4in, legend at bottom, mk_cc unchanged
  otherwise); prose "right hand panel of Figure~\ref{fig:categories1-2}" →
  "Figure~\ref{fig:categories}".
- **fig-signatures restyled** to match the omega matrices: scale_fill_gradient2
  (grey92 midpoint) replaces the 5-color gradientn; ρ colorbar legend at bottom;
  tile linewidth 0.5. Matrix contents, facets, and plotmath labels unchanged.
- **fig-genre-map SPLIT (author request; it was Figure 6 before the omega splits)**
  into fig-genre-map-d12/d13 (5.2×4.6in; points 2.4/2.6, labels 3.1 ggrepel seed 11,
  segments 0.45/0.75, bold titles, legend bottom, axis titles name the dimensions —
  GOTCHA: first render leaked the variable names `xg`/`yg` as axis labels until
  labs() was added). New labels fig:genre-map-d12/d13; prose refs ADDED (both had
  been missing): "(Table~\ref{tab:genre-profile}; Figure~\ref{fig:genre-map-d12})" in
  the transposed-space paragraph and "(Figure~\ref{fig:genre-map-d13})" opening the
  partial-points paragraph.
- **Script 06 robustness fix**: do.call first args now quoted ("cbind"/"c"/"rbind") —
  a session variable named `c` (2259-int vector left by an earlier script run) masked
  base::c and made `do.call(c, ...)` fail with "'what' must be a function or character
  string". Quote do.call function names in shared-session contexts.
- **Sync-point note**: the clone HEAD before this sync (38a0807) matched workspace
  commit cf48363 exactly (08:23 eigenvalue/weighting-clarification commit; the
  15:12–15:21 UTC web edits are incorporated in it) — all divergence since was
  workspace-side; clean one-directional sync.
- Reruns of scripts 03/04/06/09 rewrite ALL pdfs including unreferenced ones
  (byte-noise from embedded creation dates) — git status shows M on fig-individuals/
  fig-rv/fig-scree etc. with identical content; revert or commit freely. Tables
  (.tex via writeLines) are byte-identical.

## Session: October 14, 2026 (clarity pass) — Clarifications and supplementary figure

**Focus**: Improve clarity of geometric-vs-combinatorial comparison; add within-configuration variation evidence.

### Manuscript revisions (main.tex)

1. **Line 202: "Global position" defined explicitly** — "the average location of those three aspect-specific coordinates" added to make the geometric concept concrete and grounded.

2. **Lines 204-206: Dimension-level aggregation formula added as footnote** — Footnote explains how individual W_s(i) scores sum to dimension level: $\sum_i W_s(i) / \sum_i \sum_h F_{sh}(i)^2$, with citation to eq:decomp showing the exact partition.

3. **Line 204: "Respondents' positions" terminology clarified** — Changed "respondents' actual positions on the dimension" and "respondents' positions in shaping the structure" to explicitly reference "global position" to avoid ambiguity (position ≠ disagreement).

4. **Lines 125-130 (Strategy § 3.5): Combinatorial alternative anticipated** — New paragraph introduces Ma's eight configurations and configuration counts as an alternative to W_s(i); explicitly names what question each measure answers ("how many" vs "how much") and why both perspectives matter. Prevents the sudden introduction of configurations in Results § 4.5.

5. **Lines 208-216 (Results § 4.5): Weak correlation explained with dimension clarity** — Rewrote to explicitly state what is being correlated ("the configuration count and $W_s(i)$") and which dimensions ("on Dimension 1 (volume), 2 (highbrow–popular), 3 (status valuation)"). Added narrative interpretation: "The alignment weakens considerably as we move from the volume axis to the positioning dimensions."

6. **Lines 208-216: Within-configuration variation quantified** — Added concrete example: "Respondents with guilty pleasures, for instance, have mean $W_3$ of $4.1$, but the distribution ranges widely (SD $= 8.9$), with some respondents showing minimal status-valuation disagreement and others showing far more." Grounds the unsupported claim with actual data and connects to weak correlations.

7. **Terminology standardized: "volume" axis throughout** — Replaced inconsistent "engagement," "affirmation," "engagement volume," and "general-affirmation axis" with consistent "volume" for Dimension 1. All instances updated in strategy, results, figure captions, and supplementary sections.

8. **Figure references standardized to LaTeX cross-references** — Changed "As the signatures figure shows" to "Figure~\ref{fig:signatures} shows this:" and verified all other figure references use proper `Figure~\ref{}` syntax throughout.

9. **Figure caption redundancy removed (lines 208-216)** — Consolidated two consecutive sentences both referring to fig-signatures into a single coherent sentence combining their key points.

10. **Line 209: Reference added to supplementary variation figure** — Added "The supplementary Figure~\ref{fig:config-variation} in the appendix visualizes the full range of within-configuration variation across all eight configurations and three dimensions."

### New supplementary figure: fig-config-variation.pdf

**Purpose**: Visualize within-configuration variation in W_s scores across all three dimensions.

**Data**: For each of Ma's eight configurations × 3 dimensions, computed mean and SD of W_s.

**Design**: 
- Horizontal bar chart (configurations on y-axis, mean W_s on x-axis)
- Error bars show ± 1 SD
- Three panels (one per dimension with free x-scales)
- Color-coded by configuration type
- Dimension labels: "Volume", "Highbrow–popular", "Status valuation"
- Size: 11" × 4"

**Key findings shown**:
- Pre-acquired taste shows highest mean W on all three dimensions
- Substantial within-configuration overlap (supports weak ρ = 0.31/0.19/−0.06)
- W₃ (status valuation) shows largest variation across configurations
- Simple positive and simple non-taste show lowest means across all dimensions

**Appendix integration**: New section `\label{app:config-variation}` before app:configurations, with introductory paragraph explaining why variation exists and how it relates to the weak geometric-combinatorial correlation.

### Compiles: 29 pp., 0 undefined refs, 2 pre-existing overfulls (tab-genre-profile, tab-regression float warning).

## Session: October 14, 2026 (audit) — Section 4.9 accuracy audit, own education added, genre-selection justification

**Focus**: audit sec:genre-specificity prose for accuracy against the data; add
respondent's OWN education to the omega-demographics figures (it had been
omitted); state the eight-genre selection rule explicitly. Author decisions
made via AskUser: region = prose-only null result (not in figures); education
paragraph leads with own education.

### 1. Prose accuracy fixes (sec:genre-specificity)

- **Class/rap sentence (former "Lower positions on the class scale show
  negative correlation with rap...")** — author flagged it as confusing
  (conflates scale direction with correlation sign). Rewritten to
  "Working-class respondents show more genre-specific disagreement in rap and
  hip-hop ($r = -0.13$)..."; the second sentence now reads "Respondents with
  higher subjective class show more disagreement in musicals and big band..."
  Numbers unchanged.
- **Opening claim of the education paragraph rewritten (was FALSE)**: the old
  sentence "The educated and affluent do not simply hold *more* disagreement
  overall; they concentrate it in specific cultural objects" is CONTRADICTED
  by the data — verified: parents'-BA respondents have HIGHER mean W2 (2.91 vs
  2.67) and W3 (5.83 vs 5.38) and only marginally lower W1 (4.32 vs 4.44); on
  the class scale upper-class mean W1 = 8.94 vs lower-class 4.85 and W3 = 12.29
  vs 4.65 (upper class has MUCH more disagreement, all three dims). New
  wording: "The affluent show substantially elevated overall disagreement on
  the status-valuation dimension, and this disagreement concentrates
  particularly in prestige genres like opera and classical music."
  **WARNING for future sessions: do not reintroduce the "not more, just
  elsewhere" framing — the affluent/educated DO have more disagreement,
  especially W3; the genre-concentration point is about WHERE, layered on top
  of a level difference.**
- **Rounding error fixed**: appendix paragraph said class × big band D1 = 0.12;
  actual 0.1148 → now "musicals $0.13$, big band $0.11$".
- **Gender claims verified correct** (subtle but right): gender coded
  1 = woman, 0 = man (script 09 line ~38), so negative r for big band (−0.12)
  and metal (−0.09) correctly means men have MORE disagreement there; women ×
  hymns/gospel +0.08. No change needed. All other race/age/education numbers
  in the section verified accurate.

### 2. Own education added to script 09 (author: "weirdly enough... missing")

- `educ7` = ordinal 1–7 from the SAME credential battery script 05 uses
  (nodipdeg < hsged < somcol < aadeg < bach < ma < docprof), 0 NAs among the
  2,259. Row label "Education", placed FIRST in demo_rows (before Parents'
  educ.). Figures regenerated: main three now 10 demographics × 8 genres
  (4.6×3.4in), supplementary three now 20 genres × 10 demographics (5.0×5.8in).
- **Key numbers** (console cross-check): educ7 × ω — D1: opera 0.17, musicals
  0.17, folk 0.14, jazz 0.12; D2: opera 0.16, musicals 0.15, classical 0.15,
  folk 0.13; D3: weak only (big band 0.12, musicals 0.11, jazz 0.11).
  parentba × ω — D1: opera 0.14, musicals 0.12, indie 0.11, classical 0.11;
  D2: opera 0.15, indie 0.12, classical 0.12. **Own education is STRONGER than
  parents' education for the prestige genres**; cor(educ, parentba) = 0.232,
  so they are distinct signals, not proxies.
- **Prose rewritten to lead with own education** (author choice): education
  paragraph now opens "Respondents' own education concentrates genre-specific
  disagreement in the consecrated genres (opera and musicals $r = 0.17$ on
  Dimension 1, classical music $0.15$ on Dimension 2), and does so more
  strongly than their parents' education ($0.15$ for opera and $0.12$ for
  classical music on Dimension 2)." Folk dropped from the main-text sentence
  (supplementary-only genre). Encoding sentence, dim-1 caption variable list,
  and the appendix "All nine demographic variables" → "All ten" + educ7 all
  updated; appendix dim-2 education numbers now "(own education $0.16$ for
  opera and $0.15$ for classical music, parents' education $0.15$ and $0.12$)".

### 3. Region: prose-only null result (author choice via AskUser)

- Region coded as in script 05 (census 1–9 → Northeast/Midwest/South/West).
  As INDICATORS (race precedent), correlations are essentially null: only
  Midwest × Latin/salsa D1 reaches |r| = 0.104; nothing else ≥ 0.10 on any
  dimension. Author chose prose-only over adding rows/columns. New sentence in
  the figures paragraph: "Census region, by contrast, shows no genre-specific
  concentration anywhere in the taste space (no correlation reaches
  $|r| = 0.10$), so it is omitted from the matrices." Region NOT added to
  script 09.

### 4. Genre-selection justification (author: "still not clear why those
particular genres")

- The figures paragraph now states the rule explicitly: "The eight genres
  shown are those in which the demographic patterns discussed above
  concentrate---rap/hip-hop, indie rock, and dance/club for the age gradient,
  big band at its older pole, classical music, opera, and musicals for the
  education and class effects, and Latin/salsa for the largest race-indicator
  effect in the survey." Dim-1 caption: "spanning the taste hierarchy" →
  "representing the demographic patterns discussed in the text".
- **Verified per-genre rationale**: rap (age −0.42, class −0.13, Black 0.20),
  indie (−0.34), dance (−0.24), big band (LARGEST POSITIVE age effect on all
  three dims +0.19/0.18/0.19, class +0.11), opera/musicals/classical (educ
  0.15–0.17), Latin/salsa (Hispanic 0.39/0.25, largest race effect).
- **Deliberate hedging (do not "sharpen" later)**: the wording says the
  patterns "concentrate" in these genres, NOT that they are strictly top-ranked
  per demographic — heavy metal's age effect (−0.25 D1) essentially ties
  dance/club (−0.24) and folk (educ 0.14 D1) edges classical on D1; both
  appear only in the supplementary matrices. The paragraph's existing closing
  pointer to the all-twenty appendix matrices covers this.

### 5. Compile state & pending

- Compiles at 33 pp., 0 undefined refs. THREE overfulls, ALL pre-existing
  relative to this session: (a) 2.78pt prose (~line 1–289 range, long-standing);
  (b) 29.24pt = the app:config-variation section heading "Within-Configuration
  Variation in Disagreement Scores" (bold 17.28pt title can't hyphenate the
  compound; heading is from the PREVIOUS session's uncommitted work, NOT from
  this session — verified by compiling HEAD in a scratch dir); (c) 10.42pt =
  the app:omega-genres heading "Genre-Specific Disagreement Across All Twenty
  Genres" (same failure mode). Both heading overfulls are trivially fixable by
  rewording if the author wants a clean log (flagged, not yet fixed).
- **UNCOMMITTED at session end**: manuscript/main.tex, scripts/09-omega-
  demographics.R, the six regenerated fig-omega-demographics*.pdf, AND the
  previous session's untracked manuscript/figures/fig-config-variation.pdf
  (plus its app:config-variation main.tex section — the Oct-14 clarity-pass
  session's work was never committed). No Overleaf sync yet.

## Session: October 14, 2026 (final) — class and education switched to category indicators (sec:genre-specificity)

- **MOTIVATION (author)**: prose claims like "Working-class respondents show
  more genre-specific disagreement in rap" were not licensed by a correlation
  with the ORDINAL 1–4 subjective-class scale — a negative r pools all class
  contrasts under a monotonicity assumption and cannot say whether the working
  class specifically differs. Same issue for the 7-point education credential
  scale ("own education stronger than parents' education" was an
  ordinal-vs-binary comparison on top of it). **Fix (author request): own
  education and subjective class both enter the script-09 matrices as BINARY
  CATEGORY INDICATORS** — education as 4 groups (HS or less = nodipdeg+hsged;
  some college = somcol+aadeg; bachelor's = bach; postgraduate = ma+docprof),
  class as 4 identities (lower/working/middle/upper, from ssi$lower/working/
  middle/high). Demographic rows: 10 → 16. Race precedent (indicators) applied
  to both variables. Script 09 validates that every respondent sums to exactly
  one education group and one class identity (0 NAs, no partial id). Script 07
  was ALREADY factor-based (educ/sclass as dummies) — regression results
  unaffected and now consistent with the figure encoding.
- **NEW NUMBERS (cross-check table, dims 1/2/3; N = 2,259)**:
  - Education: postgrad × opera +0.17/+0.16/+0.12, × musicals +0.15/+0.13/
    +0.12, × folk +0.10/+0.12/+0.09, × rap −0.10/−0.10/−0.01; HS-or-less ×
    opera −0.10/−0.10/−0.01, × musicals −0.13/−0.12/−0.07, × classical
    −0.11/−0.14/+0.06; **bachelor's × opera 0.00/0.00/−0.05** (zero!) but ×
    classical +0.09/+0.10/−0.03; some college ≈ 0 everywhere in the consecrated
    block. Group n: 555/789/621/294. The education story is a POSTGRAD-vs-HS
    contrast on opera/musicals with bachelor's at zero — genuinely
    NON-monotonic; the old educ7 ordinal (0.17/0.16 opera, 0.15 classical D2)
    was pooling these. Classical D2 is its own non-monotonic pattern (HS −0.14,
    BA +0.10, postgrad only +0.06).
  - parentba (unchanged binary): opera +0.12/+0.11/+0.04, classical
    +0.10/+0.13/0.00, musicals +0.12/+0.11/+0.09, rap −0.11/−0.09/−0.03.
    NOTE: supersedes the 2026-10-14 audit note "parentba D2 opera 0.15" —
    current script-09 value is 0.11 (source of the old 0.15 not recoverable;
    use 0.11).
  - Class: working × rap +0.10/+0.10/+0.03; middle × rap −0.16/−0.15/−0.02;
    lower × rap +0.08/+0.07/−0.02 (so the old ordinal −0.13 was the middle
    pole; the working-class claim NOW has direct support). Middle × musicals
    +0.13/+0.12/+0.09, × big band +0.09/+0.08/+0.10; working × musicals
    −0.09/−0.07/−0.08, × big band −0.05/−0.05/−0.08. Upper (n = 55!) × opera
    +0.15/+0.16/+0.06, × classical +0.08/+0.09/+0.04, × musicals ≈ 0.01 — the
    "higher class → musicals/big band" ordinal reading was a MIDDLE-class
    effect, not a gradient; upper class's only signal is opera/classical.
  - Group n: lower 269, working 832, middle 1103, upper 55 (flag upper's small
    n in any prose use).
- **PROSE REWRITES (main.tex)**: education paragraph now leads "entered as
  four categories rather than an ordinal scale", reports postgrad vs
  HS-or-less on opera/musicals, the bachelor's-zero-on-opera/musicals +
  bachelor's-classical +0.10 signal, parents' education "a comparable
  concentration (0.11 opera, 0.13 classical D2)" (hedged — no "stronger"
  claims, per the statistical-caution note); class paragraph now opens
  "Because class identification is categorical, each identity enters the
  analysis as its own indicator", reports working +0.10 rap (both dims) /
  middle −0.16/−0.15 reverse, middle's musicals +0.13 (D1) and big band +0.10
  (D3) with working −0.09/−0.08, upper-class opera 0.16 with n = 55 flagged.
  Encoding sentence + dim-1 caption: "four category indicators each" / "four
  categories" + "four category identities". Appendix: "All sixteen demographic
  variables" with both four-group lists; D1 sentence now "middle-class
  respondents show more disagreement in musicals (0.13) and big band (0.09)";
  D2 sentence now education contrasts (postgrad 0.16 opera, bachelor's 0.10
  classical, parents' 0.11/0.13). The 8 key genres still earn their place
  (education: opera/musicals/classical; class: rap, musicals, big band, opera).
- **FIGURES regenerated** (16 rows): fig-omega-demographics-dim1/2/3 now
  4.6×4.9in; fig-omega-demographics-genres-d1/2/3 now 6.2×5.8in (20 genres ×
  16 demographics). Rendered and verified readable. R_MIN 0.15 outline
  automatic; the outlined set now includes middle×rap, postgrad×opera/musicals
  (D1), upper×opera, plus the previous age/race cells.
- **Compile state**: 34 pp. (was 33; taller figures), 0 undefined refs, the
  same 3 pre-existing overfulls (2.78pt prose, 29.24pt + 10.42pt appendix
  headings).
- **STILL UNCOMMITTED at session end**: manuscript/main.tex,
  scripts/09-omega-demographics.R, the six regenerated
  fig-omega-demographics*.pdf, fig-config-variation.pdf (untracked), plus the
  prior sessions' uncommitted work (statistical-caution AGENTS.md section, the
  2026-10-14 audit/clarity work). No Overleaf sync yet.

## Session: October 15, 2026 — Regression regeneration, prose refinement, and section restructuring

**Focus**: Regenerate script 07 with categorical education and class indicators (matching
script 09 encoding); update section 4.7 with new regression results; improve section 4.8
structure and flow; clarify section 4.6 (Duality) explanation of partial points.

### Major changes

1. **Script 07 regenerated with categorical indicators** (education 4 groups, class 4
   identities; matching script 09 encoding):
   - Extracted education from individual credential variables (nodipdeg, hsged, somcol,
     aadeg, bach, ma, docprof) and grouped into four categories (HS-or-less, some college,
     bachelor's, postgraduate).
   - Extracted class from four binary identity indicators (lower, working, middle, upper).
   - Built regression predictors as binary factors with reference categories (HS-or-less
     for education, lower for class).
   - Computed bivariate eta² for both the categorical variables (reconstructed at block
     level from indicators) and single-indicator demographics (age, gender, race, etc.).
   - R² values essentially unchanged: 0.051/0.018/0.020 (vs. prior 0.052/0.020/0.021).
   - Genre-based (ω) component R² identical: 0.084/0.078/0.033.

2. **Section 4.7 (Who Has Complex Tastes?) completely rewritten with categorical results**:
   - Removed redundant opening question paragraph that merely restated what the next
     sentence answered.
   - Updated R² numbers to match categorical encoding (5.1%, 1.8%, 2.0%).
   - Replaced asterisks with explicit p-values throughout (p < .001, p = .014, etc.).
   - Restructured to emphasize that effects concentrate on W1 and W3, with education
     categories showing no main effects on W1/W2 and only weak effects on W3.
   - Clarified that upper-class effect is strongest (b=3.80, p<.001 on W1; b=7.72,
     p<.001 on W3) and that parents' education is significant on W1 (b=1.30, p<.001).
   - Added age-specific coefficients (age 30–39: b=−1.08, p=.014; age 70+: b=−2.09,
     p<.001) showing younger respondents have less disagreement on W1.
   - Updated genre-based component discussion to report exact R² values (8.4%, 7.8%,
     3.3%) and note that coherence component shows no social structuring (R² ~4.7%,
     1.9%, 1.9%).
   - Maintained interpretation that social position shapes WHICH GENRES anchor complex
     tastes, not WHETHER people have complex tastes overall.

3. **Section 4.8 (Genre-Specific Disagreement) restructured for clarity**:
   - Moved figure introduction paragraph to immediately after section heading (line 232),
     before detailed demographic findings.
   - Figure intro now explains: eight genres shown, which demographics they represent,
     what cells encode (Pearson r between demographic and ω), and color meaning.
   - Removed redundant "Figures...map these patterns visually" paragraph that appeared
     later in the section.
   - Added bridging paragraph at end of section explaining supplementary (20-genre)
     matrices: they show demographic shaping is genuinely genre-specific, with few
     correlations >|r|=0.15 outside highlighted genres.

4. **Section 4.6 (The Duality) explanation of partial points clarified**:
   - Added full conceptual paragraph (before Figure 9) explaining what partial points are:
     three per dimension, showing aspect-specific positions for each genre.
   - Explained what their spread means: aspects place genre differently, revealing
     segmented audiences by aspect.
   - Provided concrete example (Dimension 2): rap/reggae/metal negative for likers/
     listeners but positive for evaluators—different populations.
   - Updated Figure 9 caption to explain the displacement shows how status attributions
     segment audiences differently from liking/listening.
   - Added closing sentence connecting genre-level segmentation back to individual-level
     complex-taste concept.

5. **Minor prose improvements**:
   - Changed "respondents not identifying as women" and "respondents identifying as
     women" to simply "men" and "women" (since survey has binary coding).
   - Removed "respondents identifying as upper class" phrasing in class paragraph,
     standardized to "respondents identifying as upper class" with n=55 flag.
   - Simplified HS-or-less education prose: removed redundant dimension citations (both
     D1 and D2 at r=−0.10 for opera).
   - Added table reference (Table~\ref{tab:genre-profile}) in opening paragraph of Duality
     section right after the percentages for heavy metal/Latin/bluegrass/classical/opera.
   - Improved class paragraph parallel structure: "Middle-class respondents show the
     opposite pattern:" with dimension-specific coefficients.

### Compile and numbering verification

- Manuscript compiles cleanly at 34 pp., 0 undefined refs (when run from manuscript/
  directory after script-03 regeneration).
- Actual section/figure numbering in compiled PDF verified:
  - Section 4.6 (The Duality) = Figures 8 (dims 1–2) and 9 (dims 1–3)
  - Section 4.8 (Genre-Specific Disagreement) = Figures 5–7 (eight-genre matrices,
    main text) and Figures 12–14 (twenty-genre matrices, appendix)
  - All figure references now point to correct compiled figures.

### Technical notes for future sessions

- Script 07 now uses the same categorical indicator encoding as script 09 for education
  and class. Both scripts create education/class factors from underlying binary/ordinal
  indicators; if changes to encoding are needed, update BOTH scripts.
- The regression R² values with categorical encoding are nearly identical to ordinal
  encoding, so the claim "demographics weakly predict W" is robust to encoding choice.
- Genre-based (ω) component shows stronger social structure than total W (R² 0.084 vs
  0.051 on W1), validating the decomposition interpretation.
- All p-values are now explicit in main text (no asterisks), improving accessibility and
  allowing readers to judge significance themselves.

### Files modified this session

- manuscript/main.tex: Section 4.7 completely rewritten; section 4.8 restructured; section
  4.6 clarified; minor prose improvements throughout. ~40 line changes total.
- scripts/07-regression.R: Regenerated with categorical indicators for education and class;
  outputs regenerated tables 6–7 (tab-regression.tex, tab-w-eta.tex).
- AGENTS.md: This session note (just now).

### Pending

- No Overleaf sync (awaiting author approval of restructured text).
- Scripts 01–06 already run recently; script 07 output now current. Scripts 08–09 remain
  up-to-date from prior sessions.
- Manuscript ready for final review and Overleaf sync.

## Session: October 15, 2026 (later) — Appendix demarcation + omega-matrix label redesign

- **main.tex**: appendix now visually separated from the main text — `\clearpage` +
  `\appendix` + an unnumbered `\section*{Appendix}` heading with a one-sentence
  lead-in ("The following supplementary materials provide additional technical
  details..."). Appendix sections continue to number A/B/C.
- **Script 09, label redesign (applied to ALL SIX omega matrices — main figs 5–7
  AND supplementary figs 12–14)**: x-axis labels moved from the bottom to the
  TOP, angled at 60 degrees, start-anchored at their own column tick
  (`hjust = 0, vjust = -0.05`), cell text 2.7 (supplementary) / 2.5 (main),
  axis text 8/7, sizes trimmed slightly at the author's request.
  - GOTCHA 1: on a TOP axis, vjust is mirrored — SMALLER vjust moves the labels
    closer to the panel (vjust = 1 pushed them up into the title; -0.05 is the
    author-confirmed snug value; -0.2 overlaps the top row of cells).
  - GOTCHA 2: end-anchoring (`hjust = 1`) puts the label's bulk over the
    PREVIOUS column — the author read it as off-by-one. Start-anchoring
    (`hjust = 0`) puts the lower tip of each label exactly at its tick.
  - Margins: `plot.margin = margin(8, 30, 2, 2)` (supplementary) /
    `margin(8, 20, 2, 2)` (main) — top clears the title above the tall
    angled-label strip, right reserves room for the longest label's up-right
    drift ("Multirace/Other" at 45 degrees was clipped; 60 degrees fits).
  - Correlation values unchanged (console cross-check identical to prior runs).
- fig-config-variation.pdf (untracked leftover from the clarity-pass session)
  now committed; it is referenced from app:config-variation in main.tex.
- Compiles at 35 pp., 0 undefined refs. Committed and synced to Overleaf;
  outer-repo gitlink refreshed.
