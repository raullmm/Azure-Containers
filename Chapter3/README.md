
# Correr Contenedores en Azure Function

**Azure Function** es un servicio implementado en Azure en 2013 que permite ejecutar código en un entorno *serverless*, es decir, solo pagas por lo que consumes a la hora de correr el código. No es necesario tener una máquina corriendo 24 horas al día. Este servicio ejecuta tu código cuando es necesario y pagas únicamente por esa ejecución.

## Modos de Ejecución de Azure Function

Azure Function se puede ejecutar mediante dos métodos principales:

- **Triggers**: Un *trigger* (disparador) inicia la ejecución de una Azure Function. Un ejemplo común es el disparador HTTP, donde un cuerpo JSON (body) envía parámetros para la ejecución.
  
- **Bindings**: Los bindings están integrados en las Azure Functions y permiten ejecutar la función automáticamente en base a eventos, como colas o temporizadores.

## Contenedores en Azure Function

Aunque Azure Function no fue diseñado específicamente para ejecutar contenedores, es posible hacerlo cuando necesitas usar un runtime no soportado. Sin embargo, hay algunas consideraciones importantes:

- **Cold Start**: Azure Functions tienen un "cold start", lo que significa que solo pueden correr por 10 minutos. Si tu contenedor tarda 6 minutos en cargarse, solo tendrás 4 minutos para ejecutar el código restante. Para superar este problema, Azure ofrece varios planes:

### Planes Disponibles

1. **Consumption Plan**: 
   - Plan más básico.
   - Incluye *cold start* y tiene limitaciones de tiempo.
   - Adecuado para funciones de corta duración y entornos dinámicos.

2. **Premium Plan**: 
   - Incluye *pre-warmed workers* para evitar el *cold start*.
   - Mayor costo, pero sin interrupciones para contenedores que requieren tiempos más largos.

3. **Dedicated Plan**: 
   - Similar a App Service.
   - Específico para aplicaciones que requieren tiempos de ejecución más largos y constantes.

En el **Premium Plan**, el *cold start* ya no es un problema y los contenedores pueden ejecutarse de forma eficiente.

## Desplegando Contenedores en Azure Function

Para desplegar un contenedor, puedes utilizar el script `./Deploy-AzureFunction-Container.ps1` que encontrarás en esta carpeta. Utilizaremos una imagen básica para desplegar la Function App en Azure. En este ejemplo, el libro sugiere usar Azure Deployment Center para obtener una imagen desde DockerHub, pero también se puede hacer mediante comandos CLI.

### Pasos para Crear y Desplegar la Imagen:

1. **Crear la imagen de Docker**: Utiliza las Azure Function Core Tools para crear la imagen:
   
   ```bash
   func init --worker-runtime dotnet --docker
   func new --name BillingStatements --template "HTTP trigger" --authlevel anonymous
   ```

2. **Subir la imagen a DockerHub**: Una vez creada la imagen, puedes subirla a DockerHub para usarla en el **Deployment Center**.

## Pros y Contras de Usar Contenedores en Azure Function

### Pros:
- **Adaptación al entorno**: Si solo puedes usar Function Apps y necesitas un runtime no soportado, esta opción te permite adaptarte sin cambiar de entorno.
  
- **Integración con Premium Plan existente**: Si ya tienes un plan Premium o Dedicated, puedes ejecutar contenedores sin costos adicionales por otros planes.

- **Integración con Azure**: Aprovechas todas las ventajas de seguridad, conexiones con otros servicios, permisos, etc., que ofrece Azure.

### Contras:
- **Solo soporta Linux**: Actualmente, Azure Function App solo soporta contenedores en Linux.

- **Modificaciones en el código del contenedor**: Para desplegar un contenedor, debes seguir un proceso específico que incluye la creación de plantillas, lo que puede ser tedioso.

- **No es la mejor solución para contenedores**: Azure Function no está diseñado específicamente para contenedores, por lo que el manejo de errores y la interacción con el contenedor pueden ser limitados.

## Consideraciones Finales

Esta solución no es la más óptima para contenedores, pero puede resolver necesidades específicas en entornos donde las Function Apps ya están integradas. Para aplicaciones que requieren mayor flexibilidad, es recomendable evaluar otras opciones como Azure Kubernetes Service (AKS) o App Services.

