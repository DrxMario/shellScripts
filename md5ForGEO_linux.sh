#!/bin/sh

################################################################################
# Generate MD5 Checksums in a tab-delimited format ready for GEO submission
#
# Note that the program assumes fastqs are in files with the .fastq.gz extension
#
# Mario Rosasco for BRI 2020
################################################################################
usage="Usage: md5forGEO_linux.sh <directory with fastq.gz files>"

if [ -z $1 ]
  then
    echo "Error: no directory argument passed to script."
    echo $usage
    exit 1
fi

for currFile in `ls $1/*fastq.gz`
do
	currLib=`basename $currFile`
	currChecksum=`md5sum $currFile | cut -f1 -d" "`
	printf "%s\tfastq\t%s\n" $currLib $currChecksum
done