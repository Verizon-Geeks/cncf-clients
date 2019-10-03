# Nodejs integration with etcd

## Running etcd

### Using Docker

```
export NODE1=192.168.1.21

docker volume create --name etcd-data

export DATA_DIR="etcd-data"

REGISTRY=quay.io/coreos/etcd
# available from v3.2.5
REGISTRY=gcr.io/etcd-development/etcd

docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:latest \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name node1 \
  --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster node1=http://${NODE1}:2380
```

### Running on Windows

```
choco install etcd
```

## Node Integration

Library Used - ``node-etcd``

### Installing Library
```
npm install node-etcd
```

### Initializing Client

```
const Etcd = require('node-etcd');

const etcd = new Etcd("192.168.184.113:2379");
```

### Set Keys

```
etcd.set('/database/mongo', '192.168.10.89');

etcd.set('/database/sql', '192.168.10.90');

etcd.set('/database/postgress', '192.168.10.91');
```

### Get Keys

```
etcd.get('/database', { recursive: true }, console.log);
```

### Watch

> Need to update this section