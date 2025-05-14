#!/bin/bash
set -e

print_usage() {
  echo "Usage: ./init.sh OPTION
Cloud-1 server configuration.

  -f, --force-build          Rebuild images ignoring caches
  -d, --deploy               Deploy server with Terraform
  -c, --configure            Configure deployed server with Ansible
      --configure-role=ROLE  Configure a specific service
      --rm                   Remove deployed server
  -v, --verbose              Set logs in verbose mode
  -h, --help                 Print this message"
}

TERR_NODE=terraform_node
ANS_NODE=ansible_node

setup_terraform_image() {
  if [ ! -z ${NOCACHE+x} ] || ! docker images | grep -q $TERR_NODE; then
    docker build -f environment/Dockerfile . -t $TERR_NODE $NOCACHE
  fi
}

setup_ansible_image() {
  if [ ! -z ${NOCACHE+x} ] || ! docker images | grep -q $ANS_NODE; then
    docker build . -t $ANS_NODE $NOCACHE
  fi
}

DEPLOY=1 CONFIG=1
for arg in "$@"; do
  case "$arg" in
    -f|--force-build) NOCACHE=--no-cache ;;
    -d|--deploy)      DEPLOY=1 CONFIG=0 ;;
    -c|--configure)   DEPLOY=0 CONFIG=1  ;;
    --configure-role=*) 
      CONFIG=1
      ANSIBLE_ROLE=${arg##*=}
      ;;
    --rm) DEPLOY=0 CONFIG=0 RM=1 ;;
    -v|--verbose)     
      if command -v cowsay >/dev/null; then
        VERBOSE=1
      fi 
      ;;
    -h|--help)
      print_usage; exit 0 
      ;;
    *) 
      echo "Unknown argument: $arg" >&2
      print_usage >&2; exit 1 
      ;;
  esac
done

if [ ! -z ${VERBOSE+x} ]; then
  echo() {
    builtin echo $@ | cowsay
  }
fi

if [ ! -z ${RM+x} ] && [ ${DEPLOY} -ne 0 ]; then
  echo "Incompatible flags: --deploy, --rm" >&2
  print_usage >&2
  exit 1
fi

if [ ! -z ${RM+x} ] && [ ${CONFIG} -ne 0 ]; then
  echo "Incompatible flags: --configure, --rm" >&2
  print_usage >&2
  exit 1
fi

if [ ! -z ${RM+x} ]; then
  docker run --rm $TERR_NODE terraform apply \
    --destroy \
    --auto-approve \
    --var-file=terraform.tfvars
  exit 0
fi

if [ ${DEPLOY} -ne 0 ]; then
  if [ ! -f "terraform/terraform.tfvars" ]; then
    echo "[ Error ] tfvars file not provided, exiting..." >&2
    exit 1
  fi
  setup_terraform_image
  docker run -v ./terraform:/opt/terraform $TERR_NODE plan \
    --var-file=terraform.tfvars \
    --input=false
  docker run -v ./terraform:/opt/terraform $TERR_NODE apply \
    --auto-approve \
    --var-file=terraform.tfvars
fi

if [ ${CONFIG} -ne 0 ]; then
  setup_ansible_image
  docker run $ANS_NODE ansible-playbook \
    -i inventory \
    cloud1.playbook.yml \
    $ANSIBLE_ROLE
  exit 0
fi
