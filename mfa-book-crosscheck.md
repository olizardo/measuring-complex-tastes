# Cross-Check: Manuscript Measures and Equations vs. Pagès (2014)

Reference: Jérôme Pagès, *Multiple Factor Analysis by Example Using R* (CRC Press, 2015),
stored as `Multiple Factor Analysis by Example Using R_26_10_06_18_01_12.pdf`.
Page numbers below are the **printed** book pages. In this PDF copy, PDF page = printed
page + 15 (e.g., printed p. 108 is PDF page 123). The book's PDF page numbering is
itself shifted chapter by chapter only if you use a different copy — if so, use the
section numbers, which are stable.

Each entry gives: the manuscript location, the manuscript's definition, the Pagès
counterpart (section + pages), and a status line.

---

## Notation dictionary

| Manuscript | Pagès | Notes |
|---|---|---|
| aspect / block $h$, $h = 1,\dots,H$ ($H = 3$) | group of variables $j$, $j = 1,\dots,J$ | Book reserves "group" for the block; we reserve it sociologically (msq. decision 7/10) |
| $F_s(i)$, global (compromise) coordinate | $F_s(i)$, mean individual | Book: "mean individual" $i$ appears at the barycentre of its $J$ partial points, all of equal weight (§5.2, pp. 104, 106) |
| $F_{sh}(i)$, partial coordinate | $J \cdot F_s(i^j)$ | **Dilation convention.** Pagès' raw partial point $i^j$ has coordinate $F_s(i^j)$; for graphs partial points are *dilated by the $J$ coefficient* so that $i$ is the barycentre. Our $F_{sh}(i)$ **is** the dilated version (what FactoMineR stores in `ind$coord.partiel`). |
| $W_s(i)$ | within-class inertia of $N_i^J$ along axis $s$ | §5.4 (see entry 6) |
| $\lambda_{1h}$, separate first eigenvalue | $\lambda_1^j$ | |
| balancing weight $1/\lambda_{1h}$ | variable weight $1/\lambda_1^j$ (qualitative: per-category $1/(Q_j \lambda_1^j)$) | |

---

## 1. Two-step construction and block weighting by $1/\lambda_1$

**Manuscript:** Analytic Strategy, "Constructing the Global Complex Taste Space"
(separate MCA per aspect; global analysis over all 60 columns, each block weighted by
the inverse of its separate first eigenvalue). Balancing weights also quoted in
sec:contrib footnote (5.00 / 6.45 / 4.28) and tab-groups.

**Pagès:** §4.3 "Weighting Variables in MFA", pp. 82–86. The two defining features
(p. 83): (1) the weight is the same for every variable of a group, so within-block
inertia is not distorted; (2) maximum axial inertia is standardized to 1 by giving each
variable weight $1/\lambda_1^j$ — "the PCA of the full table with these weights is the
core of the MFA." Immediately verified on the toy table: after weighting, "the groups'
contributions to the first axis … are identical. Weighting has worked perfectly" (p. 83).

**Qualitative version (our case):** §8.2 "MFA of Qualitative Variables", esp. p. 163:
each category of group $j$ has its MCA weight divided by $\lambda_1^j$ (first eigenvalue
of the separate MCA of group $j$); each indicator variable gets weight
$1/(Q_j \lambda_1^j)$. Also §8.2.1 and §8.3.1 (weighting for mixed data, pp. 160, 168).

**Status: direct match.** One verification note for the math review: FactoMineR's
realized global per-column weight is $(1-p_j)/(J\,\lambda_{1h})$ (category mass $p_j$),
i.e., the standard MCA weight times the block's $1/\lambda_{1h}$ — consistent with
Pagès' "divide the weight of each category by $\lambda_1^j$."

---

## 2. RV coefficient

**Manuscript:** Analytic Strategy, "Independence or Redundancy…" (+ combined formula
footnote); Table tab-rv; sec:rv.

Definition (footnote): for each block $h$, configuration matrix
$\mathbf{S}_h = \mathbf{Z}_h \mathbf{W}_h \mathbf{Z}_h'$; RV compresses the similarity of
the two blocks' inter-individual distance structures; 0–1, multivariate analog of a
squared correlation.

**Pagès:** §7.2 "Scalar Product and Relationship Between Groups of Variables",
pp. 133–139, subsection "Lg and RV", pp. 137–138:

$$RV(K_j, K_l) = \frac{\langle W_j, W_l\rangle_D}{\|W_j\|_D \|W_l\|_D}$$

- $RV = 0$ iff every variable of one group is uncorrelated with every variable of the
  other (p. 138) — matches our RV-0 gloss.
- $RV \le 1$, attained iff the two clouds of individuals are **homothetic** (p. 138) —
  matches our RV-1 "same shape / fixed multiple of distances" gloss.
- Single-variable blocks: the scalar product reduces to $r^2(v,z)$ (pp. 133–136) — our
  "squared correlation" framing.
- Figure 7.2 (p. 137) gives RV/Lg values in nine typical cases — the best single figure
  for reviewing what the coefficient responds to.
- Cloud-shape = inter-point distances framing: §5.1, pp. 102–103 ("we define the shape
  of a cloud of points by all of its interpoint distances").

For qualitative groups the underlying relationship measurement is built on squared
correlation ratios rather than correlations: §8.2, p. 164 ("this Lg measurement is
based on the correlation ratio (and not the …)").

**Status: direct match.** One flag: see entry 3's citation note.

---

## 3. Lg coefficient

**Manuscript:** Analytic Strategy, "Interpretation of Complex Taste Space Dimensions"
(+ footnote); Table tab-groups "Lg with the MFA" column; sec:contrib and the
Lg-magnitude guard.

Manuscript footnote: $Lg(h,k) = \mathrm{tr}(\mathbf{S}_h \mathbf{S}_k)/N^2$
(respondents equally weighted; MCA column weights absorb the balancing);
$Lg(h,h)$ = sum of squared eigenvalues of the separate analysis in the global metric;
$Lg(h, \mathrm{MFA})$ normalizes the global analysis as a block by its $\lambda_1$.
Prose quotes the book's "number of common dimensions, each weighted by its inertia"
with cite p. 137.

**Pagès:**

- Formula, §7.2, p. 137:
  $$Lg(K_j, K_l) = \frac{\langle W_j, W_l\rangle_D}{\lambda_1^j \lambda_1^l}$$
  — the balancing appears explicitly in the denominator; with it absorbed into the
  global column weights (our setup), this is the same quantity as our
  $\mathrm{tr}(\mathbf{S}_h \mathbf{S}_k)/N^2$.
- Choice rule, p. 138: "RV or Lg is chosen according to whether we want to distinguish
  between … two one-dimensional homothetic structures and … two multidimensional
  homothetic structures"; "In RV, without paying attention to the dimension of this
  common structure. In Lg, taking into account the dimension of this common structure
  and its inertia relative to that of the groups. Lg is in some ways a 'number of
  common dimensions', each 'weighted' by its inertia."
- $Lg(h,h)$ = norm in the groups' space: §7.3, pp. 139–140, with Table 7.1 (p. 140)
  showing exactly the "eigenvalues divided by the first of them, squared and cumulated"
  structure — i.e., $Lg(K_j,K_j) = \sum_s (\lambda_s^j/\lambda_1^j)^2$.
- Group-vs-axis version: §7.4, pp. 140–141 — the coordinate of group $K_j$ on axis
  $w_s$ of the relationship square is $Lg(F_s, K_j)$, read as the projected inertia of
  $N_{K_j}$ on $v_s$.

**Status: matches, with two flags.**

1. **Off-by-one citation in the manuscript.** The quoted phrase "number of common
   dimensions, each weighted by its inertia" is on printed **p. 138**, not p. 137
   (p. 137 carries the Lg/RV formulas). If you want the quote pinned to its page,
   change `[p.~137]` to `[pp.~137--138]`.
2. **$Lg(h, \mathrm{MFA})$ as a single number** (the tab-groups column) is
   FactoMineR's implementation-level quantity: the compromise enters as a pseudo-block
   normalized by its own $\lambda_1$, consistent with the book's general Lg definition
   (§7.2) — but the book itself only displays the per-axis version
   $Lg(F_s, K_j)$ (§7.4, pp. 140–141). If a reviewer asks "where in Pagès is Lg with
   the MFA?", the honest answer is the definition plus FactoMineR, not a displayed
   formula.

---

## 4. Aspect (group) contributions to a dimension

**Manuscript:** Analytic Strategy, "Composition of Complex Taste Space Dimensions"
(footnote): $\mathrm{ctr}(h,s) = \sum_{j \in h} w_j f_{js}^2 / \lambda_s$, summing to
100% per dimension. Tables tab-groups; sec:contrib.

**Pagès:**

- General point-contribution machinery: §1.6.2, pp. 17–18 — contribution of a point to
  an axis = its projected inertia / total projected inertia; explicitly as percentages;
  and the Comment (p. 17–18): "for a given axis, the contributions can be added
  together to represent the contribution of a subset of … variables." That Comment is
  the warrant for summing variable contributions into a block contribution.
- §4.3, p. 83 uses exactly this aggregated notion ("the groups' contributions to the
  first axis, that is to say the sums of the contributions of the variables of a
  given group").
- §7.5, p. 143 gives the groups-space version:
  $$CTR(K_j, w_s) = \frac{Lg(F_s, K_j)}{\sum_j Lg(F_s, K_j)} = \frac{\text{projected inertia of } N_{K_j} \text{ on } v_s}{\text{projected inertia of } N_K \text{ on } v_s}$$
  — the same decomposition viewed in $\mathbb{R}^I$ (sums to 100% because
  $\sum_j Lg(F_s, K_j) = \lambda_s$).
- Worked instance for qualitative groups: §8.4.2, p. 174, Table 8.6 "Decompositions of
  Inertia by Axis and by Group."

**Status: direct match.** Our footnote's $w_j f_{js}^2 / \lambda_s$ (variable form,
$\mathbb{R}^K$) and the book's $CTR(K_j,w_s)$ ($\mathbb{R}^I$ form) are the same
quantity by the usual duality. Also relevant to our Lg-magnitude guard: §8.4.2, p. 174
—"The first eigenvalue of 1.920 is close to its maximum (the number of groups)": MFA's
$\lambda_1$ is bounded above by the number of blocks, the fact behind our
"first axis of near-unit inertia per block" reading of the Lg floor.

---

## 5. Partial points and the mean individual

**Manuscript:** eq:decomp lead-in ("each individual $i$ has $H$ partial points … whose
average is the individual's global point"); fig-worked-example; sec:duality partial
points.

**Pagès:** §5.2 "Method", pp. 103–106:

- Partial cloud $N_I^j$ = cloud $N_I$ seen through group $j$ only (p. 103 ff.).
- Partial coordinates from the global analysis:
  $F_s^j = \tilde{X}^j M u_s$; partial transition relation (p. 105–106):
  $F_s(i^j)$ is (up to a constant) the mean of group-$j$ variables' coordinates weighted
  by individual $i$'s values — "partial individuals are on the side of the variables
  [of group $j$] for which they have a high value."
- Mean individual: $\sum_j F_s(i^j) = J \cdot F_s(i)$, so after the $J$-dilation point
  $i$ is the barycentre of its $J$ partial points, "all of the same weight, which is
  logical given the desire to balance out the influence of the groups" (p. 106). This
  is our "global point = average of partials" with $J \to H$.
- Qualitative data version: §8.2.3, p. 165 ("the notion of partial individuals …
  identical for quantitative and qualitative variables").

**Status: direct match** (mind the dilation convention in the dictionary above).

---

## 6. Equation eq:decomp — the aspect-disagreement score $W_s(i)$

**Manuscript:** eq:decomp,
$$\sum_{h=1}^{H} F_{sh}(i)^2 = H\,F_s(i)^2 + W_s(i), \qquad
W_s(i) = \sum_h \left(F_{sh}(i) - F_s(i)\right)^2$$
plus the interpretive paragraph (aspect-disagreement read as complex taste).

**Pagès:** §5.4 "Interpretation Aids", pp. 107–109 — **this is the source passage**:

- p. 108: cloud $N_{IJ}$ of all partial points, partitioned into $I$ classes $N_i^J$
  (one class per individual); Huygens' theorem applied to this partition, axis by axis:
  $$\mathrm{Inertia}[N_{IJ}/O] = \mathrm{Inertia}[N_I/O] + \sum_i \mathrm{Inertia}[N_i^J/i]$$
- p. 108: "The within-class inertia of $N_i^J$ measures the heterogeneity, along an
  axis $u_s$, of the partial points associated with individual $i$." This sentence is
  the book's one-line statement of what $W_s(i)$ measures.
- Table 5.1 (p. 109): contributions of individuals to within-class inertia, ranked —
  the book's use of $W_s$ is as a screening device (homogeneous vs. heterogeneous
  individuals); the manuscript elevates the same quantity to a substantive score.
- The between/total ratio per axis (p. 109, Table 5.2): an aggregate indicator of
  similarity of partial-cloud structures.

**Status: matches the book's identity, our packaging.** The manuscript's eq:decomp is
the per-individual, single-axis form of the Huygens identity (with the $H$-dilation
made explicit), which is algebraically equivalent — our cited "pp. 108–109" is the
right passage. **One standing caution (do not conflate when quoting the book):**
Pagès' Table 5.2 between/total ratio is an *aggregate ratio of inertias*
(0.8964, 0.6990, … on his data); our headline "56%, 52%, 63% of the average projected
partial inertia" is a *mean of individual-level ratios*. Same family, different
statistic — don't attribute our numbers to the book's table or vice versa.

---

## 7. Per-aspect decomposition of $W_s$ (which aspect stands apart)

**Manuscript:** subsubsection "Which Aspect Stands Apart?"
(sec:aspect-shares), citing \citep[pp.~108--109]{pages2014mfa}; per-aspect shares
32.5/33.5/34.0 (dim 1), 19.6/31.9/48.6 (dim 2), 17.8/17.8/64.4 (dim 3); script 04's
§5.4 decomposition (Wp/Wc/We columns).

**Pagès:** §5.4, pp. 108–109, final paragraph of the section: "When there are more than
two active groups, it can be interesting to decompose this within-individual inertia by
group of variables. We thus obtain the contributions of the partial individuals to the
within inertia." (In the two-group case each per-group term is half the total — same
algebra as our three squared deviations summing to $W_s$.)

**Status: direct match**; the cite pp. 108–109 is correct for this too.

---

## 8. Superimposed-representation caveat (eq:decomp footnote)

**Manuscript:** footnote after "grows as the aspects disagree more": partial-point
distances are meaningful only when the partial clouds are comparably spread along the
studied dimensions, "since the superimposed representation accentuates differences in
spread between clouds \citep[pp.~112--116]"; then the defense (MFA weighting makes the
three partial clouds equally spread along their leading directions).

**Pagès:** §5.5 "Distortions in Superimposed Representations", pp. 110–116, exactly the
cited range:

- §5.5.1, pp. 110–112: the trapeziums counterexample (two groups with identical
  components but different variances — the superimposed representation exaggerates the
  higher-variance group).
- §5.5.2, pp. 112–114: geometric interpretation (comparison of inter-point distances
  across groups only meaningful at comparable spread).
- §5.5.3, pp. 114–115: algebra approach.
- §5.6, p. 116: the conclusion — for the superimposed representation, "distances
  between partial points are only easily interpretable for a given group … the
  distances between partial points of different groups are only [interpretable when
  the clouds have comparable spread]" (paraphrase; read the page directly).

Our defense via the balancing weights is the natural continuation: §4.3 (pp. 82–86)
standardizes each block's maximum axial inertia to 1 in the global metric, so the
comparability condition holds by construction for the leading directions.

**Status: direct match; citation accurate.**

---

## 9. Pairwise partial-point distances, $\sum_{h<k} d_s^2(h,k) = H \cdot W_s(i)$

**Manuscript:** subsubsection "Pairwise Distances Across Aspects" + footnote (pure
algebra: $\sum_{h<k}(F_{sh}-F_{sk})^2 = H\sum_h F_{sh}^2 - (\sum_h F_{sh})^2$ with
$F_s = H^{-1}\sum_h F_{sh}$); Table tab-pairs; sec:antinomies pair readings.

**Pagès:** **no explicit counterpart formula.** The book never writes the pairwise
identity down; it belongs to the same machinery as §5.4 (within-class inertia) and the
comparability discussion of §5.5–5.6 (which is why the caveat footnote in entry 8
matters for tab-pairs too — pairs are cross-group distances).

**Status: paper's own identity, trivial algebra from the book's construction.**
Reviewable directly: with three partial coordinates $a,b,c$ and mean $m$,
$(a-b)^2+(a-c)^2+(b-c)^2 = 3[(a-m)^2+(b-m)^2+(c-m)^2]$ — the $H=3$ version of the
footnote. Nothing to check against the book beyond the §5.5 comparability caveat.

---

## 10. Equation eq:genre — per-genre contributions, $\omega_s(i;g)$, cross-genre coherence

**Manuscript:** eq:genre,
$$W_s(i) = \sum_g \omega_s(i;g) + 2H^2 \sum_{g<g'}\sum_h d_{ighs} d_{ig'hs}, \qquad
\omega_s(i;g) = H^2 \sum_h d_{ighs}^2$$
with $c_{ighs} = \Delta_{ghs}(z_{igh} - p_{gh})$, $d_{ighs} = c_{ighs} - \bar{c}_{igs}$
(centered per genre); footnote gives $F_{sh}(i) = H\sum_g c_{ighs}$ and
$F_s(i) = \sum_{g,h} c_{ighs}$.

**Pagès:** **no counterpart — this is the paper's own decomposition.** Its ingredients
are all book machinery, and that is where to review the math:

- The representation of partial coordinates as sums of per-variable contributions is
  the partial transition relation, §5.2, pp. 105–106 (entry 5), specialized to
  indicator variables; in the qualitative case the category masses and MCA weights
  enter via §8.1–8.2 (weighted MCA), pp. 159–168.
- Category coordinates and the $1/p_k$-type scaling: §2.4.2, pp. 45–47, and §2.5.2,
  pp. 50–51 (see entry 11).
- The exactness identities ($W_s$ = genre-based part + cross term) are just the
  per-genre version of the §5.4 within-class inertia with the $H$-dilation — the
  verification is algebraic (script 04 checks them to ~1e-15), not textual.

**Status: paper's own.** Review via `scripts/04-antinomies.R` section 3b
(omega / cell_cfg / Dcoef in `antinomy_scores.rds`); cite Pagès only for the
ingredients, never for the decomposition itself.

---

## 11. MCA category coordinates and rare-category upweighting

**Manuscript:** 4.1 volume-axis reading (rarest categories most extreme:
listening-to-folk $+1.43$ etc.), the MCA footnote in the strategy, the worked-example
listening-weighs-2x footnote; tab-genre rates context.

**Pagès:** Chapter 2 (MCA):

- §2.4.2 "Cloud of Categories", pp. 45–47: category coordinates, and the two-sided
  fact — a category's influence/coordinate grows with rarity ("the rarer they are, the
  greater influence categories have"); also the practical warning about very rare
  categories (grouping them).
- §2.5.1, pp. 48–49: eigenvalues expressed as averages of squared correlation ratios —
  the property behind "rare categories receive the most extreme scores, as is typical
  of MCA," and behind reading small inertia percentages (our 9.6/7.5/6.2%) without
  alarm.
- §2.4.2/§2.5.2–2.5.3, pp. 45, 50–52: categories as barycentres of the individuals who
  possess them + transition relations — the fact our duality section leans on when it
  says the original analysis's category coordinates locate a genre through its
  audience composition.

**Status: direct match** (the manuscript cites Rouanet & Le Roux for the rarity
property; Pagès ch. 2 is the same statement in MFA-book form).

---

## 12. Eigenvalues and inertia percentages

**Manuscript:** tab-eigen; $\lambda_1 = 1.51$ (9.6%) … first five 32.5%; robustness
footnote eigenvalue comparison.

**Pagès:** §1.6.1, p. 16 (percentage of inertia associated with an axis); §2.5.1,
pp. 48–49 (MCA eigenvalues ≤ 1, max attained iff binary structure; read as averages of
correlation ratios); §8.4.2, p. 174 ($\lambda_1$ of an MFA is bounded by the number of
groups — our 1.509 vs. 3).

**Status: direct match.** No manuscript formula to check beyond the definitions.

---

## 13. Partial axes (separate-analysis axes vs. global axes)

**Manuscript:** tab-partial-axes; Results "Partial Axes" subsection
(correlations 0.84/0.86/0.19 on dim 1, etc.).

**Pagès:** §4.5 "Relationships with Separate Analyses", pp. 88–91 — the separate
analyses' factors ("also known as partial axes") are projected as supplementary
variables into the MFA and read as correlations; the passage explicitly interprets
first- vs. second-factor alignments and warns that close separate eigenvalues can mask
plane-level similarity by rotation. Worked example in the mixed/qualitative case:
§8.4.3, p. 175 (Figure 8.1) with the factor-factor correlation table (Table 8.5,
p. 174) — the model for our tab-partial-axes.

**Status: direct match.**

---

## 14. Supplementary elements and the correlation ratio $\eta^2$

**Manuscript:** tab-w-eta ($\eta^2$ of demographics with the W scores — pure bivariate
statistics, no MFA geometry); pipeline-only (currently unreferenced) script 05
supplementary-position analysis: supplementary *group* of demographics, category
barycenters, $\eta^2$ with dimensions (age 0.33 on dim 2).

**Pagès:**

- §1.8 "Supplementary Elements", pp. 23–25: the supplementary status (projected, never
  influent) — our demographics as supplementary group 4.
- §1.9 "Qualitative Variables in PCA", pp. 26–28: qualitative variables represented
  through the squared correlation ratio; "The squared correlation ratio divides
  between-inertia by total inertia" (p. 23 context, §1.9 pp. 26–28) — the $\eta^2$
  definition behind tab-eta/tab-w-eta.
- MCA version: §2.7, pp. 54–55 (eigenvalues as means of squared correlation ratios;
  relationship square).
- In MFA's relationship square, supplementary qualitative variables are shown by their
  squared correlation ratios with the factors: §7.4 Remark, p. 142.
- Implementation gotcha (ours, not the book's): FactoMineR requires supplementary
  columns inside a declared supplementary *group* (`num.group.sup = 4`) and does **not**
  store supplementary-group category coordinates — barycenters must be computed from
  `res$ind$coord`; the book's supplementary-variable treatment presumes the standard
  `quali.sup` route.

**Status: direct match for the definitions; the tab-w-eta usage is ordinary
bivariate statistics and needs no book warrant.**

---

## 15. Transposed MFA (genres as targets)

**Manuscript:** sec:duality, including the justification paragraph (CA duality broken
by MCA + block weighting; different balancing weights after transposition;
statistics-over-individuals don't survive transposition) and the statement that the
analysis was implemented "by direct application of the algorithm in [the book]."

**Pagès:** **no section of the book performs or discusses transposing the data table.**
The building blocks to review against:

- MCA duality and transition relations: §2.5.3, pp. 51–52 (the duality that *simple* CA
  would give for free, and which MCA + block weighting breaks — our argument, stated
  in our terms, not the book's).
- Weighting: §4.3 (pp. 82–86) and §8.2 (pp. 162–168) — since the separate analyses
  differ after transposition, so do the $1/\lambda_1$ weights (mechanics only; the
  observation is ours).
- RV/Lg are defined over the individuals of an analysis (§7.2, pp. 133–139), which is
  why genre-level RVs exist only in the transposed fit.
- "The algorithm in the book" = the weighted MCA construction of §8.1 (pp. 159–162):
  indicator matrix, MCA column weights, block multiplier $1/\lambda_1^j$, SVD. Our
  script 06 replicates this manually and was validated against FactoMineR to <1e-5
  before switching to the manual implementation (FactoMineR OOMs at this size).

**Status: paper's own analysis design; book supplies only the components.** For a math
review, the check is `scripts/06-transposed-mfa.R`'s validation block, not a book page.

---

## 16. Robustness: MCA vs. scaled PCA within blocks

**Manuscript:** strategy footnote (same MFA with `type="c"`; eigenvalues 1.504/1.188/
0.997 vs. 1.509/1.178/0.982; RV 0.32/0.01/0.01; coordinates $r = 0.98/0.97/0.84$;
W-scores 0.96/0.89/0.77; shares 56/53/61 vs. 56/52/63; the one real difference is
MCA's rare-category upweighting). Script 08.

**Pagès:** the closest book discussion is §2.8.3 "MCA/PCA Comparison for Ordinal
Variables," pp. 59–61 (MCA vs. PCA of the same coded variables, with comments on when
they diverge). The manuscript's framing ("MCA gives [rare categories] proportionally
more weight … a feature here") is consistent with the book's chapter-2 treatment of
category rarity (entry 11). There is no book discussion of `type="c"` MFA specifically —
that is FactoMineR functionality.

**Status: consistent with the book's MCA/PCA material; the robustness design and
numbers are ours (script 08 / `output/robustness_pca.rds`).**

---

## Summary table

| # | Manuscript item (location) | Pagès counterpart (§, pp.) | Status |
|---|---|---|---|
| 1 | Block weighting $1/\lambda_1$ (strategy 3.1, tab-groups) | §4.3, pp. 82–86; §8.2, p. 163 | Direct match |
| 2 | RV coefficient + 0/1 glosses (strategy 3.2, tab-rv) | §7.2, pp. 133–139; Fig. 7.2 p. 137; §8.2 p. 164 | Direct match |
| 3 | Lg coefficient + footnote (strategy 3.3, tab-groups) | §7.2, p. 137; §7.3 pp. 139–140 (Table 7.1); §7.4 pp. 140–141 | Match; **cite off by one** (phrase on p. 138); $Lg(h,\mathrm{MFA})$ is FactoMineR-level |
| 4 | Aspect contributions ctr(h,s) (strategy 3.4, tab-groups) | §1.6.2 pp. 17–18; §4.3 p. 83; §7.5 p. 143; §8.4.2 p. 174 (Table 8.6) | Direct match |
| 5 | Partial points, global = mean of partials (eq:decomp setup, figures) | §5.2, pp. 103–106; §8.2.3, p. 165 | Direct match (mind $J$-dilation) |
| 6 | **eq:decomp** $W_s(i)$ | §5.4, pp. 107–109 (Huygens on $N_{IJ}$; Table 5.1) | Match; our per-individual packaging; **Table 5.2 caution** |
| 7 | Per-aspect shares Wp/Wc/We (sec:aspect-shares) | §5.4, pp. 108–109 (last ¶) | Direct match |
| 8 | Superimposed-representation caveat footnote | §5.5, pp. 110–116 (§5.5.2 pp. 112–114; §5.5.3 pp. 114–115; §5.6 p. 116) | Direct match; cite accurate |
| 9 | Pairwise distances $\sum d^2 = H\,W_s$ (tab-pairs) | None explicit; §5.4 + §5.5–5.6 machinery | Paper's own identity (trivial algebra) |
| 10 | **eq:genre** ($\omega$, coherence) | None; ingredients §5.2 pp. 105–106, §8.1–8.2 pp. 159–168, §2.4.2–2.5.2 pp. 45–51 | Paper's own; verify in script 04 §3b |
| 11 | MCA rare-category upweighting (4.1, footnotes) | §2.4.2 pp. 45–47; §2.5.1 pp. 48–49 | Direct match |
| 12 | Eigenvalues / percentages (tab-eigen) | §1.6.1 p. 16; §2.5.1 pp. 48–49; §8.4.2 p. 174 | Direct match |
| 13 | Partial axes (tab-partial-axes) | §4.5, pp. 88–91; §8.4.3 p. 175 (Table 8.5 p. 174) | Direct match |
| 14 | Supplementary elements, $\eta^2$ (tab-w-eta; script 05) | §1.8 pp. 23–25; §1.9 pp. 26–28; §2.7 pp. 54–55; §7.4 Remark p. 142 | Match; implementation gotchas are ours |
| 15 | Transposed MFA (sec:duality) | No counterpart; §2.5.3 pp. 51–52, §4.3, §8.1–8.2 | Paper's own design; verify script 06 |
| 16 | MCA-vs-PCA robustness (footnote, script 08) | §2.8.3 pp. 59–61 (nearest discussion) | Ours; consistent with book |

## Flags for the author (nothing urgent)

1. **Lg quote citation.** "number of common dimensions, each 'weighted' by its
   inertia" sits on printed p. 138; the manuscript cites p. 137 (the formulas' page).
   Consider `[pp.~137--138]`.
2. **Table 5.2 ≠ 56/52/63%.** Never describe our mean-of-individual-ratios headline
   as "Pagès' between/total ratio" — they are different aggregations of the same
   Huygens identity (already respected in the current prose; keep it that way).
3. **Dilation convention.** In any future technical appendix, state explicitly that
   $F_{sh}(i)$ is Pagès' *dilated* partial coordinate ($J\cdot F_s(i^j)$), so that the
   barycentre reading ($F_s = H^{-1}\sum_h F_{sh}$) holds.
4. **Unbooked quantities.** eq:genre, the pairwise identity, $Lg(h,\mathrm{MFA})$ as a
   single aggregate, and the transposed MFA have no Pagès page to appeal to. If a
   reviewer asks for sources, the answer is the definitions + FactoMineR + replication
   scripts, not the book.
