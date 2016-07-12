#!/bin/bash

[ -f /data/valhalla.json ] || cp /conf/valhalla.json /data/

if [ ! -d /data/valhalla ] ; then
  mkdir -p /data/valhalla
  valhalla_build_admins -c /data/valhalla.json /data/*.pbf
  valhalla_build_tiles -c /data/valhalla.json /data/*.pbf
fi

exec /usr/local/bin/valhalla_route_service "$@"
