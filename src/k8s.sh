#!/bin/bash

if hash g$GNU_AWK 2>/dev/null; then
  GNU_AWK='gawk'
else
  GNU_AWK='awk'
fi

# Only if kubectl exists
if hash kubectl 2>/dev/null; then

  # Setup completion
  source <(kubectl completion bash)
  hash stern 2>/dev/null && source <(stern --completion=bash)

  # Add completion
  function add_completion() {
    local shell_cmd
    shell_cmd=$1

    if [[ $(type -t compopt) == "builtin" ]]; then
      complete -o default -F "_complete_alias" "$shell_cmd"
    else
      complete -o default -o nospace -F "_complete_alias" "$shell_cmd"
    fi
  }

  ## Shortcuts
  alias k='kubectl'
  add_completion k

  alias kg='kubectl get'
  add_completion kg

  alias kga='kubectl get --all-namespaces'
  add_completion kga

  alias ky='kubectl get -o yaml'
  add_completion ky

  alias kya='kubectl get --all-namespaces -o yaml'
  add_completion kya

  alias kd='kubectl describe'
  add_completion kd

  alias kda='kubectl describe --all-namespaces'
  add_completion kda

  alias kl='kubectl logs'
  add_completion kl

  alias kla='kubectl logs --all-namespaces'
  add_completion kla

  ## Context
  alias kc='kubectx'
  add_completion kc

  alias kn='kubens'
  add_completion kn

  ### Grep shortcuts
  function __kgrep() {
    if [ "$#" -eq 1 ]; then
      echo >&2 "+${1}"
      eval "$1"
    elif [ "$#" -eq 2 ]; then
      echo >&2 "+${1}"
      eval "$1" | rg "$2"
    else
      return 1
    fi
  }

  function kpods() {
    __kgrep "kubectl get pods" "$1"
  }

  function kall() {
    __kgrep 'kubectl get all,secret,pvc,role,rolebinding,pv,clusterrole,clusterrolebinding --all-namespaces -o custom-columns=":.metadata.namespace,:.kind,:.metadata.name" | column -t' "$@"
  }

  function kimg() {
    __kgrep 'kubectl get pods --all-namespaces -o custom-columns="NAME:.metadata.name,STATUS:.status.phase,NODE:.status.hostIP,IMAGE:.spec.containers[*].image" | column -t' "$@"
  }

  ## Common ops commands

  ### RBAC bindings
  alias krbac="kubectl get rolebindings,clusterrolebindings --all-namespaces -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,GROUPS:subjects[?(@.kind==\"Group\")].name,SERVICE_ACCOUNTS:subjects[?(@.kind==\"ServiceAccount\")].name'"

  ### Bad pods and deployments
  function kbad() {
    kubectl get pods --all-namespaces -o wide | $GNU_AWK '{ if ($1 == "NAMESPACE") { $1="PODS"; } else { $1=$1"/"$2 } }; { split($3, READY, "/"); if (($4 == "Running" && READY[1] != READY[2]) || $4 !~ /Running|Completed/) { print $1,$3,$4,$5,$6,$8}}' | column -t
    echo
    kubectl get deployments --all-namespaces | $GNU_AWK '{  if ($1 == "NAMESPACE") { $1="DEPLOYMENTS"; TARGET="TARGET"; UPDATED="UPDATED"; AVAIL="AVAIL" } else { $1=$1"/"$2; TARGET=$3; split($3,TARGET_A,"/"); UPDATED=$4; AVAIL=$5; }} $1=="DEPLOYMENTS" || !(($TARGET_A[1] == $TARGET_A[2]) && ($UPDATED == $TARGET_A[2]) && ($AVAIL == $TARGET_A[2])) { print $1,TARGET,UPDATED,AVAIL }' | column -t
  }

  ### Decode secret
  function ksecret() {
    local selected_secret_line selected_ns selected_secret selected_data

    if [ "$#" -eq 1 ]; then
      selected_secret_line="$(kubectl get secret --all-namespaces -o go-template -o template='{{ range $i := .items }}{{ range $f,$v := .data }}{{ printf "%s %s %s\n" $i.metadata.namespace $i.metadata.name $f }}{{end}}{{end}}' | column -t | fzf -q "$1")"
    elif [ "$#" -eq 0 ]; then
      selected_secret_line="$(kubectl get secret --all-namespaces -o go-template -o template='{{ range $i := .items }}{{ range $f,$v := .data }}{{ printf "%s %s %s\n" $i.metadata.namespace $i.metadata.name $f }}{{end}}{{end}}' | column -t | fzf)"
    fi

    selected_ns="$($GNU_AWK '{ print $1 }' <<<"$selected_secret_line")"
    selected_secret="$($GNU_AWK '{ print $2 }' <<<"$selected_secret_line")"
    selected_data="$($GNU_AWK '{ print $3 }' <<<"$selected_secret_line")"

    echo "[${selected_ns}/${selected_secret}: ${selected_data}]"
    echo ""
    kubectl get secret -n "$selected_ns" "$selected_secret" -o jsonpath --template="{.data.$(sed 's/\./\\./g' <<<"$selected_data")}" | base64 --decode
  }

fi
