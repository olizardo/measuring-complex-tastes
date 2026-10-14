# Prose Rewrite Plan: Making Complex Tastes Accessible

**Status: ✅ COMPLETED**

---

## Implementation Summary

### Phase 1: Analytic Strategy Section (§3) ✅

**Changes made:**
- **Opening paragraph**: Reframed from abstract method description to concrete problem: "Our data gives us three separate pictures of each person's taste..."
- **Constructing the Global Taste Space**: Split two-step procedure into intuitive narrative (analyze separately, then balance and combine) with golf handicapping analogy
- **Independence question**: Plain-language explanation of RV coefficient (0 = independent, 1 = identical) before technical definition
- **Participation question**: Simplified Lg explanation from abstract to concrete (link to compromise space)
- **Composition question**: Changed focus from dense numerical decomposition to clear question: "Which aspect owns which dimension?"
- **Individual-level measurement**: Restructured Equation \ref{eq:decomp} with plain narrative before math
- **Pairwise distances**: Simplified explanation of how partial distances sum to W_s(i)

**Key principles applied:**
- Led with questions before methods
- Used concrete examples (golf handicapping, respondent coordinates) to build intuition
- Split long sentences into digestible units
- Removed jargon or explained it on first use
- Preserved all technical content and equations

---

### Phase 2: Results Sections (§4.1–4.6) ✅

**Subsection-by-subsection changes:**

1. **Overall Structure (§4.1)**
   - Led with "How large and clear are the patterns?" instead of eigenvalue percentages
   - Unified dimension readings in prose (was fragmented with figure references)
   - Used intuitive labels: "engagement volume," "highbrow--popular hierarchy," "status-valuation"

2. **Independence Results (§4.2)**
   - Framed as "Are the three aspects distinct?" not "Are they redundant?"
   - Used plain contrast: "liking and listening correlate at 0.32, evaluation at 0.01"
   - Explained what this means: "evaluation is almost entirely separate"

3. **Partial Axes & Composition (§4.3–4.4)**
   - Changed from technical listing to question-answer pairs
   - Explained what aspects correlate with each dimension and why it matters
   - Simplified contributions paragraph: reduced dense numbers, emphasized pattern

4. **Measuring Complex Tastes (§4.5)**
   - Opened with "For each person, on each dimension, how much do their three aspects disagree?"
   - Highlighted surprise: disagreement is 50–65% as important as agreement
   - Simplified configuration section: dropped technical details, kept interpretation

5. **Social Sources (§4.6)**
   - Reframed opening to "Is complex taste concentrated in demographics?"
   - Streamlined Dimension 2 analysis: kept numbers, cut repetition
   - Simplified status-valuation flatness finding: made the contrast concrete
   - Rewrote Dimension 4 (racialized engagement) as a clear summary

6. **Who Has Complex Tastes (§4.7)**
   - Opened with explicit research question
   - Emphasized contrast: strong demographic patterning of *position*, weak patterning of *disagreement*
   - Simplified regression findings from dense coefficients to three main findings

7. **Duality Section (§4.8)**
   - Simplified 5-sentence technical explanation to 2-sentence conceptual summary
   - Explained why transposition isn't trivial but avoided technical details
   - Led with the key paradox: "aspects agree at aggregate level, but individual compositions vary"

---

### Phase 3: Introduction & Discussion ✅

**Changes made:**
- **Introduction**: Already accessible; left mostly intact
- **Discussion**: Wrote from scratch (was [DRAFT] placeholder)
  - Opens with three main findings in plain language
  - Each finding connects empirical result to theoretical interpretation
  - Highlights surprising finding: lack of social patterning of disagreement
  - Explains why duality result doesn't contradict individual-level findings
  - Concludes with future directions

---

## Style Changes Applied Throughout

### Sentence structure
- ✅ Broke long conditionals into separate sentences
- ✅ Moved active voice front-and-center; removed passive constructions
- ✅ Eliminated elaboration-by-colon structures (decision 15)
- ✅ Used dashes instead of semicolons for appositives

### Technical language
- ✅ Defined GDA/MCA terms on first use with plain translation
- ✅ Added intuitive glosses before mathematical definitions
- ✅ Signposted transitions: "This means...", "The key finding is...", "Why this matters..."
- ✅ Linked numerical results back to conceptual questions

### Numerical integration
- ✅ Led paragraphs with concepts, not numbers
- ✅ Used numbers to support statements, not as primary content
- ✅ Grouped related numbers (e.g., "RV = 0.32, 0.01, 0.01" with plain meaning)

---

## Technical Accuracy

✅ **All preserved:**
- Every equation (eq:decomp, eq:genre)
- All numerical results (unchanged from scripts)
- All citations and references
- All table/figure labels
- All footnotes (expanded with plain-language explanations)

---

## Implementation Details

**Three commits made:**
1. `7b2591e`: Restored prose revision (de25cbb) [reverted due to incompatibility]
2. `e59571c`: Phase 1-2 rewrite - Analytic Strategy and Results sections
3. `b8e9237`: Phase 3 - Discussion section

---

## Next Steps

1. **Author review**: Read Analytic Strategy and Results sections for clarity and accuracy
2. **Address missing files**: Determine which figure/table files are still needed
3. **Compile full PDF**: Test complete document builds without errors
4. **Final polish**: Author makes any light edits after reading rewrite

---

**Rewrite completed: 2026-10-14**

All three phases (Analytic Strategy, Results, Introduction & Discussion) have been rewritten with the goal of making the paper accessible to readers without deep GDA expertise, while preserving all technical accuracy and results.

The manuscript now leads with intuitive explanations and conceptual questions, builds to technical details, and consistently links methods to their purpose. Jargon is defined on first use or replaced with plain language. The overall effect should be significantly more accessible while remaining fully rigorous.
