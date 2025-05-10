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

## Useful links
Docker container management with Ansible
- https://medium.com/@Oskarr3/docker-containers-with-ansible-89e98dacd1e2

How to use Terraform with DigitalOcean
- https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean


## Set environment variables for a command, a good way

Load variables from a .env
```
- name: Load .env as a fact
  set_fact:
    env_vars: "{{ lookup('ini', role_path + '/.env') }}"
```

or one by one
```
environment:
  APP_ENV: "{{ lookup('ini', 'APP_ENV file=' + role_path + '/.env') }}"
```

Then use the fact to set the environment variables in the command
```
- name: Use env vars in a command
  command: ./run-app.sh
  environment:
    APP_ENV: "{{ env_vars.APP_ENV }}"
    DB_HOST: "{{ env_vars.DB_HOST }}"
```

## Terraform docs
An example of an expected variable configuration for Terraform can be found in `terraform/terraform.tfvars.example`.

- **do_token**: DigitalOcean token, needed by terraform for DO API communication.
- **pvt_key**: Path to the SSH private key file, must be mounted in some way into the terraform container.
- **ssh_key_name**: Name of the SSH public key uploaded to DO, will be used for droplet comm.


