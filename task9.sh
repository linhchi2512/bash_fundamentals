#!/bin/bash

# Most profitable box office each year.

gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
  y = $19
  b = $4
  r = $5
  t = $6

  if (y !~ /^[0-9]{4}$/) next
  if (b !~ /^[0-9]+(\.[0-9]+)?$/) next
  if (r !~ /^[0-9]+(\.[0-9]+)?$/) next
  if (b == 0 || r == 0) next

  p = r - b

  if (!(y in best_profit) || p > best_profit[y]) {
    best_profit[y] = p
    best_row[y] = $0
    best_title[y] = t
  }
}

END{
  for (y in best_profit) {
    printf "%s|%15d|%s\n", y, best_profit[y], best_title[y]
  }
}
' tmdb_movies.oneline.csv \
| sort -t'|' -k1,1n