# Install required AzureAD module


# Connect to Azure AD
# Connect
<# if ($([array](Get-MgContext)).'Count' -gt 0) {
    Disconnect-MgGraph
}
$null = Connect-MgGraph -Scopes ([string[]]('UserAuthenticationMethod.Read.All','User.ReadWrite.All')) -TenantId $TenantId -Environment 'Global' -ContextScope 'Process' #>
$null = Connect-MgGraph -Scopes ([string[]]('UserAuthenticationMethod.Read.All','User.Read.All','SecurityEvents.Read.All'))

# Connect-MgGraph -Scopes "Policy.Read.All"

# Variables

$compliant = "COMPLIANT"
$notcompliant = "NOT COMPLIANT"