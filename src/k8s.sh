# Print command before exec
function kubectl_alias() {
	echo "+ kubectl $@"
	command kubectl $@
}

# Aliases that need completion

## Shortcut
alias k='kubectl'

## Get
alias kg='kubectl get'

## Switch context
alias kc='kubectl_alias config use-context'

## Get pod image
alias kimg='kubectl_alias get pods -o "custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.status.hostIP,IMAGE:.spec.containers[*].image"'

## Get deployment image
alias kdimg='kubectl get deployment -o "custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.status.hostIP,IMAGE:.spec.template.spec.containers[*].image"'

## Kicks off a rolling restart
## For annotation, $K8S_DOMAIN in .src/local.sh or defaults to "krestart"
alias krestart='kubectl_alias patch -p  "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"${K8S_DOMAIN:-krestart}/date\":\"$(date +'%s')\"}}}}}"'

# Auto completion set up
source <(kubectl completion bash)

## kubectl doesn't include completion for just deployments so creating one
__kubectl_get_resource_deployment() {
	__kubectl_parse_get "deployment"
}

if [[ $(type -t compopt) == "builtin" ]]; then
	complete -o default -F __start_kubectl k
	complete -o default -F __kubectl_get_resource kg
	complete -o default -F __kubectl_config_get_contexts kc
	complete -o default -F __kubectl_get_resource_pod kimg
	complete -o default -F __kubectl_get_resource_deployment kdimg
	complete -o default -F __kubectl_get_resource_deployment krestart
else
	complete -o default -o nospace -F __start_kubectl k
	complete -o default -o nospace -F __kubectl_get_resource kg
	complete -o default -o nospace -F __kubectl_config_get_contexts kc
	complete -o default -o nospace -F __kubectl_get_resource_pod kimg
	complete -o default -o nospace -F __kubectl_get_resource_deployment kdimg
	complete -o default -o nospace -F __kubectl_get_resource_deployment krestart
fi

# Aliases that do not need completion

## List contexts
alias kcl='kubectl_alias config get-contexts'

## List pods in a namespace
alias kpods='kubectl_alias get pods -o wide'

## List all pods
alias kallpods='kubectl_alias get pods -o wide --all-namespaces'
