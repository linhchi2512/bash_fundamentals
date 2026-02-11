#!/bin/bash

# Filter out the movies with an average rating above 7.5 and save them to a new file.
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
  rating = $18
  gsub(/^"|"$/, "", rating)

  if (rating > 7.5) {
    printf "%6.3f|%s\n", rating, $0
  }
}
' tmdb_movies.oneline.csv \
| sort -t'|' -k1,1nr \
| cut -d'|' -f2- \
| {
    head -1 tmdb_movies.oneline.csv
    cat
  } > task2.csv