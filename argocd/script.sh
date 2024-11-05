

# TO RUN ARGO CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# TO EXPOSE ARGO CD
kubectl port-forward svc/argocd-server -n argocd 8080:443

# TO LOGIN TO ARGO CD
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d



password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argocd login localhost:8080 --username admin --password $password

argocd repo add https://github.com/bilalmab/example-voting-app

argocd app create nginx-via-argo \
  --repo https://github.com/bilalmab/example-voting-app \
  --path nginx-app \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated

argocd app sync nginx-via-argo


argocd app delete nginx-via-argo 