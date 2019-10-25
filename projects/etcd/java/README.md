# java integration with etcd

## Running etcd in docker

```
docker volume create --name etcd-data

docker run \
    -p 2379:2379 \
    --restart=always \
    --name etcd gcr.io/etcd-development/etcd:latest \
    /usr/local/bin/etcd \
    --data-dir=/etcd-data --name <hostname> \
    --advertise-client-urls http://<host_ip>:2379 --listen-client-urls http://0.0.0.0:2379 \
    --heartbeat-interval 1000 \
    --election-timeout 5000
```
## java Integration
Library Used - ``jetcd``

### jetcd - Java Client for etcd
jetcd is the official java client for etcd v3.

### Java Versions
  Java 8 or above is required.

### Download
  #### Maven
```
      <dependency>
        <groupId>io.etcd</groupId>
        <artifactId>jetcd-core</artifactId>
        <version>${jetcd-version}</version>
      </dependency>
```
  #### Gradle
```
    dependencies {
        compile "io.etcd:jetcd-core:$jetcd-version"
    }
```
### Usage
```
// create client
Client client = Client.builder().endpoints("http://<host_ip>:2379").build();
KV kvClient = client.getKVClient();

ByteSequence key = ByteSequence.from("test_key".getBytes());
ByteSequence value = ByteSequence.from("test_value".getBytes());

// put the key-value
kvClient.put(key, value).get();

// get the CompletableFuture
CompletableFuture<GetResponse> getFuture = kvClient.get(key);

// get the value from CompletableFuture
GetResponse response = getFuture.get();

// delete the key
kvClient.delete(key).get();
```
