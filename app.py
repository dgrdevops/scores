from flask import Flask, jsonify
from kubernetes import client, config

app = Flask(__name__)

@app.route('/welcome', methods=['GET'])
def welcome():
    return "Welcome to 365Scores EKS Cluster!"

@app.route('/kube-system-pods', methods=['GET'])
def kube_system_pods():
    config.load_incluster_config()
    v1 = client.CoreV1Api()
    pods = v1.list_namespaced_pod(namespace="kube-system")
    pod_names = [pod.metadata.name for pod in pods.items]
    return jsonify({"kube-system pods": pod_names})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)