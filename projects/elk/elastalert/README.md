Overview

Elastalert works by combining Elasticsearch with two types of components, rule types and alerts. Elasticsearch is periodically queried and the data is passed to the rule type, which determines when a match is found. When a match occurs, it is given to one or more alerts, which take action based on the match.





Elastalert Installation

Install elastalert by cloning the elastalert project from git repository.

Setup dependencies

$ sudo su

$ yum update -y

$ yum install git python-devel lib-devel libevent-devel bzip2-devel openssl-devel ncurses-devel zlib zlib-devel xz-devel gcc -y

$ yum install python-setuptools -y

$ easy_install pip

$ git clone https://github.com/Yelp/elastalert.git

$ cd elastalert

$ pip install –r requirements.txt

$ pip install "setuptools>=11.3"

$ python setup.py install

$ pip install "elasticsearch>=5.0.0"

Open config.yaml file, there are multiple configuration options to run the elastalert. Edit the configurations according to the requirement.

Then create an index for elastalert in elasticsearch. This index is used by elastalert to save the informations related to all alerts and matches.

$ elastalert-create-index

Next step is to create a rule based on the requirement. There are certain predefined rules provided by elastalert. Sample rules is under example_rules folder.





Run elastalert with following command,

$ python -m elastalert.elastalert --verbose --rule example_frequency.yaml –- config config.yaml

Now elastalert will start to run.





Email alert

One among the alerting methods provided by elastalert is email. Setting required to send out an email alert is as follows.

Open rule.yaml file and add following contents.

alert:

- “email”

email:

- "receiver@gmail.com"

smtp_host: "smtp.gmail.com"

smtp_port: 465

smtp_ssl: true

from_addr: “sender@gmail.com”

smtp_auth_file: ‘smtp_auth_file.yaml’ # provide absolute path of auth file

Open smtp_auth_file.yaml and add following contents.

user: “sender@gmail.com”

password: “<password>”

Password provided in the above mentioned file should be the app password generated for gmail account.

Follow below mentioned link to generate app password for gmail account.

https://support.google.com/accounts/answer/185833?hl=en





Bitsensor Elastalert

Yelp Elastalert by default does not provide support for kibana. So, bitsensor has developed a wrapper on top of Yelp Elastalert called Bitsensor elastalert. This is used in combination with Elastalert kibana plugin.

Bitsensor Elastalert enables user to visualize alerts and rules through kibana. Also using kibana various visualizations and dashboards can be created for alerts.





Elastalert-kibana-plugin installation

$ cd /usr/share/kibana/bin

$./kibana-plugin install https://github.com/bitsensor/elastalert-kibana-plugin/releases/download/1.1.0/elastalert-kibana-plugin-1.1.0-7.3.0.zip

Restart kibana after successful installation of the plugin.

Based on kibana version being used, elastaler-kibana-plugin flavor varies. Release notes can be found in below link,

https://github.com/bitsensor/elastalert-kibana-plugin/releases

By default the plugin will connect to localhost:3030. If ElastAlert server is running on a different host or port add/change the following options in config/kibana.yml file:

elastalert-kibana-plugin.serverHost: 123.0.0.1

elastalert-kibana-plugin.serverPort: 9000





Bitsensor-Elastalert Installation

Clone the repository

$ git clone https://github.com/bitsensor/elastalert.git

$ cd elastalert

$ nvm install

$ node install

$ npm install

Check config/config.json file and modify path of elastalert.

Place config.yaml file in elastalert directory. This is same as one found in Yelp elastalert. Also copy the same file to config-test.yaml for testing rules.

Run following command to start bitsensor-elastalert and push logs to a file.

$mkdir log

$npm start > log/output.log &





Custom Rules

User can define own rules for creating custom matches and alerts. These rules can be placed under elastalert_modules folder.


