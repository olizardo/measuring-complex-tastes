The manuscript compiles cleanly (42 pages in a scratch build, no undefined references or citation warnings). This list contains only the items still open. Line numbers refer to [manuscript/main.tex](manuscript/main.tex) as it currently stands.

## Structural gaps

- Introduction: engagement with the literature is still limited to Ma and Bourdieu. Candidate keys in the global bibliography, not yet cited: `peterson1996changing-967`, `warde2007understanding-43f`, and `lizardo2014omnivorousness-3f3`. Check each one before citing it.
- Limitations: the evaluation-coding sensitivity sentence is missing. Rerun the earlier codings from git history and add the numbers.
- Overleaf sync of the uncommitted 2026-10-16 and 2026-10-17 changes, and a rebuild of `main.pdf`.

## Style

- `manuscript-audit.md` dates from October 13 and predates the restructuring, so it should not be used as a to-do list.

## Assistant-drafted passages awaiting the author's approval

- The Dimension 4 decomposition paragraph in Results.
- The Figure 10 interpretive paragraph in the configuration section.
- The transposed racial-composition reading, the mood/easy-listening exception, and the Dimension 4 caption reading.
- The genre-level gender sentence and the Discussion gender paragraph.
- The Abstract and the Limitations subsection, both added on 2026-10-17.
- The race η² sentence in the transposed section now cites the Dimension 3 disagreement value (η² = 0.064, `tab-w-eta`). The earlier value of 0.25 had no table source.

## What I checked and what I did not

Checked and consistent: the table values in the prose (eigenvalues, contributions, Lg, pair shares, genre rates, genre-profile percentages), the regression coefficients in the text against `tab-regression` and `tab-coherence-regression`, the η² values, the 66 cell count, the coherence shares (85–89% of variance; 33%, 25%, and 52% negative), the 0.25 and 0.20 values in the demographic correlations, the category coordinates quoted in Section 3.1 against the fit, and the worked-example arithmetic (W values, global points, and the 92%, 83%, 74%, and 22% shares). The Lg coefficient formula in the text matches FactoMineR's `res$group$Lg` (MFA column equals the sum of the block values divided by λ₁).

Not verified: transposed-MFA values (the ρ coefficients, partial coordinates, and RV values of 0.92, 0.53, and 0.48), the worked-example percentiles (88th and 94th), the guilty-pleasure $W_4$ mean and SD, and the 321 and 412 respondent counts.
