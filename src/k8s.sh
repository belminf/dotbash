# Print function before running it
function kubectl_alias() {
	echo "+ kubectl $@"
	command kubectl $@
}

# Simple aliases (no need to use kubect_alias)
alias k='kubectl'
alias kg='kubectl get'

# Aliases I want more verbsoe

## Switch context
alias kc='kubectl_alias config use-context'

## List contexts
alias kcl='kubectl_alias config get-contexts'

## List pods in a namespace
alias kpods='kubectl_alias get pods -o wide'

## List all pods
alias kallpods='kubectl_alias get pods -o wide --all-namespaces'

## Get container image
alias kimg='kubectl_alias get pods -o "custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.status.hostIP,IMAGE:.spec.containers[*].image"'

## Kicks off a rolling restart
## For annotation, $K8S_DOMAIN in .src/local.sh or defaults to "krestart"
alias krestart='kubectl_alias patch -p  "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"${K8S_DOMAIN:-krestart}/date\":\"$(date +'%s')\"}}}}}"'
