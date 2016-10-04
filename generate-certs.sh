#!/bin/bash

source ./env

rm -rf ./certs/
mkdir certs

echo "Create a Cluster Root CA"

openssl genrsa -out ./certs/ca-key.pem 2048
openssl req -x509 -new -nodes -key ./certs/ca-key.pem -days 10000 -out ./certs/ca.pem -subj "/CN=kube-ca"

for (( i=0; i<$master_count; i++ ))
do
  echo "---Kubernetes API Server Keypair---"
  echo "Create api server OpenSSL config"

cat << EOF > ./certs/${master_fqdns[i]}-api-openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = ${K8S_SERVICE_IP}
IP.2 = ${master_ips[i]}
EOF

  echo "Generate the API Server Keypair"
  openssl genrsa -out ./certs/${master_fqdns[i]}-apiserver-key.pem 2048
  openssl req -new -key ./certs/${master_fqdns[i]}-apiserver-key.pem -out ./certs/${master_fqdns[i]}-apiserver.csr -subj "/CN=kube-apiserver" -config ./certs/${master_fqdns[i]}-api-openssl.cnf
  openssl x509 -req -in ./certs/${master_fqdns[i]}-apiserver.csr -CA ./certs/ca.pem -CAkey ./certs/ca-key.pem -CAcreateserial -out ./certs/${master_fqdns[i]}-apiserver.pem -days 365 -extensions v3_req -extfile ./certs/${master_fqdns[i]}-api-openssl.cnf

done

echo "Generate the Cluster Administrator Keypair"
openssl genrsa -out ./certs/admin-key.pem 2048
openssl req -new -key ./certs/admin-key.pem -out ./certs/admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in ./certs/admin.csr -CA ./certs/ca.pem -CAkey ./certs/ca-key.pem -CAcreateserial -out ./certs/admin.pem -days 365

echo "---Kubernetes Workers Keypairs---"
for (( i=0; i<$worker_count; i++ ))
do
  echo "Create ${worker_fqdns[i]} OpenSSL config"

cat << EOF > ./certs/${worker_fqdns[i]}-openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = ${worker_ips[i]}
EOF

  echo "Generate the Kubernetes ${worker_fqdns[i]} Worker Keypairs"
  openssl genrsa -out ./certs/${worker_fqdns[i]}-worker-key.pem 2048
  openssl req -new -key ./certs/${worker_fqdns[i]}-worker-key.pem -out ./certs/${worker_fqdns[i]}-worker.csr -subj "/CN=${worker_fqdns[i]}" -config ./certs/${worker_fqdns[i]}-openssl.cnf
  openssl x509 -req -in ./certs/${worker_fqdns[i]}-worker.csr -CA ./certs/ca.pem -CAkey ./certs/ca-key.pem -CAcreateserial -out ./certs/${worker_fqdns[i]}-worker.pem -days 365 -extensions v3_req -extfile ./certs/${worker_fqdns[i]}-openssl.cnf
done
