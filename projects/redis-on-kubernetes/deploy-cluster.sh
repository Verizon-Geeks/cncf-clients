# No of master node. The same no of Slave will also be created.
MASTERS=3
# Namespace to launch the cluster. The namespace should not exist in Kubernetes
NAMESPACE="redis-cluster"

NODES=$(($MASTERS*2))
echo "> Creating Namespace 'redis-cluster'"
kubectl create namespace $NAMESPACE
echo "> Creating ConfigMap, Service & StatefulSet"
kubectl apply -f redis-cluster.yml -n $NAMESPACE

echo "> Checking service state"
while true
do
  rows=$(kubectl get pods -n $NAMESPACE|awk '{if(NR>1)print}'|grep 'redis-cluster'|awk '{ print $2}'|grep '1/1'|wc -l)
  if [ $rows == 1 ]
  then
    echo "Service is ready"
    break
  else
    sleep 1
  fi
done

echo "> Scaling redis-cluster to "$NODES
kubectl scale statefulset redis-cluster --replicas=$NODES -n $NAMESPACE

echo "> Checking readiness of all replicas"
while true
do
  rows=$(kubectl get pods -n $NAMESPACE| awk '{if(NR>1)print}'|grep 'redis-cluster'|awk '{ print $2}'|grep '1/1'|wc -l)
  if [ $rows == $NODES ]
  then
    echo "All replicas are ready"
    break
  else
    sleep 1
  fi
done

echo "> Creating the cluster"
kubectl exec -it redis-cluster-0 -n $NAMESPACE -- redis-cli --cluster create --cluster-replicas 1  $(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]} {.status.podIP}:6379' -n $NAMESPACE) <<< "yes"
