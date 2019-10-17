#!/bin/bash
Help() {
   echo "`basename $0` is a script to insert human readable timestamp at left most column to the original log file. "
   echo "Usage: `basename $0` -f [input_log_file]"
   echo " "
   echo "   <Note:> "
   echo "           <required> -f [input_log_file] gorouter.stdout.log,  auctioneer.stdout.log "
   echo ""
   echo "  e.g. ./`basename $0` -f gorouter.stdout.log"
   echo "       ./`basename $0` -f autioneer.stdout.log"
   exit 1
}

# Check input parameters
while getopts ":f:h:" option;
do
   case "$option" in
      f) inputfile=$OPTARG;;
      h) Help;;
      *) Help
         exit 1;;
   esac
done

if [ -z ${inputfile} ]; then
     Help
fi

outfile=$inputfile.new
if [ -e ${outfile} ]; then
    rm ${outfile} 
fi

while IFS= read -r line
do
   temptime=`echo $line | awk -F'timestamp"' ' { print $2 }' | sed -E 's/^(:"|:)//' | sed -n 's/\([0-9]\{10\}\).*/\1/p'`
   varlength=${#temptime} 
   if [ $varlength  -ne 0 ] ; then
      newtime=`date -r $temptime`
      echo $newtime $line >> $outfile  
   else   
      echo $line >> $outfile  
   fi
done < $inputfile
