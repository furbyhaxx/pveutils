#!/bin/bash

nodes=$(ls /etc/pve/nodes)
nodes=(${nodes//;/ })
currentNode=$(hostname)

# get sync order
readarray -t syncOrder < /data/.syncOrder.arr

# loop over nodes
for key in "${!syncOrder[@]}"
do
 n=${syncOrder[$key]}

 if ping -c 1 some_ip_here &> /dev/null
  then
   echo "$n online"
   coreNode=$n
   echo "defining $n as core node"
   break
 else
  echo "$n is offline"
 fi

 #echo "Key is '$key'  => Value is '${arrIN[$key]}'"
done

if [ $coreNode != $currentNode  ]
then
 # current node is not core node
 echo "Setting up for node $n"
 else
  echo "current node is core node"
  # loop over nodes
  for key in "${!nodes[@]}"
  do
   n=${nodes[$key]}

   if [ $n != $currentNode  ]
   then
    echo "Setting up for node $n"
    unison "$" -repeat watch
   fi
  done
fi


#[ -z $(ps -axo comm | grep unison) ] && unison pve4to3 -repeat watch
#[ -z $(ps -axo comm | grep unison) ] && unison pve3to4 -repeat watch
