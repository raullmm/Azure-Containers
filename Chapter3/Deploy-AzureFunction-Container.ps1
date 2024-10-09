# Variables for the deployment
$resourceGroupName = "rg-functions-containers"  # Replace with your desired resource group name
$location = "westeurope"  # Replace with your desired Azure region
$storageAccountName = "azfuncstor$(Get-Random)"  # Unique storage account name (append random number)
$planName = "containerplan"  # Replace with your desired plan name
$functionAppName = "containerinfunction01"  # Replace with your desired function app name
$containerImage = "nginx:nginx"  # Replace with your desired container image

# Step 1: Create the resource group
Write-Host "Creating resource group..."
az group create --name $resourceGroupName --location $location

# Step 2: Verify if the resource group was created
Write-Host "Verifying resource group creation..."
az group show --name $resourceGroupName

# Step 3: Create the storage account
Write-Host "Creating storage account..."
az storage account create --name $storageAccountName --location $location --resource-group $resourceGroupName --sku Standard_LRS

# Step 4: Create the Premium plan
Write-Host "Creating Premium plan for Azure Functions..."
az functionapp plan create --name $planName --location $location --resource-group $resourceGroupName --number-of-workers 1 --sku EP1 --is-linux

# Step 5: Create the Function App and deploy the container
Write-Host "Creating Function App and deploying container..."
az functionapp create --name $functionAppName --resource-group $resourceGroupName --storage-account $storageAccountName --plan $planName --functions-version 3 --deployment-container-image-name $containerImage

# Step 6: Get the Function App URL and test the endpoint (you can customize this based on the deployed API)
$functionAppUrl = "https://$functionAppName.azurewebsites.net/api/BillingStatements"
Write-Host "Function App deployed. Testing the endpoint..."
Invoke-RestMethod -Uri $functionAppUrl

# Optional Step: Delete the resource group when done (use with caution)
# Uncomment the following line if you want to delete the resources after testing
# az group delete --name $resourceGroupName --yes --no-wait

Write-Host "Deployment script completed."
