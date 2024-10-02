# Contenedores Corriendo en una Web App

## ¿Qué es una Web App en Azure?

**Web App** es un servicio PaaS (Platform as a Service) ofrecido por Azure, donde solo necesitas preocuparte por el código de tu aplicación. Las tareas como actualizaciones, gestión de conexiones, módulos y dependencias corren a cargo de Azure, lo que facilita la administración de tu aplicación.

Además, es posible correr contenedores dentro de una Web App utilizando plantillas que se encuentran en el repositorio `azureappservice.ps1`. Simplemente debes crear un **App Service Plan**, donde defines características como el **SKU**, el tamaño y el número de Web Apps por plan (dependiendo del SKU).

Para crear una web app que ejecute un contenedor, puedes usar el parámetro `--deployment-container-image-name` seguido del nombre de la imagen de tu contenedor. De esta manera, la Web App correrá el contenedor de manera muy similar a cómo lo haría un **pod en Kubernetes**.

### ¿Se pueden correr múltiples contenedores?

Sí, es posible ejecutar múltiples contenedores en una Web App, de manera similar a cómo lo hace un pod. Para esto, solo necesitas configurar la Web App con algunas características diferentes. Puedes encontrar más detalles en la [documentación oficial de Azure](https://docs.microsoft.com/en-us/azure/app-service/tutorial-multi-containerapp).

---

## Pros y Contras de Correr Contenedores en una Web App

### Pros

1. **Escalabilidad**
   - **Escalado vertical**: Puedes escalar verticalmente cambiando el SKU del App Service Plan a uno superior. Esto incrementará los recursos disponibles para la Web App.
   - **Escalado horizontal**: Si tu aplicación está diseñada para soportar este tipo de escalado, puedes agregar más **workers** al plan. Esto conlleva un mínimo tiempo de inactividad. El escalado puede basarse en el uso de **memoria**, **CPU** o incluso estar programado para momentos específicos.

   **Ejemplo**:
   - Si tu aplicación experimenta picos de tráfico en ciertas horas, puedes programar el escalado horizontal para esas horas.

2. **Compatibilidad con múltiples runtimes**
   - Al desplegar contenedores, si un runtime específico no está disponible en el plan de App Service, puedes incluirlo dentro de la imagen del contenedor. Esto te permite utilizar el runtime que necesites para tu aplicación.

3. **Integración con CI/CD**
   - Azure App Service tiene la opción **Deployment Center**, que te permite integrar fácilmente con repositorios Git. Puedes configurar un flujo de trabajo para crear, subir y utilizar imágenes de contenedores en tu Web App sin complicaciones.

   **Ejemplo**:
   - Puedes configurar un pipeline de CI/CD que, tras cada commit en tu repositorio, genere automáticamente una nueva imagen del contenedor y la despliegue en tu Web App.

4. **Compatibilidad con Windows y Linux**
   - Azure App Service soporta ambos sistemas operativos. Sin embargo, es importante notar que no puedes ejecutar ambos en un mismo App Service Plan. Debes crear planes separados para **Linux** y **Windows**.
   - Para un plan Linux, debes usar el parámetro `--is-linux`, y para un plan en Windows, `--hyper-v`.

---

### Contras

1. **Escalado limitado**
   - Los contenedores están diseñados para escalar principalmente de forma horizontal. En el contexto de Azure App Service, el escalado horizontal no es tan ágil o manejable como en plataformas nativas de contenedores como Kubernetes.
   - App Service puede desplegar un nuevo contenedor de tu aplicación sin tener conocimiento de su estado actual, lo que en aplicaciones complejas puede generar problemas.

   **Ejemplo**:
   - Si uno de tus contenedores falla, otros contenedores no tienen consciencia del fallo y no pueden cubrir su funcionalidad, a diferencia de lo que ocurre en Kubernetes.

2. **Una Web App = Un Contenedor**
   - Cada Web App solo puede correr un único contenedor. Si tu aplicación requiere múltiples contenedores, necesitarás desplegar varias Web Apps, lo que incrementará el costo del servicio.

   **Ejemplo**:
   - Para una aplicación compleja con microservicios, necesitarás varias Web Apps para cada contenedor, lo cual podría no ser rentable en comparación con otras soluciones como Kubernetes.

3. **Monitoreo e Integración Limitados**
   - Azure Web App no está optimizado para contenedores, lo que significa que el monitoreo y la depuración pueden ser más complicados. Tendrás que implementar soluciones adicionales para monitorear o resolver errores en tus contenedores.

   **Ejemplo**:
   - Si tu contenedor tiene un error en producción, no podrás aprovechar los servicios de monitoreo nativos de Azure directamente, y deberás implementar tu propio sistema de logs y alertas.

4. **Limitación de Puertos**
   - Solo puedes exponer los puertos **80** y **443** en una Web App. Si tu aplicación necesita conectarse a otro servicio externo a través de diferentes puertos, esto no será posible. La solución es desplegar los contenedores utilizando **Docker Compose** para que ambos servicios compartan la misma red.

   **Ejemplo**:
   - Si tu aplicación necesita conectarse a una base de datos que opera en un puerto distinto de los permitidos, tendrás que configurar ambos en un mismo **Docker Compose** para permitir la comunicación.


