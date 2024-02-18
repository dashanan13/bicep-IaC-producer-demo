// Creates a storage account, private endpoints and DNS zones
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
@maxLength(3)
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

@description('SQL administrator users name')
@secure()
param administratorLogin string

@description('SQL administrator users password')
@secure()
param administratorLoginPassword string 


@description('''
Public Endpoints allow access to this resource through the internet using a public IP address. 
An application or resource that is granted access with the following network rules still requires proper authorization to access this resource
''')
param publicNetworkAccess string = 'Disabled'


@description('''
Restrict network access to a specific set of resources by supplying their fully-qualified domain names
Whether or not to restrict outbound network access for this server. 
Value is optional but if passed in, must be 'Enabled' or 'Disabled'
''')
param restrictOutboundNetworkAccess string = 'Disabled'

@description('Sets if the resource allows Azure AD auth or SQL or both')
param azureADOnlyAuthentication bool = false

@description('SQL server version, check product home page for other values')
param version string = '12.0'

@description('''
Azure AD principle type for administration, user or group or application. 
Other options will be evaluated in next versions.
Currently Group is supported.
''')
param principalType string = 'Group'

@description('Azure AD Group name tat will be used for administration')
param aadadminlogin string


@description('''
Azure AD Group SID tat will be used for administration
This can be obtained from Azure AD groups
''')
param aadadminloginsid string

@description('Azure Tenent ID')
param tenantId string

@description('SQL server TLS version to use')
param minimalTlsVersion string = '1.2'


@description('Unique name for the resource')
//var name = toLower('demo-${locationCode}-${projectCode}-${envCode}-asa-${sequence}')
var name = toLower('demo-${projectCode}-${envCode}-sqs-${locationCode}-${sequence}')
var storageNameCleaned = replace(name, '-', '')


resource sqlserver 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: storageNameCleaned
  location: location
  tags: {
    owner : assetowner
    purpose : detailedPurpose
    'Used by': ownerteam
    'Business criticality': criticality
    'Data classification': classification
    template : 'Demo-Operations_IaC storage account template'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: azureADOnlyAuthentication
      principalType: principalType
      login: aadadminlogin
      sid: aadadminloginsid
      tenantId: tenantId
    }
    minimalTlsVersion: minimalTlsVersion
    publicNetworkAccess: publicNetworkAccess
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    version: version
  }

}






output sqlserverId string = sqlserver.id
output sqlserverName string = sqlserver.name
