#!/usr/bin/env bash


z=$(basename "$0")

usage() {
	printf "Usage: %s <ip> [-v]\n" "$z"
	exit 1
}

[ $# -eq 1 -o $# -eq 2 ] || usage

ip=$1

geo=$(curl http://www.telize.com/geoip/$1 2> /dev/null)

verbose=False
[[ $1 == "-v" || $2 == "-v" ]] && verbose=True


[ -n "$geo" ] || (echo "No response from database" && exit 2)

python - <<EOF
from __future__ import print_function
import json,math
d = json.loads('$geo')
if $verbose:
    for i,val in d.iteritems():
        print(i+':',val)
else:
    print(d['city'] if 'city' in d else '', d['country'], "(%s, %s)" % (d['latitude'],d['longitude']))
EOF




