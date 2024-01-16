# Install required AzureAD module
# Import-Module Microsoft.Graph

# Function to prompt for authentication and connect to Graph
function Connect-ToGraph {
    # Prompt for credentials if not already connected
    if (-not (Get-MgContext)) {
        Connect-MgGraph -Scopes ([string[]](
            'UserAuthenticationMethod.Read.All', 
            'User.Read.All', 
            'SecurityEvents.Read.All', 
            'Policy.Read.All', 
            'RoleManagement.Read.All', 
            'AccessReview.Read.All'))
    }
}

Connect-ToGraph

# Variables

$compliant = "COMPLIANT"
$notcompliant = "NOT COMPLIANT"