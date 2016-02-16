#!/bin/sh

echo "Start openHAB 1.8.1 Docker Version"

# Cleanup Addons directory
rm -R -f /opt/openhab/addons/*

# Enable addons
echo "Enable addons"
for addon in $(echo $OH_ADDONS | tr ", " "\n")
do
  path=`cd /opt/openhab/allAddons && ls $addon*`
  echo "Enable addon $path"
  cp /opt/openhab/allAddons/$path /opt/openhab/addons
done

if [ ! -f /opt/openhab/configurations/openhab.cfg ]
then
    echo "Enable demo mode"
    cp -R /opt/openhab/demoData/* /opt/openhab/  >> /dev/null
    cp /opt/openhab/configurations/openhab_default.cfg /opt/openhab/configurations/openhab.cfg >> /dev/null
fi

setOption() {
  if [ -n "$2" ]; then
    sed -i -E "s/# $1=/$1=$2/" /opt/openhab/configurations/openhab.cfg
    echo "\t$1=$2"
  fi
}

echo "Update configuration"
setOption homematic:host                $OH_HOMEMATIC_HOST
setOption homematic:host.timeout        $OH_HOMEMATIC_HOST_TIMEOUT
setOption homematic:callback.host       $OH_HOMEMATIC_CALLBACK_HOST
setOption homematic:callback.port       $OH_HOMEMATIC_CALLBACK_PORT
setOption homematic:alive.interval      $OH_HOMEMATIC_ALIVE_INTERVAL
setOption homematic:reconnect.interval  $OH_HOMEMATIC_RECONNECT_INTERVAL

echo "Disable File Logging"
sed -i -E "s/<\appender\s.*FILE\s\///" /opt/openhab/configurations/logback.xml

# Run openHAB
sh /opt/openhab/start.sh
