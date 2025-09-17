
📝 DevOps Project Setup Checklist (Azure + Azure DevOps)

1. Azure Setup
	•	Decide on a project name (e.g., maven-hello-app-v2, banking-app-v2).
	•	Create a dedicated Resource Group:

az group create --name rg-<project-name> --location <region>


	•	Create Azure Container Registry (ACR) (if needed):

az acr create --resource-group rg-<project-name> --name <acr-name> --sku Basic


	•	Create App Service Plan + Web App (for container deploys):

az appservice plan create --name asp-<project-name> --resource-group rg-<project-name> --sku B1 --is-linux
az webapp create --resource-group rg-<project-name> --plan asp-<project-name> --name <app-name> --deployment-container-image-name hello-world



⸻

2. Azure DevOps Setup
	•	Go to Project Settings → Service connections → New service connection.
	•	Create Azure Resource Manager (ARM) connection:
	•	Scope: Subscription → Resource Group (rg-<project-name>).
	•	Name it: arm-connection-<project-name>.
	•	Create Docker Registry (ACR) connection:
	•	Registry type: Azure Container Registry.
	•	Name it: acr-connection-<project-name>.

⸻

3. Pipeline Setup
	•	Add azure-pipelines.yml to your repo.
	•	Define stages:
	•	Build → compile/test Maven/Node/Go app.
	•	Docker Build & Push → build image and push to ACR.
	•	Deploy → deploy image from ACR to App Service.
	•	In Docker task, enforce correct architecture:

arguments: '--platform linux/amd64'


	•	Use service connections in YAML:

containerRegistry: 'acr-connection-<project-name>'
azureSubscription: 'arm-connection-<project-name>'



⸻

4. Verification
	•	Restart App Service after deploy:

az webapp restart --name <app-name> --resource-group rg-<project-name>


	•	Check logs:

az webapp log tail --name <app-name> --resource-group rg-<project-name>


	•	Test app in browser or with curl.

⸻

5. Cleanup (to avoid billing)
	•	Delete Resource Group (kills all resources):

az group delete --name rg-<project-name> --yes --no-wait


	•	Delete Service Connections in Azure DevOps (acr-connection-<project-name>, arm-connection-<project-name>).
	•	(Optional) Delete Service Principals from Azure AD if auto-created.

⸻

🔑 Naming Convention
	•	Resource Group → rg-<project>
	•	ACR → <project>acr
	•	App Service Plan → asp-<project>
	•	App Service → <project>-app
	•	Service connections → acr-connection-<project>, arm-connection-<project>
