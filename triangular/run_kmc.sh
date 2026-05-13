#!/usr/bin/env bash
# Build and run the Fortran KMC. Run on your laptop where gfortran is available.

set -e
cd "$(dirname "$0")"

echo "Building..."
gfortran -O3 -fno-range-check -ffree-line-length-none kmc_triangular_jmvr.f90 -o kmc_triangular

echo "Running..."
./kmc_triangular | tee kmc_run.log

echo ""
echo "Now compare with theory:"
echo "    python3 kmc_fortran_vs_theory.py"
