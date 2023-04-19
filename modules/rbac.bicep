param identityName string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: identityName
}

resource contributor 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

resource storageBlobReaderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' existing = {
  scope: subscription()
  name: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
}

resource keyVaultReaderRoleDefinition 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' existing = {
  scope: subscription()
  name: '21090545-7ca7-4776-b22c-e363652d74d2'
}

resource contributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(identity.id, contributor.id)
  properties: {
    roleDefinitionId: contributor.id
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource storageBlobReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(identity.id, storageBlobReaderRoleDefinition.id)
  properties: {
    roleDefinitionId: storageBlobReaderRoleDefinition.id
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource keyVaultReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(identity.id, keyVaultReaderRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultReaderRoleDefinition.id
    principalId: identity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}
