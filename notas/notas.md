# Playbook execution

# Execiton environment
python -m venv .venv
source ./.venv/bin/activate
pip install ansible-navigator ansible-builder

execution-environment-yml:
```yaml
version: 3

images:
  base_image:
    name: quay.io/fedora/fedora:39

dependencies:
  ansible_core:
    package_pip: ansible-core
  ansible_runner:
    package_pip: ansible-runner
  system:
  - openssh-clients
  - sshpass
  galaxy:
    collections:
    - name: community.postgresql
```

Construcción de la imagen:
```bash
ansible-builder build --tag <name> --container-runtime docker
```

Lanzamiento de playbook desde execution context:
```bash
ansible-navigator run test_localhost.yml --execution-environment-image postgresql_ee --mode stdout --pull-policy missing --container-options='--user=0'
```

Lanzamiento de playbook desde ee a nodos remotos:
```bash

```

# Instalación de Ansible
- Nodo de control: se requiere python
- Nodo gestionado: se requiere provisionar con python, ssh un un usuario con una shell interactiva POSIX.

# Configuración de Ansible
La configuración de Ansible reside en un archivo `ansible.cfg`.
Para generar un archivo de configuración:
```bash
ansible-config init --disabled > ansible.cfg
```

# Construcción de inventorios
Se construyen los inventorios desde las `fuentes de inventorios` o inventory sources, donde se incluyen los hosts que referencian los nodos gestionados y sus variables asociadas. Cuando se encuentran definidos, se usan patrones para seleccionar hosts y lanzar las tareas correspondientes.

El inventorio más simple es un único fichero con una lista de hosts y grupos.

El archivo por defecto es `/etc/ansible/hosts`, se puede usar uno customizado con las flags de ejecución `-i <ruta al archivo>` o se puede crear un inventorio dinámico.
Se pueden usar múltiples fuentes.

Formato estándar:
```toml
example.com

[primer grupo]
example-2.com
test.example.com

[segundo grupo]
test2.example.com
```
Las cabeceras son agrupaciones de hosts.
Grupos por default: `all` y `ungrouped`, all contiene todos los hosts, ungrouped los que no están incluídos dentro de un grupo. Los hosts pueden estar en multiples grupos.

Existen las `relaciones padre-hijo`.

Ejecución de un inventorio:
```bash
ansible-playbook <playbook.yml> -i inventory -i inventory-2
```

Se pueden añadir variables de configuración en el inventorio.
```toml
# en toml
[host-group]
example.com http_port=80
[host-group:vars]
maxRequestsPerChild: 800
```
Lista de variables comunes:
- ansible_connection
- ansible_host
- ansible_port (22 por default)
- ansible_user (usuario de logging en host)
- ansible_password
- ansible_ssh_private_key_file
- ansible_ssh_common_args
- ansible_sftp_common_args
- ansible_scp_extra_args
- ansible_ssh_extra_args
- ansible_ssh_pipelining

Para escalado de privilegios:
- ansible_become
- ansible_become_method
- ansible_become_user
- ansible_become_password
- ansible_become_exe
- ansible_become_flags

Para config. de entorno:
- ansible_shell_type
- ansible_python_interpreter
- ansible_*_interpreter
- ansible_shell_executable

# Playbooks
- ansible_pull: los nodos comprueban configuración en un punto central, checkout de un repo con instrucciones de configuración de git, y se ejecuta `ansible-playbook` contra ese contenido.

- ansible-lint: para lintear playbooks.
# Roles

Creación de roles:
```bash
ansible-galaxy init my_role
```

Estructura por defecto de un proyecto de ansible:
```
roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```
Ansible intenta buscar un archivo `main.yml` en cada directorio.
- `tasks/main.yml` son las tareas para un rol.
- `handlers/main.yml` handlers importados para el playbook padre.
- `defaults/main.yml` valores de baja precedencia.
- `vars/main.yml` valores de alta precedencia.
- `files/*` archivos disponibles para rol e hijos.
- `templates/*.j2` templates a usar para los roles hijos.
- `meta/main.yml` metadatos para el rol.

Ningún archivo es requerido para la definición de un rol.
Cómo se ejecutan en cascada todas las tareas de todos los roles, cuando sólo se debería hacer una llamada a un único playbook?
# Handlers

# Defaults

# Templates

# Ansible playbook apt module

## Todoes
- Investigar `ansible-pull`
- Investigar jinga