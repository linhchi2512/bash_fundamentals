#!/bin/bash

FILE="${1:-tmdb_movies.oneline.csv}"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: File not found: $FILE" >&2
  exit 1
fi

# CSV-safe field matcher (handles commas inside quotes and escaped quotes "")
FPAT_CSV='([^,]*)|("([^"]|"")*")'

# Row count (excluding header)
echo "== Row count (excluding header) =="
gawk -v FPAT="$FPAT_CSV" 'NR>1{c++} END{print "rows:", c+0}' "$FILE"
echo

# Detect malformed rows (NF mismatch vs header)
echo "== Malformed rows (column count mismatch) =="
gawk -v FPAT="$FPAT_CSV" '
NR==1{expected=NF; next}
NF!=expected{
  bad++
  if(bad<=20){
    print "Bad line " NR ": NF=" NF ", expected=" expected > "/dev/stderr"
  }
}
END{
  print "expected_cols:", expected
  print "bad_rows:", bad+0
  if((bad+0) > 0) exit 2
}
' "$FILE" || {
  rc=$?
  echo "NOTE: Found malformed rows (exit code $rc). See stderr above for examples." >&2
}
echo

# Missing values per column (empty or "")
echo "== Missing values per column (empty or \"\") =="
gawk -v FPAT="$FPAT_CSV" '
NR==1{
  n=NF
  for(i=1;i<=n;i++) h[i]=$i
  next
}
{
  for(i=1;i<=n;i++){
    v=$i
    if(v=="" || v=="\"\"") miss[i]++
  }
}
END{
  for(i=1;i<=n;i++) printf "%s\t%d\n", h[i], miss[i]+0
}
' "$FILE" | column -t -s $'\t'