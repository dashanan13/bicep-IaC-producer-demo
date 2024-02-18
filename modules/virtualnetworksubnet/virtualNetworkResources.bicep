
// Common parameters
param envCode string
param location string
param ownerteam string
param assetowner string
param criticality string
param projectCode string
param locationCode string
param classification string
// Parameters specific to KV
param detailedPurposeNSG string
param sequenceNSG string
// Parameters specific to NSG
param detailedPurposeVNET string
param sequenceVNET string
// Parameters specific to VNet
param sequenceVSNET string
param vnetAddressPrefix string
param subnetPrefix string


module stgnsg 'br:templatestore13.azurecr.io/networksecuritygroup:0.1.20240129.5' = {
  name: 'random_nsg'
  params: {
    assetowner: assetowner
    classification: classification
    criticality: criticality
    detailedPurpose: detailedPurposeNSG
    envCode: envCode
    location: location
    locationCode: locationCode
    ownerteam: ownerteam
    projectCode: projectCode
    sequence: sequenceNSG
  }
}

module stgvnet 'br:templatestore13.azurecr.io/virtualnetwork:0.1.20240129.5' = {
  name: 'random_vnet'
  params: {
    assetowner: assetowner
    classification: classification
    criticality: criticality
    detailedPurpose: detailedPurposeVNET
    envCode: envCode
    location: location
    locationCode: locationCode
    ownerteam: ownerteam
    projectCode: projectCode
    sequence: sequenceVNET
    vnetAddressPrefix: vnetAddressPrefix
  }
}

module stgsubnet 'br:templatestore13.azurecr.io/virtualnetworksubnet:0.1.20240129.5' = {
  name: 'random_svnet'
  params: {
    envCode: envCode
    locationCode: locationCode
    networkName: stgvnet.outputs.virtualNetworkName
    networkSecurityGroupId: stgnsg.outputs.networkSecurityGroupId
    projectCode: projectCode
    sequence: sequenceVSNET
    subnetPrefix: subnetPrefix
  }
}
