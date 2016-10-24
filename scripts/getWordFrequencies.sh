#!/bin/bash


perl topicPreProcess.pl $1  > words
cat words  | sort -f | uniq -i -c | sort -n > word_frequencies
