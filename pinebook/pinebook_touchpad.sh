#! /bin/sh
#  touchpad.sh
#
#  Mark H. Harris 
#  2014/08/07
#  2017/06/19  (pinebook port)
#
#  Enable or Disable the TouchPad  based on xinput
#  
#  notes:  assumes 'one' touchpad
#          assumes xinput    see man xinput
#
#  usage:
#          touchpad on|1        (enables)
#          touchpad off|0       (disables)
#
#

# check if X server is accessible
if ! xset q >/dev/null 2>&1; then
    echo "No X server at \$DISPLAY [$DISPLAY]... Aborting!!!" >&2
    exit 1
fi

# get the touchpad device number TDEVICE
for line in $(xinput list |grep -i "hailuck" |grep -i "pointer"); do
  for word in $(echo $line |grep -i "id"); do
     TDEVICE=$(echo $word |cut -d'=' -f2)
  done
done

# get Device Enabled status for touchpad
for line in $(xinput --list-props $TDEVICE |grep "Device Enabled"); do
  TPRESTAT=$(echo $line |cut -d':' -f2 |cut -d' ' -f2)
done

# set prestatus keyword based on numerical data
if [ "$TPRESTAT" = "1" ]; then
  PSTATUS="enabled"
elif [ "$TPRESTAT" = "0" ]; then
  PSTATUS="disabled"
else
  PSTATUS="unknown"
fi

# get the touchpad name by device number
TNAME=$(xinput list --name-only $TDEVICE)

# turn enable or disable the device per input parms
echo " "
if [ "$1" = "on" ] || [ "$1" = "1" ]; then
  xinput --enable $TDEVICE
  echo "Enabling" $TNAME "ID="$TDEVICE "..."
  echo " "
elif [ "$1" = "off" ] || [ "$1" = "0" ]; then
  xinput --disable $TDEVICE
  echo "Disabling" $TNAME "ID="$TDEVICE "..."
  echo " "
else
  echo $TNAME "ID="$TDEVICE "(currently "$PSTATUS")"
  echo " "
  echo "touchpad on    (enables)"
  echo "touchpad off   (disables)" 
  echo " "
fi

# get current Device Enabled status for touchpad
for line in $(xinput --list-props $TDEVICE |grep "Device Enabled"); do
  TCURSTAT=$(echo $line |cut -d':' -f2 |cut -d' ' -f2)
done

# display status of touchpad if the status has changed
if [ "$TCURSTAT" = "1" ]; then
  TSTATUS="enabled"
elif [ "$TCURSTAT" = "0" ]; then
  TSTATUS="disabled"
else
  TSTATUS="unknown"
fi
if [ $PSTATUS != $TSTATUS ]; then
  echo "Device Status:" $TNAME "ID="$TDEVICE "("$TSTATUS")"
  echo " "
else
  echo "TouchPad Status ("$TSTATUS") Unchanged"
  echo " "
fi
