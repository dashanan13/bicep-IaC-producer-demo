// create public IP address

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
This parameter takes the name of theresource that this resource is intended for to be attached
''')
@minLength(5)
@maxLength(25)
param attachedto string

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIpAddressType string = 'Static'

@description('Unique  Name for the resource')
//var name = toLower('demo-${locationCode}-${projectCode}-${envCode}-pip-${sequence}')
var name = toLower('demo-${projectCode}-${envCode}-pip-${locationCode}-${sequence}')

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${attachedto}-${uniqueString(resourceGroup().id, attachedto)}')

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: name
  location: location
  tags: {
    owner : assetowner
    Purpose : detailedPurpose
    'Used by': ownerteam
    'Business criticality': criticality
    'Data classification': classification
    template : 'Demo-Operations_IaC Public IP template'
  }
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIpAddressType
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

output publicipid string = publicIp.id
output publicipname string = publicIp.name
