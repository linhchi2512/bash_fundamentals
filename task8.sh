#!/bin/bash

# Which genre has the highest average rating, and which genre has the lowest average rating?
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
    genres = $14
    rating = $18
    gsub(/^"|"$/, "", genres)
    gsub(/^"|"$/, "", rating)   
    if (rating !~ /^[0-9]+(\.[0-9]+)?$/) next
    if (rating == 0) next   
    ng = split(genres, genre_list, "|")
    for (i=1; i<=ng; i++) {
        genre = genre_list[i]
        if (genre != "") {
            genre_sum[genre] += rating
            genre_count[genre]++
        }
    }
}
END {
    for (genre in genre_sum) {
        avg = genre_sum[genre] / genre_count[genre]
        if (avg > max_avg) {
            max_avg = avg
            max_genre = genre
        }
        if (avg < min_avg || min_avg == 0) {
            min_avg = avg
            min_genre = genre
        }
    }
    printf "Genre with highest average rating: %s - %.2f\n", max_genre, max_avg
    printf "Genre with lowest average rating: %s - %.2f\n", min_genre, min_avg
}
' tmdb_movies.oneline.csv