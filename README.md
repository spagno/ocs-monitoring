# OCS MONITORING

## Installation

clone this project

    git clone https://github.com/spagno/ocs-monitoring.git && cd ocs-monitoring

create the project

    oc new-project rhgs-metrics

edit the namespace adding `openshift.io/node-selector: ""` to let the statefulsets run in to the infra servers

install prometheus from the template

    oc new-app -f templates/prometheus.yaml -n NAMESPACE=rhgs-metrics

install grafana from the template

    oc new-app -f templates/grafana.yaml -n NAMESPACE=rhgs-metrics

create the role in kube-system namespace

    oc create -f roles/prometheus_kubelet_role.yaml

create the role binding in kube-system namespace

    oc create -f roles/prometheus_kubelet_rolebinding.yaml

import the dashboards from the directory `dashboard` to your grafana installation
