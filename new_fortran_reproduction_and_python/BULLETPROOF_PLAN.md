# Bulletproof plan — `new_fortran_reproduction_and_python/`

**Date:** 2026-05-02
**Goal:** every panel of Fig 1–4 paper-faithful at the bit-/MC-noise level, reproducible from a clean checkout in one command per figure, with **one consistent toolchain** (Fortran MC → `.txt` ; Python exact → `.txt` ; gnuplot reads both `.txt` files and overlays).  No more matplotlib lock-in for plot artefacts your prof has to read.

---

## 1. What "bulletproof" means here

Five concrete criteria.  A panel is **bulletproof** iff it satisfies all five:

| # | Criterion | Why it matters |
|---|---|---|
| B1 | **Authors' code is the reference.** Every observable is computed by `TRW._original_code_by_paperauthors.py` (or a Python port that's bit-verified against it). | Eliminates "is my code right?" from the audit chain. |
| B2 | **Fortran MC matches exact Python at MC noise.** Per-panel rel-error budget documented and within bounds. | Tests both implementations against each other. |
| B3 | **Visual reproduction matches paper figure.** Cross-check side-by-side comparison artefact exists. | Catches qualitative bugs that pass numerical checks. |
| B4 | **One-command rebuild.** `bash run.sh tcrw-figX-all` rebuilds Fortran, runs Python exact, regenerates gnuplot PDFs, all from clean. | Eliminates "I forgot to rerun X" mistakes. |
| B5 | **Convention documented.** L convention, angle convention, normalization noted in the source AND in a single-source-of-truth README section. | Prevents convention drift in DP2. |

---

## 2. Current state matrix

Symbols: ✅ done · ⚠ partial / stale · ❌ missing · 🚫 not applicable

| Figure | Panel | B1 reference | B2 MC↔exact | B3 paper visual | B4 one-cmd | B5 convention | overall |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **Fig 1** | (b) trajectory | ✅ | ⚠ no MSD overlay | ✅ pdf | ⚠ partial | ✅ | ⚠ |
|     | (c) MSD vs t | ✅ | ⚠ no overlay | ✅ pdf | ⚠ | ✅ | ⚠ |
|     | (d) D vs ω | ✅ | ✅ crosscheck.png | ✅ | ⚠ | ✅ | ✅ |
| **Fig 2** | clean P(X,Y) ω∈{0,0.5,1} | ✅ | ✅ at MC noise | ✅ authors+pymc+overlay | ⚠ no `tcrw-fig2-all` | ✅ | ✅ |
|     | clean currents (J, J_ω, J_Dr) | ✅ | ✅ | ✅ | ⚠ | ✅ | ✅ |
|     | defects ω=0 | ✅ | ✅ | ✅ | ⚠ | ✅ | ✅ |
|     | **L convention off-by-one (L=10 → 11)** | ⚠ | ⚠ | ⚠ paper-L=9 not 10 | ❌ | ⚠ documented but not fixed | ⚠ |
| **Fig 3** | (a) P_edge/P_bulk vs D_r | ✅ | ✅ matplotlib overlay | ⚠ no gnuplot overlay yet (have `_overlay.gnu` for 3a only) | ⚠ | ✅ | ⚠ |
|     | (b) ratio vs D_r | ✅ | ✅ | ⚠ no gnuplot overlay | ⚠ | ✅ | ⚠ |
|     | (c)(d) per-y current vs D_r | ✅ | ✅ | ⚠ no gnuplot overlay | ⚠ | ✅ | ⚠ |
|     | (e) θ_total vs D_r | ✅ | ✅ | ⚠ no gnuplot overlay | ⚠ | ✅ | ⚠ |
|     | (f) P-ratio vs ω | ✅ | ✅ | ⚠ no gnuplot overlay | ⚠ | ✅ | ⚠ |
|     | (g) ratio vs ω | ✅ | ✅ | ⚠ no gnuplot overlay | ⚠ | ✅ | ⚠ |
|     | (h)(i) per-y current vs ω | ✅ | ✅ | ⚠ no gnuplot overlay | ⚠ | ✅ | ⚠ |
|     | (j) θ_total vs ω | ✅ | ✅ | ⚠ no gnuplot overlay | ⚠ | ✅ | ⚠ |
| **Fig 4** | (b) PBC bands | ✅ torus crosscheck | 🚫 (no MC) | ✅ | ❌ no `tcrw-fig4-all` | ✅ | ⚠ |
|     | (c) OBC L=2 surfaces | ✅ bit-identical | 🚫 | ✅ matplotlib | ❌ | ✅ | ⚠ |
|     | (d)(e) Re(λ) vs D_r/ω | ✅ | 🚫 | ⚠ visually busy | ❌ | ✅ | ⚠ |
|     | (f)(g) complex plane | ✅ | 🚫 | ✅ | ❌ | ✅ | ⚠ |
|     | (h) HPBC vs k_y | ✅ no authors-ref | 🚫 | ✅ | ❌ | ✅ | ⚠ |
|     | (i) band circle | ✅ | 🚫 | ✅ | ❌ | ✅ | ⚠ |

**Aggregate state:** Fig 2 & Fig 1(d) are bulletproof.  Fig 1(b)(c), Fig 3 (all), Fig 4 (all) are 80–90 % bulletproof — gap is mostly **B3 (gnuplot overlay) and B4 (one-cmd run)**, plus the lingering Fig 2 L convention issue.

---

## 3. Concrete gaps to close

### G1.  ~~Fig 2 L convention off-by-one~~ **REMOVED — was wrong.**

**Earlier audit (REAUDIT_2026-04-30.md §4.1) and this plan claimed paper Fig 2 needs L = 11 sites.**  That is **wrong**.  Paper Fig 2 axes run 0..9 (10 sites per side), so the **current Fortran `L = 10` site-count convention is paper-faithful as-is.**  No change needed in `tcrw_fig2_clean.f90` or `tcrw_fig2_defects.f90`.

Implication for the audit chain:
- Paper Fig 2 uses **L = site count** convention (paper "L = 10" = 10×10 grid).
- Authors' `TRW.py` uses **L = max-index** convention (authors' `L = N` → (N+1)² sites).
- These two conventions differ by 1.  Paper's "L = 10" Fig 2 corresponds to authors' code at `L = 9`.

REAUDIT_2026-04-30.md §4.1 should be patched to flip the same conclusion.  Tracking as G1' below.

### G1'.  Patch stale text in REAUDIT_2026-04-30.md §4.1

Change "paper L = 10 corresponds to your L = 9" → "paper L = 10 corresponds to authors' code L = 9; your Fortran already runs at the correct 10×10 grid by using site-count convention".  One paragraph edit.

Effort: 5 min.

### G2.  Fig 3 gnuplot overlays for all panels
Have `tcrw_fig3a_overlay.gnu` as worked example; need 7 more (b, cde, f, g, hij, e, j).  Already have `tcrw_fig3_exact_dump.py` writing all 8 `_exact.txt` files, so the data layer is done — only `.gnu` files missing.

Effort: ~40 min total (5 min per panel, copy-edit pattern).

### G3.  Python→gnuplot pattern for Fig 1
`tcrw_fig1_pymc.py` and `tcrw_fig1_bloch_diffusion.py` produce matplotlib PNGs.  Add `tcrw_fig1_exact_dump.py` that writes `tcrw_fig1{b,c,d}_exact.txt` matching Fortran column layout, then add `_overlay.gnu` files.

Effort: ~30 min.

### G4.  Fig 4 gnuplot rendering
Most Fig 4 panels are matplotlib-only.  3D surface plot 4(c) and 4(i) band circle are easier to keep in matplotlib (gnuplot's `splot` is uglier for these).  But 4(b), 4(d), 4(e), 4(h) are 1D line plots that gnuplot handles cleanly.

**Recommend split:**
- 4(b), 4(d), 4(e), 4(h) → port to gnuplot (Python writes `.txt`, gnuplot plots).  These are line-plot panels.
- 4(c), 4(f), 4(g), 4(i) → keep matplotlib.  3D surfaces / scatter-with-color-by-edge-weight is matplotlib's strength.

Effort: ~1 hour.

### G5.  `run.sh` orchestration targets
Add `tcrw-fig{1,2,3,4}-all` targets that chain: build Fortran → run MC → run Python exact dump → run gnuplot for each panel → save PDFs.  One command per figure.

Effort: ~30 min (mostly copy-paste of existing pattern in `run.sh`).

### G6.  Fig 1 cross-check overlays
`tcrw_fig1d_crosscheck.png` exists; (b) and (c) don't.  Add MSD overlay (Fortran from `tcrw_fig1c_msd_w*.txt` vs exact Python from `tcrw_fig1_pymc`).

Effort: ~20 min.

### G7.  Stale paths in two cross-check scripts
`tcrw_obc_crosscheck_authors.py` and `tcrw_fortran_vs_exact.py` (in `TIFR_DP2/` parent folder, leftovers from old folder name) hardcode `/sessions/elegant-wizardly-einstein/...`.  Cheap fix.

Effort: 5 min.

### G8.  Single source-of-truth README §Convention
Currently spread across REAUDIT_2026-04-30.md, FIG2_CONVENTION_FIX.md, FIG3_AUDIT_REPORT.md, individual `.f90` headers.  Consolidate into `CONVENTIONS.md` referenced from main README.

Effort: ~30 min (mostly copy-paste).

---

## 4. The Python-to-gnuplot uniform pattern (the core spine)

This is the standard you wanted ("pythontognuplotone").  One pattern, applied to every figure.

### 4.1.  Three layers per panel

```
┌──────────────────────┐   ┌──────────────────────┐   ┌──────────────────────┐
│  DATA LAYER          │   │  EXACT LAYER         │   │  PLOT LAYER          │
│  Fortran MC drives   │   │  Python eigensolve   │   │  gnuplot reads .txt  │
│  → tcrw_figX_summary │   │  → tcrw_figX_exact   │   │  → tcrw_figX*.pdf    │
│   .txt               │   │   .txt               │   │                      │
│  (integer counts)    │   │  (per-step probs)    │   │  one .gnu per panel  │
└──────────────────────┘   └──────────────────────┘   └──────────────────────┘
        │                          │                          │
        └──────── same column layout, gnuplot reads either ────┘
```

### 4.2.  Conventions for `_exact.txt` files

- **Identical column order to the matching `_summary.txt`** (no aliasing).
- Comment lines start with `#` (gnuplot ignores).
- Blank line between data blocks (e.g. between L values) → enables gnuplot's `index N`.
- Use `numpy.savetxt(file, arr, fmt="%.6e", header=cols, comments="# ")` or equivalent.
- Per-step normalisation already baked in (Python J's are per-step; Fortran's are integer counts → divide by `T_use` in the `.gnu` `using` clause).

### 4.3.  Conventions for `_overlay.gnu` files

- **Filename convention:** `tcrw_figXY_overlay.gnu` always plots Fortran (markers) + exact Python (lines) on the same axes.
- **Style convention:** keep the existing `tcrw_figXY.gnu` for Fortran-only plots; the overlay is an additive sibling, not a replacement.
- **`using` expressions identical** for both files (because column layouts match).  If Fortran column needs `($col / T)` to normalize, the same expression appears with `T = 1` for the exact data:

```gnuplot
T_F(L, D_r) = column normalisation for Fortran
T_E         = 1.0   # exact Python is already per-step

plot \
   summary u 2:($3) w p ls 1 title 'L=10 MC',     \
   exact   u 2:($3) w l ls 1 notitle              # exact, lines only
```

Or for currents where T_use needs reconstruction:

```gnuplot
T(L, Dr) = (Dr < L*L*Dr/100 ? 1e8 : 100*max(L*L, 1.0/Dr)/Dr)
plot \
   summary u 2:($4 / T($1, $2)) w p ls 1, \
   exact   u 2:4                w l ls 1
```

### 4.4.  Fortran-only panels stay Fortran-only

Where Fortran is genuinely the source of truth (Fig 1 trajectory rendering, Fig 2 trajectory PDF), no Python `_exact.txt` exists.  The overlay pattern is for panels where exact is meaningful (any steady-state observable).

---

## 5. Phased plan

### P0 — Critical (today's session, ~1 hr)

1. ~~**G1 — Fig 2 L convention fix**~~ — **Cancelled.** Fig 2 is already paper-faithful at `L = 10` site-count.
2. **G1' — Patch REAUDIT_2026-04-30.md §4.1 stale text** (5 min) → audit log self-consistent.
3. **G2 — Fig 3 gnuplot overlays for all 8 panels** (40 min) → bulletproofs Fig 3.
4. **G7 — fix stale paths in 2 cross-check scripts** (5 min) → portable.

After P0: Fig 2 stays as-is (already bulletproof), Fig 3 bulletproof, audit log consistent.

### P1 — Important (~2 hr)

4. **G3 — Fig 1 Python→gnuplot dump and overlays** (30 min).
5. **G4a — Fig 4 line-plot panels (b, d, e, h) → gnuplot** (1 hr).
6. **G6 — Fig 1 (b)(c) cross-check overlays** (20 min).

After P1: Fig 1 and Fig 4 are bulletproof for the panels gnuplot handles well.

### P2 — Polish (~1 hr)

7. **G5 — `run.sh tcrw-figX-all` orchestration** (30 min).
8. **G8 — Consolidate `CONVENTIONS.md`** (30 min).

After P2: one command per figure rebuilds everything; conventions documented in one file.

### P3 — Optional / nice-to-have

9. Fig 4(c) and 4(i) gnuplot port (could be done; matplotlib is fine here).
10. Fig 2 fortran-vs-exact overlay style — extend to gnuplot.
11. Notebook cleanup — the four `Fig{1,2,3,4}_TCRW_reproduction_audit.ipynb` notebooks could be regenerated as live documents pointing at the bulletproof artefacts.

---

## 6. Concrete file checklist

After all phases:

```
DATA LAYER (Fortran MC, .txt outputs)
  tcrw_fig1{b,c,d}_*.txt                  (already exist)
  tcrw_fig2_*_w{0.0,0.5,1.0}.txt          (already exist; rerun after G1)
  tcrw_fig2_*_defects.txt                 (already exist; rerun after G1)
  tcrw_fig3{a,b,cde,e,f,g,hij,j}_summary.txt (already exist)

EXACT LAYER (Python, _exact.txt outputs)
  tcrw_fig1_exact_dump.py                 [NEW: G3]
  tcrw_fig1{b,c,d}_exact.txt              [NEW: G3]
  tcrw_fig3_exact_dump.py                 (exists)
  tcrw_fig3{a,b,cde,e,f,g,hij,j}_exact.txt (exist after first run)
  tcrw_fig4_exact_dump.py                 [NEW: G4]
  tcrw_fig4{b,d,e,h}_exact.txt            [NEW: G4]

PLOT LAYER (gnuplot, .gnu)
  tcrw_fig1{b,c,d}_overlay.gnu            [NEW: G3]
  tcrw_fig2_*_overlay.gnu                 (existing, may need refresh)
  tcrw_fig3a_overlay.gnu                  (exists, sample)
  tcrw_fig3{b,cde,e,f,g,hij,j}_overlay.gnu [NEW: G2]
  tcrw_fig4{b,d,e,h}_overlay.gnu          [NEW: G4]

PLOT LAYER (matplotlib, kept for 3D / scatter-with-color)
  tcrw_fig4{c,f,g,i}.py                   (exist)
  tcrw_fig3_authors.py / pymc.py          (exist; Fig 3 multi-panel summary)

ORCHESTRATION
  run.sh    — adds tcrw-fig{1,2,3,4}-all targets [G5]
  CONVENTIONS.md  [NEW: G8]
  README.md (updated cross-refs to CONVENTIONS.md)

REPORTS (already exist, keep)
  REAUDIT_2026-04-30.md
  FIG2_CONVENTION_FIX.md
  FIG3_AUDIT_REPORT.md
  FIG4_AUDIT_REPORT.md
  FIG3A_CROSSCHECK_REPORT.md
```

---

## 7. Risks & mitigations

| Risk | Mitigation |
|---|---|
| Fig 2 rerun at L=11 takes 15 min × 3 ω = 45 min | Acceptable; user accepts long Fortran runs (memory). |
| `_exact.txt` and `_summary.txt` column drift after future Fortran source edit | Add a `tcrw_fig{X}_check_columns.py` smoke test that diffs the `# columns:` header lines. |
| Sparse Perron at L=99, 199, 499 (Fig 3a paper extension) is slow | Park as P3 — paper says master curve already collapses at L≥19. |
| Fig 4 panels (h)/(i) D_r assumption (we picked 0.1) | Already documented in FIG4_AUDIT_REPORT §5.1; flag in CONVENTIONS.md. |
| Fortran summary file format changes break `_overlay.gnu` | Use `# columns: ...` line as the contract; `.gnu` files reference column numbers, not content. |

---

## 8. Definition of done

You're done when:

- `bash run.sh tcrw-fig1-all` rebuilds **everything** for Fig 1 (Fortran binary → MC run → Python exact → gnuplot PDFs).
- Same for figs 2, 3, 4.
- Every `*_overlay.pdf` shows MC dots inside MC-noise distance of the exact line (or is fully exact, no MC, for Fig 4 panels).
- `CONVENTIONS.md` defines L convention, angle convention, J normalization in one place.
- `REAUDIT_2026-04-30.md` is the audit log (no edits needed).
- Email-ready: you can hand the folder to your PI, your collaborator, or your prof, and they reproduce every figure with one command.

After this, the folder is genuinely "done" and DP2 (jerky-on-lattice) can fork the bulletproof pymc files (`tcrw_fig{1,2,3}_pymc.py`) without inheriting any audit debt.
