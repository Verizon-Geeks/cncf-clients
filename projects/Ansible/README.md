# Trigger Jenkins Job Using Ansible Playbook


### Pre-requistes

- Jenkins
- Ansible 



## Playbook To Trigger the Jenkins Job. 

```

  --- 
  - hosts: all
    tasks: 
	- name: Launch Jenkins Job 
	  uri:
	     url: "https://{{username}}:{{token}}@url"
		 method: POST
		 force_basic_auth: yes
		 body_format: json
		 status_code: 201
		 timeout: 400
	  register: jenkins_output
 
    - name: Retrieve the Jenkins Queue ID
      set_stats:
         data: 
           jobInfo: "{{ jenkins_output.location }}"		 

```

### Playbook To Check The Status of the Jenkins Job 

```
--- 
- hosts: all  
  tasks:
  - name: Extracting Queue ID From The Queue Location
    set_fact: 
	    jninfo1: "{{ jobinfo.split('/')[6]}}"

  - name: Retrieve Job Status Based On The QueueId in XML format
    uri: 
	   url: "https://{{username}}:{{token}}@{{url}}/api/xml?tree=build[id,number,result,queueId]&xpath=//build[queueId={{jninfo1}}]"
	   return_content: yes
	   force_basic_auth: yes
	register: response
    delay: 30
    retries: 10
    until: response.status == 200	
    
```
