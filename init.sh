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
