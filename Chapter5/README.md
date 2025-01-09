Azure Container Apps for Serverless Kubernetes

Nacio en noviembre de 2021, es un servicio nuevo de Azure totalmente serverless que ha llegado como revolución para correr tus contenedores.

Es importante destacar que Azure Container Apps (ACA) es manejado por Kubernetes, pero con la diferencia de que el cluster lo maneja Microsoft, solo te preocupas por el contenedor en sí.
Al ser manejado por Kubernetes, ACA utiliza varios opensources, como puede ser KEDA, Darp y Envoy (Igress Nginx), que aunque nosotros no tengamos que manejar estos servicios es importante saberlo.
Al crear un ACA también podrás disfrutar de un FQDN Fully Qualified Domain Name, que podrás cambiar por tu dominio y certificado correspondiente.

Vamos a ver los componentes de este servicio:

- Environment 

El servicio se divide en environemnts donde son desplegados los ACA, estos environments actuan parecido al Namespace en Kubernetes. Comparten VNET y Log Analitycs Workspace en Azure, es conveniente que los ACA que esten dentro de un environemnt tengan relacion entre sí, ya sea por que se necesitan, por que establezcan conexión o son de una misma aplicación, por el contrario, deberían de separarse en diferentes environemnts. Una cosa importante, es que no se tienen que pagar por Environments creados en el servicio, si no por ACA desplegados.

- Revisions

Una revisions puede manejar uno o varios contenedores.
A la hora de ejecutar un cambio en nuestro ACA se creará una nueva revision con ese cambio, las revisions se encargaran de ejecutar este cambio de configuracion o imagen y mantendrán vivo nuestro ACA. Son parecido a lo que llamamos en kubernetes Replicaset. 
Cambios que ejecutarán una nueva revision:
    - UPGRADEAR la imagen
    - Añadir reglas de escalado KEDA
    - Cambios en la configuracion de Dapr
    - Cualquier tipo de cambio en la template del contenedor

Cambios que no crearán una nueva revisión:
    - Modificar reglas o activar/desactivar Ingress
    - Cambiar los valores de los secretos
    - Cualquier cambio fuera del template del contendor

- Contenedores

Algunas de las caracteristicas destacables a tener en cuenta de los Contenedores en este servicio:
    - Puedes correr cualquier tipo de imagen mientras sea linux-based x86/64 (linux/arm64)
    - Para exponer tu apicación al exterior solo están disponibles los puertos 80 y 443
    - Si el contenedor crashea, ACA lo va a crear de nuevo otra vez automaticamente.

Sabiendo esto la infraestructura sería de esta manera:

![alt text](image.png)