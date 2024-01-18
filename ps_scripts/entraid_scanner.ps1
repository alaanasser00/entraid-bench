# Install required AzureAD module
Import-Module Microsoft.Graph

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

# Specify the path to your script files
$scriptPath = "./controls"  # Replace with the actual path

# List available function names
$functionNames = Get-ChildItem -Path $scriptPath -Filter *.ps1 | ForEach-Object { $_.BaseName }

# Map control file names to titles
$functionTitleMappings = @{
    # Add mappings here (replace with your actual function names and desired titles)
    "Check-authenticationStrength" = "Ensure 'Phishing-resistant MFA strength' is required for Administrators"
    "Check-BannedPasswords" = "Ensure custom banned passwords lists are used"
    "Check-BlockNonAdminTenantCreation" = "Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes'"
    "Check-DynamicGroupForGuestUsers" = "Ensure a dynamic group for guest users is created"
    "Check-MicrosoftAuthenticatorFatigue" = "Ensure Microsoft Authenticator is configured to protect against MFA fatigue"
    "Check-OnPremisesSync" = "Ensure that password hash sync is enabled for hybrid deployments"
    "Check-PermanentActiveAssignments" = "Ensure 'Privileged Identity Management' is used to manage roles"
    "Check-SecurityDefaultStatus" = "Ensure Security Defaults is disabled on Azure Active Directory"
}

# Display control menu
<# Write-Host "Select the control you want to use:"
for ($i = 0; $i -lt $functionNames.Count; $i++) {
    Write-Host "$(($i + 1))- $($functionNames[$i])"
}
Write-Host "------------------------------------------------"
Write-Host "0- Run All Controls" #>

# Get user choice
$choice = Read-Host "Enter your choice (number):"

# Initialize progress bar parameters
$totalControls = $functionNames.Count
$completedControls = 0


# Validate and execute the chosen function(s)
<# if ($choice -eq 0) { #>
    $allResults = @()

    foreach ($functionName in $functionNames) {
        $functionTitle = $functionTitleMappings[$functionName]

            # Update progress bar
            $completedControls++
            # Clear previous progress bar line
            Write-Host "`r" -NoNewline
            # Create a simple progress bar using characters
            $progressBar = '=' * $completedControls + ' ' * (20 - $completedControls)
            Write-Host "Checking Control: $progressBar ($completedControls of 20): $functionTitle"

        $currentResults = . "$scriptPath\$functionName.ps1" | Select Control, ControlDescription, Finding, OnPremisesSyncEnabled, LastSyncDateTime, DynamicGroupName, DynamicGroupTypes, DynamicGroupMembershipRule, Result
        $allResults += $currentResults  # Append results to the array
        
    }

    $allResults | Export-Csv -Path "scan_results.csv" -NoTypeInformation
    Write-Host "All results combined and exported to scan_results.csv"

<# } else {
    if ($choice -in 1..$functionNames.Count) {
        $functionToRun = $functionNames[$choice - 1]
        . "$scriptPath\$functionToRun.ps1" | Select Control, ControlDescription, Finding, OnPremisesSyncEnabled, LastSyncDateTime, DynamicGroupName, DynamicGroupTypes, DynamicGroupMembershipRule, Result | Export-Csv -Path ("$functionToRun.csv") -NoTypeInformation
        Write-Host "Results exported to $scriptPath\$functionToRun.csv"
    } else {
        Write-Host "Invalid choice. Please try again."
    }
} #>