create the project
oc new-project rhgs-metrics

edit the namespace adding
    openshift.io/node-selector: ""
to let the statefulsets run in to the infra servers

install prometheus from the template
oc new-app -f prometheus.yaml -n NAMESPACE=rhgs-metrics

install grafana from the template
oc new-app -f grafana.yaml -n NAMESPACE=rhgs-metrics

create the role in kube-system namespace
oc create -f prometheus_kubelet_role.yaml 

create the role binding in kube-system namespace 
oc create -f prometheus_kubelet_rolebinding.yaml
