Hashicorp Vault Guide


## Install Vault
Generate secret for enabling TLS
```
bash create-secret.sh
```

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