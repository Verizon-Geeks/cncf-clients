# gRPC integration with Python

### In gRPC a client application can directly call methods on a server application on a different machine as if it was a local object, making it easier to create distributed applications and services. As in many RPC systems, gRPC is based around the idea of defining a service, specifying the methods that can be called remotely with their parameters 
### and return types. On the server side, the server implements this interface and runs a gRPC server to handle client calls. On the client side, the client has a stub (referred to as just a client in some languages) that provides the same methods as the server.

### Pre-requistes

- gRPC Python is supported for use with Python 2.7 or Python 3.4 or higher. 

###Ensure you have pip version 9.0.1 or higher:

```

  $ python -m pip install --upgrade pip 

```

## Install gRPC

```
$ python -m pip install grpcio

```

## Install gRPC tools

```
$ python -m pip install grpcio-tools

```

## Run a gRPC application

## Download the example

```
$ # Clone the repository to get the example code:
$ git clone -b v1.24.0 https://github.com/grpc/grpc
```

### Run the Server From examples/python/helloworld directory

```
$ python greeter_server.py

```

###Run the client

```
python greeter_client.py

```

## Update gRPC Service

### The server and the client “stub” have a SayHello RPC method that takes a HelloRequest parameter from the client and returns a HelloReply from the server, 
```
// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}


```
### Update examples/protos/helloworld.proto and update it with a new SayHelloAgain method
```
// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
  // Sends another greeting
  rpc SayHelloAgain (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}



```

### Generate the gRPC Code

```

$ python -m grpc_tools.protoc -I../../protos --python_out=. --grpc_python_out=. ../../protos/helloworld.proto

```

### This regenerates helloworld_pb2.py which contains our generated request and response classes and helloworld_pb2_grpc.py which contains our generated client and  server classes.


### Update the greeter_server.py

```
class Greeter(helloworld_pb2_grpc.GreeterServicer):

  def SayHello(self, request, context):
    return helloworld_pb2.HelloReply(message='Hello, %s!' % request.name)

  def SayHelloAgain(self, request, context):
    return helloworld_pb2.HelloReply(message='Hello again, %s!' % request.name)


```

### Update the greeter_client.py

```

def run():
  channel = grpc.insecure_channel('localhost:50051')
  stub = helloworld_pb2_grpc.GreeterStub(channel)
  response = stub.SayHello(helloworld_pb2.HelloRequest(name='you'))
  print("Greeter client received: " + response.message)
  response = stub.SayHelloAgain(helloworld_pb2.HelloRequest(name='you'))
  print("Greeter client received: " + response.message)



```

### Run the Server

```
$ python greeter_server.py

```


### Run the Client

```
$ python greeter_server.py



```
