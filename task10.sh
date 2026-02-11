#!/bin/bash

# Which director has the highest average rating (with min 5 films)?
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
    director = $9
    rating = $18
    gsub(/^"|"$/, "", director)
    gsub(/^"|"$/, "", rating)
    if (rating !~ /^[0-9]+(\.[0-9]+)?$/) next
    if (rating == 0) next
    nd = split(director, director_list, "|")
    for (i=1; i<=nd; i++) {
        d = director_list[i]
        if (d != "") {
            dir_sum[d] += rating
            dir_count[d]++
        }
    }
}
END {
    for (d in dir_sum) {
        if (dir_count[d] >= 5) {
            avg = dir_sum[d] / dir_count[d]
            if (avg > max_avg) {
                max_avg = avg
                max_dir = d
            }
        }
    }
    print "Director with highest average rating (min 5 films):", max_dir, "-", max_avg
}
' tmdb_movies.oneline.csv