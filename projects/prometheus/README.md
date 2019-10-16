# Flask application for generating random numbers

This is an example of flask application that generates metrics.
Prometheus configurations for json exporter client to enable metrics collection.

# Installation
pip install prometheus_client

# Configure prometheus
cd /etc/prometheus/prometheus.yml

Edit prometheus.yml as following:

    #Prometheus.yml
    scrape_configs:
       #The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
       - job_name: 'prometheus_metrics'
         #Override the global default and scrape targets from this job every 5 seconds.
         scrape_interval: 5s
         static_configs:
           - targets: ['localhost:8080']
       - job_name: 'get_metrics'
           scrape_interval: 2s
           metrics_path: /generate_metrics
           scheme: http
           static_configs:
               - targets: ['localhost:2345']

Here value for "metrics_path" is the API endpoint that is returning parameter used for metrics.
For example, "/generate_metrics" in this case and json collector is running on 2345 port.


# JSON exporter for collecting metrics
    class JsonCollector(object):
        def __init__(self, endpoint):
            self._endpoint = endpoint
        def collect(self):
        # Fetch the JSON
            response = json.loads(requests.get(self._endpoint).content.decode('UTF-8'))

            # Metrics with labels for the documents loaded
            metric = Metric('sample_metrics', 'Requests failed', 'gauge')
            metric.add_sample('sample_metrics',value=response, labels={})
            yield metric

        if __name__ == '__main__':
        start_http_server(2345)
        REGISTRY.register(JsonCollector(sys.argv[1]))
        while True: time.sleep(1)


