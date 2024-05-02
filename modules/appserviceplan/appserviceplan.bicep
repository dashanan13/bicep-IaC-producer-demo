// Creates a Azure Ap Plan
//Version 0.2: added various tiers of plan capacity and zone redundancy capabilty added

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
  'app'
])
param plankind string

@description('''
Define the SKU family for the plan. 
Make sure that the plan name + SKU name combination is available.
Plan details and pricing at: https://azure.microsoft.com/en-us/pricing/details/app-service/windows/
''')
@allowed([
  'Free'
  'Basic'
  'Standard'
  'Premium v2'
  'Premium v3'
])
param plantier string

@description('''
Define the SPlan name in te said SKU family.
Make sure that the plan name + SKU name combination is available.
Plan details and pricing at: https://azure.microsoft.com/en-us/pricing/details/app-service/windows/

Allowed values for each tier listed below (allowed value restriction is not in place, use the list below)
Free: F1
Basic: B1, B2, B3
Standard: S1, S2, S3
Premium V2: P1V2, P2V2, P3V2
Premium V3: P0V3, P1V3, P2V3, P1mv3, P2mv3, P3mv3, P4mv3, P5mv3, P1mv3, P1mv3

''')
param planname string


@description('''
Set zone redundancy.
Free, Basic and Standard plans do not support redundanct, selecte False for these plans
Premium plans support redundancy.
''')
@allowed([
  false
  true
])
param zoneRedundant bool = false 


var productshort = ((plankind == 'linux') ? 'lsf' : 'wsf')
var reserved = ((plankind == 'linux') ? true : false)

@description('Unique name for the resource')
//var name = toLower('demo-${locationCode}-${projectCode}-${envCode}-akv-${sequence}')
var name = toLower('demo-${projectCode}-${envCode}-${productshort}-${locationCode}-${sequence}')
            


resource appserviceplan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  tags: {
    owner : assetowner
    'Plan type': plankind
    purpose : detailedPurpose
    'Used by': ownerteam
    'Business criticality': criticality
    'Data classification': classification    
    template : 'demo-Operations_IaC App Service Plan template'
  }
  sku: {
    name: planname
    tier: plantier
  }
  kind: plankind
  properties: {
    reserved: reserved
    zoneRedundant: zoneRedundant
  }
}

output appserviceplanId string = appserviceplan.id
output appserviceplanName string = appserviceplan.name
output appserviceplanObj object = appserviceplan
