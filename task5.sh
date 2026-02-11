#!/bin/bash

# Top 10 highest-grossing films
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
  budget = $20
  rev    = $21

  gsub(/^"|"$/, "", budget)
  gsub(/^"|"$/, "", rev)

  if (rev == 0 || budget == 0) next

  profit = rev - budget
  printf "%012.2f|%s\n", profit, $0
}
' tmdb_movies.oneline.csv \
| sort -t'|' -k1,1nr \
| cut -d'|' -f2- \
| {
    head -1 tmdb_movies.oneline.csv
    cat
  } | head -11 > task5.csv