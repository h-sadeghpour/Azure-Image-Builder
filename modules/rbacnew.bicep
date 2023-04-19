param identityName string
param roleDefinitionId string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: identityName
}
resource rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {

  name: guid(identity.id, roleDefinitionId)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: identity.properties.principalId
  }
}
