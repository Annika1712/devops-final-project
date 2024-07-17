# Orchestration with Kubernetes

### Installation for testing:

Important: you need Minikube or AWS EKS

In the root directory of the project execute the command:
```
cd kubernetes
```


Then you could create namespaces using the next `kubectl` command:
```
kubectl apply -f .\namespace.yml
```

Next step: deploy Redis:
```
kubectl apply -f .\redis\
```

Next step: deploy MongoDB:
```
kubectl apply -f .\mongodb\
```

Next step: deploy backend application:
```
kubectl apply -f .\backend\
```

Next step: setup value for NEXT_PUBLIC_API_URL in `.\frontend\01_frontend_config_map_secrets.yml`


Next step: deploy frontend application:
```
kubectl apply -f .\frontend\
```

Useful commands:
```
kubectl get --namespace=development pods
kubectl get --namespace=development services
```