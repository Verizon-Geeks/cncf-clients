# ELK setup

## Installation
To pull this image from the Docker registry, open a shell prompt and enter:
```
$ sudo docker pull sebp/elk
```
Run a container from the image with the following command:
```
$ sudo docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name elk sebp/elk
```
Note:This command publishes the following ports, which are needed for proper operation of the ELK stack
```
5601 (Kibana web interface).
9200 (Elasticsearch JSON interface).
5044 (Logstash Beats interface, receives logs from Beats such as Filebeat)
```

## How to use Logstash

  - Define the custom logstash configuration files and place under /etc/logstash/conf.d/
  - To pick the placed configuration file, restart the logstash service with command:
  ``service logstash restart``
  - If service is not up, check the logstash log file /var/log/logstash/logstash-plain.log

### Logstash example with file as input:
```
input {
    file {
        path => "/var/log/airflow.log"
        type => "logs"
        start_position => "beginning"
    }
}
output {
   elasticsearch {
     hosts => ["localhost:9200"]
     index => <index-name>
  }
}
```
