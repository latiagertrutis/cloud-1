# Ansible useful commands:

To build the control node:

```
ansible-builder build --tag <container-name> --container-runtime docker
```

> IMPORTANT: use docker backend

To run the controler node with the navigator:

```
ansible-navigator run ./playbook.yml -i ./inventory.yml --ce docker --execution-environment-image <container-name> --mode stdout --pull-policy missing --container-options='<test-network>' --container-options='--user=0'
```

Notice:
* `pull-policy` missing to only pull if the container does not exist.
* `--container-options='<test-network>'`to have acces to the test containers in you host machine.
* A separated `--container-options='--user=0'`to specify user.
