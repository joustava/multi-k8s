# This will be executed in the context of Travis.
# docker and gcloud are already configured and authenticated.

# Build and Tag docker images.
# See, e.g: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide
# for why we this is one good way to do it.
docker build -t joustava/multi-client:latest \
             -t joustava/multi-client:$SHA \
            -f ./client/Dockerfile ./client/

docker build -t joustava/multi-server:latest \
             -t joustava/multi-server:$SHA \
             -f ./server/Dockerfile ./server/

docker build -t joustava/multi-worker:latest \
             -t joustava/multi-worker:$SHA \
             -f ./worker/Dockerfile ./worker/

# Push latest images to Docker Hub.
docker push joustava/multi-client:latest
docker push joustava/multi-server:latest
docker push joustava/multi-worker:latest

# Tag git rev'd images to Docker Hub as well.
docker push joustava/multi-client:$SHA
docker push joustava/multi-server:$SHA
docker push joustava/multi-worker:$SHA

# Apply Kubernetes config (kubectl/gcloud)
kubectl apply -f k8s

# Our images in deployment configuration always use latest.
# We do it like so to make Kubernetes aware of the update without having to rewrite/edit the deployment yaml files in any way.
kubectl set image deployments/server-deployment server=joustava/multi-server:$SHA
kubectl set image deployments/client-deployment server=joustava/multi-client:$SHA
kubectl set image deployments/worker-deployment server=joustava/multi-worker:$SHA

