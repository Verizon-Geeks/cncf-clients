const Etcd = require('node-etcd');
const etcd = new Etcd("192.168.184.113:2379");

// etcd.set('/database/mongo', '192.168.10.89');
// etcd.set('/database/sql', '192.168.10.90');
// etcd.set('/database/postgress', '192.168.10.91');

// etcd.get('/database', { recursive: true }, console.log);

etcd.watch('foo', console.log);

const watcher = etcd.watcher('foo');
watcher.on('change', console.log);
watcher.on("set", console.log);
watcher.on("error", console.log);