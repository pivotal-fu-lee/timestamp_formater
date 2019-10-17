#!/bin/bash
Help() {
   echo "`basename $0` is a script to add human readable timestamp at left most column to the original log file. "
   echo "Usage: `basename $0` -t [type] -f [input_log_file]"
   echo " "
   echo "   <Note:> "
   echo "           <required> -t [type] gorouter or autioneer "
   echo "           <required> -f [input_log_file] gorouter.stdout.log or auctioneer.stdout.log "
   echo ""
   echo "  e.g. ./`basename $0` -t gorouter gorouter.stdout.log"
   echo "       ./`basename $0` -t autioneer autioneer.stdout.log"
   exit 1
}

# Check input parameters
while getopts ":f:h:t:" option;
do
   case "$option" in
      f) inputfile=$OPTARG;;
      h) Help;;
      t) type=$OPTARG;;
      *) Help
         exit 1;;
   esac
done

outfile=$inputfile.new
if [ -e ${outfile} ]; then
    rm ${outfile} 
fi

while IFS= read -r line
do
   if [ $type  == "gorouter" ] ; then
     temptime=`echo $line | awk -F'timestamp"' ' { print $2 }' | sed 's/^://' | sed -n 's/\([0-9]\{10\}\).*/\1/p'` 
   elif [ $type  == "autioneer" ] ; then
     temptime=`echo $line | awk -F'timestamp"' ' { print $2 }' | sed 's/^://' | sed -n 's/\([0-9]\{10\}\).*/\1/p' | sed 's/"//g'` 
   else  
     echo "           <required> -t [type] gorouter or autioneer "
     exit 1
   fi  
   varlength=${#temptime} 
   if [ $varlength  -ne 0 ] ; then
      newtime=`date -r $temptime`
      echo $newtime $line >> $outfile  
   else   
      echo $line >> $outfile  
   fi
done < $inputfile
