# 2026-05-15 PI meeting notes: after triangular JMVR bug fix

## What happened

Prashant showed Kabir the triangular single-walker result:

- Dipanjan's triangular Fourier/notebook calculation had a triangular-torus boundary/grid issue.
- The \(c_3\) coefficient also had the wrong chirality sign.
- Correct sheared triangular grid plus corrected \(c_3\) sign matches KMC at the noise floor.
- Kabir accepted this and was happy: "very nice", "you figured it out", and said the bug had bothered him for years.

This closes the immediate one-particle JMVR cleanup problem.

## Kabir's main new direction

Kabir does **not** want us to keep focusing on the old translation-bias parameter \(\epsilon\) as "chirality".

He explicitly said:

> "That's not chirality. Chirality means rotation type."

So the next project is:

> Build a **chiral random walker on the triangular lattice**, analogous to the square-lattice chiral random walker literature.

The key idea is to take Kabir group's active-walker model and add **rotation chirality**:

\[
d \to d+1 \quad \text{and} \quad d \to d-1
\]

with unequal rates, instead of the symmetric JMVR rotation rule

\[
d \to d\pm1 \quad \text{at rate } \gamma/2.
\]

For a triangular lattice the walker has six directors:

\[
d \in \{0,1,2,3,4,5\}.
\]

The simplest chiral triangular rule is therefore probably:

\[
d \to d+1 \quad \text{at rate } \gamma_+,
\qquad
d \to d-1 \quad \text{at rate } \gamma_-,
\]

with

\[
\gamma_+ + \gamma_- = \gamma,
\qquad
\chi = \frac{\gamma_+ - \gamma_-}{\gamma}
\]

as the rotation-chirality parameter.

## Ref. 44 from the TCRW paper

TCRW paper local file:

```text
/Users/prashantbisht/Documents/dp2/TIFR_DP2/tcrw.pdf
```

TCRW references 42--44 are:

1. Ref. 42: Hargus, Epstein, Mandadapu, "Odd diffusivity of chiral random motion", PRL 127, 178001 (2021).
2. Ref. 43: Sevilla, "Diffusion of active chiral particles", PRE 94, 062120 (2016).
3. Ref. 44: Mallikarjun and Pal, "Chiral run-and-tumble walker: Transport and optimizing search", Physica A 622, 128821 (2023).

Ref. 44 has been downloaded locally:

```text
/Users/prashantbisht/Documents/dp2/TIFR_DP2/triangular/papers/Mallikarjun_Pal_2023_chiral_run_and_tumble_walker_ref44.pdf
```

The important thing in Ref. 44:

- Four possible orientations in 2D.
- The walker reorients by turning left, turning right, or reversing.
- Left/right/reversal have different rates:

\[
\Gamma_1,\quad \Gamma_2,\quad \Gamma_3.
\]

- Chirality is the left-right bias in tumbling/reorientation.
- They compute transport and first-passage/search properties.

## What we should do next

### Project 1: single-particle chiral triangular walker

This is the immediate next work.

Build the triangular analogue of the square-lattice chiral random walker:

- Six internal directions instead of four.
- Translation on triangular nearest-neighbor lattice.
- Rotation chirality in the internal director dynamics.
- Compute:
  - bulk diffusion / moments,
  - probability distributions,
  - first-passage/search observables,
  - OBC edge localization and currents,
  - spectrum and edge modes.

This is the "write a paper quickly" direction Kabir emphasized.

### Project 2: triangular TCRW / topology

After the basic chiral triangular walker is working, extend the TCRW-style topological analysis:

- Build triangular Bloch matrix.
- Compare square vs triangular lattice.
- Check gap closing.
- Compute edge spectra under OBC / HPBC.
- Compute topological invariant if needed.

Kabir expects similar edge modes, but the interesting question is:

> What is genuinely different between square and triangular lattices?

Likely differences:

- sixfold vs fourfold anisotropy,
- boundary-condition choices: normal vs sheared/screw triangular boundary,
- triangular lattice may reduce large-distance anisotropy.

### Project 3: active hard-hexagon / equation of state

This is later, not the immediate next task.

Kabir showed:

Jaleel, Mandal, Thomas, Rajesh, "Freezing phase transition in hard-core lattice gases on the triangular lattice with exclusion up to seventh next-nearest neighbor", PRE 106, 044136 (2022).

Motivation:

- For nearest-neighbor exclusion on triangular lattice, the hard-hexagon model has an exact equilibrium equation of state.
- Add activity and measure deviations from exact equilibrium pressure/chemical potential.
- This is a multi-particle direction and harder than the single-walker chiral triangular paper.

## Questions to clarify

1. In the first chiral triangular model, should we keep the old translation-bias \(\epsilon\), or set \(\epsilon=0\) and introduce only rotation chirality?

   Current best guess: set \(\epsilon=0\) for the clean chiral-random-walker project. The old \(\epsilon\) model is a separate JMVR translation-bias model.

2. Should the triangular analogue of Ref. 44 include a reversal rate

\[
d\to d+3
\]

or should we first use only adjacent rotations \(d\to d\pm1\)?

   Current best guess: start with adjacent rotations only, then add reversal as a Ref.-44-style extension.

3. Which boundary geometry should be the default for OBC edge modes?

   Options:
   - rhombus/parallelogram OBC,
   - hexagonal OBC,
   - strip / hybrid periodic-open boundary condition.

   Current best guess: start with rhombus because it is easiest to code, then test hexagon/strip once the matrix is trusted.

4. Kabir mentioned "normal" versus "sheared/screw" boundary conditions on triangular. Need to ask later whether this should be part of the first paper or a later section.

5. Kabir said he would send the latest Dipanjan version. If it arrives, put it under `triangular/` and audit it, but do not let it delay the new chiral project.

