#!/bin/bash

# Calculate the sum of the box office revenue for all movies.
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
  rev = $5
  gsub(/^"|"$/, "", rev)

  if (rev !~ /^[0-9]+(\.[0-9]+)?$/) next
  if (rev == 0) next
  sum += rev
}
END {
  print "Total box office revenue:", sum
}
' tmdb_movies.oneline.csv