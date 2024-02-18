// Creates a KeyVault 

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


@description('''
Define the Sensitivity of data hosted by this resource. :
''')
@allowed([
  'yes'
  'no'
])
param softdelete string = 'yes'

@description('Unique name for the resource')
//var name = toLower('demo-${locationCode}-${projectCode}-${envCode}-akv-${sequence}')
var name = toLower('demo-${projectCode}-${envCode}-akv-${locationCode}-${sequence}')
            


resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: name
  location: location
  tags: {
    owner : assetowner
    purpose : detailedPurpose
    'Used by': ownerteam
    'Business criticality': criticality
    'Data classification': classification
    template : 'Demo-Operations_IaC KeyVault template'
  }

  properties: {
    createMode: 'default'
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    // needs to be changed after testing to: 'enableSoftDelete: false'
    enableSoftDelete: softdelete == 'no' ? false : true
    enableRbacAuthorization: true
    enablePurgeProtection: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 7
    tenantId: subscription().tenantId
  }
}

output keyvaultId string = keyVault.id
output keyvaultName string = keyVault.name
