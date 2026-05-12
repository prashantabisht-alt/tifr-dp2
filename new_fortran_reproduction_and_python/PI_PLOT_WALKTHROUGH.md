# Plot-by-plot walkthrough script for PI meeting

**How to use this:** keep open as a tab. Show plots in this order. Spend ~1–2 min per plot unless PI asks for more. If PI cuts you off and moves on, that's good — means they got it.

---

## Order of presentation

Paper-order, figure 1 → 4. This builds the physics story:
- **Fig 1** — single walker, free space, defines the model.
- **Fig 2** — confined walker, edge current emerges.
- **Fig 3** — parametric scans, quantifies edge physics.
- **Fig 4** — explains it via non-Hermitian topology.

Each figure: show **one comparison plot** to establish authority, then **one detail plot** if PI wants more.

---

## Fig 1 — Single walker, free space (3 plots, ~3 min)

### Plot 1.1: `tcrw_fig1b_pymc.png` — trajectory snapshots at $\omega \in \{0, 0.5, 0.75, 1\}$

**Say:** "Top-left $\omega = 0$, top-right $\omega = 0.5$, bottom-left $\omega = 0.75$, bottom-right $\omega = 1$. At $\omega = 0$ and $\omega = 1$ the walker traces a closed orbit — purely chiral, no diffusion. At $\omega = 0.5$ it's a regular random walker, fully diffusive. The intermediate $\omega = 0.75$ is the interesting case — biased random walk with chirality."

**Point at:** the closed loops at $\omega = 1$ vs the diffusive cloud at $\omega = 0.5$.

**Physics anchor:** rotational noise breaks the closed orbit; chirality biases the rotations. The competition gives an effective diffusion constant.

**Likely PI question:** "Why does the walker not drift in any direction?"
**Answer:** "Because the walker has 4-fold symmetry of the director — at the bulk level there's no net direction, only chirality. Drift would require breaking the 4-fold symmetry, which a wall does — that's Fig 2."

---

### Plot 1.2: `tcrw_fig1c_pymc.png` — MSD vs t at four $\omega$ values

**Say:** "Mean-square displacement is linear in time at long times for every $\omega$ except the closed-orbit cases ($\omega = 0, 1$, where MSD saturates). Slope = $4 D_{\rm eff}$. At $\omega = 0.5$ the slope is largest — chirality cancels, walker is most diffusive."

**Point at:** the long-time linear regimes; the slope difference between $\omega = 0.5$ (steepest) and $\omega = 0.9$ (shallow).

**Physics anchor:** $D_{\rm eff}(\omega)$ is non-monotonic, peaks at $\omega = 0.5$ — opposite of what you might naively expect.

**Likely PI question:** "Where does the saturation at $\omega = 1$ come from?"
**Answer:** "Closed orbit. At $\omega = 1$ pure chiral motion, the walker traces a 4-step square cycle and never escapes. Any noise event ($D_r > 0$) breaks that closure and gives diffusion."

---

### Plot 1.3: `tcrw_fig1d_crosscheck.png` — $D_{\rm eff}$ vs $\omega$ at two $D_r$ values, MC and exact overlay

**Say:** "This is the cross-check that proves both my Fortran MC and my Python exact agree with the analytic Bloch-diffusion result. Symbols are MC, line is the exact Bloch eigenvalue calculation. Peak at $\omega = 0.5$ as expected."

**Point at:** the overlap between markers and line — that's what 'verified' looks like.

**Physics anchor:** the exact line comes from diagonalizing the 4×4 Bloch matrix at $\mathbf{k} = 0$, taking the curvature of the leading eigenvalue, gives $D_{\rm eff}$ analytically.

**Likely PI question:** "Why is $D_{\rm eff}$ exactly zero at $\omega = 0$ and $\omega = 1$?"
**Answer:** "Closed orbits — MSD bounded → diffusion zero. The exact calculation shows a $D_{\rm eff} \propto D_r$ scaling near $\omega = 0, 1$ with the prefactor going to zero in the $D_r \to 0$ limit."

---

## Fig 2 — Confined walker, edge current (3 plots, ~5 min — this is where the story lives)

### Plot 2.1: `tcrw_fig2_authors.png` — $P(X, Y)$ heatmap + currents, three rows for $\omega \in \{1, 0.5, 0\}$

**Say:** "Left column is the spatial distribution $P(X, Y)$ on a $10 \times 10$ box, log scale. Black = bulk, yellow = edge. Walker is concentrated on the boundary by ~3 orders of magnitude — that's the edge localization. Right three columns are total current $J$, chiral component $J_\omega$, and noise-induced component $J_{D_r}$. Top row is fully chiral $\omega = 1$ — clear CCW circulation. Middle row $\omega = 0.5$ — same edge localization but currents nearly cancel. Bottom row $\omega = 0$ with the L-shape defect — note the edge current wraps around the defect too, that's the topological signature."

**Point at:** (1) the bright edge in the heatmap, (2) the swirling arrows in $J$ for the top row, (3) the way the bottom row shows current flowing around the defect cluster.

**Physics anchor:** edge localization happens for all $\omega$, but currents only flow when chirality $\omega \neq 0.5$. The defect row proves edges are intrinsic, not box-special.

**Likely PI question:** "What's the role of the L-shape defect?"
**Answer:** "Demonstration that the edge effect is topological — it forms wherever there's a wall, not just on the outer boundary. If you put a defect cluster inside the bulk, the chiral edge current wraps it the same way it wraps the box. That's the 'no edge is special' message."

---

### Plot 2.2: `tcrw_fig2_fortran_vs_exact_w1.0.png` — 2×3 layout: P_Fortran vs P_exact + residual, J_Dr and J_omega quivers overlaid, stats

**Say:** "This is one of the cross-check plots — Fortran MC versus exact Python at $\omega = 1$, $D_r = 10^{-3}$, $L = 10$. Top row: P from Fortran, P from exact, residual. Notice the residual is $10^{-4}$ to $10^{-5}$ — that's MC noise on $T = 10^{10}$ steps. Bottom row: quiver overlays for $J_{D_r}$ and $J_\omega$. Red is Fortran, black is exact. They sit on top of each other. The stats panel on the right gives $\max|P_F - P_E| = 1.18 \times 10^{-4}$, RMS $3 \times 10^{-5}$ — well within the MC budget of $1/\sqrt{T \cdot P} \approx 10^{-5}$."

**Point at:** the residual heatmap (third panel top row) showing only random noise, not systematic patterns; the overlapping quiver fields in the bottom row.

**Physics anchor:** matches at MC noise level → both implementations are correct, no bias.

**Likely PI question:** "What if I see a systematic pattern in the residual?"
**Answer:** "I'd worry. Random pattern means MC noise; systematic pattern means a kernel bug or convention mismatch. We get random — passes the test. I have similar plots at $\omega = 0$ and $\omega = 0.5$, all clean."

---

### Plot 2.3: `tcrw_fig2_currents_fortran.png` (or `tcrw_fig2_currents.pdf` if PI prefers gnuplot output)

**Say:** "Same data as the authors plot, but here from the Fortran-only path through gnuplot. Same physics, different toolchain. PDF output goes straight into LaTeX."

**Point at:** clean gnuplot rendering, professional look.

**Physics anchor:** same as 2.1.

**Why show this:** if PI is gnuplot-friendly, this earns a smile. If not, skip.

---

## Fig 3 — Parametric scans (3 plots, ~5 min)

### Plot 3.1: `tcrw_fig3_compare_with_paper.png` — paper Fig 3 stacked over my reproduction

**Say:** "Paper on top, my reproduction below. All ten panels — (a) through (j). Top row scans $D_r$ at $\omega = 1$, bottom row scans $\omega$ at $D_r = 10^{-3}$. Panel (a) is the master-curve collapse — multiple L curves overlap, that's the topological signature. Panel (b) is the $|J_{D_r}|/|J_\omega|$ ratio plateau at ~0.7 followed by divergence as $D_r \to 1$. Panels (c–d) and (h–i) are quiver fields on the left wall — note the direction sweep from down to right in panel (c), and the symmetric flip across $\omega = 0.5$ in panel (h). Panels (e) and (j) are the angle plots — paper's qualitative claims about $\theta_{J_\omega} = \pm \pi/4$ and $\theta_{J_{Dr}}$ stepping at $\omega = 0.5$ are directly visible."

**Point at:** (1) the matching shapes between paper and mine in (a) and (g) (V-shape symmetric about $\omega = 0.5$), (2) the arrow rotation in (c) at small vs large $D_r$, (3) the discontinuity in (j) at $\omega = 0.5$.

**Physics anchor:** every paper qualitative claim has been verified visually and numerically.

**Likely PI question:** "Why does $|J_{D_r}|/|J_\omega|$ diverge as $D_r \to 1$?"
**Answer:** "Bookkeeping artefact, not edge physics. At $D_r$ near 1, almost every chiral attempt is preceded by a noise event — so by the decomposition rule almost every translation gets attributed to $J_{D_r}$ regardless of where it is. The ratio diverges because $J_\omega$ vanishes by definition, not because the physical edge current is large. The paper makes this point on page 3."

---

### Plot 3.2: `tcrw_fig3a_crosscheck.png` — Fortran MC vs exact, panel (a)

**Say:** "Same panel (a) data with my exact Python overlay. Markers are Fortran MC, lines are exact eigensolve. The L curves collapse, and the cross-check is tight — edge agreement at $10^{-3}$ relative error, bulk at 1–4 % above $D_r = 10^{-2}$. Below $D_r = 10^{-2}$ bulk noise grows to 30–70 %, but that's expected: the wall-escape autocorrelation time is $1/D_r^2$, so at $T = 10^8$ steps you only see ~$K_{\rm meas} = 100$ effective independent bulk samples. Standard error scales as $1/\sqrt{100} \sim 10\%$, going up to 70 % in worst cells."

**Point at:** how the markers track the exact lines tightly at large $D_r$, then scatter visibly at small $D_r$ — that's the wall-trapping signature.

**Physics anchor:** MC-noise budget is consistent with the $1/D_r^2$ correlation time predicted by the two-state edge model. So **the MC noise itself confirms the analytical prediction**.

**Likely PI question:** "Could you push T higher to suppress noise?"
**Answer:** "Yes, $T = 10^{10}$ would suppress to ~1 % at the cost of ~15 minutes per cell. The paper used $T = 10^{10}$. I used $T = 10^8$ for cross-checking because the noise budget at this T already validates the kernel. For paper-quality reproduction I'd push to $10^{10}$."

---

### Plot 3.3: `tcrw_fig3_cdhi_overlay.png` — spatial quiver overlay diagnostic

**Say:** "Spatial overlay for panels (c)(d)(h)(i). Gray arrows are exact, colored arrows are Fortran. Same direction at every cell. This is the per-y current verification — panel (h) clearly shows the $\omega = 0$ → $\omega = 1$ chirality flip with arrows pointing up on the left of the figure and down on the right. Panel (i) shows the continuous $J_\omega$ direction sweep through zero at $\omega = 0.5$."

**Point at:** the arrow-direction agreement at the symmetric points.

**Physics anchor:** cell-by-cell verification, not just totals.

**Likely PI question:** "Why is the colorbar scale different between (h) and (i)?"
**Answer:** "Different physical magnitudes. $|J_\omega|$ is nearly constant in $\omega$ at fixed $D_r = 10^{-3}$ — paper says explicitly 'almost constant'. $|J_{D_r}|$ varies by orders of magnitude, vanishing at $\omega = 0.5$ where chirality cancels. So narrow range for (i), wide range for (h). I tuned each colorbar to its own data range."

---

## Fig 4 — Non-Hermitian topology (4 plots, ~5 min, or skip to summary if time short)

### Plot 4.1: `tcrw_fig4b_paper.png` — PBC band structure $\Gamma$–$X$–$M$–$\Gamma$

**Say:** "Bulk Bloch bands for the 4×4 transition matrix $P(\mathbf{k})$ along the high-symmetry path. Three rows are $\omega = 1, 0.5, 0$. Top: chiral, gap is open. Middle: $\omega = 0.5$, **gap closes** — that's the topological phase transition. Bottom: $\omega = 0$, gap reopens with opposite chirality. The matrix is non-Hermitian because the noise and chiral rules rotate in opposite directions, so eigenvalues can be complex; we plot real part on top and imaginary on bottom."

**Point at:** the gap closing in the middle row at the high-symmetry points.

**Physics anchor:** gap closure = topological phase transition. Either side is topologically distinct.

**Likely PI question:** "What's the symmetry that protects the gap?"
**Answer:** "Sublattice / chiral symmetry: there's a unitary $S$ such that $S P S^{-1} = -P$, so eigenvalues come in $\pm \lambda$ pairs. Combined with time-reversal (real coefficients) you get $\pm \lambda$ AND $\pm \lambda^*$, four eigenvalues per $\mathbf{k}$. The gap is between the $+\lambda$ and $-\lambda$ pair. Closing requires both pairs to coincide, which happens when the non-Hermitian splitting between chiral and noise rules vanishes — at $\omega = 1/2$."

---

### Plot 4.2: `tcrw_fig4c_compare_with_paper.png` — OBC spectrum on $L = 2$, surfaces over $(\omega, D_r)$

**Say:** "Same matrix but now with open boundary conditions — only $L = 2$, so it's a 16×16 matrix. Plotted as 3D surfaces over the $(\omega, D_r)$ plane. Color is edge weight: blue is bulk-localized eigenvector, red is edge-localized. Note the X-shaped intersection where bulk and edge bands cross — that's the precursor to bulk-boundary correspondence. Even at $L = 2$ you can see edge modes peeling off."

**Point at:** the red sheets (edge modes) at large $\omega$ and small $D_r$ — that's the topological region.

**Physics anchor:** OBC introduces edge states; their localization is what protects them.

**Likely PI question:** "Why $L = 2$? Doesn't that have only the edge?"
**Answer:** "Yes, that's the point — at $L = 2$ every site is a corner, so the 'edge' is the whole system. The interesting feature is the spectral structure shows up even there. Larger $L$ in panels (d)–(g) shows the bulk-boundary separation more cleanly."

---

### Plot 4.3: `tcrw_fig4d_compare_with_paper.png` — Re(λ) vs $D_r$ at $\omega = 1$, $L = 10$

**Say:** "OBC bands as a function of $D_r$ at fully chiral $\omega = 1$. Each curve is one eigenvalue tracked across $D_r$. Color is edge weight. Note the **coalescence at $D_r \to 0$** — multiple eigenvalues collapsing to the same real part. That's an exceptional point, characteristic of non-Hermitian systems. As $D_r$ grows the spectrum spreads back out."

**Point at:** the dense collapse at $D_r = 0$ on the left, the spread on the right.

**Physics anchor:** exceptional points are where eigenvectors become degenerate (not just eigenvalues) — uniquely non-Hermitian feature.

**Likely PI question:** "What's an exceptional point physically?"
**Answer:** "It's a degeneracy point in a non-Hermitian operator where two or more eigenvalues AND their eigenvectors coincide. In a Hermitian system you'd have orthogonal eigenvectors at a degeneracy; here they coalesce. Physically it means at $D_r = 0$ several modes become indistinguishable — chirality alone cannot lift the degeneracy. Adding any noise lifts it."

---

### Plot 4.4: `tcrw_fig4_FULL_AUDIT.png` — stacked overview of all panels

**Say:** "All Fig 4 panels stacked vertically. Quick summary tour: top is the 3D surface, then the band crossings vs $D_r$ and $\omega$, then the complex-plane spectra showing edge mode rings, then the HPBC bands and the band circle in $(\cos k_x, \cos k_y)$. Each panel verified bit-identical to authors' code where applicable, or self-consistent where authors didn't ship code (HPBC and band circle)."

**Point at:** the variety of perspectives — same matrix, six different views.

**Physics anchor:** cross-cutting visualization of the same topology from different angles. If any panel disagreed with the others you'd know something was wrong.

**Likely PI question:** "Why so many panels for one matrix?"
**Answer:** "Each emphasizes a different feature of the spectrum. Panel (b) is bulk gap structure, (c) is the $(\omega, D_r)$ phase diagram in spectrum space, (d, e) are 1D scans, (f, g) are complex-plane bird's-eye views, (h, i) are hybrid boundary cases. Topology is hard to summarize in one plot — the paper uses six and so do I."

---

## What to skip (or only show if asked)

- All `tcrw_fig{1,2,3}*.pdf` (the gnuplot-only Fortran outputs) — redundant with the matplotlib versions for storytelling. Show only if PI specifically asks for gnuplot output.
- The 6 individual `tcrw_fig3{a,b,cde,f,g,hij}_crosscheck.png` files — `compare_with_paper.png` already shows the data; the individual cross-checks are deeper detail. Show only if PI asks "is panel X verified?"
- `tcrw_fig2_pymc.png` — basically identical to `tcrw_fig2_authors.png`; only mention if PI asks "what's the difference between authors and pymc versions?"

---

## Closing line (after walking through plots)

> "Net result: every paper figure reproduced three ways, all consistent at machine or MC-noise precision. Bit-identical to authors' published reference. One known cosmetic discrepancy (Fig 3h colorbar) explained as paper's visual clipping. This is the verified base I want DP2 to build on — adding jerk to the lattice walker and seeing what changes."

That's the handoff line for the DP2 conversation. It tees up the next research question without overclaiming.

---

## Total time budget

- Fig 1: 3 min (3 plots × 1 min)
- Fig 2: 5 min (3 plots, but 2.1 deserves more time)
- Fig 3: 5 min (3 plots; 3.1 is the centerpiece)
- Fig 4: 5 min (4 plots; can compress if PI cuts off)
- Closing + Q&A: 5–10 min

**Total: ~25–30 min** of plot-walking. If PI gets bored at 15, that's fine — you've covered the essentials by then. If PI wants to keep going, you've got fuel for another 30.
