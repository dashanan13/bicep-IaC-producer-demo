# bicep-IaC-producer-demo
 
# Introduction 
This repo is dedcated to create shared IaC bicep moddules for use by projects.


Naming convention: demo-< project code >< environment code >< product code>< location code >< 3-10 character sequence, example: 001 >

<TODO> The standards and abbriviations will be published soon
Example:  the container registry name noeacrsiac001p can be broken into
noe=norway east, 
acr=azure container registry, 
siac=shared Iac, 
001=sequence, 
p=production

Established as:
Step 1: Basic setup
- Set-AzContext <it-sub>
- Set-AzDefault -ResourceGroupName RG-Management
- New-AzContainerRegistry -Name noeacrsiac001p -Sku Basic -Location norwayeast #noe=norway east, acr=azure container registry, siac=shared Iac, 001=sequence, p=production

Step 2: 
- Setup repo structure such that it is as: modules/< resource name >/< resource bicep file, resource version file and resource test/publish pipeline >

Step 3: 
- Setup pipeline in Azure Pipelines and and test



# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Permissions needed for each project to use the templates: 
    - Setup a service connection to the subscription that will receive the deployment
    - Provide the service prinmciple created with "AcrPull" permission over  Container registry: noeacrsiac001p
    - Provide the team group or team users with "AcrPull" and "Reader" permission over  Container registry: noeacrsiac001p, this will help in autocomplete in editors 
    while using modules
    - All of this achived by membership to AAD Group: Azure_IaC_Readers
2.	Permissions needed for  IT to author templates
    - Contributor permission over repo
    - Contributor permission, "AcrPush" and "AcrPull" permission over Container registry
    - All of this could be achived by membership to AAD Group: Azure_IaC_Publishers
3.  Software dependencies
    - Visual studio code
    - Bicep cli and addons
    - Azure Devops
3.	Latest releases
    - Azure Storage Account: 0.1
    - Azure Virtual Machine: 0.1
    - Azure SQL database: 0.1
    - Azure Keyvault: 0.1
    - Azure WebApps: 0.1

# Resources
Sample usage template to use modules under repository subfolder testing
More resources to learn: 
- https://learn.microsoft.com/en-us/training/browse/?terms=BICEP&resource_type=learning%20path 
- https://github.com/MicrosoftDocs/azure-docs/tree/main/articles/azure-resource-manager/bicep
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules 
- https://www.rickroche.com/2021/07/bicep-modules-refactor-compose-reuse/ 
- Markdown reference: https://learn.microsoft.com/en-us/azure/devops/project/wiki/markdown-guidance?view=azure-devops#lists

Template references: https://github.com/Azure/azure-quickstart-templates/tree/master 

Naming convention document: 

- Cloud Adoption framework reference: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging 

# Short code list:
1. TEAMS::
    - CRM:  CRM
    - FDB:  FDB <facilitated by autofacet>
    - Next: NXT <facilitated by autofacet>
    - Power:    PWR
    - Sales:    SLS <facilitated by autofacet>
    - Hercules: HRC <facilitated by autofacet>
    - Viking:   VIK

    - Autofacet:    AFT   <Need to be removed and updated on tempaltes, this is a company and will be replaced by products, talked ot Urvil Kaswala about this>
    - DARS: DRS
    - Service Contract/Agreement: SAC <TBD code>
    - Package portal: PKP 

    - Platform: PTF
    - Logistics:    LOG
    - Fleet sales:  FSL
    - Integrasjon:  INT
    - Inhouse architect:    IAR
    - LastBill og Bus:  LBB
    - Business Intelligence:    BUI
    - Master data managment:    MDM


2. LOCATIONS::
    - West Europe:  WEU
    - North Europe: NEU
    - East Norway:  NOE


3. PRODUCTS (3-5 characters)::
    
    The product codes try to align with Microsoft recomendations: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations

    Exceptions are taken when the resources need more nuanced product naming code.
    The exceptions are listed below-

    - App service plan: 	asp  > 'lsf' : 'wsf'
    - Function App: func > 'lfn' : 'wfn'
    - Keyvault: kv > akv
    - Log Analytics workspace: log > law
    - Storage account: sa > asa
    - WebApp: app > 'lwa' : 'wwa'

