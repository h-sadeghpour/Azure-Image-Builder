param PrincipalId string
param roleDefinitionId string

resource rbac 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {

  name: guid(PrincipalId, roleDefinitionId)
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
