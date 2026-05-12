# PI meeting prep — TCRW reproduction
**Goal:** be able to explain what you did in 5 min, defend the physics for 30 min, and tweak any knob the PI asks for live.

---

## 1. Three-sentence elevator pitch

You reproduced all four data figures of Osat, Meyberg, Metson, Speck (arXiv:2602.12020) — a topological non-Hermitian random-walker paper — in **three independent ways** that all agree at machine/MC-noise precision: Fortran Monte Carlo, exact transition-matrix solution via the authors' published Python (`TRW.py`), and a self-contained Python re-implementation. Bit-identity to the authors' reference matrix at six phase-diagram points (`max|W_authors − W_yours| = 0.00e+00`). Every paper qualitative claim about angles, edge currents, gap-closures, and L-collapse is verified.

That's the line if PI asks "what did you do?".

---

## 2. The model in one minute (memorize)

A walker on a 2D lattice carries a director $d \in \{\uparrow, \rightarrow, \downarrow, \leftarrow\}$. Each MC step:

- with probability $D_r$: **noise step** — rotate director only, no translation. Rotation direction biased by $\omega$:
  - CCW with prob $\omega$, CW with prob $1-\omega$.
- with probability $1 - D_r$: **chiral step** — translate by $\hat{d}$, then rotate. Bias **opposite** to noise:
  - CW with prob $\omega$, CCW with prob $1-\omega$.
- if the chiral translation hits a wall: blocked — **no move and no rotation** (self-loop).

Two consequences load-bearing for everything else:

1. **The two rotation rules have opposite chirality.** This is what breaks Hermiticity of the discrete-time generator $P$ and gives the topology.
2. **Blocked chirals don't reset memory.** The walker's "last event flavor" survives across blocked attempts. This is the **semi-Markov** rule that defines the $J = J_{D_r} + J_\omega$ split.

**Steady state.** Solve $P\pi = \pi$ for the right Perron eigenvector. $\pi$ is a probability over $4(L+1)^2$ states (in authors' L convention).

**Edge localization.** Despite the bulk being a random walk, $\pi$ peaks at boundary sites by orders of magnitude.

**Edge current.** Of all spatial translations, those preceded by a noise step are attributed to $J_{D_r}$, the rest to $J_\omega$. Both are non-zero on edges, and at $\omega = 1$, $D_r$ small:
$$
\theta_{J_\omega}\big|_{\rm left\ wall} = +\pi/4 \quad \text{(constant)}, \qquad
\theta_{J_{D_r}}\big|_{\rm left\ wall} = -\pi/2 \quad \text{(walker drifts down)}.
$$

---

## 3. Each figure in three lines

### Fig 1 — single walker, free space
- Trajectory (panel b), MSD vs t (panel c), $D_{\rm eff}$ vs $\omega$ (panel d).
- Key fact: $D_{\rm eff}$ is non-monotonic, peaks at $\omega = 0.5$ where chirality cancels and the walker is most diffusive. At $\omega = 1$ (purely chiral), the walker traces a closed orbit and $D_{\rm eff} \to 0$.
- Your verification: Bloch-diffusion exact $D_{\rm eff}(\omega)$ overlays the MC at every $\omega$.

### Fig 2 — confined walker, edge current
- $P(X, Y)$ heatmap, $J$, $J_\omega$, $J_{D_r}$ vector fields.
- Key fact: walker concentrates at boundary; **the two currents coexist with different chiralities**. Defect-row (Fig 2k–o) shows the same edge current also forms around internal defects → "edges are intrinsic, not box-special".
- Your verification: 2×3 cross-check (P_Fortran vs P_exact heatmaps + J quiver overlays + RMS stats) at all three $\omega \in \{0, 0.5, 1\}$.

### Fig 3 — parametric scans
- (a, b) scan vs $D_r$ at $\omega = 1$, multiple L; (f, g) scan vs $\omega$ at $D_r = 10^{-3}$, multiple L. (c, d, h, i) per-y left-wall current vector fields. (e, j) angle of total wall current.
- Key facts: $P_{\rm edge}/P_{\rm bulk}$ collapses to a master curve **independent of L** — that's the topological signature. $J_{D_r}/J_\omega$ ratio plateaus at ~0.7 for $D_r < 0.1$, then diverges as $D_r \to 1$ (bookkeeping artefact, not physics).
- Your verification: 6 cross-checks, all at MC-noise floor. Angles agree at $10^{-3}$ rad on totals.

### Fig 4 — non-Hermitian topology
- (b) PBC band structure $\Gamma$–$X$–$M$–$\Gamma$. (c) OBC spectrum surfaces over $(\omega, D_r)$ at $L=2$. (d, e) OBC bands vs $D_r$ and $\omega$. (f, g) complex-plane spectra. (h) HPBC vs $k_y$. (i) HPBC band circle.
- Key facts: PBC gap **closes at $\omega = 1/2$** — topological phase transition. OBC develops protected **edge modes** (verified by edge-localized eigenvectors of right eigenvectors). Non-Hermiticity → eigenvalues spread into the complex plane and an exceptional point appears at $D_r \to 0$.
- Your verification: Bloch matrix bit-identical to authors' real-space transition matrix on a PBC torus (max$|\Sigma_{\rm torus} - \Sigma_{\rm Bloch}| < 1.2 \times 10^{-14}$). OBC matrix bit-identical to authors at six test points.

---

## 4. Conventions PI may ask about

| Item | Authors' Python | Your Fortran | Paper figures |
|---|---|---|---|
| L | max-index → $(L+1)^2$ sites | site-count → $L^2$ sites | site-count (Fig 2 axes 0..9) |
| Direction order | $[\uparrow, \rightarrow, \downarrow, \leftarrow]$ = 0..3 | same | same |
| State index | $(i \cdot (L+1) + j) \cdot 4 + d$ | $d \cdot L^2 + y \cdot L + x$ | implied site-major |
| Angle $\theta$ | $\text{atan2}(J_y, J_x)$ from $+x$ | same | "with respect to horizontal axis" (page 4) |
| $J_{D_r} / J_\omega$ split | flux-flavor partition (Markov) | trajectory `prev_noise` flag | "translation right after a noise step" |

**The L-convention asymmetry is real.** Paper Fig 2 axes go 0..9 → 10 sites → matches your Fortran $L=10$. For Fig 3 your code uses authors' max-index ($L_\text{paper} + 1$ sites), which is consistent with the authors' Python but possibly off-by-one vs the paper figure axis labels. **State this proactively if the topic comes up — do not let PI find it.** Numerically the difference is 2–3 % on the master curve, doesn't change physics.

---

## 5. Anticipated PI questions and prepared answers

### Q1: "Why does the walker localize at the edge?"
**A:** At $\omega = 1$ the chiral rule rotates the director CW after every successful translation. On the left wall the walker hits with director $\leftarrow$, gets blocked indefinitely until a noise event flips its direction. The opposite chirality of the noise rule (CCW at $\omega = 1$) sends $\leftarrow \to \downarrow$, then a chiral step takes it down by one and rotates it back to $\leftarrow$. So per noise event the walker drifts one site down the wall — that's the "skipping orbit". Drift speed $\sim D_r$ per noise event, but noise events themselves arrive at rate $D_r$, so the overall down-drift is $\sim D_r^2$ per step. Wall-escape requires *two* consecutive noise events flipping the director away from the wall, hence escape time $\tau_{\rm wall} = 1/D_r^2$.

### Q2: "What's the topological invariant?"
**A:** Vectorized 2D Zak phase computed on the bulk PBC bands. It's nontrivial in the region $D_r < 1/2$, $\omega \neq 1/2$. Bulk-boundary correspondence then guarantees the OBC edge modes seen in Fig 4(c–h). The gap closes at $\omega = 1/2$ because chiral-CW and chiral-CCW rates are equal there → non-Hermitian splitting vanishes → topological phase transition. We didn't recompute the Zak phase ourselves; we verified the gap closure (Fig 4b) and the edge modes (Fig 4c–h) directly.

### Q3: "Why two currents instead of one?"
**A:** Decomposition is by which event preceded a translation: noise event → $J_{D_r}$, chiral event → $J_\omega$. They have **different chiralities at the wall**: at $\omega = 1$, $J_\omega$ at left wall points $+\pi/4$ (chiral motion goes up-right, walker leaves edge), $J_{D_r}$ points $-\pi/2$ (drifts down along wall). They nearly cancel: the *total* edge current $J = J_\omega + J_{D_r}$ is small, but each piece is large. The Fig 3(b) ratio plateau at $\sim 0.7$ for $D_r < 0.1$ is the signature.

### Q4: "How do you know your code is correct?"
**A:** Three independent cross-checks. (a) Element-wise matrix identity to authors' published `TRW.build_sparse_transition_matrix` at six $(\omega, D_r, L)$ points covering all corners of the phase diagram including $\omega = 1/2$ and $D_r \in \{0, 1\}$ — `max|W_A − W_U| = 0.00e+00` everywhere. (b) Fortran MC matches exact Python at MC noise: $10^{-3}$ rel-error on edge observables, 1–4 % on bulk above $D_r = 10^{-2}$, 30–70 % below — and that 30–70 % is consistent with the wall-escape correlation time $\tau_{\rm wall} = 1/D_r^2$ giving only $\sim 100$ effective independent samples at $T = 10^8$ steps. (c) For Fig 4 PBC bands, my Bloch matrix's spectrum equals the union of spectra of authors' real-space matrix on a PBC torus, to $10^{-14}$.

### Q5: "What discrepancies did you find?"
**A:** Two minor ones, both cosmetic. (a) Paper Fig 3(h) colorbar shows max $\log|J_{D_r}| \approx -5$, exact gives $-4.65$. Both my Fortran MC AND my exact Python agree on $-4.65$, so the paper colorbar likely clips at the round-number $-5$ tick. (b) Earlier audit incorrectly suggested the Fig 2 L convention was off-by-one — wasn't, you confirmed paper axes go 0..9 = your $L = 10$ Fortran convention. Already noted in `REAUDIT_2026-04-30.md`.

### Q6: "What's the natural DP2 extension?"
**A:** Stephy Jose suggested four directions in her email (April). The lowest-risk is **jerky harmonic oscillator in 2D** — extend Lowen's 1D jerky calculation. The most exciting is **adding jerk to the lattice walker** to see how the third time-derivative changes the topology — does the gap close at $\omega = 1/2$ still, or does it shift? The two-state edge model (Methods of TCRW paper) becomes a (director × angular-momentum) model with jerk → analytic escape time should pick up corrections in the jerk parameter. Snap-active particle (4th derivative) is the high-risk variant.

### Q7: "Show me the figure at $L = 99$" (or any other tweak)
**A:** Live demo. See §6 below.

### Q8: "Why did you use both Fortran and Python?"
**A:** Different jobs. Fortran does the long Monte Carlo runs ($T = 10^{10}$, ~15 min of wall-clock per cell) where you need raw speed for statistics. Python does the eigenvalue-problem side: build the transition matrix and diagonalize. Linear algebra in Python is identical to Fortran-LAPACK because numpy *is* LAPACK underneath, just with friendlier syntax. So Fig 4 (pure spectral analysis, no MC) is Python-only by choice — Fortran would buy nothing.

---

## 6. Live tweaks if PI asks

### "Run Fig 3(a) at $L = 99$ for me"
```python
# in IPython at /TIFR_DP2/new_fortran_reproduction_and_python/
import tcrw_fig3_exact as ex
import numpy as np

D_r_grid = np.logspace(-3, 0, 15)
ratios = []
for D in D_r_grid:
    pi, *_ = ex.steady_state_and_currents(omega=1.0, D_r=float(D), L_paper=99)
    P_e, P_b, _, _ = ex.edge_bulk_per_site(pi, 99)
    ratios.append(P_e / P_b)

import matplotlib.pyplot as plt
plt.loglog(D_r_grid, ratios, 'o-'); plt.show()
```
Takes 1–2 min at $L = 99$ (sparse Perron via shift-invert). At $L = 199$, ~5 min.

### "Try $\omega = 0.3$, $D_r = 0.05$"
```python
pi, J_Dr, J_om, _ = ex.steady_state_and_currents(0.3, 0.05, 10)
t = ex.left_wall_J_totals(J_Dr, J_om, 10)
print(t)  # ratios, angles, abs values
```

### "Add a defect at (5, 5)"
```python
# Use authors' TRW directly; supports a `defects=` kwarg.
import importlib.util
spec = importlib.util.spec_from_file_location("TRW", "TRW._original_code_by_paperauthors.py")
TRW = importlib.util.module_from_spec(spec); spec.loader.exec_module(TRW)
W = TRW.build_sparse_transition_matrix(L=9, omega=0.0, D_r=1e-3, defects=[(5,5)])
pi, _ = TRW.solve_steady_state_sparse(W, L=9, defects=[(5,5)])
J_Dr, J_om = TRW.calculate_J1_J2_with_boundaries(pi, W, L=9, D_r=1e-3, omega=0.0, defects=[(5,5)])
```
Plot afterwards with `tcrw_fig2_pymc.reshape_pi_to_PXY` + `imshow`.

### "Run a short Fortran MC at $\omega = 0.7$"
```bash
# Edit tcrw_fig2_clean.f90: change omega_list to (/ 0.7_dp /)
# and reduce T_steps from 10**10 to 10**8 for a quick run (takes ~2 min)
gfortran -O2 -fno-range-check -ffree-line-length-none tcrw_fig2_clean.f90 -o tcrw_fig2_clean
./tcrw_fig2_clean
```
Or just have the existing $\omega \in \{0, 0.5, 1\}$ outputs ready to show.

### "Show me the edge mode at $L = 12$"
```python
import tcrw_fig4f as f4f
P = f4f.build_obc_matrix(omega=1.0, D_r=0.1, L=12)
import numpy as np
evals, evecs = np.linalg.eig(P.toarray())
# Pick the most edge-localized eigenvector
edge_w = f4f.compute_edge_weight(evecs, L=12)
i = np.argmax(edge_w)
print(f"Most edge mode: λ = {evals[i]:.4f}, edge weight = {edge_w[i]:.3f}")
```

---

## 7. Files to have open during the meeting

If PI asks "show me the code", have these tabs ready:

1. `TRW._original_code_by_paperauthors.py` — to point to authors' definitions when discussing model/decomposition.
2. `tcrw_step.f90` — to show the kernel matches authors line-by-line.
3. `tcrw_fig3_exact.py` — to demo a live tweak.
4. `tcrw_fig3_authors.png` and `tcrw_fig3_compare_with_paper.png` — to show paper-faithful reproduction visually.
5. `tcrw_fig4_FULL_AUDIT.png` — for the spectral / topology side.
6. `REAUDIT_2026-04-30.md` and `FIG3_AUDIT_REPORT.md` — for the audit trail.

---

## 8. Honest items to volunteer (don't let PI find them first)

- **Fig 3 L convention asymmetry** — your code uses authors' max-index, paper Fig 2 axes use site-count. Effect is 2–3 % numerically, doesn't change physics. Acknowledge once, move on.
- **Paper Fig 3(h) colorbar discrepancy of 0.35 dex** — explained by colorbar visual clipping, not a code bug. State this proactively.
- **Fig 3 cross-checks have 30–70 % MC noise on bulk at $D_r < 10^{-2}$** — this is the wall-escape correlation time, not a kernel bug. Easy to suppress with a longer Fortran run if PI wants tighter numbers.
- **Fig 4 panels (g)(h)(i) use $D_r = 0.1$** — paper doesn't label this explicitly for those panels; we picked 0.1 to match Fig 4(e). If supplemental gives a different value, 30 s rerun.

---

## 9. What you should NOT claim if pressed

- **Don't claim** you derived the Zak phase or the topological invariant. You verified the gap-closure and edge-mode existence, but the topological argument itself is the paper's, not yours.
- **Don't claim** the Methods two-state edge model — you understand it but didn't re-derive it.
- **Don't claim** to have explored defect or maze physics — those are panels you reproduced for completeness, not extended.

If PI asks "what's *original* about your work here?", answer:
> "Nothing original — this is reproduction work to validate the methodology and build a tested base for DP2. The originality starts when we add jerk and see whether the gap-closure condition shifts, the edge-mode protection survives, and the wall-escape time gets jerk corrections."

That's the right framing. PI will respect honesty more than overclaim.

---

## 10. Two hours of focused prep (suggested)

| Time | Activity |
|---|---|
| 30 min | Read this doc, then re-read paper §II + §III with this doc beside you |
| 30 min | Re-read paper §IV + Methods (model definition, two-state edge, Zak phase) |
| 30 min | Open `TRW.py`, `tcrw_step.f90`, `tcrw_fig3_exact.py`, `build_obc_matrix` in `tcrw_fig2_pymc.py` — read each in full |
| 20 min | Practice answering Q1, Q2, Q3, Q4, Q6 OUT LOUD (in your room, no notes) |
| 10 min | Dry-run the live tweaks in §6 once each — make sure they execute |

Stop after 2 hours. More than that and you'll be tired tomorrow.

---

## 11. Bottom line (memorize this)

**Reproduced 4 paper figures three ways. Bit-identical to authors' published code. MC matches exact at MC-noise. All paper qualitative claims verified. One known cosmetic discrepancy (Fig 3h colorbar), explained. Ready to extend to DP2 (jerky chiral active particles) on this verified base.**

Say that line if PI gives you 30 seconds and walks away. It's all true.
