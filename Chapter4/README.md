# Azure Container Instances: Serverless Containers

En 2017, Azure introdujo el servicio **Azure Container Instances (ACI)** como parte de la tendencia serverless. Este servicio se utiliza ampliamente en diversas arquitecturas modernas.

## Introducción a Azure Container Instances

Azure Container Instances (ACI) es una solución diseñada para aplicaciones cloud-native, ofreciendo la capacidad de ejecutar contenedores de forma aislada y segura. Al usar ACI, no necesitas preocuparte por la gestión del hardware, sistema operativo, parches, entre otros aspectos de la infraestructura subyacente. 

**Características principales:**
- Compatible con contenedores Linux y Windows.
- Integración con diversos servicios de Azure.
- Uso de comandos Docker CLI como `docker run` para desplegar contenedores en ACI.

## Infraestructura

Crear un ACI, significa crear un "**Container Group**" (grupo de contenedores). Estos grupos funcionan de manera similar a los pods en Kubernetes. Los contenedores dentro de un grupo comparten:
- **Red**
- **Almacenamiento**
- **Espacios de nombres (namespaces)**

Los contenedores dentro de un mismo grupo pueden comunicarse entre sí y comparten la misma máquina virtual.

### Ejemplo de Container Group

![Ejemplo de Container Group](image.png)

### Recursos en la Máquina Virtual

Los recursos de la máquina virtual donde corren los contenedores tienen límites predefinidos según la región. En general:
- Máximo: **4 vCPU** y **16 GB de memoria RAM**.
- Los contenedores deben respetar estos límites.

**Buenas prácticas:**
- Define *request* y *limits* para cada contenedor, facilitando la convivencia sin conflictos de recursos.
- Deja un margen de recursos en la máquina virtual para evitar saturaciones.

### Ejemplo:
Si creas dos contenedores con un request de 1 vCPU y 3 GB de memoria cada uno, la máquina virtual asignará 2 vCPU y 6 GB de memoria, y pagarás únicamente por estos recursos.

## Networking

### Endpoints Públicos y Privados
Por defecto, ACI expone endpoints públicos para acceder al contenedor. Sin embargo, es posible integrarlo con una VNET de Azure para hacerlo privado, mejorando la comunicación interna entre servicios en Azure.

#### Ejemplo de uso:
En una aplicación con:
- **Frontend**: Web App.
- **Base de datos**: Azure SQL Database.

El backend puede ejecutarse en ACI dentro de una VNET privada para optimizar la comunicación y seguridad.

**Limitación:**
Si un ACI está en una VNET, pierde el acceso al endpoint público. Esto puede resolverse mediante servicios adicionales como:
- Application Gateway.
- Load Balancer HTTP/HTTPS.
- Front Door.

## Integración con Azure Kubernetes Service (AKS)

Un caso común de uso es escalar aplicaciones en picos de carga. Por ejemplo:
- Una aplicación de e-commerce tiene carga moderada la mayor parte del año, pero durante eventos como Navidad, experimenta picos breves e intensos.

Con ACI:
- AKS puede usar ACI como servicio de Kubelet para escalar dinámicamente.
- Una vez que la carga disminuye, Kubernetes reduce automáticamente los recursos.

## Despliegue con YAML

En la carpeta `Chapter4`, encontrarás un archivo llamado `example-ACI-yaml.yml` para desplegar un ACI con dos contenedores utilizando YAML. El comando para desplegarlo es:

```bash
az container create \ 
    --resource-group "rg-containers-aci" \ 
    --file aci.yaml
```

## Pros y Contras de ACI

### Pros
- **Cobro por uso:** Pago por segundos según el uso de CPU y memoria, haciéndolo económico.
- **Velocidad:** Rápido para gestionar y ejecutar imágenes de contenedores.
- **Integración:** Compatible con Logic Apps y VNETs para soluciones privadas.
- **Flexibilidad:** Agrupación de contenedores por grupos, facilitando la estructura de las soluciones.

### Contras
- **Limitaciones de recursos:** Máximo de 4 vCPU y 16 GB por grupo de contenedores.
- **Restricciones de endpoint:** No permite endpoints públicos y privados simultáneamente sin servicios adicionales.
- **Escalado manual:** Requiere pipelines externas para automatizar tareas como escalar y detener grupos de contenedores.


