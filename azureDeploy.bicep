//Parameters
param resourceGroupName string
param location string
param identityName string
param computeGalleryName string
param imageDefinitionName string
param imageTemplateName string
param sourceImagePublisher string
param sourceImageOffer string
param sourceImageSku string
param sourceImageVersion string
param vmSize string
param diskSize int
param fslogixScriptURI string
param OptimizeOsScriptURI string
param installappszipURI string
param installcoreappsexeURI string
param scriptmsiURI string
param storageAccountName string
param containerName string

// Define target scope
targetScope = 'subscription'

//Get existing resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' existing = {
  name: resourceGroupName
}

//Get existing Storage Account 
resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: 'storageAccountName'
  scope: rg 
}

// Retrieving resource property
output blobEndpoint string = stg.properties.primaryEndpoints.blob

//Get exisitng container
resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' existing = {
  name: 'storageAccountName/blobEndpoint/containerName'
  scope: rg 
}

//Create user assigned managed identity
module identity './modules/identity.bicep' = {
  name: 'identityDeployment'
  scope: rg    
  params: {
    identityName: identityName
    location: location
  }
}

//Assign RBAC to the user assigned managed identity
module rbac './modules/rbac.bicep' = {
  name: 'rabcDeployment'
  scope: rg    
  params: {
    identityName: identityName
  }
  dependsOn: [
    identity
  ]
}

//Create Azure Compute Gallery
module acg './modules/computeGallery.bicep' = {
  name: 'acgDeployment'
  scope: rg    
  params: {
    computeGalleryName: computeGalleryName
    location: location
  }
}

//Create image defination
module imagedef './modules/imageDefinition.bicep' = {
  name: 'imagedefDeployment'
  scope: rg   
  params: {
    computeGalleryName: computeGalleryName
    imageDefinitionName: imageDefinitionName
    location: location
  }
  dependsOn: [
    acg
  ]
}

//Create image template
module imageTemplate './modules/imageTemplate.bicep' = {
  name: 'imageTemplateDeployment'
  scope: rg   
  params: {
    imageTemplateName: imageTemplateName
    imageDefinitionName: imageDefinitionName
    sourceImagePublisher: sourceImagePublisher
    sourceImageOffer: sourceImageOffer
    sourceImageSku: sourceImageSku
    sourceImageVersion: sourceImageVersion
    identityName: identityName
    computeGalleryName: computeGalleryName
    vmSize: vmSize
    diskSize: diskSize
    location: location
    fslogixScriptURI: fslogixScriptURI
    OptimizeOsScriptURI: OptimizeOsScriptURI
    installappszipURI: installappszipURI
    installcoreappsexeURI: installcoreappsexeURI
    scriptmsiURI: scriptmsiURI
    containerName: containerName
    storageAccountName: storageAccountName
    storageContainer: storageContainer
  }
  dependsOn: [
    imagedef
  ]
}
