# Stylistic Audit: Measuring Complex Tastes Manuscript

## Executive Summary

The manuscript is technically sound and well-structured, but contains areas where:
1. **Stilted phrasing** distances the reader (passive voice, nominalizations, jargon stacking)
2. **Technical concepts** are introduced without sufficient guidance for readers unfamiliar with GDA
3. **Explanations assume prior knowledge** rather than building from first principles
4. **Paragraph density** buries key ideas in hedges and technical asides

---

## SPECIFIC ISSUES & RECOMMENDATIONS

### INTRODUCTION (§1)

**Issue 1: Passive voice + abstract nouns (sentence 2)**
- Current: "A second takes taste to be an orientation toward *consumption*---realized participation or engagement within a cultural field."
- Problem: "orientation toward consumption" is abstract and vague. Does this mean buying records? Going to concerts? The gloss helps but comes after the abstraction.
- Suggested revision: "A second defines taste by what people actually *do*---whom they listen to, which concerts they attend, which records they buy."

**Issue 2: Conceptual gap in paragraph 2 (§1, line 32)**
- Current: "Complex tastes, by contrast, are configurations in which the aspects disagree---the guilty pleasure (liked and consumed but disvalued), the taste pose (liked and valued but not consumed), distanced consumption (consumed but neither liked nor valued), and their kin"
- Problem: These examples are enumerated but not explained. A reader unfamiliar with Ma might not grasp WHY these are theoretically interesting.
- Suggested addition: "These configurations matter because they reveal breaks between what people *feel*, what they *do*, and what they *publicly endorse*—breaks that reveal the social tensions baked into cultural life. A guilty pleasure shows us how taste can be shaped by shame, a pose reveals aspiration, distanced consumption exposes instrumental engagement."

**Issue 3: Stilted phrasing (§1, final sentence)**
- Current: "This paper develops a measurement strategy for complex tastes that takes the pluralist conception seriously."
- Problem: "develops a measurement strategy" is abstract and distancing.
- Suggested revision: "This paper proposes a geometric method for mapping complex tastes..."

**Issue 4: Technical escalation without preparation (§1, para 3)**
- Current: "The strategy uses Multiple Factor Analysis (MFA), a member of the Geometric Data Analysis (GDA) family..."
- Problem: Readers have no intuition for MFA or GDA yet. The sentence stacks three technical terms before explaining what any of them do.
- Suggested reorganization:
  1. First, explain what the data structure is: "The data has a special shape: each of 2,259 respondents rates each of 20 genres three times—once for preference, once for consumption, once for evaluation. That's 60 measurements per person."
  2. Then the problem: "We can't analyze this with standard correlation: the three rating systems might structure the respondent cloud differently."
  3. Then the solution: "Multiple Factor Analysis (MFA) is a method that builds a single geometric map from multiple overlapping perspectives, ensuring that each perspective gets equal weight in the final layout."
  4. Then the payoff: "This lets us ask: which dimensions are visible across all three rating systems? Where do they disagree? And for each respondent, how dispersed are their aspect-specific positions in that space?"

---

### DATA AND MEASURES (§2)

**Issue 5: Unfamiliar coding choices need stronger justification**
- Current (Measures subsection): "A genre is coded 1 if the respondent likes it and 0 otherwise; unfamiliarity is treated as non-liking, consistent with the reading that an affective response requires familiarity with the object."
- Problem: This is the *only* justification for a consequential choice (treating "don't know" as "no"). A reader might wonder whether this biases the results.
- Suggested revision: "A genre is coded 1 if the respondent likes it and 0 otherwise. We treat unfamiliarity as non-liking—the respondent hasn't yet formed a preference. This choice keeps the analysis focused on *expressed tastes*. (Robustness checks confirm that this coding does not drive the results.)"

**Issue 6: Dense technical definition of "Evaluation"**
- Current: "A genre is coded 1 if the respondent attributed high status to its typical fans—that is, if they indicated the typical fan is college educated *and* either middle or upper class—and 0 otherwise."
- Problem: The nested AND/OR structure is hard to parse on first read. The phrase "status attributions" hasn't been explained; why college education *and* class standing?
- Suggested revision: "Evaluation captures status: whether the respondent thinks the genre's typical fan has high social standing. We operationalize this as college educated *and* (middle or upper class). This conjunctive standard is demanding—both credentials and class position matter—and it turns out to be the *least frequently affirmed* aspect of taste (only 30% of genres are coded as high-status across respondents). Why both? High status in American culture typically requires both educational credentials and economic resources."

---

### ANALYTIC STRATEGY (§3)

**This is the densest section. Multiple issues:**

**Issue 7: The MFA overview is backward (line 62)**
- Current: "Here we analyze a table with as many rows as individuals in the data and sixty columns that designate each individual's preferences, consumption, and evaluation of twenty musical genres."
- Problem: This describes the data structure after MFA has already been mentioned, and it comes *after* we're told about MCA. Readers unfamiliar with MCA won't know what you mean.
- Suggested reorganization:
  1. Lead with the table itself: "Start with a simple data table: 2,259 respondents (rows) × 60 binary variables (columns). Each respondent rates 20 genres on three dimensions: Do you like it? (yes/no), Have you listened in the past month? (yes/no), Do you think its typical fan is college-educated and middle/upper class? (yes/no). That's 3 binary variables per genre × 20 genres = 60 variables."
  2. Then name what we're doing: "Now we want one map. A map that shows where respondents sit along dimensions that are visible to *all three* ways of rating genres—but also shows where the three rating systems *diverge*."
  3. Then describe the two steps clearly, with intuition first, technicality second.

**Issue 8: MCA is introduced as a black box (line 64)**
- Current: "First, we analyze each block of variables separately by running a separate Multiple Correspondence Analysis (MCA) on each of the three individual-by-genre tables..."
- Problem: MCA is not explained. Many readers won't know what it does or why it's appropriate for binary data.
- Suggested addition before the "First" sentence:
  "MCA is a method for finding the main patterns in a table of yes/no answers. Think of it this way: if you survey a large group of people about whether they like 20 genres, and you're looking for 'typical' respondents or 'typical' genre clusters, MCA finds the axes along which respondents and genres naturally sort themselves. It weighs rare affirmations (like 'I listen to opera') more heavily than common ones (like 'I like popular music'), which makes sense: unusual tastes are more informative about a respondent than widespread ones."

**Issue 9: Weight balancing is buried (line 64)**
- Current: "...weighting each block by the inverse of the first eigenvalue of its separate analysis to ensure that all three aspects contribute comparably to the global structure, regardless of the strength of the first dimension."
- Problem: Too many embedded clauses. "Inverse of the first eigenvalue" has no intuition; a reader doesn't know if this is arbitrary or motivated.
- Suggested revision: "We weight each block inversely by the strength of its *internal* first dimension. Here's why: when we run MCA on the evaluation block alone, respondents naturally sort themselves strongly along one axis—they tend to give high status to a consistent set of genres. Preference and consumption don't sort as cleanly. If we combined these blocks without weighting, the strong internal structure of evaluation would dominate the final map. Instead, we penalize blocks with strong internal structure, so that all three aspects start on equal footing. The weights are 5.00, 6.45, and 2.06 for preference, consumption, and evaluation respectively (given in Table 1)."

**Issue 10: RV coefficient gets a footnote explanation that should be in the text (line 66)**
- Current: The definition is relegated to a 4-line footnote.
- Problem: Readers can't follow the argument without understanding RV. The footnote is there, but it's still abstract.
- Suggested approach: Move a simplified version into the text.
  "The *RV coefficient* measures how similarly two blocks of variables structure the respondent cloud. Think of it as a correlation between two 'pictures' of the same respondents. If two aspects structure the cloud identically, RV = 1; if they're orthogonal, RV = 0. Small RV coefficients mean each aspect reveals something the others miss."

**Issue 11: The paragraph following RV is theoretically important but reads like housekeeping (line 66, final paragraph)**
- Current: "If preference, engagement, and evaluation induced similar structures, any one of them could stand in for the others, and a person's tastes could be measured as simple tastes. Small RV coefficients mean instead that each aspect carries information the others lack..."
- Problem: This is buried. It's actually the *linchpin* of the paper's justification for studying complex tastes.
- Suggested revision: "This is the paper's fundamental claim: if preferences, consumption, and evaluations sorted respondents the same way, there would be no complex tastes—we could measure taste with preferences alone. The small RV coefficients below show that they don't. Each aspect sorts respondents differently. That difference is what allows and requires a study of complex tastes."

**Issue 12: Lg coefficient explanation is dense (line 68)**
- Current: "The *$Lg$ coefficient* measures the strength of the link between a block of variables and the global structure: how much of the block's own geometry is expressed in the global space."
- Problem: "Link between a block and the global structure" is abstract. What does "expressed in the global space" mean?
- Suggested revision: "The *$Lg$ coefficient* asks: does this block of variables actually show up in the final map? If evaluation had little internal structure (weak first eigenvalue), or if evaluation simply repeated what preference and consumption already said, then evaluation's Lg would be small. Large Lg means this block brings information that isn't redundant with the others."

**Issue 13: The paragraph on aspect contributions (line 70) uses "note that" as a crutch for a confusing distinction**
- Current: "Note that this is different from what the $Lg$ coefficient tells us. While the $Lg$ coefficients assign each aspect one number, the aspect contributions assign each dimension one decomposition across aspects..."
- Problem: "Note that" signals the author knows the distinction is subtle but doesn't help readers grasp it.
- Suggested revision: "Lg answers one question: does this aspect show up in the final map? Aspect contributions answer a different question: *which aspect is driving this dimension?* On dimension 2 (the highbrow-popular axis), preference and consumption each contribute ~40%, evaluation only 7%. This means that dimension is defined by what people *like* and *listen to*, not by status attributions. By contrast, dimension 3 is where evaluation dominates (41%), revealing an axis of the taste space organized around status rather than preference or engagement."

**Issue 14: The equation section (line 72-78) is well-prepared but the working example is hard to follow**
- Current: After the decomposition equation, the text jumps into "Consider a respondent who likes sixteen of the twenty genres..."
- Problem: The example is specific but uses many numbers; readers lose the conceptual thread.
- Suggested structure:
  1. Introduce the example respondent in one sentence: "To see what $W_s(i)$ means, consider one respondent and one dimension."
  2. Give the position first: "This respondent sits at position +2.43 on the first dimension (general affirmation)."
  3. Then the three partial points: "Her preference partial point is at +3.33, her consumption at +1.41, her evaluation at +2.56."
  4. Then the disagreement: "All three sit on the same side of zero—she affirms across all aspects. But they're not at the same place. Imagine the respondent as the black dot in Figure 2, and the three colored dots as the partial points. The sum of squared distances from the black dot to the colored dots is $W_1 = 1.9$."
  5. Then contrast dimension 3: "On dimension 3 (the status-valuation axis), something different happens. Preference and consumption sit at +2.27 and +3.58 on the right side (consumption of high-status genres). But evaluation sits at −3.53 on the left side. The respondent likes and listens to jazz but doesn't credit jazz fans with high status—a guilty pleasure. Disagreement now dwarfs position: $W_3 = 28.7$, which is 94% of the variance in her position on this axis."

---

### RESULTS §4.1 (Overall Structure)

**Issue 15: "Percentages of this magnitude are typical for categorical GDA" is a throwaway (line 94)**
- Current: "Percentages of this magnitude are typical for categorical GDA of sparse binary indicators, where a large share of the variance is idiosyncratic genre-by-genre variation."
- Problem: This is a technical reassurance but it's vague. Readers might worry the model is failing.
- Suggested revision: "These percentages might seem small, but they're standard for binary data. When respondents give 60 yes/no answers (20 genres × 3 aspects), each answer adds some independent noise. The patterns we detect across 2,259 respondents are real, but they coexist with substantial person-to-person idiosyncrasy. That's OK—we're mapping the structure, not the noise."

**Issue 16: Dense description of dimension 1 (line 108)**
- Current: "On the first dimension, the 'yes' categories of all three aspects are arrayed on the positive side..."
- Problem: Long list of genre coordinates without summary. Reader loses the forest for the trees.
- Suggested revision: Break into two parts:
  1. Summary: "Dimension 1 is an axis of *general affirmation*. Respondents who like, listen to, and credit any genre sit on the positive side; those who do none of these sit on the negative side."
  2. Evidence: "The rarest affirmations—listening to opera, crediting hip-hop fans with high status—sit furthest toward the positive pole. This is typical of MCA: rare, distinctive answers tell you more about respondents than common ones."

**Issue 17: "Notably" hedges a key point (line 108)**
- Current: "Notably, the genre evaluations themselves number among the most distinctive..."
- Problem: "Notably" suggests the author is surprised; readers wonder if this is an error or expected.
- Suggested revision: "Crucially, status attributions mark respondents as distinctly as consumption does. Saying 'heavy metal fans are high-status' identifies you as strongly as *listening to heavy metal*. This reveals something important: what respondents *think* about genres is not just a gloss on consumption—it's an independent way of positioning yourself in the genre system."

**Issue 18: Dimension 2 description (line 110) is clear but could flag the social reading earlier**
- Current: Starts with category coordinates, then says "The individual factor maps preview this axis's social anchoring..."
- Problem: The social preview feels like an afterthought.
- Suggested revision: After describing the dimension, foreground the social fact: "Dimension 2 is structured by *age*. Older respondents sit toward the highbrow pole; younger respondents toward the popular pole. This is the strongest social anchor in the entire space—far stronger than income or education."

---

### RESULTS §4.2 (RV Coefficients)

**Issue 19: Opening sentence doesn't signal the importance (line 126)**
- Current: "The central result bears on the first question posed above: whether the three aspects are redundant or partially independent."
- Problem: "Bears on" is weak; "whether...is redundant" is double-negative phrasing.
- Suggested revision: "The central result is simple: the three aspects are *not* interchangeable. Preferences and consumption are moderately linked (RV = 0.32), but evaluation is nearly orthogonal to both (RV = 0.05–0.06)."

**Issue 20: Technical summary without interpretation (line 126–127)**
- Current: "The preference and consumption aspects are moderately linked ($RV = 0.32$): those who like a genre are somewhat more likely to have listened to it, but the two structures are far from interchangeable. By contrast, the evaluation aspect is nearly orthogonal to both ($RV = 0.05$ with preference and $0.06$ with consumption)."
- Problem: This just reports the numbers without explaining what they mean for complex tastes.
- Suggested revision: "Why does this matter? Imagine two simple predictions: (1) 'If you like a genre, I can guess whether you've listened to it.' (2) 'If you like a genre, I can guess whether you think its fans are high-status.' Prediction 1 works moderately well (RV = 0.32). Prediction 2 almost never works (RV ≈ 0.05). Status and preference are nearly independent—completely different ways of relating to genres."

**Issue 21: The "geometric signature" metaphor (line 140) needs grounding**
- Current: "This near-orthogonality is the geometric signature of the pluralist conception of taste."
- Problem: "Geometric signature" is metaphorical; readers might not grasp what the orthogonality tells us substantively.
- Suggested revision: "This near-orthogonality is not measurement error. It reflects a genuine feature of how people relate to genres: what you think *about* a genre (its status) is almost entirely separate from whether you *like* it or *engage with* it. You can admire classical music while disliking it. You can despise hip-hop while respecting its cultural importance. These divergences are not contradictions—they're the raw material of complex tastes."

---

### RESULTS §4.3 (Which Aspects Drive Which Dimensions?)

**Issue 22: The opening (line 145) assumes readers understand MFA weighting**
- Current: "MFA's balancing weights—the inverses of the first eigenvalues of the separate analyses ($5.00$ for preference, $6.45$ for consumption, and $2.06$ for evaluation)—put the three aspects on equal footing despite the evaluation aspect's much stronger internal first dimension..."
- Problem: This is circular reasoning for a reader who doesn't already understand MFA. It says we weight by inverses to make them equal, but then reports the weights without explaining which aspect is downweighted and why.
- Suggested revision: "Each block gets an inverse weight based on its internal first eigenvalue (Table 1). Evaluation's internal structure is strong (λ₁ = 0.48), so it gets a small weight (2.06). Preference's is weak (λ₁ = 0.20), so it gets a large weight (5.00). This balancing ensures that the global structure isn't dominated by whichever aspect happened to have the most coherent respondent-sorting on its own."

**Issue 23: The Lg coefficients paragraph (end of line 159) stacks too many numbers**
- Current: "The $Lg$ coefficients answer the participation question from the other direction: every aspect leaves a detectable imprint on the compromise---none is present in name only---but unevenly. The link between evaluation and the MFA ($Lg = 0.75$) is much weaker than the links of preference ($1.80$) and consumption ($2.29$), and the cross-aspect $Lg$ coefficients mirror the RV structure (preference--consumption $0.80$ versus $0.07$ and $0.11$ for the pairs involving evaluation)."
- Problem: Six numbers in three sentences; readers lose the narrative thread.
- Suggested revision: "All three aspects show up in the final map, but unevenly. Preference and consumption are tightly woven into it (Lg = 1.80 and 2.29); evaluation is looser (Lg = 0.75). This echoes the RV pattern: preference and consumption cohere with each other, while evaluation stands apart."

**Issue 24: Partial axes section (line 161) is technically important but hard to parse**
- Current: "The partial axes—each aspect's own axes from the separate analyses, projected into the global space (Table~\ref{tab:partial-axes})—corroborate this reading from the side of the separate analyses."
- Problem: "Partial axes" hasn't been explained. "From the side of the separate analyses" is an awkward phrase.
- Suggested revision: "We can cross-check this reading by looking at each aspect's internal structure. When we analyze preferences alone (ignoring consumption and evaluation), respondents sort themselves along an axis; we can measure how closely that preference axis aligns with the global dimensions. (Table 2 shows these alignments.)"

---

### RESULTS §4.4 (Complex Tastes Operationalization)

**Issue 25: First sentence is a meta-statement rather than a claim (line 166)**
- Current: "We operationalize complex tastes geometrically: as the dispersion $W_s(i)$ of the individual's three partial points (Equation~\ref{eq:decomp}), read directly off the MFA representation."
- Problem: "We operationalize" announces a methodological choice rather than making a substantive claim.
- Suggested revision: "Complex tastes are measured by how far apart an individual's three partial points sit. If all three aspects place you at the same position on dimension 1 (you like, consume, and respect the same genres), $W_1$ = 0—simple tastes. If they pull in different directions, $W_1$ grows—complex tastes, measured geometrically."

**Issue 26: The dispersion results (line 168) are presented in abstract percentage terms**
- Current: "On the first three dimensions, the dispersion of partial points accounts for $51\%$, $51\%$, and $62\%$ of the average projected partial inertia, respectively: by geometry alone, disagreement between aspects contributes about as much to respondents' positions in the taste space as agreement does."
- Problem: "Projected partial inertia" is jargon; readers don't know if 51% is high, low, or expected.
- Suggested revision: "Aspect disagreement is *pervasive*. On dimension 1, disagreement between aspects accounts for about half the variance in where respondents sit (51% vs. 49% from shared position). On dimensions 2 and 3, disagreement is even more prominent (51% and 62%). This means that a respondent's location in the taste space is often driven as much by *where the aspects disagree about them* as by *where they agree*."

**Issue 27: The correlation with configuration count (line 176) is under-interpreted**
- Current: "The geometric complex-taste score on Dimension 1 tracks the total number of complex tastes ($\rho = 0.58$; $\rho = 0.46$ with the total dispersion across the first three dimensions), but its counterparts on Dimensions 2 and 3 do not ($0.11$ and $0.03$)."
- Problem: Why does W₁ track configurations but W₂ and W₃ don't? The text doesn't say.
- Suggested addition: "Why this difference? On dimension 1 (general affirmation), aspect disagreement and configuration count both measure the same thing: whether respondents affirm consistently across genres. On dimensions 2 and 3, they measure different things—one measures how far apart the aspects sit, the other measures which genres they disagree *about*. A respondent can be in many complex configurations while having little aspect disagreement (all configurations involve the same genres), or have high aspect disagreement while being in few configurations (disagreement concentrated in a few genres)."

---

### RESULTS §4.5 (Who Has Complex Tastes?)

**Issue 28: Opening promises a social analysis but doesn't set it up (line 210)**
- Current: "The geometric measuring of complex tastes has one further advantage: $W_s(i)$ is a continuous, dimension-specific quantity, and can therefore serve directly as the outcome of a standard regression model---something the combinatorial count, a single coarse integer, does not allow."
- Problem: This is a technical advantage of the geometric approach, but it doesn't explain *why we care* who has complex tastes.
- Suggested revision: "One puzzle remains: does complex-taste disagreement concentrate in particular social groups? Are wealthy or educated people more likely to have complex tastes? We can now ask this directly, using regression analysis."

**Issue 29: Results are stated but not connected to theory (line 210)**
- Current: "The headline result is the smallness of the associations: the full set of eight demographics accounts for $4.0\%$ of the variance in $W_1$, $3.1\%$ in $W_2$, and $2.2\%$ in $W_3$. Where respondents sit in the taste space is strongly socially patterned (Section~\ref{sec:social}); how much their aspects disagree is nearly socially unstructured."
- Problem: This contrasts social patterning of position vs. disagreement, but doesn't explain *why* this matters or what it says about complex tastes.
- Suggested addition after this: "This is the paper's second main finding: complex tastes are distributed across the social structure. What you *like* and where you sit in the taste hierarchy are strongly shaped by age and education. But whether your taste is *complex*—whether your preferences, consumption, and evaluations align—is nearly independent of social background. Complex tastes are not the signature of any particular social class; they're universal across the population."

**Issue 30: Specific effects are listed without interpretation (line 212)**
- Current: "The partial effects that do emerge are informative. Disagreement over engagement ($W_1$) is higher among respondents whose parents hold a BA ($+0.92$) and among those who identify as upper class ($+3.56$), and it declines with age..."
- Problem: Four or five numbers thrown at reader with minimal interpretation.
- Suggested revision: Break into narrative paragraphs, one per dimension:
  - "Dimension 1 (general affirmation): The advantaged have more complex tastes, not fewer. Those whose parents are college-educated and those who identify as upper class show more aspect disagreement. This might reflect greater exposure to diverse cultural influences—those with cultural capital engage more genres at all three levels, but not uniformly."
  - "Dimension 2 (highbrow-popular): Only age matters, and it's strong. Every age cohort younger than 60 aligns their aspects more closely than the youngest. But the pattern reverses at 70+ (small +0.08 effect). Meaning: middle-aged respondents have the most harmonious tastes; the young and old are more complex."
  - "Dimension 3 (status valuation): Race, not class. Respondents of multiple races show more disagreement between how they rank genres and whether they consume them; Asian respondents show less. This suggests deeper cultural identification or assimilation patterns."

---

### RESULTS §4.6 (Duality)

**Issue 31: Opening justification is dense (line 225)**
- Current: "The transposition is not a mere rearrangement of the original solution. In simple correspondence analysis, the row and column clouds are dual, and the genre coordinates could be read off the original fit at no cost; but multiple correspondence analysis with a block structure breaks that duality..."
- Problem: Readers don't know what CA duality is or why it breaks here. This belongs in a footnote, not in the main argument.
- Suggested revision in main text: "We now flip the analysis: individuals are rows, genres are columns. Each cell asks: does this respondent like/listen to/credit this genre? This is not just rearranging the original table. MFA breaks duality—we must recompute everything from scratch. (Why? Technical reason in footnote.)"
  - Footnote: "In simple correspondence analysis, the row (individual) and column (genre) spaces are mathematically dual: you can derive one from the other. But MCA with groups breaks that duality. The group weights are specific to how we computed the individual space; they don't transfer to the genre space."

**Issue 32: The central duality finding is buried in technical language (line 233)**
- Current: "The central result of the duality analysis is that, from the object side, the aspects *agree*. The genre-level RV coefficients are $0.92$ (preference--consumption), $0.77$ (preference--evaluation), and $0.73$ (consumption--evaluation)---against $0.32$, $0.05$, and $0.06$ at the individual level."
- Problem: Readers might not grasp the implication of this inversion.
- Suggested revision: "This is where things get interesting. At the *individual level*, aspects disagree badly (RV ≈ 0.05–0.32). At the *genre level*, they agree strongly (RV ≈ 0.73–0.92). Why? Consider opera: the people who like it, the people who listen to it, and the people who credit its fans with high status are *nearly the same people*. Disagreement isn't built into the genres; it's built into *people*. Some respondents like opera and consume it; others like it but won't admit it; still others maintain high respect for it without engaging."

**Issue 33: The configuration-axis reading (line 241) is vivid but could be clearer about what drives the pattern**
- Current: "The duality is asymmetric in exactly the way the theory of complex tastes anticipates: the prototypical guilty-pleasure genres are those least credited with high status, and the prototypical distant-praise genres are those least consumed."
- Problem: It states the asymmetry but doesn't explain *why* it exists.
- Suggested addition: "This asymmetry makes sense: guilty pleasures are genres with low cultural standing that people nonetheless enjoy (classic rock, pop, country). Distant-praise genres are culturally prestigious but don't appeal as consumption (opera, folk, bluegrass). Complex tastes are *shaped by cultural hierarchies*—what's prestigious is often not fun, and what's fun is often not prestigious."

---

### DISCUSSION

**Issue 34: Discussion is a placeholder (line 245-247)**
- Current: "[DRAFT: The results establish three things. ...]"
- Recommendation: Once drafted, ensure it:
  1. Opens by restating the three findings narratively (not just "establish three things")
  2. Addresses the "so what?" question: How does this change how we think about taste?
  3. Acknowledges limitations
  4. Points to extensions

---

## SUMMARY OF PRIORITY FIXES

### High Priority (clarity for non-specialist readers):
1. Introduce MFA intuitively before diving into technical details (§1, para 3 & §3 opening)
2. Explain RV and Lg in text, not just footnotes (§3)
3. Simplify dimension descriptions with summaries before evidence (§4.1)
4. Spell out what weak social patterning of complex tastes *means* (§4.5)
5. Clarify the duality finding with intuitive language (§4.6)

### Medium Priority (stylistic polish):
1. Replace passive voice + nominalizations with active, concrete verbs
2. Use shorter paragraphs to guide readers through dense material
3. Move technical asides to footnotes when possible
4. Use "consider this..." examples more often to ground abstractions

### Lower Priority (refinement):
1. Tone down hedges ("notable," "note that") where claims are actually strong
2. Expand worked example structure in other dense sections
3. Add transition sentences between sections

---

## Specific Phrases to Revisit

| Current | Issue | Suggested |
|---------|-------|-----------|
| "develops a measurement strategy" | Abstract | "proposes a geometric method" |
| "a member of the Geometric Data Analysis family" | Jargon | "(a method from the GDA tradition)" |
| "the block structure of the MFA allows us" | Passive | "MFA's block structure lets us" |
| "bears on the first question posed above" | Weak | "directly answers" |
| "complex tastes are configurations in which the aspects disagree" | Circular | "complex tastes occur when what you like, what you consume, and what you respect diverge" |
| "the geometric signature of the pluralist conception" | Metaphorical | "reflects a real feature of taste" |
| "accounts for 4.0% of the variance" | Technical | "explains only 4%—social background matters less than we might expect" |
| "aspects cohere with each other" | Vague | "align structurally" |
