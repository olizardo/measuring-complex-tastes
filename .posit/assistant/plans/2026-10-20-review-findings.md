# Manuscript Prose Review: Sections Warranting Rewrite

**Date:** 2026-10-20  
**Status:** Reviewed Introduction through early Results; pulled latest web edit (b7ed184)

---

## Overall Assessment

**Strengths:**
- Introduction is well-motivated and clear
- Data/Measures section is honest about coding choices and constraints
- Results subsections on dimensions (3.2) are engaging and well-explained
- Discussion (newly rewritten) is conversational and integrated
- Appendix sections are thorough and generally readable

**Sections with Stilted/Technical Prose:**

---

## 1. **Section 3.1: MFA Methodology (lines 64–75)** ⚠️ **HIGH PRIORITY**

**Problem:** 
- Very technical explanation of the two-step MFA construction
- Dense paragraphs on eigenvalue weighting, column standardization, matrix operations
- Jargon-heavy (MCA, indicator matrix, PCA, concatenation, scaling)
- Footnote 5 is exceptionally long (lines 75–76+) and covers robustness checks in prose form
- This section is a barrier to reader engagement

**Example:** Lines 71–73
> "We apply the weights in three steps. First, we expand each aspect's indicators into yes/no columns for each genre (the MCA indicator matrix), doubling the columns from 20 to 40. We center each column at its mean $p_j$ (the proportion of respondents who chose that category) and divide by $\sqrt{p_j(1-p_j)}$. Second, we multiply each column by $\sqrt{(1-p_j)/(\lambda_{1,h} J)}$..."

**Recommendation:**
- Keep the intuitive explanation (lines 68–71: "In the first step..." through "...listening alone")
- Condense the technical details (lines 71–75) into a single clear paragraph that explains the *why* (balance aspects so none dominates) without all the matrix notation
- Move detailed formulas and robustness checks to a clearly separated **Technical Note** or Appendix subsection
- Rewrite to emphasize: "We weight each aspect so that the aspect with strongest internal structure doesn't dominate the combined picture. This ensures a balanced compromise space."

**Impact:** Makes the Methods accessible to sociologists who aren't GDA experts

---

## 2. **Section 3.1a: RV Coefficient Explanation (lines 77–90)** ⚠️ **MEDIUM PRIORITY**

**Problem:**
- The explanation of RV is correct but dense (lines 79–90)
- Equation 1 (RV formula) is presented with minimal intuition before diving into matrix notation
- Two long footnotes (lines 85 and 86–87) with formal definitions
- Reader has to parse formal language before the intuitive take-home ("the three aspects are empirically distinct")

**Current flow:**
1. Introduce RV as "multivariate analog of correlation"
2. Show equation
3. Explain what $\mathbf{S}_h$ and $\mathbf{S}_k$ are
4. Interpret RV range (0 to 1)
5. Report the actual values (0.35, 0.014, 0.015)
6. Conclude

**Recommendation:**
- Lead with intuition: "To know whether the three aspects are truly separate, we ask: do respondents who are similar on one aspect tend to be similar on another? The RV coefficient measures this."
- *Then* introduce the equation and explain what it measures
- Simplify footnotes or move formal definitions to appendix
- Condense lines 86–90 to emphasize the finding: "Preference and consumption show moderate overlap, but evaluation is nearly independent."

**Impact:** Makes a technical concept accessible without sacrificing rigor

---

## 3. **Section 3.1b: Dimension Interpretation (lines 98–165)** ✓ **GOOD, minor tweaks**

**Status:** Generally well-written and engaging

**Minor improvements:**
- Lines 100: The explanation of "inertia" is good but could be slightly tighter
- Lines 110: "Choosing to listen to or like genres along this hierarchy is linked to generation" — could emphasize this is a finding from elsewhere; readers may wonder if it's from this analysis
- Overall: This section reads well and doesn't need major rewrite

---

## 4. **Section 3.3: Lg Coefficient and Contributions (lines 130–165)** ⚠️ **MEDIUM PRIORITY**

**Problem:**
- Similar to RV section: technical explanation with heavy notation
- Lines 136–141: Dense explanation of the Lg coefficient
- Equation 3 (contribution formula, line 159) is complex
- Readers need to parse notation before understanding what the results mean

**Current flow:** Definition → equation → interpretation → table

**Recommendation:**
- Lead with question: "Do all three aspects contribute equally to the shared space, or does one dominate?"
- Explain Lg intuitively: "We measure how much of each aspect's internal structure survives when we combine them"
- Report findings first (Table 3 shows...), then explain the measure
- Move formal equation definitions to Appendix if needed
- Clarify what "participation" means in less technical terms

**Impact:** Improves accessibility without losing precision

---

## 5. **Section 3.4: Measuring Aspect Disagreement (lines 179–267)** ⚠️ **HIGH PRIORITY**

**Problem:**
- This section defines $W_s(i)$, the core measure, and it's quite technical
- Heavy notation and equations (Equations 5, 6, 7 at lines 184–233 roughly)
- The worked example (lines 240–260) is good, but it comes *after* all the formalism
- Structure: formalism first, then example — should be reversed for readability

**Recommendation:**
- **Lead with the worked example** (respondents 362 and 1881) to show what disagreement looks like in practice
- *Then* explain the measure more formally
- Use the example to ground the notation: "For respondent 362, we compute how far apart their preference, consumption, and evaluation partial points sit from their global position on each dimension"
- Move dense derivations (Equations 5–7) to appendix or technical note
- Emphasis: What disagreement *means* (aspects pulling in different directions) before how it's *calculated*

**Impact:** Makes the core measure intuitive and memorable

---

## 6. **Section 3.5: Socio-Demographic Results (lines 303–330)** ✓ **GOOD**

**Status:** Well-contextualized, results embedded in interpretation. No major rewrite needed.

---

## 7. **Section 3.6: Genre-Specific Results (lines 331–357)** ✓ **GOOD**

**Status:** Clear narrative and engagement with the contradiction (individual vs. genre level). No major rewrite needed.

---

## 8. **Section 3.7: Coherence (lines 358–368)** ⚠️ **MINOR**

**Problem:**
- Uses older language: "survive correction" and "does not survive controls" (lines 364, 406)
- Should align with new terminology in Discussion (use "statistically significant after adjustment")

**Recommendation:**
- Search for all instances of "survive" in this context and replace with "statistically significant after [adjustment/correction]"
- Make language consistent with Decision 34 in AGENTS.md

**Impact:** Consistency and clarity

---

## 9. **Section 3.8: Transposed (Genre) MFA (lines 369–412)** ✓ **ACCEPTABLE**

**Status:** Readable. The setup is clear, and the figure captions (which now include leader-line wording) explain the encoding well.

**Minor note:** The distinction between this section and the full Results could be clearer earlier (i.e., explicitly signal that we're now treating genres, not respondents, as units).

---

## 10. **Data and Measures Section (lines 38–59)** ✓ **GOOD**

**Status:** Honest, clear operationalization. The discussion of evaluation coding (lines 49–51) is particularly good.

---

## Summary of Priorities

### **HIGH PRIORITY** (Major readability gains)
1. **Section 3.1: MFA Methodology** — Condense technical details, emphasize intuition, consider moving formulas to Appendix
2. **Section 3.4: Measuring Aspect Disagreement** — Lead with worked example, then explain formally; move dense derivations to Appendix

### **MEDIUM PRIORITY** (Good accessibility gains)
1. **Section 3.1a: RV Coefficient** — Lead with intuition, then formalism
2. **Section 3.3: Lg Coefficient & Contributions** — Similar treatment

### **LOW PRIORITY** (Minor tweaks for consistency)
1. **Section 3.7: Coherence** — Update language to match new terminology
2. **Introduction and Data sections** — Already clear; no major rewrite needed

---

## Recommendations for Author Review

1. **Which sections matter most to you?** Are the high-priority technical sections (3.1, 3.4) barriers for your intended readers?
2. **Appendix preference:** Would you prefer formulas and derivations moved to an Appendix, or kept inline?
3. **Worked examples:** Should the manuscript include more worked examples (like the respondents 362 and 1881 pair) to ground abstract measures?
4. **Timeline:** Which rewrites would have the most impact on submission-readiness?

