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

if [ -z "$OH_HOMEMATIC_HOST" ]; then
sed "s/# homematic:host=/homematic:host=$OH_HOMEMATIC_HOST/" /opt/openhab/configurations/openhab.cfg > /opt/openhab/configurations/openhab.cfg
fi

#sed "s/# homematic:host=/homematic:host.timeout=$OH_HOMEMATIC_HOST_TIMEOUT/" /opt/openhab/configurations/openhab.cfg > /opt/openhab/configurations/openhab.cfg
#sed "s/# homematic:host=/homematic:callback.host=$OH_HOMEMATIC_CALLBACK_HOST/" /opt/openhab/configurations/openhab.cfg > /opt/openhab/configurations/openhab.cfg
#sed "s/# homematic:host=/homematic:callback.port=$OH_HOMEMATIC_CALLBACK_PORT/" /opt/openhab/configurations/openhab.cfg > /opt/openhab/configurations/openhab.cfg
#sed "s/# homematic:host=/homematic:alive.interval=$OH_HOMEMATIC_ALIVE_INTERVAL/" /opt/openhab/configurations/openhab.cfg > /opt/openhab/configurations/openhab.cfg
#sed "s/# homematic:host=/homematic:reconnect.interval=$OH_HOMEMATIC_RECONNECT_INTERVAL/" /opt/openhab/configurations/openhab.cfg > /opt/openhab/configurations/openhab.cfg

# Run openHAB
sh /opt/openhab/start.sh
