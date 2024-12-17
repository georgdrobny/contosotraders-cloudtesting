// common
targetScope = 'resourceGroup'

// parameters
////////////////////////////////////////////////////////////////////////////////

// common
@minLength(3)
@maxLength(6)
@description('A unique environment suffix (max 6 characters, alphanumeric only).')
param suffix string

@secure()
@description('A password which will be set on all SQL Azure DBs.')
param sqlPassword string // @TODO: Obviously, we need to fix this!

param resourceLocation string = resourceGroup().location

// tenant
param tenantId string = subscription().tenantId

// aks
param aksLinuxAdminUsername string // value supplied via parameters file

param prefix string = 'contosotraders'

param prefixHyphenated string = 'contoso-traders'

// sql
param sqlServerHostName string = environment().suffixes.sqlServerHostname

// use param to conditionally deploy private endpoint resources
param deployPrivateEndpoints bool = false

// variables
////////////////////////////////////////////////////////////////////////////////

// key vault
var kvName = '${prefix}kv${suffix}'
var kvSecretNameProductsApiEndpoint = 'productsApiEndpoint'
var kvSecretNameProductsDbConnStr = 'productsDbConnectionString'
var kvSecretNameProfilesDbConnStr = 'profilesDbConnectionString'
var kvSecretNameStocksDbConnStr = 'stocksDbConnectionString'
var kvSecretNameCartsApiEndpoint = 'cartsApiEndpoint'
var kvSecretNameCartsInternalApiEndpoint = 'cartsInternalApiEndpoint'
var kvSecretNameCartsDbConnStr = 'cartsDbConnectionString'
var kvSecretNameImagesEndpoint = 'imagesEndpoint'
var kvSecretNameAppInsightsConnStr = 'appInsightsConnectionString'
var kvSecretNameUiCdnEndpoint = 'uiCdnEndpoint'
var kvSecretNameVnetAcaSubnetId = 'vnetAcaSubnetId'

// user-assigned managed identity (for key vault access)
var userAssignedMIForKVAccessName = '${prefixHyphenated}-mi-kv-access${suffix}'

// cosmos db (stocks db)
var stocksDbAcctName = '${prefixHyphenated}-stocks${suffix}'
var stocksDbName = 'stocksdb'
var stocksDbStocksContainerName = 'stocks'

// cosmos db (carts db)
var cartsDbAcctName = '${prefixHyphenated}-carts${suffix}'
var cartsDbName = 'cartsdb'
var cartsDbStocksContainerName = 'carts'

// app service plan (products api)
var productsApiAppSvcPlanName = '${prefixHyphenated}-products${suffix}'
var productsApiAppSvcName = '${prefixHyphenated}-products${suffix}'
var productsApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var productsApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// sql azure (products db)
var productsDbServerName = '${prefixHyphenated}-products${suffix}'
var productsDbName = 'productsdb'
var productsDbServerAdminLogin = 'localadmin'
var productsDbServerAdminPassword = sqlPassword

// sql azure (profiles db)
var profilesDbServerName = '${prefixHyphenated}-profiles${suffix}'
var profilesDbName = 'profilesdb'
var profilesDbServerAdminLogin = 'localadmin'
var profilesDbServerAdminPassword = sqlPassword

// azure container app (carts api)
var cartsApiAcaName = '${prefixHyphenated}-carts${suffix}'
var cartsApiAcaEnvName = '${prefix}acaenv${suffix}'
var cartsApiAcaSecretAcrPassword = 'acr-password'
var cartsApiAcaContainerDetailsName = '${prefixHyphenated}-carts${suffix}'
var cartsApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var cartsApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// azure container app (carts api - internal only)
var cartsInternalApiAcaName = '${prefixHyphenated}-intcarts${suffix}'
var cartsInternalApiAcaEnvName = '${prefix}intacaenv${suffix}'
var cartsInternalApiAcaSecretAcrPassword = 'acr-password'
var cartsInternalApiAcaContainerDetailsName = '${prefixHyphenated}-intcarts${suffix}'
var cartsInternalApiSettingNameKeyVaultEndpoint = 'KeyVaultEndpoint'
var cartsInternalApiSettingNameManagedIdentityClientId = 'ManagedIdentityClientId'

// storage account (product images)
var productImagesStgAccName = '${prefix}img${suffix}'
var productImagesProductDetailsContainerName = 'product-details'
var productImagesProductListContainerName = 'product-list'

// storage account (old website)
var uiStgAccName = '${prefix}ui${suffix}'

// storage account (new website)
var ui2StgAccName = '${prefix}ui2${suffix}'

// storage account (image classifier)
var imageClassifierStgAccName = '${prefix}ic${suffix}'
var imageClassifierWebsiteUploadsContainerName = 'website-uploads'

// cdn
var cdnProfileName = '${prefixHyphenated}-cdn${suffix}'
var cdnImagesEndpointName = '${prefixHyphenated}-images${suffix}'
var cdnUiEndpointName = '${prefixHyphenated}-ui${suffix}'
var cdnUi2EndpointName = '${prefixHyphenated}-ui2${suffix}'

// azure container registry
var acrName = '${prefix}acr${suffix}'

// load testing service
var loadTestSvcName = '${prefixHyphenated}-loadtest${suffix}'

// application insights
var logAnalyticsWorkspaceName = '${prefixHyphenated}-loganalytics${suffix}'
var appInsightsName = '${prefixHyphenated}-ai${suffix}'

// portal dashboard
var portalDashboardName = '${prefixHyphenated}-dashboard${suffix}'

// aks cluster
var aksClusterName = '${prefixHyphenated}-aks${suffix}'
var aksClusterDnsPrefix = '${prefixHyphenated}-aks${suffix}'
var aksClusterNodeResourceGroup = '${prefixHyphenated}-aks-nodes-rg${suffix}'

// virtual network
var vnetName = '${prefixHyphenated}-vnet${suffix}'
var vnetAddressSpace = '10.0.0.0/16'
var vnetAcaSubnetName = 'subnet-aca'
var vnetAcaSubnetAddressPrefix = '10.0.0.0/23'
var vnetVmSubnetName = 'subnet-vm'
var vnetVmSubnetAddressPrefix = '10.0.2.0/23'
var vnetLoadTestSubnetName = 'subnet-loadtest'
var vnetLoadTestSubnetAddressPrefix = '10.0.4.0/23'

// jumpbox vm
var jumpboxPublicIpName = '${prefixHyphenated}-jumpbox${suffix}'
var jumpboxNsgName = '${prefixHyphenated}-jumpbox${suffix}'
var jumpboxNicName = '${prefixHyphenated}-jumpbox${suffix}'
var jumpboxVmName = 'jumpboxvm'
var jumpboxVmAdminLogin = 'localadmin'
var jumpboxVmAdminPassword = sqlPassword
var jumpboxVmShutdownSchduleName = 'shutdown-computevm-jumpboxvm'
var jumpboxVmShutdownScheduleTimezoneId = 'UTC'

// private dns zone
var privateDnsZoneVnetLinkName = '${prefixHyphenated}-privatednszone-vnet-link${suffix}'

// chaos studio
var chaosKvExperimentName = '${prefixHyphenated}-chaos-kv-experiment${suffix}'
var chaosKvSelectorId = guid('${prefixHyphenated}-chaos-kv-selector-id${suffix}')
var chaosAksExperimentName = '${prefixHyphenated}-chaos-aks-experiment${suffix}'
var chaosAksSelectorId = guid('${prefixHyphenated}-chaos-aks-selector-id${suffix}')

// tags
var resourceTags = {
  Product: prefixHyphenated
  Environment: suffix
}

// resources
////////////////////////////////////////////////////////////////////////////////

//
// key vault
//

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: kvName
  location: resourceLocation
  tags: resourceTags
  properties: {
    // @TODO: Hack to enable temporary access to devs during local development/debugging.
    accessPolicies: [
      {
        objectId: '31de563b-fc1a-43a2-9031-c47630038328'
        tenantId: tenantId
        permissions: {
          secrets: [
            'get'
            'list'
            'delete'
            'set'
            'recover'
            'backup'
            'restore'
          ]
        }
      }
    ]
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: tenantId
  }

  // secret
  resource kv_secretProductsApiEndpoint 'secrets' = {
    name: kvSecretNameProductsApiEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (fqdn) of the products api'
      value: 'placeholder' // Note: This will be set via github worfklow
    }
  }

  // secret 
  resource kv_secretProductsDbConnStr 'secrets' = {
    name: kvSecretNameProductsDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the products db'
      value: 'Server=tcp:${productsDbServerName}${sqlServerHostName},1433;Initial Catalog=${productsDbName};Persist Security Info=False;User ID=${productsDbServerAdminLogin};Password=${productsDbServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
    }
  }

  // secret 
  resource kv_secretProfilesDbConnStr 'secrets' = {
    name: kvSecretNameProfilesDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the profiles db'
      value: 'Server=tcp:${profilesDbServerName}${sqlServerHostName},1433;Initial Catalog=${profilesDbName};Persist Security Info=False;User ID=${profilesDbServerAdminLogin};Password=${profilesDbServerAdminPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
    }
  }

  // secret 
  resource kv_secretStocksDbConnStr 'secrets' = {
    name: kvSecretNameStocksDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the stocks db'
      value: stocksdba.listConnectionStrings().connectionStrings[0].connectionString
    }
  }

  // secret
  resource kv_secretCartsApiEndpoint 'secrets' = {
    name: kvSecretNameCartsApiEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (fqdn) of the carts api'
      value: cartsapiaca.properties.configuration.ingress.fqdn
    }
  }

  // secret
  resource kv_secretCartsInternalApiEndpoint 'secrets' =
    if (deployPrivateEndpoints) {
      name: kvSecretNameCartsInternalApiEndpoint
      tags: resourceTags
      properties: {
        contentType: 'endpoint url (fqdn) of the (internal) carts api'
        value: deployPrivateEndpoints ? cartsinternalapiaca.properties.configuration.ingress.fqdn : ''
      }
    }

  // secret
  resource kv_secretCartsDbConnStr 'secrets' = {
    name: kvSecretNameCartsDbConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the carts db'
      value: cartsdba.listConnectionStrings().connectionStrings[0].connectionString
    }
  }

  // secret
  resource kv_secretImagesEndpoint 'secrets' = {
    name: kvSecretNameImagesEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url of the images cdn'
      value: 'https://${cdnprofile_imagesendpoint.properties.hostName}'
    }
  }

  // secret
  resource kv_secretAppInsightsConnStr 'secrets' = {
    name: kvSecretNameAppInsightsConnStr
    tags: resourceTags
    properties: {
      contentType: 'connection string to the app insights instance'
      value: appinsights.properties.ConnectionString
    }
  }

  // secret
  resource kv_secretUiCdnEndpoint 'secrets' = {
    name: kvSecretNameUiCdnEndpoint
    tags: resourceTags
    properties: {
      contentType: 'endpoint url (cdn endpoint) of the ui'
      value: cdnprofile_ui2endpoint.properties.hostName
    }
  }

  // secret
  resource kv_secretVnetAcaSubnetId 'secrets' =
    if (deployPrivateEndpoints) {
      name: kvSecretNameVnetAcaSubnetId
      tags: resourceTags
      properties: {
        contentType: 'subnet id of the aca subnet'
        value: deployPrivateEndpoints ? vnet.properties.subnets[0].id : ''
      }
    }

  // access policies
  resource kv_accesspolicies 'accessPolicies' = {
    name: 'replace'
    properties: {
      // @TODO: I was unable to figure out how to assign an access policy to the AKS cluster's agent pool's managed identity.
      // Hence, that specific access policy will be assigned from a github workflow (using AZ CLI).
      accessPolicies: [
        {
          tenantId: tenantId
          objectId: userassignedmiforkvaccess.properties.principalId
          permissions: {
            secrets: ['get', 'list']
          }
        }
        {
          tenantId: tenantId
          objectId: aks.properties.identityProfile.kubeletidentity.objectId
          permissions: {
            secrets: ['get', 'list']
          }
        }
      ]
    }
  }
}

resource kv_roledefinitionforchaosexp 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: kv
  // This is the Key Vault Contributor role
  // See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#key-vault-contributor
  name: 'f25e0fa2-a7c8-4377-a976-54943a77a395'
}

resource kv_roleassignmentforchaosexp 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: kv
  name: guid(kv.id, chaoskvexperiment.id, kv_roledefinitionforchaosexp.id)
  properties: {
    roleDefinitionId: kv_roledefinitionforchaosexp.id
    principalId: chaoskvexperiment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource userassignedmiforkvaccess 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: userAssignedMIForKVAccessName
  location: resourceLocation
  tags: resourceTags
}

