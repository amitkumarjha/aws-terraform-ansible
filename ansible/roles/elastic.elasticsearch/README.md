# Aws-Terraform-Ansible

####Installing elasticsearch with 3 nodes cluster

Servers were created from terraform, we will be going to use dynamic inventory file to apply the changes
as per each host/groups.

[Setup Ansibile Dynamic Inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html#inventory-script-example-aws-ec2)

one done please export you keys:

```buildoutcfg
export AWS_ACCESS_KEY_ID='AK123'
export AWS_SECRET_ACCESS_KEY='abc123'
```

Downnload the ec2.py and ec2.ini files and try running the scripts to check the working of the script

```buildoutcfg
./ec2.py --list
ansible -i ec2.py -u ubuntu asia-south-1 -m ping
```

The elastic search ansibile script is forked from elastic community setup
[Github link of elastic ansible](https://github.com/elastic/ansible-elasticsearch/)

We had just modifed the files and updated as per the requirement on our side.

In our case we are going to setup 3 nodes elastic search cluster with below specfication:

    1) 1 Master Node
    2) 2 Data NOdes
    3) TLS ENCRYPTED ON HTTPS with PKCS12 keystore and truststore(https://www.elastic.co/guide/en/elasticsearch/reference/7.4/configuring-tls.html#node-certificates)


So all the communication between the nodes will happen only on the encrpyted secured packets and with 
the passstore defined in the group_vars
```buildoutcfg
es_ssl_keystore_password: "changeme"
es_ssl_truststore_password: "changeme"
``` 

Run the Role:

```buildoutcfg
ansible-playbook -i inventory/ --tags elastic  elasticsearch.yml -D
```


Test/varify the cluster is  encrpyted:

Check the ports on all the server should be listing on the `eth0` network interface like below
```buildoutcfg
root@ip-10-0-1-254:~# netstat -antlp | grep java
tcp6       0      0 :::9200                 :::*                    LISTEN      4182/java           
tcp6       0      0 :::9300                 :::*                    LISTEN      4182/java
root@ip-10-0-1-254:~# ps -ef | grep java
elastic+  4182     1  3 21:05 ?        00:00:30 /usr/share/elasticsearch/jdk/bin/java -Des.networkaddress.cache.ttl=60 -Des.networkaddress.cache.negative.ttl=10 -XX:+AlwaysPreTouch -Xss1m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djna.nosys=true -XX:-OmitStackTraceInFastThrow -Dio.netty.noUnsafe=true -Dio.netty.noKeySetOptimization=true -Dio.netty.recycler.maxCapacityPerThread=0 -Dio.netty.allocator.numDirectArenas=0 -Dlog4j.shutdownHookEnabled=false -Dlog4j2.disable.jmx=true -Djava.locale.providers=COMPAT -Xms200m -Xmx200m -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -Djava.io.tmpdir=/tmp/elasticsearch-13826850781161275579 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${heap.dump.path} -XX:ErrorFile=/var/log/elasticsearch/hs_err_pid%p.log -Xlog:gc*,gc+age=trace,safepoint:file=/var/log/elasticsearch/gc.log:utctime,pid,tags:filecount=32,filesize=64m -XX:MaxDirectMemorySize=104857600 -Des.path.home=/usr/share/elasticsearch -Des.path.conf=/etc/elasticsearch -Des.distribution.flavor=default -Des.distribution.type=deb -Des.bundled_jdk=true -cp /usr/share/elasticsearch/lib/* org.elasticsearch.bootstrap.Elasticsearch -p /var/run/elasticsearch/elasticsearch.pid --quiet
root      4446  4366  0 21:22 pts/1    00:00:00 grep --color=auto java
  
```

Now check the cluster health and nodes if everything is in place as we know we have encrypted the connection
so we will have to pass the certificate user and password in the url to verify or you can ignore the ssl
verication in curl output

```buildoutcfg
curl -u elastic:changeme https://localhost:9200/_nodes -k
curl -u elastic:changeme https://localhost:9200/ -k
curl -u elastic:changeme https://localhost:9200/_cluster/health -k
```

Output should be something like this
```buildoutcfg
{
	"cluster_name": "elastic-cluster",
	"status": "green",
	"timed_out": false,
	"number_of_nodes": 3,
	"number_of_data_nodes": 2,
	"active_primary_shards": 0,
	"active_shards": 0,
	"relocating_shards": 0,
	"initializing_shards": 0,
	"unassigned_shards": 0,
	"delayed_unassigned_shards": 0,
	"number_of_pending_tasks": 0,
	"number_of_in_flight_fetch": 0,
	"task_max_waiting_in_queue_millis": 0,
	"active_shards_percent_as_number": 100.0
}
```
