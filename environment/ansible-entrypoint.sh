#!/bin/sh

ANSIBLE_PLAYBOOK="ansible-playbook"

usage() {
    echo "Usage: $0 [-b] [-d]"
    echo ""
    echo "Options:"
    echo "  -b    Run the bootstrap playbook"
    echo "  -d    Run the deploy playbook"
    echo "  -h    Print this help"
    echo ""
    echo "If no options are provided, both bootstrap and deploy are executed by default."
    exit 0
}

while getopts "bdt:" name; do
    case $name in
	b) bootstrap=1 ;;
	d) deploy=1 ;;
	t) tags="$OPTARG" ;;
	?) usage ;;
    esac
done

if [ -z ${bootstrap+x} ] && [ -z ${deploy+x} ]; then
    bootstrap=1
    deploy=1
fi

if [ ! -z ${bootstrap+x} ]; then
    echo "Starting Bootstrap..."
    $ANSIBLE_PLAYBOOK -i inventory/bootstrap.yml bootstrap.yml
fi

if [ ! -z ${deploy+x} ]; then
    echo "Starting Deploy..."
    $ANSIBLE_PLAYBOOK -i inventory/inventory.yml playbook.yml ${tags:+--tags "$tags"}
fi
