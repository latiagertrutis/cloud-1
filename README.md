# Cloud-1

Automatic deploy of the inception project.

## Getting started

This project consists mainly in two parts: first a Terraform configuration which will automatically create any number of specified droplets (check `./config/terraform.tfvars`), then an Ansible script that will automatically configure, deploy and run the inception project (mariadb, wordpress and nginx).

In order to wrap both functionalities in one single executable, the `launcher` script has been created:
```
$ ./launcher -h
Usage: ./launcher OPTION
Cloud-1 server configuration.

  -f, --force-build          Rebuild images ignoring caches
  -d, --deploy               Deploy server with Terraform
  -c, --configure            Configure deployed server with Ansible
      --configure-role=ROLE  Configure a specific service
  -r  --rm                   Remove deployed server
      --ssh-key              Path to ssh key private file to use (default: /home/mateo/.ssh/terraform_key)
      --ssh-pubkey           Path to ssh key public file to use (default: /home/mateo/.ssh/terraform_key.pub)
  -v, --verbose              Set logs in verbose mode
  -h, --help                 Print this message
  ```
  
By default `launcher` will first run Terraform to provision the machines, and next Ansible in order to configure them. You can run both parts separately by calling `launcher -d` to only run Terraform. Or `launcher -c` to only run the Ansible bit.

Four files are needed in order to be able to launch:
* `.env`: The environment variables needed for inspection.
* `key.pem` and `cert.pem`: The ssl key and certificate in order to run https.
* `terraform.vars`: Terraform authentication and configuration parameters.

All this files must be placed in `.config` directory and the `launcher` script will automatically copy them in their correspondent directories.

## Terraform docs
An example of an expected variable configuration for Terraform can be found in `terraform/terraform.tfvars.example`.

- **do_token**: DigitalOcean token, needed by terraform for DO API communication.
- **pvt_key**: Path to the SSH private key file. By default its value is `/tmp/.ssh/terraform_key` and should not be modified since the `launcher` script will automatically mount in this location the keys provided with the parameters `--ssh-pubkey` and `--ssh-key`.
- **ssh_key_name**: Name of the SSH public key uploaded to DO, will be used for droplet comm.
- **droplet_count**: Number of dropletes to be instanciated

To use terraform in playground mode:
```bash
docker run -it --entrypoint sh -v .:/opt/app terraform_node
```

Then, inside, you can check out the actual state of a machine with the following command.
```bash
terraform show state 'digitalocean_droplet.cloud-1'
```

To force a resource to be reapplied, first you must taint it then reapply.
```bash
terraform taint 'local_resource.name'
terraform apply -target 'local_resource.name'
```
