
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

@description('Name of the network that will contain this subnet')
param networkName string

@description('Group ID of the network security group')
param networkSecurityGroupId string

@description('Training subnet address prefix')
param subnetPrefix string

@description('Unique name for the virtual network subnet1')
//var subnetName = toLower('demo-${locationCode}-${projectCode}-${envCode}-snet-${sequence}')
var subnetName = toLower('demo-${projectCode}-${envCode}-snet-${locationCode}-${sequence}')


resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: networkName
}


resource symbolicname 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: subnetName
  parent: vnet
  properties: {
    addressPrefix: subnetPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'

    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
      }
      {
        service: 'Microsoft.ContainerRegistry'
      }
      {
        service: 'Microsoft.Storage'
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
  }
}
