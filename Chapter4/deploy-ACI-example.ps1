# Implementación de Contenedores en Azure Container Instances (ACI)

# Paso 1: Crear un Grupo de Recursos
# Este comando crea un nuevo grupo de recursos donde residirán todos los recursos de Azure.
az group create `
  --name "rg-containers-aci" `
  --location "west europe"

# Paso 2: Crear un Grupo de Contenedores y Desplegar una Aplicación
# El siguiente comando crea un grupo de contenedores y despliega la aplicación de estados de cuenta.
az container create `
  --resource-group "rg-containers-aci" `
  --name billingstatementscontainer `
  --image whaakman/container-demos:billingstatementsv3 `
  --dns-name-label billingstatements `
  --ports 80

# Explicación de los Parámetros:
# --resource-group: Especifica el grupo de recursos creado anteriormente.
# --name: Nombre del grupo de contenedores.
# --image: Ruta a la imagen del contenedor. Docker Hub es el registro predeterminado.
# --dns-name-label: Crea un nombre DNS para el contenedor. Por ejemplo: billingstatements.westeurope.azurecontainer.io.
# --ports: El número de puerto que se expone para acceder al contenedor, en este caso, el puerto 80 (HTTP).

# Nota:
# Si es la primera vez que despliegas una instancia de contenedor en una suscripción, 
# podrías ver un mensaje indicando que el Proveedor de Recursos Microsoft.ContainerInstance se está registrando. 
# Este proceso puede tardar unos minutos.

# Paso 3: Verificar el Estado del Grupo de Contenedores
# Usa este comando para obtener el Nombre de Dominio Completo (FQDN) y el estado de aprovisionamiento del grupo de contenedores.
az container show `
  --resource-group "rg-containers-aci" `
  --name billingstatementscontainer `
  --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
  --out table

# Paso 4: Consultar la API del Contenedor con PowerShell
# Una vez que el contenedor esté desplegado y el estado de aprovisionamiento sea "Succeeded", puedes consultar la API utilizando su FQDN.
# Reemplaza "billingstatements.westeurope.azurecontainer.io" con el FQDN real de tu contenedor.
Invoke-RestMethod -Uri "http://billingstatements.westeurope.azurecontainer.io/BillingStatement"

# Salida:
# El comando devuelve la respuesta de la API, que contiene los datos de los estados de cuenta.
# También puedes ver el mismo resultado navegando al FQDN en un navegador web.

# Próximos Pasos:
# Explora la configuración de Infraestructura como Código (IaC) en YAML requerida para este despliegue.
# Consulta el archivo YAML proporcionado para mayor personalización y automatización de tus despliegues de contenedores.
