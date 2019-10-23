# Configure IPMI exporter for metrics collection from multiple

IPMI targets needs be configured in targets.yml, it has be placed in /etc/prometheus/ directory.

# Configure Prometheus
cd /etc/prometheus/prometheus.yml

Edit prometheus.yml as following:

      # make the foll0wing changes under 'scrape_config'
      - job_name: 'ipmi'
        scrape_interval: 1m
        scrape_timeout: 30s
        metrics_path: /ipmi
        scheme: http
        file_sd_configs:
        - files:
          - targets.yml
        refresh_interval: 5m
        relabel_configs:
        - source_labels: [__address__]
          separator: ;
          regex: (.*)(:80)?
          target_label: __param_target
          replacement: ${1}
          action: replace
        - source_labels: [__param_target]
          separator: ;
          regex: (.*)
          target_label: instance
          replacement: ${1}
          action: replace
        - separator: ;
          regex: .*
          target_label: __address__
          replacement: localhost:9290
          action: replace

# sample targets.yml
cd /etc/prometheus/targets.yml
 
    ---
    - targets:
      - w.x.y.z
      - p.q.r.s
      labels:
         job: ipmi

