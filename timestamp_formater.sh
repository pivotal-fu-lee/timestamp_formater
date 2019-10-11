#!/bin/bash
# set -x 
outfile=$1.new
Help() {
   echo "`basename $0` is a script to add human readable timestamp at left most column to the original log file. "
   echo "" 
   echo "        Usage: `basename $0` gorouter.stdout.log"
   exit 1
}
if [ $# -ne 1 ] ; then
   Help 
fi
if [ $1 == "-h" ] ; then
   Help 
fi
if [ -e ${outfile} ]; then
    rm ${outfile} 
fi
while IFS= read -r line
do
#  echo $line | awk -F'timestamp"' ' { print $2 }' | sed 's/://g' | sed -n 's/\([0-9]\{10\}\).*/\1/p' | xargs -I dummy sh -c "date -r dummy" >> $outfile
   # temptime=`echo $line | awk -F'timestamp"' ' { print $2 }' | sed 's/://g' | sed -n 's/\([0-9]\{10\}\).*/\1/p'` 
   temptime=`echo $line | awk -F'timestamp"' ' { print $2 }' | sed 's/^://' | sed -n 's/\([0-9]\{10\}\).*/\1/p'` 
   varlength=${#temptime} 
#   echo " variable length: $varlength"
   if [ $varlength  -ne 0 ] ; then
      newtime=`date -r $temptime`
      echo $newtime $line >> $outfile  
   else   
      echo $line >> $outfile  
   fi
done < $1
# paste $outfile $1 | column -s $'\t' -t > $mergefile
