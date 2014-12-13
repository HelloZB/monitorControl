#!/bin/bash
# MonitorControl v0.7 by Hello_ZB
# 23/12/2012
# Заборона заставки в залежності від навантаження на проц деякими програмами

pid1=0
prog1=skype
cpu1=   #kilkist potokiv prog1 (skype)
cpu1Max=24
prog2=chrome 
cpu2=  #CPU navantazhennya na proc prog2 (%CPU chrome)
cpu2Max=11

prog3=mplayer
cpu3=
cpu3Max=3

prog4=chromium 
cpu4=  #CPU navantazhennya na proc prog2 (%CPU chrome)
cpu4Max=11

# file="../monitorControlLog"
zastavka=2
sleep 30
# `xset +dpms && xset s off`
# echo "`date`">"$file"
# echo " +dpms">>"$file"

for (( i=0, j=0; i<16; )); do 
  vymknytuPidsvitky=1
  if [[ $zastavka -eq 2 ]]; then         
     echo "`date +%T` dovga pausa"    
    sleep 15 # (( 4as vymknennya monitora ) / 3 ) - 20 cek    
  else
     echo "`date +%T` mala pausa"
    sleep 5  
  fi  
#   echo "--i--- $i">>"$file"
#   echo "--j--- $j">>"$file"

  #perevirka skype 
#    if [[ $vymknytuPidsvitky -eq 1 ]] ; then
      if ps aux | grep -v grep | grep $prog1 > /dev/null 
      then
        pid1=`ps -C skype -o pid | grep -v PID | cut -c 2-`  # pid prog1 (skype)
#       cat /proc/$pid1/stat | cut -f 20 -d " ">>"$file" 
        cpu1=`cat /proc/$pid1/stat | cut -f 20 -d " "` # uznau kilkist potokiv
        echo "'cpu1' $cpu1"
        if [[ $cpu1 -gt $cpu1Max ]]; then                   
            echo "cpu1 $cpu1"    
            vymknytuPidsvitky=0
        fi     
      fi
#    fi
  #perevirka chrome
  if [[ $vymknytuPidsvitky -eq 1 ]] ; then
    cpu2=`top -b -n 1 | grep -m 1 $prog2 | cut -f2 -d"S" | cut -c 3-4`    
    echo "'cpu2' $cpu2"
    if [[ $cpu2 -gt $cpu2Max ]] #perevirka chrome
    then
      echo "cpu2 $cpu2"
      vymknytuPidsvitky=0
    fi
  fi
   
   #perevirka mplayer
   if [[ $vymknytuPidsvitky -eq 1 ]] ; then
      cpu3=`top -b -n 1 | grep -m 1 $prog3 | cut -f2 -d"S" | cut -c 3-4`
      echo "'cpu3' $cpu3"
      if [[ $cpu3 -gt $cpu3Max ]]       #perevirka chrome
      then
        echo "cpu3 $cpu3" 
        vymknytuPidsvitky=0
      fi
   fi
   
     #perevirka chromium
  if [[ $vymknytuPidsvitky -eq 1 ]] ; then
    cpu4=`top -b -n 1 | grep -m 1 $prog4 | cut -f2 -d"S" | cut -c 3-4`    
    echo "'cpu4' $cpu4"
    if [[ $cpu4 -gt $cpu4Max ]] #perevirka chrome
    then
       echo "cpu4 $cpu4"
      vymknytuPidsvitky=0
    fi
  fi
  
   if [[ $vymknytuPidsvitky -eq 0 ]]; then
      i=0
      if [[ $zastavka -eq 2 ]]; then
         let "j += 1"
         if [[ $j -ge 3 ]] ; then        
            zastavka=1
            j=0
            echo  "'-dpms' 2 $zastavka"
            `xset -dpms && xset s off`
            echo "MonitorControl OFF"
          fi
      fi
    else      
      j=0
      if  [[ $zastavka -eq 1 ]]; then #koly vymknena zastavka (vymknennya monitora)
          let "i += 1"        
          if [[ $i -ge 3 ]]; then
            zastavka=2    
            i=0     
            echo  "'+dpms'   1 x $zastavka"
            `xset +dpms && xset s off`
            echo "MonitorControl ON"
          fi
        fi
    fi
  
 done
