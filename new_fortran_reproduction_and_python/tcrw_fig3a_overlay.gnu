#=====================================================================
# tcrw_fig3a_overlay.gnu — Fig 3(a) with Fortran MC dots + exact lines
#
# Demonstrates the workflow:
#   - Fortran writes  tcrw_fig3a_summary.txt  (MC, integer counts)
#   - Python writes   tcrw_fig3a_exact.txt    (exact, transition matrix)
#                      via  python3 tcrw_fig3_exact_dump.py
#   - gnuplot plots both on the same axes — Fortran as MARKERS,
#     exact Python as LINES — using the same `($1==L ? $2 : 1/0)`
#     filter trick the existing tcrw_fig3a.gnu uses to split L curves.
#
# Reads:   tcrw_fig3a_summary.txt   (Fortran MC)
#          tcrw_fig3a_exact.txt     (exact Python — same column layout)
#
# Output:  tcrw_fig3a_overlay.pdf   and/or interactive qt
#
# Usage:
#   python3 tcrw_fig3_exact_dump.py        # regenerate exact .txt files
#   gnuplot -e "mode='pdf'" tcrw_fig3a_overlay.gnu
#   gnuplot -e "mode='qt'"  tcrw_fig3a_overlay.gnu
#   gnuplot                  tcrw_fig3a_overlay.gnu          # both
#=====================================================================
if (!exists("mode")) mode = "both"

f_mc = 'tcrw_fig3a_summary.txt'           # Fortran MC
f_ex = 'tcrw_fig3a_exact.txt'             # Python exact

# ---- L curve styles: viridis-like ramp ----
set style line 1 lc rgb '#440154' pt 7  ps 1.0 lw 1.5    # L = 4
set style line 2 lc rgb '#3b528b' pt 5  ps 1.0 lw 1.5    # L = 9
set style line 3 lc rgb '#21918c' pt 9  ps 1.0 lw 1.5    # L = 19
set style line 4 lc rgb '#5ec962' pt 13 ps 1.0 lw 1.5    # L = 49
set style line 99 lc rgb '#bbbbbb' dt 2 lw 0.8

# ---- axes (matches tcrw_fig3a.gnu) ----
set logscale x 10
set logscale y 10
set xrange [5e-5 : 2.0]
set yrange [0.7  : 5e3]
set xlabel 'D_r'                   font ',14'
set ylabel 'P_{edge} / P_{bulk}'   font ',14'
set format x '10^{%T}'
set ytics ( "10^0" 1, "10^1" 10, "10^2" 100, "10^3" 1000 )
set mytics 10
set tics scale 0.8
set grid   lc rgb '#dddddd' lw 0.4
set border lw 1.0
set key    right top box opaque samplen 1.8 spacing 1.2 font ',10'
set title  "TCRW Fig 3(a) — Fortran MC (markers) vs exact Python (lines), ω = 1" \
           font 'Helvetica,11'
set arrow from 5e-5, 1 to 2.0, 1 nohead ls 99

# ---- plot command: 4 L curves × 2 sources (MC + exact) ----
# Note: 'with points' for Fortran (markers only), 'with lines' for exact.
# The same `$1==L ? $col : 1/0` filter splits each file by L value.
plot_cmd = \
  "'" . f_mc . "' u ($1==4  ? $2 : 1/0):($1==4  ? $3 : 1/0) w p   ls 1 title 'L=4 MC',  " . \
  "'" . f_ex . "' u ($1==4  ? $2 : 1/0):($1==4  ? $3 : 1/0) w l   ls 1 notitle,         " . \
  "'" . f_mc . "' u ($1==9  ? $2 : 1/0):($1==9  ? $3 : 1/0) w p   ls 2 title 'L=9 MC',  " . \
  "'" . f_ex . "' u ($1==9  ? $2 : 1/0):($1==9  ? $3 : 1/0) w l   ls 2 notitle,         " . \
  "'" . f_mc . "' u ($1==19 ? $2 : 1/0):($1==19 ? $3 : 1/0) w p   ls 3 title 'L=19 MC', " . \
  "'" . f_ex . "' u ($1==19 ? $2 : 1/0):($1==19 ? $3 : 1/0) w l   ls 3 notitle,         " . \
  "'" . f_mc . "' u ($1==49 ? $2 : 1/0):($1==49 ? $3 : 1/0) w p   ls 4 title 'L=49 MC', " . \
  "'" . f_ex . "' u ($1==49 ? $2 : 1/0):($1==49 ? $3 : 1/0) w l   ls 4 notitle"

#=====================================================================
# PDF
#=====================================================================
if (mode eq "pdf" || mode eq "both") {
    set terminal pdfcairo size 14cm,10cm enhanced font 'Helvetica,10'
    set output 'tcrw_fig3a_overlay.pdf'
    eval("plot " . plot_cmd)
    unset output
    print "Wrote tcrw_fig3a_overlay.pdf"
}

#=====================================================================
# qt
#=====================================================================
if (mode eq "qt" || mode eq "both") {
    set terminal qt size 820,640 enhanced font 'Helvetica,11'
    eval("plot " . plot_cmd)
    pause mouse close
}
