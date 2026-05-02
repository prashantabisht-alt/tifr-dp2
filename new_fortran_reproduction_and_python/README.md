# TCRW Fortran Reproduction and Python Audit

This folder contains the Fortran Monte Carlo reproduction, Python cross-checks,
gnuplot scripts, numerical text outputs, notebooks, and figures for the TCRW
audit work.

The main folder is intentionally kept in its runnable flat layout because
`run.sh`, the Fortran drivers, the gnuplot scripts, and the Python cross-checks
share many file names directly.

For easier GitHub browsing, use:

- `by_file_type/01_python/` for Python scripts and exact checks.
- `by_file_type/02_fortran/` for Fortran simulation drivers and kernels.
- `by_file_type/03_gnuplot/` for gnuplot plotting files.
- `by_file_type/04_text_data/` for `.txt` numerical outputs.
- `by_file_type/05_figures/` for `.png` and `.pdf` figure outputs.
- `by_file_type/06_notebooks/` for Jupyter audit notebooks.
- `by_file_type/07_reports/` for audit notes and reports.

The `by_file_type/` entries are links to the real files here, so they make the
repository easier to inspect without changing how the reproduction scripts run.
