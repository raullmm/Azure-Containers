# Azure Kubernetes Service for Kubernetes in the Cloud

Hablando de Kubernetes podemos decir que es un servicio portable y open source ganador entre su competencia que acogieron los proveedores de nube para integrarlo en un servicio. AKS en el caso de Azure es el servicio que emplea Kubernetes para tu manejo de contenedores y orquestador de tus flujos de trabajo con estos. 

Cuando utilizas el servicio de AKS creas un cluster de Kubernetes, este cluster no es global, se creará en la región que selecciones, tiene dos partes significativas: el control plane (manejado por Azure) y la parte de los nodos.

## Control Plane

Vamos a describir un poco los objetos dentro del control plane, que de nuevo, son manejados en su mayoría por Azure (Puedes llegar a controlar estos objetos e interactuar con la API del cluster además de monitorear los logs del control plane en Azure Monitor, pero recurrirá en costes, puedes hacerlo mediante una storage account en Diagnostic Tools):

1. **ETCD** --> La base de datos que funciona como key=value, contiene todos los objetos, logs e información de todos los objetos desplegados en el cluster. 
2. **API-Server** --> La API del cluster, esta proporciona una herramienta llamada `kubectl` para interactuar externamente con ella.
3. **Kube-Scheduler** --> El encargado de ajustar el flujo de trabajo del cluster según qué nodo esté disponible en base a los recursos que este tenga.
4. **kube-controller-manager** --> El manejador de pequeños controladores varios que hay en el cluster.

## Node y Nodepools

En Azure estos son al final Virtual Machine Scale Sets, los componentes de los nodos suelen ser tres:

1. **Kube-Proxy** --> El encargado de manejar el tráfico y las redes internas de Kubernetes, redireccionar las peticiones, paquetes, etc.
2. **Kubelet** --> Es el soldado del kube-scheduler y se encarga de decidir en qué nodos correrán tus aplicaciones.
3. **Container Runtime** --> Es utilizado Docker para correr los contenedores que hay dentro de los Pods.

Dentro de este concepto de Nodo, tenemos diferentes tipos de nodos, depende de qué función necesites, servirán para una cosa u otra. En Azure los tipos son dos:

### System Nodepool

El encargado de tener todos los system pods necesarios para correr los componentes de los nodos y del control plane. Se suele utilizar solo para correr estos contenedores nada más. Algunas de sus características serían:
1. Solo puede correr Linux.
2. Cada nodo de system necesita 2 CPU y 4 GB de memoria como mínimo para correr.
3. Las máquinas en SPOT no son permitidas.
4. Puedes tener diferentes system nodepools en un mismo cluster.
5. Puedes convertirlo en un User nodepool siempre y cuando haya otro system nodepool en el cluster corriendo.

### User Nodepool

Este nodepool será el encargado de correr todos tus flujos de trabajo para tus aplicaciones. Es importante mencionar algunas características:
1. No se puede escalar a 0.
2. Puedes manejarlos como quieras: eliminar, crear, editar, etc., sin ningún error.
3. Puedes utilizar Spot VM's.
4. Pueden ser convertidos en system nodepool.
5. Puedes tener tantos user nodepool como Azure te permita.

## Objetos dentro del Cluster

### Namespaces

Es una división lógica que divide espacios dedicados a las aplicaciones. Son tres namespaces:
1. **Default** --> Es el namespace por defecto.
2. **kube-system** --> Es donde viven los pods del core.
3. **Kube-public** --> No es muy normal tenerlo, pero sirve para crear objetos que sean visibles en todo el cluster.

### POD

Es la unidad mínima que puedes crear en el cluster. Un pod correrá tu contenedor, uno o varios dependiendo de tus necesidades en la aplicación. En caso de que este se elimine, se eliminará a diferencia de que esté encima de un Deployment.

### Deployment

Creas un template con una configuración que despliega diferentes pods junto con sus réplicas. Las réplicas mantendrán los pods siempre activos. Es siempre recomendable no tener un pod único corriendo en el cluster, es mejor que este pod esté generado por un deployment.

### Services

Los servicios están hechos para relacionar objetos dentro del cluster, además de conectarlos entre sí. Los servicios son necesarios en Kubernetes debido a que las redes dentro del cluster son dinámicas, esto significa que una IP en un pod o deployment nunca va a ser estática. Por lo que utilizaremos servicios para que nuestra petición sea redirigida a nuestro pod correspondiente independientemente si cambia o no su IP.

Tipos de servicios dentro del cluster:
1. **ClusterIP** --> Mediante un label o un selector podemos redireccionar la petición hacia nuestro Pod que contiene nuestra aplicación.
2. **NodePort** --> Con este servicio puedes configurar una IP externa para exponer tu aplicación. La IP externa dependerá del nodo y se configurará el nodo correspondiente.
3. **LoadBalancer** --> Este tipo creará un servicio externo con una IP externa. En el caso de Azure, se creará un Load Balancer que se comunicará vía TCP/UDP.

### Ingress

A diferencia del servicio ACA, aquí es necesario desplegar el Ingress manualmente, utilizando la vía que tú más consideres. Al desplegar el Ingress, se crearán pods que son los controladores y un servicio de tipo Load Balancer con una IP externa (un Azure Load Balancer), entre otros muchos objetos. Estos pods apuntarán a los objetos Ingress que podrás crear en tu cluster que contendrán todas las reglas necesarias para que tu petición se redirija al servicio correspondiente.

## Versioning

Azure sigue las mismas releases que el proyecto de Kubernetes. Esto significa que hay siempre nuevas actualizaciones disponibles del control plane y de los nodos. Microsoft solo da soporte a las tres últimas versiones partiendo de su versión más nueva. Por ejemplo, si la versión más nueva del cluster es la 1.31, Microsoft te ofrecerá soporte en la 1.31, 1.30 y la 1.29. 

## Pros and Cons

### PROS
1. No tienes que preocuparte por el cluster de Kubernetes. Azure lo hará todo por ti.
2. Es fácil de integrar con los servicios de Azure, como Entra ID.
3. Tiene compatibilidad con CNCF (Cloud Native Computing Foundation).

### CONS
1. Puede ser un poco complejo de entender al principio.
2. Para cambiar de SKU en un nodepool, hay que redesplegarlo.
3. Algunas veces, para habilitar o deshabilitar una característica del cluster, tienes que redesplegarlo, lo que puede causar pérdidas de servicio o tiempo.



