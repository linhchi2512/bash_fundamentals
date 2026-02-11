#!/bin/bash

# Which director has made the most films, and which actor has appeared in the most films?
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR==1 { header=$0; next }
{
  directors = $9
  actors   = $7

  gsub(/^"|"$/, "", director)
  gsub(/^"|"$/, "", actors)

  # Count films per director
  nd = split(directors, director_list, "|")
  for (i=1; i<=nd; i++) {
    director = director_list[i]
    if (director != "") {
      dir_count[director]++
      if (dir_count[director] > max_dir_count) {
        max_dir_count = dir_count[director]
        max_dir = director
      }
    }
  }

  # Count films per actor
  na = split(actors, actor_list, "|")
  for (i=1; i<=na; i++) {
    actor = actor_list[i]
    if (actor != "") {
      act_count[actor]++
      if (act_count[actor] > max_act_count) {
        max_act_count = act_count[actor]
        max_act = actor
      }
    }
  }
}

END {
  print "Director with most films:", max_dir, "-", max_dir_count, "films"
  print "Actor with most films:", max_act, "-", max_act_count, "films"
}
' tmdb_movies.oneline.csv