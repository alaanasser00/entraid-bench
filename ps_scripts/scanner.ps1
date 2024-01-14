# Install required AzureAD module
# Import-Module Microsoft.Graph

# Connect to Entra ID
<# if ($([array](Get-MgContext)).'Count' -gt 0) {
    Disconnect-MgGraph
}
$null = Connect-MgGraph -Scopes ([string[]]('UserAuthenticationMethod.Read.All','User.ReadWrite.All')) -TenantId $TenantId -Environment 'Global' -ContextScope 'Process' #>
$null = Connect-MgGraph -Scopes ([string[]](
    'UserAuthenticationMethod.Read.All',
    'User.Read.All',
    'SecurityEvents.Read.All', 
    'Policy.Read.All',
    'RoleManagement.Read.All'))


# Variables

$compliant = "COMPLIANT"
$notcompliant = "NOT COMPLIANT"