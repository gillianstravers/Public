param Storagename string
param location string = resourceGroup().location
param accesstier string
param subnetid string
param SKU string

resource SecureStorage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: Storagename
  location: location
  sku: {
    name:  SKU
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
    allowSharedKeyAccess: false
    accessTier: accesstier
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    
  }
}

resource PEP 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: '${SecureStorage.name}-plink'
  location: location
  properties: {
    subnet: {
      id: subnetid
    }
    privateLinkServiceConnections: [
      {
        name: '${SecureStorage.name}-plink'
        properties: {
          privateLinkServiceId: SecureStorage.id
          groupIds: [
            'Blob'
          ]
        }
      }
    ]
  }
}
