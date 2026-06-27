#!/system/bin/sh
while true; do
  if [ -f /sys/class/power_supply/battery/temp ]; then
    read temp < /sys/class/power_supply/battery/temp
    echo $((temp * 100)) > /tmp/cpu_temp
  else
    echo 0 > /tmp/cpu_temp
  fi
  sleep 5
done
