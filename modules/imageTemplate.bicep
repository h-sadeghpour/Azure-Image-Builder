param imageTemplateName string
param location string
param identityName string
param vmSize string
param computeGalleryName string
param imageDefinitionName string
param sourceImagePublisher string
param sourceImageOffer string
param sourceImageSku string
param sourceImageVersion string
param diskSize int
param OptimizeOsScriptURI string
param installappszipURI string
param installcoreappsexeURI string
param scriptmsiURI string
//param removebloatwareURI string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: identityName
}

resource acg 'Microsoft.Compute/galleries@2022-03-03' existing = {
  name: computeGalleryName
}

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-02-14' = {
  name: imageTemplateName
  location: location
  identity: {
    type:'UserAssigned'
    userAssignedIdentities:{
      '${identity.id}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 600
    source: {
      type: 'PlatformImage'
      publisher: sourceImagePublisher
      offer: sourceImageOffer
      sku: sourceImageSku
      version: sourceImageVersion
    }
    vmProfile: {
      osDiskSizeGB: diskSize
      vmSize: vmSize
    }
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: '${acg.id}/images/${imageDefinitionName}'
        runOutputName: 'acgOutput'
        replicationRegions: [
          location
        ]
      }
    ]
    customize: [
      {
          type: 'PowerShell'
          name: 'OptimizeOS'
          runElevated: true
          runAsSystem: true
          scriptUri: OptimizeOsScriptURI
      }
      {
          type: 'WindowsRestart'
          restartCheckCommand: 'write-host "Restarting post OS Optimization"'
          restartTimeout: '5m'
      }   
        {
          type: 'PowerShell'
          name: 'scriptmsi'
          runElevated: true
          runAsSystem: true
          scriptUri: scriptmsiURI
      } 
        {
          type: 'PowerShell'
          name: 'installappszip'
          runElevated: true
          runAsSystem: true
          scriptUri: installappszipURI
      }
       {
          type: 'PowerShell'
          name: 'installcoreappsexe'
          runElevated: true
          runAsSystem: true
          scriptUri: installcoreappsexeURI
     }
         
    ]
  }
}

 resource startBuild 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'startBuild'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/54d81e17-d7a8-459c-9cca-ed176d923bb2/resourcegroups/rg-avdaib-prd-we-03/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-avdaib-prd-we-03': {}
    }
  }
  properties: {
    azPowerShellVersion: '7.3'
    scriptContent: loadTextContent('startBuild.ps1')
    retentionInterval: 'P1D'
  }
}

