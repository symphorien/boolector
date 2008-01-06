#!/bin/bash
for ((overlap=0;overlap<=1;overlap+=1))
  do
  if [[ $overlap -eq 1 ]]; then
    overlaparg="-o"
    limit=60
    inc=2
  else
    overlaparg=""
    limit=30
    inc=1
  fi
  for ((size=2;size<=$limit;size+=$inc))
  do
    header=1
    if [[ $overlap -eq 1 ]]; then
      filename=swapmemoverlap$size".smt"
    else
      filename=swapmem$size".smt"
    fi
    ./swapmem $size $overlaparg | boolector -rwl0 -ds | while read line
    do
      if [[ $header -eq 1 ]]; then
        echo "(benchmark $filename" > $filename
	echo ":source {" >> $filename
	echo "We swap two arbitrary byte sequences of length $size in memory two times." >> $filename
	if [[ $overlap -eq 1 ]]; then
	  echo "The sequences can overlap, hence it is not always the case" >> $filename
	else
	  echo "The sequences can not overlap, hence it is always the case" >> $filename
	fi
	echo "that swapping the sequences two times yields the initial memory state." >> $filename
	echo "" >> $filename
	echo "Swapping is done via XOR in the following way:" >> $filename
	echo "x ^= y;" >> $filename 
	echo "y ^= x;" >> $filename
	echo "x ^= y;" >> $filename
	echo "" >> $filename
	echo -n "Contributed by Robert Brummayer " >> $filename
	echo "(robert.brummayer@gmail.com)." >> $filename
	echo "}" >> $filename
	if [[ $overlap -eq 1 ]]; then
	  echo ":status sat" >> $filename
	else
	  echo ":status unsat" >> $filename
	fi
	echo ":category { crafted }" >> $filename
	header=0
      else
        echo $line >> $filename
      fi
    done
  done
done
