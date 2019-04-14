# OCS MONITORING

## Requirements

- an OCP Cluster installation with the shipped Prometheus Operator (for the kubelet metrics used by the heketi dashboard)
- an Independent OCS installation
- the node_exporter installed on the OCS nodes

## Installation

clone this project

    git clone https://github.com/spagno/ocs-monitoring.git && cd ocs-monitoring

create the project

    oc new-project rhgs-metrics

edit the namespace adding `openshift.io/node-selector: ""` to let the statefulsets run in to the infra servers

install prometheus from the template

    oc new-app -f templates/prometheus.yaml -p NAMESPACE=rhgs-metrics -p HEKETI_APP_NAMESPACE=rhgs-app -p HEKETI_INFRA_NAMESPACE=rhgs-infra

or
    oc new-app -f templates/prometheus.yaml -p NAMESPACE=rhgs-metrics -p HEKETI_APP_NAMESPACE=rhgs

if you didn't install the glusterfs-registry

install grafana from the template

    oc new-app -f templates/grafana.yaml -p NAMESPACE=rhgs-metrics

launch the playbook using the ocp inventory to create the svc and the ep

    ansible-playbook -i <ocp_inventory> ocs_monitoring.yaml

if you use multitenant network plugin join the rhgs-metrics namespace to the default one
    
    oc adm pod-network join-projects rhgs-metrics --to default

import the dashboards from the directory `dashboard` to your grafana installation and create the "prometheus" datasource using "http://prometheus.rhgs-metrics:9090" as server

Add the k8s-app label to the services:

    oc -n rhgs-app label svc heketi-storage k8s-app=heketi-storage
    oc -n rhgs-infra label svc heketi-registry k8s-app=heketi-registry

or

    oc -n rhgs label svc heketi-storage k8s-app=heketi-storage

if you didn't install the glusterfs-registry

    
