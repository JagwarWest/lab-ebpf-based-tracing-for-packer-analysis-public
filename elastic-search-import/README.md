# Importing to elasticsearch/kibana

In order to make the analysis easier (to look at), elasticsearch in conjunction with kibana is used to provide a useful platform for all sorts of visualizations and filterings.

## Starting Elasticsearch and Kibana via `docker-compose`
If you do not have any elastic search/kibana server running or don't want to download it manually, you can use the `docker-compose.yml` (i.e. execute `docker-compose up`)

### Troubleshooting
It can happen that the elasticsearch docker instance might die. 

A possibility is that the `vm.max_map_count` is too low for running the instance (ubuntu default, e.g. to 65535).

Executing `sysctl -w vm.max_map_count=262144` can resolve the issue.

For reference, look [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-prod-prerequisites).


### A word of warning:
The docker containers are running in host-network-mode for a very easy throwaway setup!
Please take this into consideration!


## Importing the dashboard
Once elasticsearch and kibana are running, you can import a preconfigured dashboard.
To do so:
- Open [http://localhost:5601/](http://localhost:5601/) in your browser and navigate to "Management" -> "Stack Management" -> "Saved Object"
- Then use the import button (top right corner)
- Now drag the file `export.ndjson` into the file dropper



## Importing data into elastic search
A dashboard without data is not really useful, therefore we have to import some data.

Please note, that the `elastic_importer.py` script relies on the elastic search python bindings (i.e. execute `pip3 install elasticsearch`).


Steps to import:
- Execute `adb root` 
- Pull the data from the device via:<br>
`adb pull /data/androdeb/debian/root/ebpf-programs/messages_packer.json`
- import data by executing: `python3 elastic_importer.py messages_packer.json`

This will teardown/rebuild existing indices and index patterns so you can quickly access the data via the dashboard without having to first configure the patterns first.