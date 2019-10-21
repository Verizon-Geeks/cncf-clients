## How to install Filebeat with dockerFile
```
ARG FILEBEAT_VERSION=6.7.2
ARG FILEBEAT_SHA1=694fe12e56ebf8e4c4b11b590cfb46c662e7a3c1


RUN apt-get update && apt-get install -y wget && apt-get install -y gnupg \
    && wget -q -O /tmp/filebeat.tar.gz https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
    && cd /tmp \
    #&& echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - \
    && tar xzvf filebeat.tar.gz \
    && cd filebeat-* \
    && cp filebeat /bin \
    && mkdir -p /etc/filebeat \
    && cp filebeat.yml /etc/filebeat/filebeat.yml \
    && rm -rf /tmp/filebeat*
```
### configure filebeat

configure the set of required log files to capture in elasticsearch index

Contact logstash for parsing and storing the logs in elasticsearch index, so mention logstash section in filebeat.yml

### start service

start the filebeat service in deployed container with command: "filebeat -c /etc/filebeat/filebeat.yml -e"

### Logstash example with filebeat as input and applying grok pattern filters:

```
input {
    beats {
        port => 5044
    }
}
filter {
     grok {
         match => ["message", "\[%{LOGLEVEL:loglevel}\] %{TIMESTAMP_ISO8601:logdate}: </%{WORD:functionName}%{GREEDYDATA:data}"
         ]
     }
     if "_grokparsefailure" in [tags] {
         drop {}
     }
}
output {
   elasticsearch {
     hosts => ["localhost:9200"]
     index => <index-name>
  }
}
```
