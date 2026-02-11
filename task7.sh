#!/bin/bash

# List the number of films by genre. For example, how many films are in the Action genre, and how many are in the Family genre?
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
    genres = $14
    gsub(/^"|"$/, "", genres)
    ng = split(genres, genre_list, "|")
    for (i=1; i<=ng; i++) {
        genre = genre_list[i]
        if (genre != "") {
            genre_count[genre]++
        }
    }
}
END {
    for (genre in genre_count) {
        print genre, "-", genre_count[genre], "films"
    }
}
' tmdb_movies.oneline.csv