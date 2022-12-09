Hashicorp Vault Guide


## Install Vault and Bank Vaults
__Prepare environment__
```
kubectl create namespace vault
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com
helm repo update
```
__Generate TLS Secrets__
```
bash create-secret.sh vault.example.com
```
__Install__
```
helm upgrade --install vault hashicorp/vault --namespace vault -f values.yml
helm upgrade --install vault-secrets-webhook banzaicloud-stable/vault-secrets-webhook --namespace vault
```

## How Vault works inside Kubernetes
## How it works

vault audit enable file file_path=stdoute



















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


vault write auth/ldap/config \
	url="ldap://ldap.example.com" \
	discoverdn=true \
	userattr=sAMAccountName \
	userdn="OU=IT,OU=CBAR,DC=example,DC=com" \
	groupdn="OU=IT,OU=CBAR,DC=example,DC=com" \
	groupfilter="(&(objectClass=person)(uid={{.Username}}))" \
	groupattr="memberOf" \
	deny_null_bind=true