// Creates a Function apps 
// version 0.2: Linux and Windows all languages and version working and container added
@description('''
Azure Region to deploy the resources into:
- West Europe:  westeurope
- North Europe: northeurope
- East Norway:  norwayeast
''')
@allowed([
  'westeurope'
  'northeurope'
  'norwayeast'
])
param location string

@description('''
Azure Region code for naming the resource:
- West Europe:  WEU
- North Europe: NEU
- East Norway:  NOE
''')
@allowed([
  'weu'
  'neu'
  'noe'
])
param locationCode string

@description('''
Project or team code for the team that will use the RG, pick the 3 character code from the list below:
(In case your team name is missing, contact Mohit.Sharma@atea.no)
- TEAM1:  TEM1
- TEAM2:  TEM2
- TEAM3:  TEM3
- TEAM4:  TEM4
- TEAM5:  TEM5
''')
@allowed([
  'TEM1'
  'TEM2'
  'TEM3'
  'TEM4'
  'TEM5'
])
param projectCode string

@description('''
Environment of the resources, test QA  dev or prod:
- Development:  dev
- Testing:  test
- Quality assurance: qa
- Production:    prod
''')
@allowed([
  'dev'
  'test'
  'qa'
  'prod'
])
param envCode string

@description('''
A sequence is used ot make a resource name unique such that similar names do not break deployments
This also keeps the length of the resource name in check by avoiding arbitary length description string at the end
Sequence is 3 digit and starts at 001 and could go upto 999
''')
@minLength(3)
@maxLength(10)
param sequence string

@description('''
This parameter takes the name or names of the people who ordered this resource.
It is used a contact point for more information or clarrification related to this resource
''')
@minLength(5)
@maxLength(250)
param assetowner string

@description('''
This parameter takes a detailed account of the purpose.
Write a detailed description of a maximun length of 250 characters
''')
@minLength(20)
@maxLength(250)
param detailedPurpose string

@description('''
Project or team name for the team that will use the RG, pick the 3 character code from the list below:
(In case your team name is missing, contact Mohit.Sharma@atea.no)
''')
@allowed([
  'TEAM1'
  'TEAM2'
  'TEAM3'
  'TEAM4'
  'TEAM5'
])
param ownerteam string

@description('''
Define the Business impact of the resource or supported workload.
''')
@allowed([
  'Low'
  'Medium'
  'High'
  'Business unit-critical'
  'Mission-critical'
])
param criticality string


@description('''
Define the Sensitivity of data hosted by this resource. :
''')
@allowed([
  'Non-business'
  'Public'
  'General'
  'Confidential'
  'Highly confidential'
])
param classification string

@description('''
Define the Sensitivity of data hosted by this resource. :
''')
@allowed([
  'linux'
  'windows'
])
param appkind string

@description('''
Declares the App service plan ID that needs to host this functionApp.
''')
param appServicePlanId string


@description('''
Declares the Storage account name needed to be associated with function app.
''')
param storageAccountName string

@description('''
Declares the Storage account id needed to be associated with function app.
''')
param storageAccountID string


@description('''
Declares the SubscriptionID of the subscription holding the stroage account.
''')
param storageSubID string


@description('''
Declares the Resource Group name in the subscription holding the stroage account.
''')
param storageRG string

@description('''
Declares the Appplication Insight Object Instrumentation Key that needed to be associated with function app.
''')
param appInsghtInstKey string

@description('''
Set public access policy for the function app.
''')
@allowed([
  'Enabled' 
  'Disabled' 
])
param publicNetworkAccess string = 'Disabled'


@description('''
Set version of base .net for Windows, this is not the version of .net so its common for all windows plan for every language.
''')
param netVersionbase string

@description('''
Set version of .net for Windows, for linux plan it can be set to an empty string.
This is usually in format:  <version>, and needs to be in single quotes.
Examples like
dotnet: 'v8.0'
node: '~18'
java: '17'
powershellcore: '7.2'
Custom: ''
''')
param netVersionwin string

@description('''
Set version of .net. for Linux and is needed only for a linux plan, for windows plan it can be set to an empty string.
This is usually in format:  <language|version>, and needs to be in single quotes.
Example: 
'Node|16'
'DOTNET-ISOLATED|7.0'
'Python|3.11'
'Java|17'
'PowerShell|7.2
Custom: ''
Container: "DOCKER|mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart"
''')
param netVersionlnx string

@description('''
Set if 32 bit workers are tobe used or 64 bit
Only 32 bit is supported now.
''')
@allowed([
  true 
  false 
])
param use32BitWorkerProcess bool = true



var siteconfigdotnetwin = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED'
      value: '1'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'dotnet-isolated'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess
  publicNetworkAccess: publicNetworkAccess
  netFrameworkVersion: netVersionwin
}

var siteconfigdotnetlnx = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED'
      value: '1'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'dotnet-isolated'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess
  publicNetworkAccess: publicNetworkAccess
  linuxFxVersion: netVersionlnx
}

var siteconfignodewin = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'WEBSITE_NODE_DEFAULT_VERSION'
      value: netVersionwin
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'node'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  netFrameworkVersion: netVersionbase
}

var siteconfignodelnx = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'node'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  linuxFxVersion: netVersionlnx
}

// Python runtime onle available for Linux, not windows
var siteconfigpythonlnx = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'python'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  linuxFxVersion: netVersionlnx
}

var siteconfigjavawin = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'java'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  javaVersion: netVersionwin
  netFrameworkVersion: netVersionbase
}

var siteconfigjavalnx = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'java'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  linuxFxVersion: netVersionlnx
}

var siteconfigpwrslcorewin = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'powershell'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  powerShellVersion: '7.2'
  netFrameworkVersion: netVersionbase
}

var siteconfigpwrslcorelnx = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'powershell'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  linuxFxVersion: netVersionlnx
}

var siteconfigcustomwin = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'custom'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  netFrameworkVersion: netVersionbase
}

var siteconfigcustomlnx = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'FUNCTIONS_WORKER_RUNTIME'
      value: 'custom'
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
}

var siteconfigcontainerlnx = {
  appSettings: [
    {
      name: 'FUNCTIONS_EXTENSION_VERSION'
      value: '~4'
    }
    {
      name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
      value: appInsghtInstKey
    }
    {
      name: 'AzureWebJobsStorage'
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=listKeys(${storageAccountID}).keys[0].value'
    }
    {
      name: 'DOCKER_REGISTRY_SERVER_URL'
      value: 'https://mcr.microsoft.com'
    }
    {
      name: 'DOCKER_REGISTRY_SERVER_USERNAME'
      value: ''
    }
    {
      name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
      value: null
    }
    {
      name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
      value: false 
    }
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  http20Enabled: false
  alwaysOn: true
  use32BitWorkerProcess: use32BitWorkerProcess 
  publicNetworkAccess: publicNetworkAccess
  linuxFxVersion: netVersionlnx
}


@description('''
Set deployment language needed.
Windows suuports: dotnet, node, java, powershellcore, custom
Linux suuports: dotnet, node, java, powershellcore, python, custom
''')
param selectedlanguage string


var selectedconfigwin = ((selectedlanguage == 'dotnet') ? siteconfigdotnetwin : ((selectedlanguage == 'node') ? siteconfignodewin : ((selectedlanguage == 'java') ? siteconfigjavawin : ((selectedlanguage == 'powershellcore') ? siteconfigpwrslcorewin : siteconfigcustomwin))))
var selectedconfiglnx = ((selectedlanguage == 'dotnet') ? siteconfigdotnetlnx : ((selectedlanguage == 'node') ? siteconfignodelnx : ((selectedlanguage == 'java') ? siteconfigjavalnx : ((selectedlanguage == 'powershellcore') ? siteconfigpwrslcorelnx : ((selectedlanguage == 'python') ? siteconfigpythonlnx : ((selectedlanguage == 'container') ? siteconfigcontainerlnx : siteconfigcustomlnx))))))

var productshort = ((appkind == 'linux') ? 'lfn' : 'wfn')
var fnkind = ((appkind == 'linux') ? 'functionapp,linux' : 'functionapp')
var selectedconfig = ((appkind == 'linux') ? selectedconfiglnx : selectedconfigwin)

@description('Unique name for the resource')
//var name = toLower('demo-${locationCode}-${projectCode}-${envCode}-akv-${sequence}')
var name = toLower('demo-${projectCode}-${envCode}-${productshort}-${locationCode}-${sequence}')


resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: name
  location: location
  tags: {
    owner : assetowner
    'FunctionApp type': appkind
    purpose : detailedPurpose
    'Used by': ownerteam
    'Business criticality': criticality
    'Data classification': classification    
    template : 'demo-Operations_IaC Function App template'
  }
  kind: fnkind
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: selectedconfig
    httpsOnly: true
  }
}


output functionAppId string = functionApp.id
output functionAppName string = functionApp.name
output fnnetVersionlnx string = netVersionlnx

