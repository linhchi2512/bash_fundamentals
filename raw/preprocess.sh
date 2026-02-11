#!/bin/bash

gawk '
function count_quotes(s,   t) {
  t = s
  gsub(/""/, "", t)        # remove escaped quotes
  return gsub(/"/, "&", t) # count remaining quotes
}
BEGIN { buf=""; open=0 }
{
  if (buf=="") buf=$0
  else buf = buf "\n" $0

  q = count_quotes($0)
  if (q % 2 == 1) open = !open

  if (!open) {
    gsub(/\n/, "\\n", buf) # replace embedded newlines inside fields with literal \n
    print buf
    buf=""
  }
}
END{
  if (buf!="") {
    # leftover means malformed CSV (unclosed quote)
    print "ERROR: unclosed quoted field at end of file" > "/dev/stderr"
    exit 1
  }
}
' movies.csv > tmdb_movies.oneline.csv

