# Passive-individuals refit: full characterization (Phase 2, 2026-10-16)

Companion to the plan
`.posit/assistant/plans/2026-10-16-1858-rebuild-analysis-on-passive-individuals-mfa-with-four-dimensions.md`.
All numbers from the regenerated pipeline (scripts 02–11 rerun 2026-10-16,
outputs in `output/`, tables in `manuscript/tables/`). Signs are ANCHORED by
script 02's flips + stopifnot checks; re-anchor after any refit.

## 1. Fit construction

- N = 2,259; **1,847 active** (construct the space) + **412 supplementary**
  (constant within ≥ 1 aspect block: pref 83 [38 all-0 / 45 all-20],
  cons 84 [74 all-0 / 10 all-20], eval 326 [321 all-0 + 5 all-20];
  15 constant in all three blocks, 66 in ≥ 2).
- Separate MCA λ1 (active-only): pref 0.155, cons 0.127, eval 0.194
  → balancing weights 1/λ1 = **6.450 / 7.904 / 5.150** (old: 0.200/0.155/0.234 → 5.004/6.452/4.277).
- Eigenvalues: λ1 = 1.605 (8.23%), λ2 = 1.413 (7.25%), λ3 = 1.051 (5.39%),
  λ4 = 0.997 (5.11%), λ5 = 0.853 (4.37%); first 4 dims = 25.97%, first 5 = 30.35%.

## 2. Dimension readings (anchored signs)

**Correspondence with the old all-active fit** (coordinate correlations):
new D1 ↔ old D2 (|r| 0.89), new D2 ↔ old D1 (0.87), new D3 ↔ old D4 (0.97),
new D4 ↔ old D3 (0.95). W scores: newW2 ↔ oldW1 0.94, newW4 ↔ oldW3 0.99,
newW1 ↔ oldW2 0.65, newW3 ↔ oldW4 0.86.

- **D1 = highbrow–popular** (+ = highbrow). cons yes: opera +0.72, big band +0.69,
  classical +0.64, musicals +0.64 vs rap −1.26, indie −1.29, dance/club −1.25,
  reggae −1.17, metal −1.17, cont rock −0.85, top-40 −0.81. pref yes: opera +0.61,
  folk +0.51, big band +0.38 vs rap −1.21, indie −0.99, metal −0.93.
  eval near-inert (yes coords −0.23..+0.39; contribution 1.1%).
  cor(D1, n likes) = −0.31, cor(D1, n listens) = −0.44 — engagement volume tilts popular.
- **D2 = volume** (+ = more engagement). ALL pref/cons yes categories positive
  (0.03–1.35; cons opera 1.13, big band 1.19, folk 1.35, jazz 1.07, musicals 1.03;
  rap/metal/top-40 cons 0.03–0.05 — rare-genre yes answers barely move the axis).
  cor(D2, n likes) 0.83, cor(D2, n listens) 0.75, cor(D2, grants) 0.23.
  eval yes coords 0.03–0.57 (Latin/salsa 0.57, metal 0.51, hymns/gospel, dance/club ~0.4–0.5);
  eval contribution 4.2%.
- **D3 = musical-family contrast** (NEW as a named axis; = old dim 4 promoted).
  + = Black/Latin popular musics + dance: cons reggae +0.95, Latin/salsa +0.76,
  rap +0.61, dance/club +0.29, opera +0.44, jazz +0.28. − = guitar-rock/country
  cluster: cons metal −0.91, indie −0.76, cont rock −0.71, rock'n'oldies −0.50,
  folk −0.43, country −0.35. eval near-inert (contribution 3.1%; yes coords
  −0.33..+0.09). cor with n likes −0.07, n listens −0.11, grants −0.19 —
  NOT a volume or status artifact.
- **D4 = status valuation** (+ = generous). All 20 eval yes categories positive:
  rap +1.94, Latin/salsa +1.94, country +1.67, reggae +1.56, metal +1.52,
  top-40 +1.29, crold +1.21, dance/club +1.03, cont rock +1.05, indie +0.72,
  folk +0.67, hymns/gospel +0.46, jazz +0.46, big band +0.53, musicals +0.24,
  **opera +0.00, classical +0.02** (≈ the no-category baseline; no categories
  span −0.29..+0.12). Ordering by rarity even starker than before.
  eval contribution 91.1%. cor(D4, grants) = 0.88.

### Partial axes (correlations, tab-partial-axes) — STRUCTURE CHANGED

| Global dim | Leading partial axes |
|---|---|
| D1 | pref ax2 −0.89, **cons ax1 −0.83**, cons ax2 +0.45 |
| D2 | pref ax1 +0.83, cons ax2 +0.73, eval ax1 +0.23 |
| D3 | cons ax3 +0.94, pref ax3 +0.88, eval ax2 +0.17 |
| D4 | eval ax1 +0.95 |

Consumption's separate axis ORDER swapped vs the old fit: cons ax1 is a
rarity-weighted volume contrast dominated by popular genres (yes coords all
positive, 0.02–1.21, largest reggae 1.21/indie 1.20/dance 1.15/rap 0.95;
cor with n listens 0.79, with highbrow-cons count 0.05), and it loads −0.83 on
D1 — consumption volume is popular-tilted and lands on the popular side of the
highbrow–popular axis. Cons ax2 (highbrow-weighted: opera +1.50, big band +1.39,
musicals +1.25 vs rap −0.37/metal −0.32; cor with n listens 0.55) carries D2's
consumption side. Preference's order is unchanged (ax1 volume, r 0.99 with
n likes; ax2 highbrow–popular). **The old "ladder shared by preference and
consumption" narrative no longer holds in this form** — the §4.3/4.5 prose must
be reworked around: (a) pref ax1/cons ax2 on volume, (b) pref ax2/cons ax1 on
highbrow–popular.

### RV / Lg / contributions

- RV: P–C **0.353** (old 0.321), P–E **0.014**, C–E **0.015** — evaluation still
  essentially independent. RV with MFA: 0.724/0.773/0.428.
- Lg(h,h) = 3.094/4.061/2.001; Lg with MFA = 2.728/3.336/1.296.
- Contributions (%): D1 pref 44.3/cons 54.6/eval 1.1; D2 52.3/43.4/4.2;
  D3 40.5/56.3/3.1; D4 4.3/4.6/91.1.

## 3. W scores (aspect-disagreement) on dims 1–4

- Mean W: **3.35 / 5.21 / 2.27 / 6.20** (H·mean W totals in tab-pairs:
  10.1/15.6/6.8/18.6 ✓).
- Mean individual disagreement shares W_s/T_s: **49.3 / 55.3 / 51.9 / 65.7%**
  (old: 56/52/63 on 3 dims).
- Per-aspect shares of W: D1 20.5/34.5/**45.1** (evaluation stands apart);
  D2 38.0/28.4/33.6 (even thirds); D3 19.5/38.4/**42.1** (evaluation + consumption
  vs preference); D4 17.1/17.8/**65.1** (evaluation two-thirds).
- Pair decomposition (mean squared pair distances, shares within dim):
  D1: P–C 2.17 (22%), P–E 3.24 (32%), C–E 4.65 (46%);
  D2: 5.17 (33)/5.98 (38)/4.48 (29) — near-even;
  D3: 1.67 (25)/1.92 (28)/3.21 (47);
  D4: P–C 0.29 (2%), P–E 9.08 (49%), C–E 9.22 (50%).
- ρ(n_complex, W_s): Pearson **0.20 / 0.45 / 0.18 / 0.08**; Spearman
  0.17/0.28/0.18/−0.11. NOTE: configurations now correlate with the VOLUME
  disagreement (0.45) more than with any positioning dimension — a reversal of
  the old pattern (0.31 on old volume W1, 0.19 old W2, −0.06 old W3).
- W4 squared-position diagnostics: cor(W4, |F4|) = 0.80 (W2/|F2| = 0.55);
  mean W4 = 5.2 among zero-grant respondents, 182.4 among grant-all-20.
- Partial point sds (active): pref 1.82/2.15/1.39/0.50; cons 2.19/1.88/1.84/0.53;
  eval 0.23/0.59/0.39/**2.86** — evaluation near-inert on dims 1–3, dominant on D4.

### Genre-level decomposition (ω / γ)

- Worked examples: **362**: W1 7.01, W2 0.13, W3 0.27, **W4 155.68**
  (= 11.24 genre-based + 144.44 coherence, 93% coherence); 13 complex configs
  (unchanged). **1881** (now a SUPPLEMENTARY individual — partial points are
  projections): W1 9.61, **W2 36.29** (5.31 + 30.98, 85% coherence), W3 0.79,
  W4 2.80. The 362/1881 contrast is now sharpest on D2 (0.13 vs 36.29) and
  D4 (155.7 vs 2.8).
- Coherence γ: means 1.75/3.58/0.63/4.76; negative-coherence shares
  33/25/**52**/30% (half the sample has cancelling per-genre disagreements on
  the musical-family axis).
- R² (same 16-indicator predictors): ω **0.222/0.079/0.201/0.030**;
  γ 0.035/0.035/0.071/0.018; W 0.044/0.036/0.100/0.019. The genre-based
  component is now MUCH more socially structured than before (old ω R²
  0.085/0.080/0.033) — demographics shape which genres anchor disagreement,
  especially on D1 and D3.

## 4. Social anchoring

- η² (supplementary demographics, dims 1–4):
  D1: age 0.313 (18–29 −0.81 → 70+ +1.40), race 0.068 (Hispanic −0.59,
  >1 race −0.63, White +0.22, Black −0.26), sclass 0.035, educ 0.032
  (gradient concentrated at the top: MA +0.48, Prof/PhD +0.65 vs some college −0.17).
  D2: educ 0.032 (No diploma −0.59 → Prof/PhD +0.32), sclass 0.011, age 0.013.
  D3: **race 0.245** (Black +1.19, >1 race +0.42, Hispanic +0.41, Asian +0.28,
  White −0.25), age 0.034 (non-monotonic: 18–39 ≈ +0.28, 50–69 ≈ −0.1, 70+ +0.18),
  sclass 0.016, region 0.014. **D4: all ≤ 0.011 (socially flat, as before).**
- η² with W1–W4 (tab-w-eta): uniformly tiny; largest cells age→W1 0.032,
  age→W3 0.040, race→W3 0.064, sclass→W2 0.014, parentba→W2 0.013.
- Regression (tab-regression, R² **0.044 / 0.036 / 0.100 / 0.019**):
  - W1: age decline (30–39 −0.82*** … 60–69 −1.59***, 70+ −0.33 n.s.),
    education + (0.45/0.42/0.62*), Hispanic +0.44*, South −0.42*, West −0.60***.
  - W2 (volume): parents' BA +1.52***, upper class +4.54***, >1 race +2.24*
    — the old W1 story moved here.
  - W3 (musical-family): **Black +1.61***, >1 race +1.41***, Hispanic +0.52***,
    age 60–69 −0.77***, 70+ −0.93***, Midwest −0.47**, South −0.35*, West −0.60***,
    income 75k+ −0.39*. R² 0.100 — the most socially structured disagreement score.
  - W4 (status): upper class +9.16***, some college −2.11*, bachelor's −2.10,
    Hispanic +2.12*, age 30–39 +2.42*, 40–49 +2.31*.

## 5. Transposed MFA (rebuilt on the 1,847 active rows)

- λ: 2.246/1.931/1.247/1.115/0.934. Genre RVs: P–C **0.915**, P–E 0.532,
  C–E 0.476 (old 0.92/0.53/0.49 — essentially unchanged).
- tD1 = old tD1 sign-flipped: + classical +3.48, opera +3.05, musicals +1.99,
  big band +1.22 (status-without-engagement genres); − top-40 −2.13, crold −1.57,
  rap −1.60, cont rock −1.42 (guilty/distanced targets).
- tD2 = old tD2 sign-flipped: + rap +1.72, reggae +1.54, metal +1.33,
  Latin/salsa +1.35 (simple-non-taste genres); − crold −3.50, moodez −2.12,
  country −1.72 (actively-held genres).
- tD3 NEW: + country +2.44, hymns/gospel +2.19, bluegrass +1.37, folk +1.07;
  − top-40 −1.62, cont rock −1.59, classical −1.35, indie −1.26.
- tD4: + blurb +1.81, moodez +1.70, jazz +1.65, rap +1.01; − country −1.72,
  metal −1.47, bluegrass −0.98, folk −0.91.
- Aspect contributions (tD1–tD4, pref/cons/eval %): 33.5/31.6/34.9;
  48.9/45.3/5.8; 44.8/41.1/14.2; 49.1/43.6/7.2. Transposed-group λ1:
  0.153/0.161/0.419.

## 6. Configuration signatures (Spearman, for fig-signatures)

Selected cells: guilty F1 −0.50/F2 +0.52/F4 −0.40 (ω1 0.50, ω3 0.47);
distant praise F4 +0.69 (ω4 0.50); pose F4 +0.42 (ω4 0.48);
justified ω3 0.24/ω1 0.24; distanced ω3 0.31; pre-acquired ω4 0.23;
simple non-taste F2 −0.79, ω1 −0.63/ω2 −0.66/ω3 −0.62/ω4 −0.40;
simple taste F2 0.46/F4 0.36, ω4 0.54; n_complex F1 −0.40/F2 0.66,
ω1 0.61/ω2 0.58/ω3 0.63/ω4 0.24. Prevalence unchanged (guilty 3.2, justified 3.3,
distant 2.2, pose 1.0, distanced 0.4, pre-acquired 0.1, simple_neg 8.9,
n_complex 10.2; 12 zero-config respondents).

## 7. Inverted robustness (script 11: main passive vs sensitivity all-active)

- Eigen: 1.605/1.413/1.051/0.997 vs 1.509/1.178/0.982.
- Separate λ1: 0.155/0.127/0.194 vs 0.200/0.155/0.234.
- RV: 0.353/0.014/0.015 vs 0.321/0.013/0.014.
- Coordinates: D1↔oldD2 0.89, D2↔oldD1 0.87, D3↔oldD4 0.97, D4↔oldD3 0.95.
- W: W2↔oldW1 0.94, W4↔oldW3 0.99, W1↔oldW2 0.65, W3↔oldW4 0.86.
- Shares: 49.3/55.3/51.9/65.7 vs 55.9/52.1/63.0 (3 dims).

## 8. Figure/asset state after Phase 1

- New/renamed: fig-categories-d14, fig-genre-map-d14 (planes (D1,D2) + (D1,D4)),
  fig-dim3.pdf (script 05, unreferenced), fig-omega-demographics-dim4,
  fig-omega-demographics-genres-d4. Deleted: fig-categories-d23,
  fig-genre-map-d13. Script 09 key genres: rap, indie, dance/club, classical,
  opera, musicals, big band, Latin/salsa (same 8).
- All tables regenerated with 4 dimension columns (tab-eigen, tab-groups,
  tab-partial-axes, tab-pairs, tab-rv, tab-eta, tab-sup-coord, tab-regression,
  tab-w-eta, tab-coherence-eta, tab-coherence-regression).
