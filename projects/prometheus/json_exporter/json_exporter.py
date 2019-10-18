from prometheus_client import start_http_server, Metric, REGISTRY
import json
import requests
import sys
import time

class JsonCollector(object):
  def __init__(self, endpoint):
    self._endpoint = endpoint
  def collect(self):
    # Fetch the JSON
    response = json.loads(requests.get(self._endpoint).content.decode('UTF-8'))
    # Metrics with labels for the documents loaded
    metric = Metric('svc_fps', 'Requests failed', 'gauge')
    metric.add_sample('svc_fps',value=response, labels={})
    yield metric

if __name__ == '__main__':
  # Usage: json_exporter.py port endpoint
  start_http_server(1241)
  REGISTRY.register(JsonCollector(sys.argv[1]))

  while True: time.sleep(1)
