# Running Python Application on Kubernetes

## Kubernetes is an open source platform that offers deployment, maintenance, and scaling features. It simplifies management of containerized Python applications while providing portability, extensibility, and self-healing capabilities.

## Whether Python application are simple or complex, Kubernetes lets you efficiently deploy and scale them seamlessly rolling out new features while limiting resources to only those required.

### Pre-requistes

-Docker
-Kubectl
-Sample Python App

## Docker is an open platform to build and ship distributed applications. To install Docker, follow the Docker official documentation.

## To verify that Docker runs your system:

```
$ docker info
Containers: 0
Images: 289
Storage Driver: aufs
Root Dir: /var/lib/docker/aufs
Dirs: 289
Execution Driver: native-0.2
Kernel Version: 3.16.0-4-amd64
Operating System: Debian GNU/Linux 8 (jessie)
WARNING: No memory limit support
WARNING: No swap limit support
```

### kubectl is a command-line interface for executing commands against a Kubernetes cluster. Run the shell script below to install kubectl

```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

```
### Deploying to Kubernetes requires a containerized application. Let's review containerizing Python applications.

### Containerization at a glance
### Containerization involves enclosing an application in a container with its own operating system. This full machine virtualization option has the advantage of being able to run an application on any machine without concerns about dependencies.

### Create a Python container image

## To create these images, we will use Docker, which enables us to deploy applications inside isolated Linux software containers. Docker is able to automatically build images using instructions from a Docker file.

## This is a Docker file for our Python application:

````

FROM python:3.6
MAINTAINER XenonStack
# Creating Application Source Code Directory
RUN mkdir -p /k8s_python_sample_code/src
# Setting Home Directory for containers
WORKDIR /k8s_python_sample_code/src
# Installing python dependencies
COPY requirements.txt /k8s_python_sample_code/src
RUN pip install --no-cache-dir -r requirements.txt
# Copying src code to Container
COPY . /k8s_python_sample_code/src/app
# Application Environment variables
ENV APP_ENV development
# Exposing Ports
EXPOSE 5035
# Setting Persistent data
VOLUME ["/app-data"]
# Running Python Application
CMD ["python", "app.py"]

``````

## Build a Python Docker image

##Build the Docker image using this command:
##
##docker build -t k8s_python_sample_code
##
##Publish the container images
##We can publish our Python container image to different private/public cloud repositories, like Docker Hub, AWS ECR, Google Container Registry, etc. For this tutorial, we'll use Docker Hub.
##
##Tag a version to the image, before building the image
##
```
docker tag k8s_python_sample_code:latest k8s_python_sample_code:0.1
```
##
##Push the image to a cloud repository
##
##Using a Docker registry other than Docker Hub to store images requires to add that container registry to the local Docker daemon and Kubernetes Docker daemons. Docker Hub is used in this example.
##
##Execute this Docker command to push the image:

```
docker push k8s_python_sample_code
```

##Working with CephFS persistent storage
##
##Kubernetes supports many persistent storage providers, including AWS EBS, CephFS, GlusterFS, Azure Disk, NFS, etc.
##To use CephFS for persistent data to Kubernetes containers, we will create two files:

```
###persistent-volume.yml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: app-disk1
  namespace: k8s_python_sample_code
spec:
  capacity:
  storage: 50Gi
  accessModes:
  - ReadWriteMany
  cephfs:
  monitors:
    - "172.17.0.1:6789"
  user: admin
  secretRef:
    name: ceph-secret
  readOnly: false
  
### persistent_volume_claim.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: appclaim1
  namespace: k8s_python_sample_code
spec:
  accessModes:
  - ReadWriteMany
  resources:
  requests:
    storage: 10Gi  
```
### We can now use kubectl to add the persistent volume and claim to the Kubernetes cluster:

```
$ kubectl create -f persistent-volume.yml
$ kubectl create -f persistent-volume-claim.yml
```
### Deploy the application to Kubernetes
### To manage the deploy of the application to Kubernetes, create two mandatory files: a service file and a deployment file.

### Create a file and name it k8s_python_sample_code.service.yml with the following content:
```
apiVersion: v1
kind: Service
metadata:
  labels:
  k8s-app: k8s_python_sample_code
  name: k8s_python_sample_code
  namespace: k8s_python_sample_code
spec:
  type: NodePort
  ports:
  - port: 5035
  selector:
  k8s-app: k8s_python_sample_code
```
### Create a file and name it k8s_python_sample_code.deployment.yml with the following content:
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: k8s_python_sample_code
  namespace: k8s_python_sample_code
spec:
  replicas: 1
  template:
  metadata:
    labels:
    k8s-app: k8s_python_sample_code
  spec:
    containers:
    - name: k8s_python_sample_code
      image: k8s_python_sample_code:0.1
      imagePullPolicy: "IfNotPresent"
      ports:
      - containerPort: 5035
      volumeMounts:
        - mountPath: /app-data
          name: k8s_python_sample_code
     volumes:
         - name: <name of application>
           persistentVolumeClaim:
             claimName: appclaim1
```
### Use kubectl to deploy the application to Kubernetes
```
$ kubectl create -f k8s_python_sample_code.deployment.yml $ kubectl create -f k8s_python_sample_code.service.yml
```
### Verify The Successful Deployment of the application

```
kubectl get services
```