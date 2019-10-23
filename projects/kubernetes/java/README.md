# Deploy java app on kubernetes

## Prequisites

1. Java 8 and Maven - to build the code with Maven and dependency tools that uses java 8 features 
2. Docker - It allows us to build, run and test Docker containers
3. Minikube (if kubernetes is not setup) - It is a tool that makes easy to run a single-node kubernetes test cluster on our local development machine

## Steps to follow

### Build Java Application
- Clone sample java project from github
  ```
    $ git clone git@github.com:danielbryantuk/oreilly-docker-java-shopping.git
    $ cd oreilly-docker-java-shopping/shopfront 
  ```
- Build the cloned application using Maven
  ```
  $ mvn clean install
  ```
### Push to docker
- create the dockerfile with above generated jar and mention the expose port
  ```
  FROM openjdk:8-jre
  ADD target/shopfront-0.0.1-SNAPSHOT.jar app.jar
  EXPOSE 8010
  ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
  ```
- Build the docker container image
  ```
  $ docker build -t danielbryantuk/djshopfront:1.0 .
  ```
- Push image to dockerhub
  ```
  $ docker login
  Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
  Username:
  Password:
  Login Succeeded
  $
  $ docker push danielbryantuk/djshopfront:1.0
  The push refers to a repository [docker.io/danielbryantuk/djshopfront]
  9b19f75e8748: Pushed 
  ...
  cf4ecb492384: Pushed 
  ```
### Deploying on kubernetes
- create a sample yaml file: "shopfront-service.yaml" with recently pushed docker image and above exposed port
  ```
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: shopfront
    labels:
      app: shopfront
  spec:
    type: NodePort
    selector:
      app: shopfront
    ports:
    - protocol: TCP
      port: 8010
      name: http
  ---
  apiVersion: extensions/v1beta1
  kind: Deployment
  metadata:
    name: shopfront
  spec:
    replicas: 1
    template:
      metadata:
        labels:
          app: shopfront
      spec:
        containers:
          - name: shopfront
            image: danielbryantuk/djshopfront:latest
            ports:
            - containerPort: 8010
            livenessProbe:
              httpGet:
                path: /health
                port: 8010
              initialDelaySeconds: 30
              timeoutSeconds: 1
  ```
- start minikube
  ```
  $ minikube start --cpus 2 --memory 4096
  Starting local Kubernetes v1.7.5 cluster...
  Setting up kubeconfig...
  Starting cluster components...
  Kubectl is now configured to use the cluster.
  ```
- deploy yaml file in local kubernetes cluster environment
  ```
  $ kubectl apply -f shopfront-service.yaml
  service "shopfront" created
  deployment "shopfront" created
  ```
- check the services and deployments
  ```
  $ kubectl get svc
  NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
  kubernetes   10.0.0.1     <none>        443/TCP          18h
  shopfront    10.0.0.216   <nodes>       8010:31208/TCP   12s
  $ kubectl get pods
  NAME              READY     STATUS    RESTARTS   AGE
  shopfront-0w1js   1/1       Running   0          2m
  ```
