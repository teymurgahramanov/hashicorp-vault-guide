Hashicorp Vault Guide

```
openssl req -x509 -newkey rsa:2048 -keyout k8s-vault-key.pem -out k8s-vault-cert.pem -sha256 -days 365 -subj /CN=*.vault.svc.cluster.local,*.vault -nodes
```
```
kubectl -n vault create secret tls vault-tls --key="k8s-vault-key.pem" --cert="k8s-vault-cert.pem"
```

helm upgrade --install vault hashicorp/vault --namespace vault -f vault-values.yml --set  server.resources.requests.memory=2Gi --set server.resources.requests.cpu=1000m 

https://developer.hashicorp.com/vault/docs/platform/k8s/helm/examples/standalone-tls
https://banzaicloud.com/blog/inject-secrets-into-pods-vault-revisited/


helm repo add hashicorp https://helm.releases.hashicorp.com

vault operator init
vault operator unseal

cat /vault/secrets/config.txt

https://banzaicloud.com/docs/bank-vaults/mutating-webhook/deploy

https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations
https://banzaicloud.com/docs/bank-vaults/mutating-webhook/annotations