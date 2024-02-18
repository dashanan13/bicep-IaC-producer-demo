targetScope='subscription'

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
The purpose of the resource group needs to be provded in a word or two :
- Use only letters and no spaces or hyphens or numbers
- A deailed description of the purpose can be provided for tags through another parameter
''')
@minLength(4)
@maxLength(10)
param purposeShort string


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

@description('Unique  Name for the resource')
//param resourceGroupName string = toLower('demo-${projectCode}-${envCode}-rg-${purposeShort}')
var resourceGroupName = toLower('demo-${projectCode}-${envCode}-rg-${purposeShort}')

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: {
    Owner : assetowner
    Purpose : detailedPurpose
    'Used by': ownerteam
    'Business criticality': criticality
    'Data classification': classification
    Template : 'Demo-Operations_IaC Resource group template'
  }
}

output resourcegroupId string = resourceGroup.id
output resourcegroupName string = resourceGroup.name
output resourcegroupobj object = resourceGroup
