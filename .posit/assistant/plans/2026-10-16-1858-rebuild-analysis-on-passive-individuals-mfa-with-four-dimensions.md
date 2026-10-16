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

