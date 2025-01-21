# -----------------------------------------------
# Script didáctico para desplegar Azure Container Apps
# -----------------------------------------------

# 1. Asegurarse de tener instalada la extensión containerapp en Azure CLI
# Este paso es necesario porque la funcionalidad está en vista previa
Write-Host "Instalando la extensión de containerapp..."
az extension add --name containerapp

# 2. Registrar el proveedor de recursos para Azure Container Apps
# Esto prepara la suscripción de Azure para soportar esta funcionalidad
Write-Host "Registrando el proveedor de recursos Microsoft.App..."
az provider register --namespace Microsoft.App

# Verificar el estado del registro
Write-Host "Verificando el estado del registro..."
$providerStatus = az provider show --namespace Microsoft.App --query "registrationState" -o tsv
if ($providerStatus -eq "Registered") {
    Write-Host "Proveedor de recursos registrado correctamente."
} else {
    Write-Host "El registro está en progreso, por favor inténtalo más tarde."
    exit
}

# 3. Crear un grupo de recursos para alojar los recursos de Azure Container Apps
# Cambiar "rg-containerapps" y "westeurope" según sea necesario
Write-Host "Creando el grupo de recursos..."
az group create --name rg-containerapps --location westeurope

# 4. Crear un entorno para Azure Container Apps
Write-Host "Creando el entorno para Azure Container Apps..."
az containerapp env create `
    --name billingmanagementapi `
    --resource-group rg-containerapps `
    --location westeurope

# 5. Crear una aplicación de contenedor dentro del entorno
# Cambiar la imagen del contenedor si es necesario
Write-Host "Creando la aplicación de contenedor..."
az containerapp create `
    --name billingstatementscontainer `
    --resource-group rg-containerapps `
    --environment billingmanagementapi `
    --image whaakman/container-demos:billingstatementsv3 `
    --target-port 80 `
    --ingress 'external'

# 6. Obtener la URL de la aplicación desplegada
Write-Host "Obteniendo la URL de la aplicación desplegada..."
$appUrl = az containerapp show `
    --resource-group rg-containerapps `
    --name billingstatementscontainer `
    --query properties.configuration.ingress.fqdn `
    -o tsv

Write-Host "La aplicación está disponible en la siguiente URL:"
Write-Host $appUrl

# 7. Probar la API usando Invoke-RestMethod
Write-Host "Probando la API..."
Invoke-RestMethod -Uri "https://$appUrl/BillingStatement"

# 8. Limpieza: eliminar el grupo de recursos
# Esto eliminará todos los recursos creados para evitar costos innecesarios
# Descomentar las siguientes líneas si deseas eliminar los recursos automáticamente al final
# Write-Host "Eliminando el grupo de recursos para limpiar los recursos creados..."
# az group delete --name rg-containerapps --yes --no-wait
