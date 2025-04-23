KUBECONFIG ?= $(HOME)/.kube/config

.PHONY: bootstrap destroy pf-argocd argo-bootstrap

bootstrap: ## Install ingress + baseline namespaces
	helm upgrade --install traefik traefik/traefik \
		--namespace traefik --create-namespace \
		-f cluster/bootstrap/traefik-values.yaml
	kubectl apply -f cluster/bootstrap/namespaces.yaml

argo-bootstrap: ## Install/Upgrade Argo CD
	helm upgrade --install argocd argo/argo-cd \
		--namespace argocd --create-namespace \
		--version 7.8.27 \
		-f cluster/bootstrap/argocd-values.yaml
	kubectl apply -f gitops/applications/root/root.yaml

destroy: ## Remove everything created in bootstrap
	-helm uninstall traefik -n traefik || true
	-kubectl delete ns traefik argocd hello --ignore-not-found

pf-argocd:
	kubectl -n argocd port-forward \
		$$(kubectl -n argocd get pods -l app.kubernetes.io/name=argocd-server \
			-o name | head -n1) 8082:8080
