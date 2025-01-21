Azure Kubernetes Service for Kubernetes in the Cloud

Hablando de kubernetes podemos decir que es un servicio portable y open source ganador entre su competencia que acogieron los proveedores de nube para integrarlo en un servicio. AKS en el caso de Azure es el servicio que emplea kubernetes para tu manejo de contenedores y orquestador de tus flujos de trabajo con estos. 

Cuando utilizas el servicio de AKS creas un cluster de kubernetes, este cluster no es global, se creará en la region que selecciones, tiene dos partes significativas. El control plane (manejado por Azure) y la parte de los nodos.

- Control Plane
Vamos a describir un poco los objetos dentro del control plane, que de nuevo, son manejados en su mayoria por Azure (Puedes llegar a controlar estos objetos e interactuar con la API del cluster además de monitorear los logs del crontol plane en Azure Monitor, pero recurrirá en costes, puedes hacerlo mediante una storage account en Diagnostic Tools)
1. ETCD --> La base de datos que function como key=value, contiene todos los objetos, logs e informacion de todos los objetos desplegados en el cluster. 
2. API-Server --> La API del cluster, esta proporciona una herramienta llamada kubectl para interactuar externalmente con ella.
3. Kube-Scheduler --> El encargado de adjustar el flujo de trabajo del cluster en segun que nodo este disponible en base a los recursos que este tenga.
4. kube-controller-manager --> El manejador de pequeños controladores varios que hay en el cluster.

Por otra parte tenemos los node y node pools.

- Node y Nodepools

En Azure esto son al final Virtual Machine Scale Sets, los componentes de los nodos suelen ser tres:

1. Kube-Proxy --> El encargado de manejar el trafico y las redes internas de kubernetes, redireccionar las peticiones, paquetes etc
2. Kubelet --> Es el soldado del kube-scheduler y se encarga de decidir en que nodos correrán tus aplicaciones.
3. Container Runtime --> Es utilizado Docker para correr los contenedores que hay dentro de los Pods.

Dentro de este concepto de Nodo, tenemos diferentes tipos de nodos, depende de que funcion necesites serviran para una cosa u otra, en Azure los tipos son dos:

- System Nodepool

El encargado de tener todos los system pods necesarios para correr los componentes de los nodos y del control plane. Se suele utilizar solo para correr estos contenedores nada más. Algunas de sus características serían:
1. solo puede correr linux
2. cada nodo de system necesita 2CPU y 4GB de memoria como minimo para correr
3. Las maquinas en SPOT no son permitidas
4. Puedes tener diferentes systemnodepool en un mismo cluster
5. Puedes convertirlo en un User nodepool siempre y cuando haya otro system nodepool en el cluster corriendo

- User nodepool

Este nodepool será el encargado de correr todos tus flujos de trabajo para tus aplicaciones, es importante mencionar algunas caracteristicas:
1. No se puede escalar a 0
2. Puedes manejarlos como quieras, eliminar, crear, editar etc sin ningun error
3. Puedes utilizar Spot VM's
4. Pueden ser convertido en systemnodepool
5. Puedes tener tantos user nodepool como Azure te permita.

Dentro de estos nodos tenemos diferentes tipos de objetos entre ellos:

- Namespaces
Es una division lógica que divide espacios dedicados a las aplicaciones. Son tres namespaces:
1. Default --> Es el namespace por defecto 
2. kube-system --> Es donde viven los pods del core
3. Kube-public --> No es muy normal tenerlo pero sirve para crear objetos que sean visibles en todo el cluster.

Dentro de los namespaces podemos crear objetos varios, uno de ellos es el llamado:

- POD

Es la unidad minima que puedes crear en el cluster, un pod correrá tu contenedor, uno o varios dependiendo de tus necesidades en la aplicación. En caso de que este se elimine, se eliminará a diferencia de que este encima de un Deployment.

- Deployment

Creas un template con una configuración que despliega diferente pods junto con sus replicas, las replicas mantendrán los pods siempre activos. Es siempre recomendable no tener un pod unico corriendo en el cluster, es mejor que este pod este generado por un deployment.

- Services

Los servicios estan hechos para relacionar objetos dentro del cluster, además de conectarlos entre sí. Los servicios son necesarios en Kubernetes debido a que las redes dentro del cluster son dinamicas, esto significa que una IP en un pod o deployment nunca va a ser estatica. Por lo que utilizaremos servicios para que nuestra peticion sea redirigida a nuestro pod correspondiente independientemenete si cambia o no su IP.
Tenemos varios tipos de servicios dentro del cluster, entre ellos:
1. ClusterIP --> Mediante un label o un selector podemos redireccionar la peticion hacia nuestro Pod que conetiene nuestra aplicación. Este suele tener dos IP, una interna y otra que puede ser 
2. NodePort --> Con este servicio puedes configurar una IP externa para exponer tu aplicación. La Ip externa dependerá del nodo y se configurara el nodo correspondiente del nodo que tu eligas.
3. LoadBalancer --> Este tipo creará un servicio externo con una IP externa, que en caso de Azure, se creará un Load Balancer que se comunicará via TCP/UDP.

Unas de las limitaciones de los servicios es que no soportan TLS por lo que es recomendable utilizar algo por encima de los servicios para exponer tu aplicación hacia el exterior, aquí entra el papel del Ingress.

- Ingress

A diferencia del servicio ACA, aquí es necesario desplegar el Ingress manualmente, utilizando la via que tu mas consideres. Al desplegar el ingress, se crearan pods que son los controladores y un servicio de tipo load balancer con una IP externa (Un Azure Load Balancer) entre otros muchos objetos. Estos pods apuntaran a los objetos Ingress que podrás crear en tu cluster que contendran todas las reglas necesarias para que tu peticion se rediriga al servicio correspondiente.

- Versioning

Azure sigue las mismas releases que el proyecto de Kubernetes, esto significa que hay siempre nuevas actualizaciones disponibles del control plane y de los nodos. Microsoft no puede hacer soporte a todas y cada una de ellas, por lo que va a dar soporte solo a las tres ultimas versiones partiendo de su versión mas nueva. Por ejemplo, si la version mas nueva del cluster es la 1.31, Microsoft te ofrecerá soporte en la 1.31, 1.30 y la 1.29. Upgradear un cluster es solo apretar un par de botones y el tiempo es minimo, ademas de que el impacto es tambien minimo.


- Pros and cons

