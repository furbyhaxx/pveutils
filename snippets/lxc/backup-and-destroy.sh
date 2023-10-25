#!/bin/bash

for vmid in "$@"
do
	echo "Working on CT/VM $vmid"
	vzdump $vmid --notes-template '{{node}}-{{vmid}}-{{guestname}}' --storage local --compress zstd --node pve01 --remove 0 --mode stop >/dev/null
	echo "Backup of CT/VM #$vmid complete"
	pct destroy $vmid --purge
	echo "Destroyed CT/VM #$vmid"
done

echo "Backup & Destroy done"

#vzdump $1 --notes-template '{{node}}-{{vmid}}-{{guestname}}' --storage local --compress zstd --node pve01 --remove 0 --mode stop
#pct destroy $1 --purge
