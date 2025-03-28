from kubernetes import client, config 

config.load_kube_config()

v1 = client.CoreV1Api()

pods = v1.list_pod_for_all_namespaces(watch=False)
for pod in pods.items:
    print(f"Pod name: {pod.metadata.name}, Status: {pod.status.phase}")
