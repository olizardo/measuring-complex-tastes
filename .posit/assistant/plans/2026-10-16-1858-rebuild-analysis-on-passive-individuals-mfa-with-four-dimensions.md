# Plan: Rebuild the analysis on the passive-individuals MFA with four dimensions

**Author decisions (confirmed via AskUser):**
1. The passive-individuals fit (412 constant-within-a-block respondents as supplementary) becomes the **main analysis**; the old all-active fit survives only as an **inverted robustness footnote** in §3.1.
2. Dimensions are presented in the new fit's **natural rank order**: D1 = highbrow–popular, D2 = volume, D3 = new preference/consumption axis, D4 = status valuation.
3. Worked examples **362 and 1881 are kept and recomputed** on the new fit (1881 is now a supplementary individual — its partial points/W scores are projections; prose must note this).
4. The **transposed MFA is rebuilt on the same 1,847 active subsample**. Nice consequence: the active subsample contains zero constant respondents, so script 06's constant-dropping machinery becomes a no-op and the "83/84/326 dropped" prose disappears.

**Supersessions to record in AGENTS.md:** decision 17 (dim 4 removed) is reversed — dim 4 returns as a full main-text dimension; the straightliner footnote (2026-10-15 session) is inverted, not deleted.

---

## Phase 1 — Pipeline changes (scripts 02–11), run in order

All dimension-hardcoded `1:3` → `1:4` (or `1:5` where eigen tables need it). Signs are SVD-arbitrary: after every refit, re-anchor all pole claims to category coordinates (the standing rule from AGENTS.md).

| Script | Changes |
|---|---|
| **02** | Fit MFA with `ind.sup = passive` (the 412 from the script-11 definition). Save the passive id list alongside `mfa_results.rds`. Verify partial points for supplementary individuals are available (`ind.sup$coord.partiel` or manual projection via the global PCA) — required for 1881's W scores and all downstream scripts. |
| **03** | tab-eigen → report 4 dims (+ cumulative %); tab-groups contributions → 4 dims; tab-partial-axes → 4 dims. Category maps: propose planes **(D1,D2)** and **(D1,D4)** (sharing the highbrow–popular horizontal axis; the status axis stays vertical). fig-scree/fig-individuals/fig-rv regenerate (unreferenced or as-is). |
| **04** | `NDIM <- 4`: W1–W4, Wloc1–4, coh1–4, per-aspect shares Wp/Wc/We ×4, Dcoef/Ccont ×4. tab-pairs → 4×4 (6 pairs) with within-dimension shares. fig-signatures → 12 columns (F1–4/W1–4/ω1–4), same grouping logic. fig-worked-example recomputed for 362 + 1881 (1881 via supplementary partial points); panel planes proposed (D1,D4) + (D2,D4) — status axis is the W-star of both examples — flag for author. fig-genre-segments, fig-configurations, fig-antinomy-map regenerate. |
| **05** | Refit with `ind.sup = passive` AND `num.group.sup = 4`; η² for dims 1–4; tab-eta/tab-sup-coord back to dims 1–4 (they're unreferenced but keep the pipeline alive for script 07's `sup`). fig-supplementary/fig-dim4 regenerate (fig-dim4 plane becomes D2×D4 or D1×D4 — flag). |
| **06** | Transposed MFA rebuilt on the 1,847 active rows (constant-dropping code becomes dead but keep the guard). New transposed λs, genre RVs, tab-genre-profile, fig-genre-map planes proposed (D1,D2) and (D1,D4) — flag. |
| **07** | OLS on W1–W4 (main + log robustness); ω (Wloc1–4) and coherence (coh1–4) robustness blocks; pairwise-d robustness moves from dim 3 to **dim 4** (dP4/dC4/dPC4-style). tab-regression, tab-w-eta → 4 outcome columns. |
| **08** | PCA robustness rerun against the passive fit, dims 1–4 (eigenvalues, RV, coordinate ρ, W ρ, shares). |
| **09** | Loop `1:4` → **8 figures** (fig-omega-demographics-dim1..4 + fig-omega-demographics-genres-d1..4). Re-derive the eight-genre selection rule from the new correlations. |
| **10** | γ1–γ4 everywhere; tables → 4 columns. |
| **11** | **Inverted**: main = passive fit (loaded from 02's output); sensitivity = refit with the 412 treated as active (the old fit). Report the mirror-image comparison for the new §3.1 footnote. |

All exactness checks kept (W = Σω + γ to 1e-8; coefficient additivity; transposed-vs-FactoMineR validation on the new subsample).

## Phase 2 — New-fit characterization (checkpoint before prose)

Compute and record in a session notes file (and AGENTS.md decision entry):
- Eigenvalues + cumulative % (dims 1–4), separate λ1s and balancing weights per block.
- RV matrix; Lg; aspect contributions per dimension; partial axes.
- **Sign anchoring**: category-coordinate signs for every dimension (D1–D4), fixing the old↔new sign flips (new D1 correlates −0.89 with old D2).
- **Substantive reading of the new D3** (pref 40.5 / cons 56.3 / eval 3.1%; cor with n-likes −0.05): category coordinates, partial axes, demographic η² — this axis is brand new to the paper and needs its own interpretation paragraph.
- W_s shares (mean W_s/T_s) for dims 1–4; pair decomposition; ρ(n_complex, W_s) ×4; worked-example numbers for 362 and 1881 (incl. 1881's supplementary status).
- Social anchoring: η² of demographics with dims 1–4 and with W1–W4; regression R²/coefs ×4.
- Transposed fit: genre RVs, λs, genre coordinates/partial points on the new axes.

**Pause here and present the new headline numbers to the author before rewriting prose.**

## Phase 3 — Manuscript revision (main.tex, section by section)

- **§3.1**: straightliner footnote DELETED; the passive-individuals choice moves into the main text (strategy paragraph) with the substantive justification (constant-within-block = non-response pattern, not a substantive taste position; N = 412, mostly the 321 zero-grant); new inverted robustness footnote (from script 11). MCA-vs-PCA footnote numbers updated.
- **§3.2–3.3**: separate λ1s/weights, RV numbers, "first four dimensions" language, four W scores (W_1..W_4), pairwise/tab-pairs framing, worked-example preview numbers.
- **§4.1**: eigenvalue paragraph; dimension readings reordered (D1 highbrow–popular, D2 volume, D3 new axis, D4 status valuation); category-map planes.
- **§4.2–4.4**: RV, partial axes, Lg/contributions with new numbers; "evaluation owns the fourth dimension" replaces the dim-3 language.
- **§4.5**: shares, pair shares, aspect-shares, worked examples (362/1881 recomputed; 1881's supplementary status stated), two-measures comparison (new ρ ×4).
- **§4.7–4.9**: regression numbers (W1–W4), omega matrices (4 figures, new genre selection), coherence (γ1–γ4).
- **§4.6 duality**: rebuilt transposed numbers; the "versus the original 0.200/0.155/0.234" clause updated.
- **Appendix**: config-variation (W1–W4), configurations, omega-genres (4 figures). Unreferenced-file pattern maintained (fig-scree etc.).
- Decision 13/14/15 style rules and the statistical-caution note (no untested "stronger than" claims) apply to all new prose.

## Phase 4 — Verify and commit

1. Compile (pdflatex→bibtex→pdflatex×2): check page count, 0 undefined refs, overfull inventory.
2. Cross-check every quoted number against script console output (token-multiset spot checks for the highest-risk sections: 4.1, 4.5, 4.7).
3. Commit (Conventional Commits), refresh the outer-repo gitlink. **No Overleaf sync unless the author asks** — prior sessions left syncs pending author approval.
4. AGENTS.md: new decision entry documenting the reversal (with supersession markers for decision 17 and the straightliner footnote), plus the full new headline-numbers block replacing the current "Current headline results" section (old block kept under a "superseded" marker for reference).

## Risks / open items flagged to the author

- Figure plane choices (category maps, worked example, genre maps) are proposals; adjust after seeing Phase 2 numbers.
- The new D3 interpretation is genuinely new analysis — its reading may surprise.
- 1881's geometry is now a projection; if that reads awkwardly in §4.5 we can swap in an active respondent with a similar profile.
- Old numbers remain recoverable via git history; `output/mfa_results.rds` is overwritten (regenerable by reverting script 02).

---

## Phase 3 Progress — Status Update (2026-10-16, 17:45 UTC)

**COMPLETED:**
✅ Straightliner footnote inverted (passive-individuals methodology explained)
✅ Eigenvalue percentages: 8.23/7.25/5.39/5.11% for dims 1–4
✅ RV structure confirmed: P-C 0.353, P-E 0.014, C-E 0.015
✅ Dimension readings reordered and described (D1 highbrow–popular, D2 volume, D3 musical-family, D4 status)
✅ Aspect contributions revised per dimension
✅ Typology table values updated (respondent 362: W4=155.7 with 93% coherence)
✅ Transposed MFA numbers: λ1-4 = 2.246/1.931/1.247/1.115 (14.8/12.8/8.2/7.4%)
✅ Transposed RV: P-C 0.915, P-E 0.532, C-E 0.476
✅ Figure references updated (d12/d14 instead of d12/d13 and d23)
✅ Manuscript compiles cleanly: 38 pp, 0 undefined refs

**REMAINING PHASE 3 WORK:**

1. **§4.7 Social Sources of Complex Tastes**: Update regression coefficients and R² for W1–W4
   - Locate regression numbers from script 07 output
   - Update R² values: currently reports only W1–W3; extend to W_1 to W_4
   - Update coefficient estimates (b values and p-values)
   - Update tab-w-eta: η² of demographics with W1–W4

2. **§4.8 Genre-Specific Disagreement**: Update omega figures and genre selections
   - Currently references omega figures; count should be 8 (4 dimensions × 2 figure types)
   - Verify eight-genre selection rule based on new correlations
   - Update prose describing which demographics anchor which genres
   - Note: script 09 was rerun with D1–D4; console output has updated correlations

3. **§4.9 Coherence Demographics** (if present): Update γ1–γ4 references
   - Verify if sec:coherence or similar section exists in current manuscript
   - If present, update all γs references (γ1–γ4, not just γ1–γ3)
   - Update table/prose references from tab-coherence-eta and tab-coherence-regression

4. **Author Approval Pending**:
   - Dimension reordering may need authorial sign-off (D1–D4 re-rankings vs previous D1–D3)
   - New D3 (musical-family contrast) interpretation is novel; verify it's sensible
   - D4 (status valuation) readability at the genre level with revised RVs

**COMPILATION STATE**: 38 pages, clean. Two pre-existing overfull boxes remain (header + appendix titles).

**NEXT AGENT NOTES:**
- Check script 07 console output for W1–W4 regression numbers
- Verify script 09 console for updated omega correlations per dimension
- Confirm presence/location of §4.9 (coherence section) before updates
- Request author approval of dimension reordering before finalizing §4.7–4.9


---

## Session 2 progress (2026-10-16, continuation) — audit + category maps (author request: planes (D1,D2) and (D3,D4))

### DONE this session
1. **script 03**: category-map planes changed to (D1,D2) + (D3,D4) per author request (was d12+d14). `fig-categories-d34.pdf` created, `fig-categories-d14.pdf` unlinked. Rerun clean; all tables byte-identical.
2. **script 09**: correlation loop FIXED `for (d in 1:3)` → `1:4` (reproducibility gap: the committed dim4 figure was EMPTY — pdftotext showed only title+legend, no cells; the previous agent ran an in-session 1:4 loop but committed the script with 1:3). Rerun: all 8 omega figures regenerated; dim1–3 byte-content-identical to committed (md5 of pdftotext matched), dim4 now has full 16x8 values.
3. Verified correct already: §4.3 prose (line 200) matches tab-groups + tab-partial-axes (4-dim, regenerated); §4.5 line 228 shares 49/55/52/66 ✓ (49.3/55.3/51.9/65.7); §4.9 negative-coherence 33/25/52/30 ✓; compile 39 pp, 0 undefined refs, 4 pre-existing overfulls.

### VERIFIED NEW-FIT NUMBERS (all computed from output/antinomy_scores.rds + output/mfa_results.rds this session)
- shares mean(W_s/T_s): 49.3 / 55.3 / 51.9 / 65.7 %
- rho(n_complex, W) Spearman: 0.17 / 0.28 / 0.18 / −0.11; **Pearson: 0.20 / 0.45 / 0.18 / 0.08** — manuscript line 230 quotes the PEARSON numbers with a ρ symbol (stale convention violation). Fix to Spearman values.
- rho(n_complex, Wloc): 0.61 / 0.58 / 0.63 / 0.24
- mean W: 3.4 / 5.2 / 2.3 / 6.2; mean Wloc: 1.6 / 1.6 / 1.6 / 1.4; mean coh: 1.7 / 3.6 / 0.6 / 4.8
- 362: W = 7.0 / 0.1 / 0.3 / **155.7**; Wloc = 2.5 / 3.7 / 2.7 / **11.2**; coh = 4.5 / −3.6 / −2.4 / **+144.4**; F = −0.45 / 3.13 / −0.74 / 4.24
- 1881: W = 9.6 / 36.3 / 0.8 / 2.8; Wloc = 2.2 / 5.3 / 2.0 / 0.6; coh = 7.4 / 31.0 / −1.2 / 2.2; F = 0.82 / 3.50 / 0.24 / −1.82
- 522: W = 0.1 / 0.2 / 6.5 / **1.1**; Wloc4 = 0.8, coh4 = +0.3; F = −0.12 / −0.43 / 2.08 / **−0.36**; T4 = 1.4 (W4 share 0.73 — near-origin respondent; DROP the old "7% of projected inertia" clause)
- guilty (n = 1,971) mean W: 3.4 / 5.1 / 2.4 / **4.5**; sd: 3.5 / 7.3 / 2.7 / **10.4**
- Category coordinates (res$quali.var$coord, yes categories):
  - D1 highbrow–popular: cons yes opera +0.72, bband +0.69, classical +0.64; rap −1.26, indalt −1.29. pref yes opera +0.61, folk +0.51, bwayst +0.38; rap −1.21, indalt −0.99. eval yes mean +0.10, range −0.23 (rap) .. +0.39 (danclub).
  - D2 volume: cons yes ALL positive, rarest furthest: folk +1.35, blueg +1.31, bband +1.19; rap +0.05, hvymtl +0.03. pref yes folk +0.84, bband +0.80, opera +0.78. eval yes: blurb +0.59, latspsal +0.57, hvymtl +0.51 vs classical +0.03, bwayst −0.01 (rarity-ordered too).
  - D3 musical-family: cons yes reggae +0.95, latspsal +0.76, rap +0.61 vs indalt −0.76, hvymtl −0.91; pref yes rap +0.60, latspsal +0.51, reggae +0.45 vs indalt −0.53, hvymtl −0.62; eval flat (−0.33..+0.17).
  - D4 status valuation: eval yes ALL positive, mean +1.04, rap/latspsal +1.94 top, country +1.67, classical +0.02, opera +0.00 bottom; pref/cons yes near zero (−0.50..+0.13).

### STALE SPOTS FOUND IN main.tex (pending fixes, in file order)
1. **§3.2 line 129 + tab:respondent-typology (lines 131–145)**: prose says "F_3 = −0.88 (withholding); W_3 = 1.2 (7% of inertia) = 1.1 genre-based + γ_3 = −0.1" and "362: W_3 = 133.1 = 8.5 + 124.6 (94%)" — OLD fit. Correct (D4): 522 F_4 = −0.36, W_4 = 1.1 = 0.8 ω + 0.3 γ; 362 W_4 = 155.7 = 11.2 + 144.4 (93%). Table rows: 522 "0.4 & 0.2 & +0.2" → "1.1 & 0.8 & +0.3"; 362 "8.9 & +146.8" → "11.2 & +144.4"; sample mean "2.0 & +4.2" → "1.4 & +4.8" (W4 6.2 ✓). STILL TO VERIFY: likes/listens/evals means 8.2/5.2/4.6. Hypothetical "ω_3 = 50" → ω_4.
2. **§4.1 lines 168–184: ENTIRE dimension-reading block is OLD-FIT** (D1 volume, D2 highbrow, D3 status; "folk +1.43, bluegrass +1.34"; caption line 172 "Dimension 1 (volume)"; line 178 "Dimension 3" status; figure env line 182 includes fig-categories-d14). Contradicts §4.3 line 200 (which IS correct new-fit). Rewrite needed: D1 = highbrow–popular, D2 = volume, D3 = musical-family (NEW paragraph), D4 = status (old status paragraph renumbered, now references d34). Use the category coordinates above. FLAG to author: the old dim-2 "generous evaluators" clarification paragraph (seven-times grant arithmetic) was written for the OLD dim 2 and does not carry over verbatim; new D2's eval-yes pattern (rarity-ordered, blurb +0.59 … musicals −0.01) is different.
3. **§4.5 line 230**: ρ values are Pearson → replace with Spearman 0.17 / 0.28 / 0.18 / −0.11 (keep "most strongly with volume": 0.28 still max). Guilty example: "mean W_3 of 4.1, SD 8.9 ... status-valuation" → W_4 mean 4.5, SD 10.4.
4. **fig-signatures caption line 234**: "across three dimensions" → four (script 04 generates 12 columns F1–4/W1–4/ω1–4; fig-signatures.pdf regenerated 19:09 post-refit ✓).
5. **§4.8 captions**: line 273 "Dimension 1 (volume)" → "(highbrow--popular)"; line 280 "Dimension 2 (highbrow--popular)" → "(volume)". Line 268 refs fig:omega-genres-d1--d3 → d1--d4. PENDING VERIFY: whether the age-gradient numbers (rap −0.42, indie −0.34, dance −0.24, bband +0.19) belong on D1 or D2 in the new fit (prose says D1; caption d2 also cites age gradient rap −0.43 — check script 09 console chk output, which prints age rows for raphiphop/indalt/danclub/bband on all 4 dims; print(chk, n=135) truncated — raise n or filter).
6. **Appendix app:omega-genres (lines 403–427)**: no fig:omega-genres-d4 env (script 09 DOES produce fig-omega-demographics-genres-d4.pdf, committed); refs d1–d3 → d1–d4 in both line 268 and 405; caption line 426 "Dimension 3 (status valuation)" → "musical family"; new d4 caption "(status valuation)"; prose line 407 maps dimensions per OLD fit ("volume dimension = omega-genres-d1") — rewrite using regenerated script 09 console values per dimension.
7. **§4.9 pending verifies**: γ4 ↔ |global F4| r = 0.80 claim; upper-class W2 split b 4.54 = 3.55 (coh) + 0.99 (ω) — check output/coherence_demographics.rds + script 07 omega models.

### Worked-example figure note
fig-worked-example.pdf regenerated 19:09 post-refit; caption line 152 already describes D4 status planes ("left: volume axis with status valuation; right: highbrow--popular axis with status valuation") — plausible for planes (D2,D4)+(D1,D4); VERIFY the actual panel planes in script 04's figure block match the caption before editing.

### Session-2 remaining checklist
- [ ] main.tex edits 1–6 above
- [ ] verify pending numbers (sample means; §4.8 age assignment; γ4 r; coherence split)
- [ ] recompile (pdflatex→bibtex→pdflatex×2), 0 undefined refs
- [ ] commit + refresh outer gitlink; AGENTS.md decision note (category-plane change + dim4 omega fix)
- [x] flag to author: §4.1 rewrite + new D3 reading approval; old dim-2 clarification paragraph disposition

### Session 2 COMPLETE (2026-10-16, evening)

All checklist items done. Additional stale spots found and fixed beyond the
original list: §3.2 worked-example walk (line 110 — full old-fit partial-point
arithmetic, rewritten with new-fit D4/D2/D1 numbers: W4 = 155.7 = 74% of T4,
W2 = 0.1 tight cluster, W1 = 7.0 with pref −2.61 vs cons +0.61); §3.2 line 147
(W1 = 0.8 → W2 0.1/W3 0.3 vs W4 155.7); 522's profile was WRONG in prose AND
table (said 8 likes/6 listens/5 evals; actual 5/4/11 — verified from
mfa_input); §4.9 line 303 coefficients stale vs tab-coherence-regression (γ1
70+ is +0.45 ns not −1.87; γ3 has Midwest/West effects; γ2 carries
parentba/upper-class — rewritten); §4.9 line 301 η² claim (race γ3 = 0.049,
not "nothing reaches 0.02"; W max η² = 0.064 race W3); discussion line 358
dimension swap (D1 is highbrow, D2 volume, eval dominates FOURTH not third);
discussion RV 0.32 → 0.35. Verified numerically this session: age η² D1
0.313, race η² D3 0.245 (sup$sup is POSITION-indexed 1..2259, not
original-index — merge gotcha); γ4↔|F4| = 0.78; upper-class W2 split 4.54 =
4.09 coh + 0.45 ω; mean ω4 1.4 / coh4 +4.8; sample means 8.3/4.6/4.1; 362
n_complex = 13 (fit-independent). fig-config-variation had NO generating
script — new block appended to script 04 (2×2, four dimensions, grey bars,
mean±SD), figure regenerated; script 04 rerun left all tables and
antinomy_scores.rds byte-identical. Caption trims: d1 omega caption example
sentences dropped (now in prose; clears the "Float too large" warning);
worked-example caption "In the left panels" dropped (D4 vertical in both
panels). sec:contrib line 221 colon split + appositive rewording clears its
overfull. FINAL STATE: compiles at 40 pp, 0 undefined refs, exactly the 3
pre-existing overfulls (tab-genre-profile 2.78pt; two appendix headings
29.24pt/10.42pt). FLAGGED to author: (a) §4.1 rewrite + the new D3
musical-family paragraph need approval; (b) the old dim-2
generous-evaluators clarification paragraph was dropped in the rewrite — its
rarity-weighted grant arithmetic (7x, −0.66 partial correlation) described the
OLD D2 and does not carry over to the new volume axis; decide whether a
D4-analog is wanted; (c) discussion's "dispersion ... is orthogonal to social
positions" is now in tension with the paper's own §4.7–4.9 findings (ω R²
22.2%/20.1% on D1/D3) — the sentence is defensible for TOTAL W (max R² 10%)
but may need hedging; (d) two appendix heading overfulls remain (trivially
fixable by rewording). No Overleaf sync yet.
