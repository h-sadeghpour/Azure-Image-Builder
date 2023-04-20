param identityName string
param PrincipalId string

resource rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {

  name: guid(identity.id, roleDefinitionId)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
