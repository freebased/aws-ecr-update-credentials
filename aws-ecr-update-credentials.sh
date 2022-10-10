#!/usr/bin/env bash

kube_namespaces=($(kubectl get secret --all-namespaces | grep regcred | awk '{print $1}'))
for i in "${kube_namespaces[@]}"
do
  :
  echo "$(date): Updating secret for namespace - $i"
  kubectl delete secret regcred --namespace $i
  kubectl create secret docker-registry regcred \
    --docker-server="$aws_account".dkr.ecr."$aws_region".amazonaws.com \
    --docker-username=AWS \
    --docker-password=$(aws ecr get-login-password) \
    --namespace=$i
done
