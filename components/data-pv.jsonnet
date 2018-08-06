# create a PV for data storage
local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["data-pv"];
local k = import "k.libsonnet";


local pv = {
  apiVersion: "v1",
  kind: "PersistentVolume",
  metadata: {
    name: "data-pv",
    namespace: env.namespace,
    labels: {
      type: "local"
    }
  },
  spec: {
    storageClassName: "fast",
    accessModes: [
      "ReadWriteOnce",
    ],
    capacity: {
      storage: "10Gi"
    },
    hostPath: {
      path: "/demo"
    },
  },
};

std.prune(k.core.v1.list.new([pv]))
