# Apuntes Terraform

- Containerización de terraform.

## Sintaxis

La sintaxis de la configuración de Terraform se separa en dos partes: la sintaxis nativa de Terraform y la configuración en JSON.

La sintaxis nativa se llama **HCL**. Sus dos componentes clave son los **argumentos** y **bloques**.

Los argumentos son básicos, asignación de un valor a un nombre.
Cada tipo de recurso tiene un esquema que define el tipo de sus argumentos.

Un bloque es un contenedor de otro contenido.
El bloque tiene un tipo, y este tipo define qué tipo de `labels` proceden tras éste.

```hcl
resource "aws_instance" "example" {
  ami = "abc123"

  network_interface {
    # ...
  }
}
```
- resource: tipo de bloque
- aws_instance: específica del proveedor
- example: nombre arbitrario de la instancia del recurso.

### Resources
Un bloque de resource describe un objeto de infraestructura (redes virtuales, instancias de computación, DNS...). 
#### Resource blocks
Declara un recurso de un tipo específico, con un nombre local y argumentos especiales propios del tipo de recurso.

Los **providers** son plugins de Terraform que ofrecen una lista de tipos de recursos. Estos tipos están implementados por el proveedor. Normalmente usados para gestionar plataformas de infraestructura en cloud u on-premise.
Los providers son externos a Terraform pero pueden ser instalados automáticamente por éste.

Para gestionar recursos, debe existir un módulo de Terraform que especifique los providers requeridos.

Los proveedores necesitan configuración para acceder a la API remota.

La mayoría de los argumentos en el cuerpo del recurso son específicos al recurso seleccionado.
Los meta-argumentos son definidos por Terraform y son aceptados en cualquier tipo de recurso.

- depends_on
- count
- for_each
- provider
- lifecycle
- provisioner

La información sobre los recursos y sus configuraciones se encuentra en Terraform Registry.

Para eliminar un recurso, se elimina de la configuración y Terraform encola la destrucción en la siguiente aplicación.
Para eliminar el recurso de la configuración sin destruirlo, se usa el meta-parámetro `lifecycle` en un block llamado `removed`.

```hcl
removed {
    from = aws_instance.example

    lifecycle {
        destroy = false
    }

    provisioner "local-exec" {
        when = destroy
        command = "echo 'Removed instance ${self.id}'"
    }
}
```

Los **checks de condiciones** son `precondition` y `postcondition`, bloques con variables condition y error_message.

```
resource "aws_instance" "example" {
    instance_type = "t2.micro"
    ami           = "ami-abc123"

    lifecycle {
        preconditions {
            condition = data.aws_ami.example.architecture == "x86_64"
            error_message = "Selected AMI must be for teh x86_64 arch. "
        }
    }
}
```

Algunos recursos dan la opción de declarar `timeouts`. La configuración de estos timeouts es a su vez parte de la API del provider.

```hcl
resource "..." ".." {
    timeouts {
        create = "60m"
        delete = "2h"
    }
}
```

#### Comportamiento del recurso
Los recursos se construyen, actualizan y destruyen en la aplicación de la configuración por Terraform.
Al aplicar una nueva infraestructura representada por un recurso, su identificador se almacena en el `state` de Terraform. Si el recurso ya existe, Terraform compara este nuevo state con el ta almacenado, aplicando la diferencia si la hubiese.

El **acceso a atributos del recurso** se realiza con expresiones dentro del módulo en el formato `<RESOURCE TYPE>.<NAME>.<ATTRIBUTE>`. Se pueden usar atributos en modo lectura provistos por la API que hacen referencia a información del recurso remoto.

##### Dependencias entre recursos
Suelen gestionarse automáticamente, tras análisis de las expresiones dentro de un recurso.

Para gestiones manuales de dependencias, `depends_on`.
Ejemplos de recursos locales:
- Generación de claves privadas.
- Certificados TLS autofirmados.
- Generación de ids aleatorios.

### Data sources

### Providers
Terraform instala los providers declarados en la configuración en la ejecución (terraform run). También 
como parte del flujo de inicialización de un directorio de trabajo.
Tres tipos de providers, oficiales, partners y comunidad.
Metaargumentos provistos por Terraform para todos los providersÑ `alias` y `version`, para declarar distintas configuraciones del mismo proveedor y para versionar el proveedor respectivamente.

```hcl
# Proveedor por default, referencia como aws
provider "aws" {
    region = "us-east-1"
}

# Proveedor con alias, referencia como aws.west
provider "aws" {
    alias = "west"
    region = "us-west-2"
}
```

#### required_providers
Cada modulo de Terraform debe declarar los providers que van a usar, esto se hace en el bloque `required_providers`, dentro del bloque terraform.
Las claves son `source` y `version`.

```
terraform {
  required_providers {
    mycloud = {
      source  = "mycorp/mycloud"
      version = "~> 1.0"
    }
  }
}
```

- on_premise
- registries
- concepto sensitive
- initializing a working directory
- netrc
- required_providers
- terraform lock hcl