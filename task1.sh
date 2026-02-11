#!/bin/bash

# Sort the movies by their release date in descending order and save them to a new file.
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { next }
{
  rd = $16
  gsub(/^"|"$/, "", rd)    

  split(rd, d, "/")
  if (length(d[3]) == 2)
    year = (d[3] >= 30 ? "19" d[3] : "20" d[3])
  else
    year = d[3]

  key = sprintf("%04d%02d%02d", year, d[1], d[2])
  print key "|" $0
}
' tmdb_movies.oneline.csv \
| sort -t'|' -k1,1r \
| cut -d'|' -f2- \
| {
    head -1 tmdb_movies.oneline.csv
    cat
  } > task1.csv
