#!/bin/bash

gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
NR>1 && NR<20 { print $16 }
' task1.csv