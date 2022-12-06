# Source: https://developer.hashicorp.com/vault/docs/platform/k8s/helm/examples/standalone-tls
if [ -z "$1" ]
  then
    echo "ERROR: Ingress Hostname not provided."
    echo "Example: create-secret.sh vault.exmaple.com"
    exit 1
fi

export SERVICE=vault
export NAMESPACE=vault
export SECRET_NAME=vault-tls
export TMPDIR=/tmp
export CSR_NAME=vault-csr
export INGRESS_HOST=$1

###

echo "Genearting key"
###
openssl genrsa -out ${TMPDIR}/vault.key 2048 > /dev/null 2>&1

echo "Creating CSR file"
###
cat <<EOF >${TMPDIR}/csr.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${SERVICE}
DNS.2 = ${SERVICE}.${NAMESPACE}
DNS.3 = ${SERVICE}.${NAMESPACE}.svc
DNS.4 = ${SERVICE}.${NAMESPACE}.svc.cluster.local
DNS.5 = ${INGRESS_HOST}
IP.1 = 127.0.0.1
EOF
openssl req -new -key ${TMPDIR}/vault.key \
    -subj "/O=system:nodes/CN=system:node:${SERVICE}.${NAMESPACE}.svc" \
    -out ${TMPDIR}/server.csr \
    -config ${TMPDIR}/csr.conf > /dev/null 2>&1

echo "Creating Kubernetes CSR"
###
cat <<EOF >${TMPDIR}/csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${CSR_NAME}
spec:
  groups:
  - system:authenticated
  request: $(cat ${TMPDIR}/server.csr | base64 | tr -d '\r\n')
  signerName: kubernetes.io/kubelet-serving
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
kubectl create -f ${TMPDIR}/csr.yaml

kubectl get csr ${CSR_NAME} > /dev/null 2>&1
if [ $? != 0 ]
then
  echo "FAIL: CSR not created" >&2
  exit 1
fi

echo "Approving CSR"
###
kubectl certificate approve ${CSR_NAME}

echo "Creating secrets for server and ingress"
###

serverCert=$(kubectl get csr ${CSR_NAME} -o jsonpath='{.status.certificate}')

echo "${serverCert}" | openssl base64 -d -A -out ${TMPDIR}/vault.crt

kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > ${TMPDIR}/vault.ca

kubectl create namespace ${NAMESPACE} > /dev/null 2>&1

kubectl -n ${NAMESPACE} create secret generic ${SECRET_NAME}-server \
    --from-file=vault.key=${TMPDIR}/vault.key \
    --from-file=vault.crt=${TMPDIR}/vault.crt \
    --from-file=vault.ca=${TMPDIR}/vault.ca > /dev/null 2>&1

kubectl -n ${NAMESPACE} create secret tls ${SECRET_NAME}-ingress \
  --cert=${TMPDIR}/vault.crt \
  --key=${TMPDIR}/vault.key

kubectl -n $NAMESPACE get secrets

echo "Cleaning"
###
kubectl delete csr ${CSR_NAME}
rm -f ${TMPDIR}/vault.{key,crt,ca}
rm -f ${TMPDIR}/{server.csr,csr.conf,csr.yaml}