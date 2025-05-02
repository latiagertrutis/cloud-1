#!/bin/bash
set -e

#ssh-keygen -q -t rsa -N '' -f ./generated_keys || true

print_usage() {
  echo "Usage: ./init.sh OPTION
Cloud-1 server configuration.

  -f, --force-build          Rebuild images ignoring caches
  -d, --deploy               Deploy server with Terraform
  -c, --configure            Configure deployed server with Ansible
      --configure-role=ROLE  Configure a specific service
      --rm                   Remove deployed server
  -a, --all                  Deploy and configure server
  -h, --help                 Print this message"
}

TERR_NODE=terraform_node
ANS_NODE=ansible_node

setup_terraform_image() {
  if [ ! -z ${NOCACHE+x} ] || docker images | grep $TERR_NODE >/dev/null; then
    docker build -f terraform/Dockerfile ./terraform -t $TERR_NODE $NOCACHE
  fi
}

setup_ansible_image() {
  if [ ! -z ${NOCACHE+x} ] || docker images | grep $ANS_NODE >/dev/null; then
    docker build . -t $ANS_NODE $NOCACHE
  fi
}

for arg in "$@"; do
  case "$arg" in
    -f|--force-build) NOCACHE=--no-cache ;;
    -d|--deploy)      DEPLOY=1 ;;
    -c|--configure)   CONFIG=1 ;;
    --configure-role=*) 
      CONFIG=1
      ANSIBLE_ROLE=${arg##*=}
      ;;
    --rm)             RM=1 ;;
    -a|--all)         DEPLOY=1;CONFIG=1 ;;
    -h|--help)
      print_usage; exit 0 
      ;;
    *) 
      echo "Unknown argument: $arg" >&2
      print_usage >&2; exit 1 
      ;;
  esac
done

if [ ! -z ${RM+x} ] && [ ! -z ${DEPLOY+x} ]; then
  echo "Incompatible flags: --deploy, --rm" >&2
  print_usage >&2
  exit 1
fi

if [ ! -z ${RM+x} ] && [ ! -z ${CONFIG+x} ]; then
  echo "Incompatible flags: --configure, --rm" >&2
  print_usage >&2
  exit 1
fi

if [ ! -z ${DEPLOY+x} ]; then
  if [ ! -f "terraform/.tfvars" ]; then
    echo "[ Error ] tfvars file not provided, exiting..."
    exit 1
  fi
  setup_terraform_image
  docker run $TERR_NODE terraform plan \
    --var-file=.tfvars \
    --input=false
  docker run $TERR_NODE terraform apply \
    --auto-approve \
    --var-file=.tfvars
fi

if [ ! -z ${CONFIG+x} ]; then
  setup_ansible_image
  docker run $ANS_NODE ansible-playbook \
    -i inventory \
    cloud1.playbook.yml \
    $ANSIBLE_ROLE
  exit 0
fi

if [ ! -z ${RM+x} ]; then
  docker run --rm $TERR_NODE terraform apply \
    --destroy \
    --auto-approve \
    --var-file=.tfvars
fi