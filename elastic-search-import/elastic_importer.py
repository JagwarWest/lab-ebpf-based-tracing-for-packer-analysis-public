from elasticsearch import Elasticsearch
import json
import datetime
from elasticsearch import helpers
import requests
import sys

es = Elasticsearch()


def import_faccessat(messages):
    print("importing faccessat")
    mappings = {
      "mappings": {
        "properties": {
            "id":           {"type": "number"},
            "uid":          {"type": "number"},
            "pid":          {"type": "number"},
            "comm":         {"type": "text"},
            "syscall":      {"type": "text"},

            "pathname":         {"type": "text"},
            "mode":     {"type": "number"},
            "tampered": {"type":"boolean"},
            "copy_successful": {"type":"boolean"},
            "type": {"type": "text"}
        }
      }
    }
    es.indices.create(index="ebpf-faccessat-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-faccessat-index"))


def import_execve(messages):
    print("importing execve")
    mappings = {
        "mappings":{
        "properties":{
            "argv":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":700}}},
            "comm":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},
            "command":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},
            "id":{"type":"long"},
            "pid":{"type":"long"},
            "ret":{"type":"long"},
            "syscall":{"type":"text","fields":{"keyword":{"type":"keyword","ignore_above":256}}},
            "tampered":{"type":"boolean"},
            "uid":{"type":"long"}}}}
    
    es.indices.create(index="ebpf-execve-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-execve-index"))


def import_mprotect(messages):
    print("importing mprotect")
    """
{'uid': 10059,
 'pid': 3157,
  'comm': 'RenderThread', 
  'address': '734faa9e5000', 
  'prot': 1, 
  'length': 4096,
   'syscall': 'mprotect', 
   'prot_worded': ['PROT_READ'], 
   'end_address': '734faa9e6000', 
   'permissions': 'r--p', 
   'offset': '00000000', 
   'pathname': '[anon:linker_alloc]', 
   'type': 'data'} 
    """

    mappings = {
      "mappings": {
        "properties": {
            'id':              {"type": "number"},
            'uid':             {"type": "number"},
            'pid':             {"type": "number"},
            'comm':            {"type": "text"},
            'syscall':         {"type": "text"},

            'address':      {"type": "text"},
            'length':          {"type": "number"},
            'offset':          {"type": "text"},
            'prot':            {"type": "number"},
            'prot_worded':     {"type": "text"},
            'end_address':        {"type": "text"},
            'permissions':     {"type": "text"},
            'pathname':        {"type": "text"},
            'type':            {"type": "text"},
        }
      }
    }
    es.indices.create(index="ebpf-mprotect-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-mprotect-index"))


def import_mmap(messages):
    print("importing mmap")
    """
    {
        'uid': 1000,
        'pid': 261615,
        'comm': 'a.out',
        'start_addr': '7fc3c385f000',
        'desired_address': '7fc3c385f000',
        'fd': 4294967295,
        'length': 13528,
        'flags': 50,
        'flags_worded': ['MAP_PRIVATE', 'MAP_ANONYMOUS', 'MAP_FIXED'],
        'offset': '00000000',
        'prot': 3,
        'prot_worded': ['PROT_READ', 'PROT_WRITE'],
        'end_addr': '7fc3c3865000',
        'permissions': 'rw-p',
        'pathname': 'anonymously_mapped',
        'type': 'data',
        'syscall': 'mmap'
    }
    """

    mappings = {
      "mappings": {
        "properties": {
            'id':              {"type": "number"},
            'uid':             {"type": "number"},
            'pid':             {"type": "number"},
            'comm':            {"type": "text"},
            'syscall':         {"type": "text"},

            'address':      {"type": "text"},
            'desired_address': {"type": "text"},
            'fd':              {"type": "text"},
            'length':          {"type": "number"},
            'flags':           {"type": "number"},
            'flags_worded':    {"type": "text"},
            'offset':          {"type": "text"},
            'prot':            {"type": "number"},
            'prot_worded':     {"type": "text"},
            'end_address':        {"type": "text"},
            'permissions':     {"type": "text"},
            'pathname':        {"type": "text"},
            'type':            {"type": "text"},
            "maps_fd": {"type":"text"}

        }
      }
    }
    es.indices.create(index="ebpf-mmap-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-mmap-index"))


def import_openat(messages):
    print("importing openat")
    """
    {
        "uid": 10155,
        "pid": 6246,
        "comm": "Measurement Wor",
        "filepath": "/dev/ashmem1f977915-50c2-4c5a-8e93-4cd2c0e7c233",
        "type": "character special (10/61)",
        "syscall": "openat",
        "flags": 524290,
        "flags_worded": "O_RDWR O_CLOEXEC",
        "id": 300
    }
    """
    mappings = {
      "mappings": {
        "properties": {
            "id":           {"type": "number"},
            "uid":          {"type": "number"},
            "pid":          {"type": "number"},
            "flags":        {"type": "number"},
            "comm":         {"type": "text"},
            "flags_worded": {"type": "text"},
            "pathname":     {"type": "text"},
            "type":         {"type": "text"},
            "syscall":      {"type": "text"},
            "tampered":     {"type": "number"},
            "copy_successful": {"type": "boolean"}

        }
      }
    }
    es.indices.create(index="ebpf-openat-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-openat-index"))


def import_unlinkat(messages):
    print("importing unlinkat")
    mappings = {
      "mappings": {
        "properties": {
            "id":           {"type": "number"},
            "uid":          {"type": "number"},
            "pid":          {"type": "number"},
            "comm":         {"type": "text"},
            "syscall":      {"type": "text"},

            "type":         {"type": "text"},
            "pathname":     {"type": "text"},
            "flags":     {"type": "number"},
            "flags_worded": {"type":"text"},
            "tampered": {"type":"boolean"},
            "copy_successful": {"type":"boolean"}
        }
      }
    }
    es.indices.create(index="ebpf-unlinkat-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-unlinkat-index"))


def import_dlopen(messages):
    print("importing dlopen")
    mappings = {
      "mappings": {
        "properties": {
            "id":           {"type": "number"},
            "uid":          {"type": "number"},
            "pid":          {"type": "number"},
            "comm":         {"type": "text"},
            "lib_function":{"type": "text"},

            "type":         {"type": "text"},
            "pathname":     {"type": "text"},
            "flags":     {"type": "number"},
            "tampered": {"type":"boolean"},
            "copy_successful": {"type":"boolean"}
        }
      }
    }
    es.indices.create(index="ebpf-dlopen-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-dlopen-index"))


def import_tcpv4_connect(messages):
    print("importing tcpv4 connect")
    mappings = {
      "mappings": {
        "properties": {
            "id":           {"type": "number"},
            "uid":          {"type": "number"},
            "pid":          {"type": "number"},
            "comm":         {"type": "text"},
            "syscall":      {"type": "text"},

            "src_address":         {"type": "text"},
            "src_port":     {"type": "number"},
            "dst_address":     {"type": "text"},
            "dst_port": {"type":"number"}
        }
      }
    }
    es.indices.create(index="ebpf-tcpv4_connect-index", body=mappings, ignore=[400, 404])
    print(helpers.bulk(es, messages, index="ebpf-tcpv4_connect-index"))


def import_categories(categories):
    es.indices.delete(index='ebpf-dlopen-index', ignore=[400, 404])
    es.indices.delete(index='ebpf-unlinkat-index', ignore=[400, 404])
    es.indices.delete(index='ebpf-openat-index', ignore=[400, 404])
    es.indices.delete(index='ebpf-mmap-index', ignore=[400, 404])
    es.indices.delete(index='ebpf-mprotect-index', ignore=[400, 404])
    es.indices.delete(index='ebpf-execve-index', ignore=[400, 404])
    es.indices.delete(index='ebpf-faccessat-index', ignore=[400, 404])
    es.indices.delete(index='ebpf-tcpv4_connect-index', ignore=[400, 404])
    for key in categories:
        if key == "openat":
            import_openat(categories[key])
        elif key == "unlinkat":
            import_unlinkat(categories[key])
        elif key == "mmap":
            import_mmap(categories[key])
        elif key == "mprotect":
            import_mprotect(categories[key])
        elif key == "execve":
            import_execve(categories[key])
        elif key == "faccessat":
            import_faccessat(categories[key])
        elif "dlopen" in key:
            import_dlopen(categories[key])
        elif key == "tcpv4_connect":
            import_tcpv4_connect(categories[key])
        else:
            print("WHAT is %s" % key)


def split_messages_into_categories(filename):
    with open(filename, "r") as f:
        messages = json.loads(f.read())
    categories = {}
    for msg in messages:
        try:
            key = None
            if "syscall" in msg:
                key = msg["syscall"]
            if "lib_function" in msg:
                key = msg["lib_function"]
                if key == "android_dlopen_ext":
                    key = "dlopen"
            if "traced_function" in msg:
                key = msg["traced_function"]

            if key != None:
                if key not in categories:
                    categories[key] = []
                categories[key].append(msg)

        except Exception as e:
            print(e)
            print(msg)
            raise e
    return categories


def create_kibana_index_patterns():
    indices = es.indices.get_alias("ebpf-*").keys()
    for index in indices:
        print("create index pattern:",index)

        payload={
          "attributes": {
            "title": index
          }
        }

        index_pattern_url = "http://localhost:5601" + "/api/saved_objects/index-pattern/" + index+"-pattern"

        # deleting existing index patterns (in case we changed something)
        ret = requests.delete(index_pattern_url, headers={"kbn-xsrf":"true"},)
        print(ret.json())

        ret = requests.post(index_pattern_url, json=payload, headers={"kbn-xsrf":"true"})
        print(ret.json())



if __name__ == "__main__":
    filename = sys.argv[1]
    categories = split_messages_into_categories(filename)
    import_categories(categories)
    if len(sys.argv) > 2:
        if sys.argv[2] == "fast":
            print("skipping creating index patterns")
            exit()
        
    create_kibana_index_patterns()