#!/bin/bash
TIMESTAMP=$(date +%s)
$(pwd)/script.sh > textfile_$TIMESTAMP
ansible glusterfs -e TIMESTAMP=$TIMESTAMP -m copy -a "src=textfile_{{ TIMESTAMP }} dest=/tmp/"
ansible glusterfs -e TIMESTAMP=$TIMESTAMP -m shell -a "mkdir -p /tmp/collector-textfile && mv /tmp/textfile_{{ TIMESTAMP }} /tmp/collector-textfile/textfile.prom"

