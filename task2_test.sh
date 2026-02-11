#!/bin/bash

# Verify all ratings in task2.csv are above 7.5
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR>1{
  r=$18; gsub(/^"|"$/, "", r)
  if(r <= 7.5) { print "BAD:", NR, r; exit 1 }
}
END{print "OK: all ratings > 7.5"}
' task2.csv