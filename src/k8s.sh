# Print command before exec
function kubectl_alias() {
	echo "+ kubectl $@"
	command kubectl $@
}

# Setup kubectl completion
source <(kubectl completion bash)

# Add completion
function add_completion() {
	local complete_cmd=$1
	local shell_cmd=$2

	if [[ $(type -t compopt) == "builtin" ]]; then
		complete -o default -F $complete_cmd $shell_cmd
	else
		complete -o default -o nospace -F $complete_cmd $shell_cmd
	fi
}

# Complete for deployments
## kubectl doesn't include completion for just deployments so creating one
function kubectl_complete_deployments() {
	__kubectl_parse_get "deployment"
}

# Aliases that need completion

## Shortcut
alias k='kubectl'
add_completion __start_kubectl k

## Switch context
alias kc='kubectl_alias config use-context'
add_completion __kubectl_config_get_contexts kc

## Get pod image
alias kimg='kubectl_alias get pods -o "custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.status.hostIP,IMAGE:.spec.containers[*].image"'
add_completion __kubectl_get_resource_pod kimg

## Get deployment image
alias kdimg='kubectl get deployment -o "custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.status.hostIP,IMAGE:.spec.template.spec.containers[*].image"'
add_completion kubectl_complete_deployments kdimg

## Kicks off a rolling restart
## For annotation, $K8S_DOMAIN in .src/local.sh or defaults to "krestart"
alias krestart='kubectl_alias patch -p  "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"${K8S_DOMAIN:-krestart}/date\":\"$(date +'%s')\"}}}}}"'
add_completion kubectl_complete_deployments krestart

# Aliases that do not need completion

## List contexts
alias kcl='kubectl_alias config get-contexts'

## List pods in a namespace
alias kpods='kubectl_alias get pods -o wide'

## List all pods
alias kallpods='kubectl_alias get pods -o wide --all-namespaces'
