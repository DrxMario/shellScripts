#!/bin/bash

################################################################################
# Add sequence to a fastq file
# 
################################################################################

# default parameters
usage="Usage: $0 [-s sequence] [-q quality] [-b] infile.fastq outfile.fastq"
seq=""
qual=""
side="end"

# user-set params
while getopts ":s:q:b" opt; do
  case $opt in
    s) 
      seq=$OPTARG
      ;;
    q)
      qual=$OPTARG
      ;;
    b)
      side="beginning"
      ;;
    \? )
      echo $usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      echo $usage
      exit 1
      ;;
  esac
done

# get the fastq file
shift $(($OPTIND - 1))
infile=$1
outfile=$2

# Check for presence of in and out fastq files
if [ -z "$infile" ] || [ -z "$outfile" ]
then
  echo $usage
  exit 1
fi
 
# use AWK to add sequence
if [ "$side" = "beginning" ]
then
  cat $infile | \
  awk -v awk_qual="$qual" -v awk_seq="$seq" \
  'NR%4==0 {print awk_qual$0} NR%2==0 && NR%4!=0 {print awk_seq$0} NR%2!=0 {print}' > \
  $outfile
else
  cat $infile | \
  awk -v awk_qual="$qual" -v awk_seq="$seq" \
  'NR%4==0 {print $0awk_qual} NR%2==0 && NR%4!=0 {print $0awk_seq} NR%2!=0 {print}' > \
  $outfile
fi
