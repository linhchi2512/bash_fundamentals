#!/bin/bash

# Find out which film had the highest and lowest box office revenue.
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
  title = $6
  rev = $5
  gsub(/^"|"$/, "", title)
  gsub(/^"|"$/, "", rev)

  if (rev !~ /^[0-9]+(\.[0-9]+)?$/) next
  if (rev == 0) next

  if (!seen) {
    min = max = rev
    min_title = max_title = title
    seen = 1
    next
  }

  if (rev > max) { max = rev; max_title = title }
  if (rev < min) { min = rev; min_title = title }
}

END {
  if (!seen) {
    print "No valid revenue values found."
    exit 1
  }
  print "Highest revenue:", max_title, "(" max ")"
  print "Lowest revenue:",  min_title, "(" min ")"
}
' tmdb_movies.oneline.csv