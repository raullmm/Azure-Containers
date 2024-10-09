Correr contenedores en Azure Function 

Azure Function es un servicio implementado en Azure en 2013, este servicio cuenta con la propiedad de ser un servicio serveless (pagas por lo que consumes a la hora de correr código), es decir, para correr tu código, no necesitarías de una máquina corriendo las 24 horas, este servicio, ejecuta tu codigo y solo pagarás por esa ejecución. Para ejecutar una Azure Function hay dos maneras, utilizando los triggers y los bindings, puedes ejecutar una Azure function utilizando un trigger HTTP, donde a partir de un body (JSON) le pasas unos parámetros y se ejecutará la funcion con esos parámetros. Por otro lado los bindings vienen integrados en la Azure Function como por ejemplo ejecutarla por colas, cada x tiempo etc...

Este servicio no ha sido creado para correr contenedores, pero se pueden correr dentro del servicio. ¿ Cuando entran en juego los contenedores ? Cuando necesitas correr un código con un runtime que Azure Function no soporta. Ante de correr el contenedor, tenemos que tener en cuenta varias cosas de Azure Function. Este servicio cuenta con un cold start, eso quiere decir que el código solo podrá correr por 10 minutos, a los 10 minutos, el codigo dejará de correr y todo se perderá, datos, variables, procesos etc. Esto puede ser un problema, si tu tienes una imagen que pesa mucho y tarda en cargar o construirse 6 minutos, solo tienes 4 minutos para correr el script. Esto tiene solución, hay diferentes planes:

- Consumption Plan: Este es el plan mas básico para correr tu function app, aqui tenemos que tener en cuenta el cold start y diversas limitaciones que nos pueden impactar al desempeño de nuestro contenedor. Eficaz para funciones que se ejecuten en un periodo corto de tiempo entornos dinamicos.

- Premium Plan: Este plan cuenta con pre-warmed workers, estos workers nunca estarán desalocados como en el caso de consumption plan, por lo que, podremos evitar ese cold start para ejecutar el contenedor. Obviamente, esto impacta en los costes de tu function app, pagarás por la CPU, memoria y recursos que tengas alocados. Eficaz para escernarios que tengas que correr Azure Function muy continuiamente.

- Dedicated Plan: Esto es un plan para correr exactamente una App Service. Mismas caracteristicas.

Para correr los contenedores, el cold start ya no es un problema, podemos seleccionar el plan Premium para evitar ese cold start y ya funcionaría perfecto.

Utilizando el script que encontrarás en esta carpeta ./Deploy-AzureFunction-Container.ps1 , podrás desplegar tu contenedor en Azure function. Estaremos utilizando una imagen básica para desplegar la function de Azure, en el libro se utiliza Azure Deployment Center dentro de la funcion app para pullear una imagen desde el DockerHub. Esto según la documentación es también posible de hacer utilizando comandos CLI.

También tenemos que tener en cuenta a la hora de crear nuestra imagen de docker para subirla a dockerHub, que está se tiene que hacer utilizando las herramientas para crear una function app (Azure Function Cool Tools) que podrás descargarla en esta URL: https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local

utilizando los comandos 

 func init --worker-runtime dotnet –docker
 func new --name BillingStatements --template "HTTP trigger" --authlevel anonymous

Tendrás la template para subir tu dockerfile a DockerHub y poder utilizar esa imagen a traves del Deployment Center como marca el libro.

Pros y Cons

Antes de mencionar los pros y cons debemos de tener en cuenta que esta no es la solucion más optima para correr un contenedor, de echo, queremos todo lo contrario. 

Pros:

- Puede solucionar un problema dentro de tu entorno.

Si tienes un entorno configurado donde solo se utilizan Function Apps y necesitas correr una parte del script en un runtime no permitido, tienes esta opción para adaptarte al entorno.

- Puede correr en tu Premium Plan existente

Si tienes ya un Premium plan contratado o un Dedicated Plan, puedes correr el contenedor sin necesidad de pagar otro plan diferente. No supondrá costes en este caso tener los contenedores corriendo mas que el que te cuesta mantener el Premium o Dedicated Plan.

- Integración con Azure

Al ser un servicio que provee Azure tienes todas las ventajas de seguridad, conexiones con otros servicios, usuarios, permisos que pueda ofrecer Azure a la hora de integrar tu Funcion App. Todo esto se puede aprovechar

Cons:

- Solo soporta Linux

Azure Function App solo puede soportar Linux, aun no esta disponible correr contenedores Windows.

- Modificar el codigo de tu contenedor.

Hemos visto que para desplegar un contenedor utilizando Azure Function necesitamos hacerlo de una manera particular, creado una funcion y una template para que la plataforma pueda ofrecernos el servicio correctamente, esto puede ser un poco tedioso a la hora de desplegar tus contenedores.

- No es la mejor solución para hostear contenedores

Ya que azure function no esta hecho para desplegar contenedores, tenemos la problematica de que no hay una manera de desbugear errores, no es muy cómodo para manejar comandos, mirar cosas dentro del contenedor, comportamientos etc
