#!/bin/bash
set -xe

ssh-keygen -q -t rsa -N '' -f ./generated_keys || true

if [ ! -d ".venv" ]; then
    python -m venv .venv
    source ./.venv/bin/activate
    pip install ansible
else
    source ./.venv/bin/activate
fi

ROLES_DIR=roles
mkdir -pv $ROLES_DIR
ansible-galaxy role init postgres --init-path $ROLES_DIR
ansible-galaxy role init nginx --init-path $ROLES_DIR
ansible-galaxy role init php --init-path $ROLES_DIR
ansible-galaxy role init phpmyadmin --init-path $ROLES_DIR

find roles -name "README.md" -type f -delete