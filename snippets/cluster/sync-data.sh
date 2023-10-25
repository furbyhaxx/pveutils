#!/bin/bash

NODES=""
CORENODE=""
SYNCORDER=""
CURRENTNODE=""
PIDS=()

function getNodes()
{
	NODES=$(ls /etc/pve/nodes)
	NODES=(${NODES//;/ })
}

function getCurrentNode()
{
	CURRENTNODE=$(hostname)
}

function getSyncOrder()
{
	# get sync order
	readarray -t SYNCORDER < /data/.syncOrder.arr
#	SYNCORDER=SYNCORDER
}

function defineCoreNode()
{
#	echo "${SYNCORDER[*]}"
	# define core node
	for key in "${!SYNCORDER[@]}"
	do
		n=${SYNCORDER[$key]}

		if ping -c 1 $n &> /dev/null
		then
			echo "$n online"
			CORENODE=$n
			echo "$CORENODE" > '/data/corenode'
			echo "defining $n as core node"
			break
		else
			echo "$n is offline"
		fi
	done
}
function resetPIDS()
{
	PIDS=()
}

function createUnisonConfig()
{
FILE=/root/.unison/$1.prf
#if [ ! -f "$FILE" ]; then
cat > /root/.unison/$1.prf <<EOL
# Roots of the synchronization
root =  /data
root = ssh://$1//data

ignore = Path */download*
ignore = Path */media*

auto = true
batch=true
confirmbigdel=true
fastcheck=false
group=true
owner=true
prefer=newer
silent=false
times=true
repeat=watch
EOL
#fi

}

getNodes
getCurrentNode
getSyncOrder
defineCoreNode

##
#arr=(1 2 3)
#echo "${arr[*]}"
#1 2 3
#arr+=(4 5 6)
#echo "${arr[*]}"
#1 2 3 4 5 6



# loop
while true
do
	# setting up core node
	if [ $CORENODE = $CURRENTNODE  ]
	then
		# current node is core node
		for key in "${!NODES[@]}"
		do
			n=${NODES[$key]}

			if [ $n != $CURRENTNODE  ]
			then
				echo "Setting up for node $n"
				createUnisonConfig $n
				unison "$n.prf" &
				PIDS+=$!
			fi
		done
		
		while true
		do
			echo "le me ce core" >> /dev/null
			# check if unison pids are still alive...
			#if ! ps -p "${PIDS[*]}" > /dev/null
			#then
			#	break  # Exit the loop when all Unison processes are finished.
			#fi
			sleep 1
		done
	else
		# current node is not core node
		if ping -c 1 $CORENODE &> /dev/null
		then
			# core alive, sleep
			sleep 15
		else
			echo "Core $CORENODE is offline. Defining new core node."
			defineCoreNode
		fi
		
	fi
done
