Hashicorp Vault Guide


## Install Vault
__Prepare environment__
```
kubectl create namespace vault
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com
helm repo update
```
__Generate TLS secret__
```
bash create-secret.sh vault.example.com
```
__Install Standalone (Docker Desktop/Minikube)__
```
helm upgrade --install vault hashicorp/vault --namespace vault -f values.yml --set dataStorage.size=5Gi --set dataStorage.storageClass=yourStorageClass --set ui.serviceType=NodePort --set server.resources.requests.memory=2Gi --set server.resources.requests.cpu=1000m
```
Access: https://localhost:32200
__Install Cluster (Test/Dev)__
```
helm upgrade --install vault hashicorp/vault --namespace vault -f values.yml --set dataStorage.size=5Gi --set dataStorage.storageClass=yourStorageClass --set ingress.enabled=true --set ingress.tls.hosts={vault.example.com} --set server.resources.requests.memory=2Gi --set server.resources.requests.cpu=1000m --set injector.replicas=(number of nodes) --set ha.enabled=true --set ha.replicas=(number of nodes)
```
__Install Cluster (Prod)__
```
helm upgrade --install vault hashicorp/vault --namespace vault -f values.yml --set dataStorage.size=5Gi --set dataStorage.storageClass=yourStorageClass --set ingress.enabled=true --set ingress.tls.hosts={vault.example.com} --set injector.replicas=(number of nodes) --set ha.enabled=true --set ha.replicas=(number of nodes)
```

helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com
helm upgrade --namespace vault --install vault-secrets-webhook banzaicloud-stable/vault-secrets-webhook --set replicaCount=1

## How Vault works inside Kubernetes
## Install Bank-Vaults Mutating Webhook
## How it works





















helm upgrade --install vault hashicorp/vault --namespace vault -f vault-values.yml --set  server.resources.requests.memory=2Gi --set server.resources.requests.cpu=1000m 

https://banzaicloud.com/blog/inject-secrets-into-pods-vault-revisited/


helm repo add hashicorp https://helm.releases.hashicorp.com

vault operator init
vault operator unseal

cat /vault/secrets/config.txt

https://banzaicloud.com/docs/bank-vaults/mutating-webhook/deploy

https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations
https://banzaicloud.com/docs/bank-vaults/mutating-webhook/annotations
https://developer.hashicorp.com/vault/docs/platform/k8s/helm/configuration