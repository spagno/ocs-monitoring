#!/bin/bash
IFS="
"
for host in $(oc get node -o wide | awk '{print $6}' | tail -n +2)
do
	for i in $(ssh $host "lsblk -P | tr '[:upper:]' '[:lower:]'")
	do
		unset pv
		unset pv_option
                normalized=$(echo ${i} | sed -e "s/ /,/g" | sed -e "s/maj:min/dm/g" | sed -r -e "s/\"253:([0-9]+?)\"/\"dm-\1\"/g")
                if [ "$(echo $normalized | cut -d',' -f2 | cut -d '=' -f2 | cut -d'-' -f1 | cut -d'"' -f2)" == "dm" ]
		then
			pv=$(echo $normalized | cut -d',' -f7 | cut -d'/' -f10 | cut -d'"' -f1)
		fi
		if [ $pv ]
		then
			pv_option=",pv=\"${pv}\""
		fi
		echo "device_map{$(echo ${normalized} | sed -e 's/ /,/g'),node=\"$host\",port=\"9100\"${pv_option}} $(date +%s)"
	done
done
for pv in $(oc get pv | grep Bound | awk '{print $1}')
do
	result=$(oc get pv ${pv} -o custom-columns=pvc:spec.claimRef.name,namespace:spec.claimRef.namespace,'volume:metadata.annotations.gluster\.kubernetes\.io/heketi-volume-id' | tail -n +2)
	pvc=$(echo $result | awk '{print $1}')
	namespace=$(echo $result | awk '{print $2}')
	volume=$(echo $result | awk '{print $3}')
	if [ "${volume}" != "<none>" ]
	then
		volume=",volume=\"vol_${volume}\""
	else
		unset volume
	fi
	string_map="namespace=\"${namespace}\",pvc=\"${pvc}\",pv=\"${pv}\"${volume}"
	echo "pvc_namespace_map{$string_map} $(date +%s)"
done
