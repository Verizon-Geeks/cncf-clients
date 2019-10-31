# Redis on kubernetes
Automated scripts to deploy Redis Cluster on Kubernetes

## For deploying Redis run
	To deploy redis cluster of 3 Masters and 6 Nodes run
	```shell
	./deploy-cluster.sh
	```
## To scale-up deployed Redis cluster run
	To scale-up existing redis cluster edit ```scaleup-cluster.sh``` and change no of masters to add. Double no of nodes will also be added to the cluster.
	```shell
	MASTERS=1
	```
	Then run
	```shell
	./scaleup-cluster.sh
	```
## To change configuration of Redis cluster
	To change configuration of redis cluster you can edit ```redis-cluster.yml```

** To Change the namespace to be deployed edit deploy-cluster.sh or scaleup-cluster.sh *NAMESPACE* veriable**