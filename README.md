# Project


## Deployment

dependencies for encrypting/decrypting service account secrets used in travis containers:
*travis gem*
gem install travis -v 1.8.10
thus we need ruby but we can just use a ruby container on local machine to encrypt the json file.


dependencies for ingress and https setup: 
*helm*
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install my-nginx stable/nginx-ingress --set rbac.create=true 
 

*cert manager github.com/jetstack/cert-manager*
check for updates https://cert-manager.io/docs/installation/kubernetes/


kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml

kubectl create namespace cert-manager

helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install \
  cert-manager \
  --namespace cert-manager \
  --version v0.11.0 \
  jetstack/cert-manager

