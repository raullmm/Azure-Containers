# 1. Create a resource group in Azure
# Before creating the App Service Plan, we need to ensure we have a resource group.
# Change the name and location as per your needs.

$resourceGroupName = "rg-appserv-containers"
$location = "West Europe"

Write-Host "Creating the resource group in Azure..."
az group create --name $resourceGroupName --location $location
Write-Host "Resource group created successfully."

# 2. Create the App Service Plan
# We are going to create an App Service Plan, which is the hosting infrastructure for our web applications.
# Here we define the name, resource group, location, operating system (Linux), and the SKU (Standard 1 - S1).
# If you want to create a plan for Windows containers, replace `--is-linux` with `--hyper-v`.

$appServicePlanName = "containersplan"
$sku = "S1"
$workers = 1

Write-Host "Creating the App Service Plan..."
az appservice plan create `
    --name $appServicePlanName `
    --resource-group $resourceGroupName `
    --location $location `
    --is-linux `
    --sku $sku `
    --number-of-workers $workers

Write-Host "App Service Plan created successfully."

# 3. Create a web app and deploy a container
# Now we create a web app inside the App Service Plan.
# We specify the name of the app, the plan where it will reside, and the container to be deployed.
# NOTE: The app name must be globally unique.

$webAppName = "containersinazure-minijuegosTest1"
$containerImage = "raulmorenoooo/minijuegos:v1"

Write-Host "Creating the web app and deploying the container..."
az webapp create `
    --name $webAppName `
    --resource-group $resourceGroupName `
    --plan $appServicePlanName `
    --deployment-container-image-name $containerImage

Write-Host "Web app created and container deployed successfully."

# 4. Additional information for authentication with Azure Container Registry (Optional)
# If you need to deploy a container from Azure Container Registry (ACR), you can include credentials
# using the `--docker-registry-server-user` and `--docker-registry-server-password` parameters.
# To use this option, you need to pass in your registry username and password.

$registryUser = "your-registry-username"
$registryPassword = "your-registry-password"

# Example for registering credentials:
# az webapp create `
#    --name $webAppName `
#    --resource-group $resourceGroupName `
#    --plan $appServicePlanName `
#    --deployment-container-image-name $containerImage `
#    --docker-registry-server-user $registryUser `
#    --docker-registry-server-password $registryPassword

Write-Host "Script completed."