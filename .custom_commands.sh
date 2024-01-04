kfzy () {
  if [[ -n $1 ]]
  then
    if [[ -n $2 ]]
    then
      kubectl get $1 --sort-by=.metadata.creationTimestamp | grep $2 | tail -n 1 | awk '{print $1;}'
    else
      kubectl get pods --sort-by=.metadata.creationTimestamp | grep $1 | tail -n 1 | awk '{print $1;}'
    fi
  else
    kubectl get pods --sort-by=.metadata.creationTimestamp | tail -n 1 | awk '{print $1;}'
  fi
}

keb () {
  kubectl exec -it $(kfzy $1) -- bash
}
