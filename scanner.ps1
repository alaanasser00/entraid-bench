# Install required AzureAD module


# Connect to Azure AD
# Connect
<# if ($([array](Get-MgContext)).'Count' -gt 0) {
    Disconnect-MgGraph
}
$null = Connect-MgGraph -Scopes ([string[]]('UserAuthenticationMethod.Read.All','User.ReadWrite.All')) -TenantId $TenantId -Environment 'Global' -ContextScope 'Process'
$null = Connect-MgGraph -Scopes ([string[]]('UserAuthenticationMethod.Read.All','User.Read.All')) #>

# Connect-MgGraph -Scopes "Policy.Read.All"

# Variables

$compliant = "COMPLIANT"
$notcompliant = "NOT COMPLIANT"

# [START CONTROL] 5.1.1.1 (L1) Ensure Security Defaults is disabled on Azure Active Directory

Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.1.1.1 (L1) Ensure Security Defaults is disabled on Azure Active Directory"

# Get Security Defaults policy and check if it's disabled
$securityDefaultsPolicy = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy | Select-Object -ExpandProperty IsEnabled


if ($securityDefaultsPolicy -eq $true) {
    $securityDefaultsPolicyResult = "$notcompliant, Security Defaults are enabled."
} else {
    $securityDefaultsPolicyResult = "$compliant, Security Defaults are disabled."
}
Write-Output "-------------------"
Write-Output "Result: $securityDefaultsPolicyResult"


Write-Output "-----------------------------------------------------------------------------"

# [END CONTROL] 5.1.1.1 (L1) Ensure Security Defaults is disabled on Azure Active Directory


# [START CONTROL] 5.1.2.3 (L1) Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes' 

Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.1.2.3 (L1) Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes' "


# Get Default User Role Permissions
$defaultUserRolePermissions = (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions

# Check if 'Restrict non-admin users from creating tenants' is set to 'Yes'
$allowedToCreateTenants = $defaultUserRolePermissions | Select-Object -ExpandProperty AllowedToCreateTenants

if ($allowedToCreateTenants -eq "Yes") {
    $allowedToCreateTenantsResult =  "$compliant, Restrict non-admin users from creating tenants' is set to 'Yes'."
} else {
    $allowedToCreateTenantsResult =  "$notcompliant, Restrict non-admin users from creating tenants' is not set to 'Yes'."
}


Write-Output "-------------------"
Write-Output "Result: $allowedToCreateTenantsResult"


Write-Output "-----------------------------------------------------------------------------"


# [END CONTROL] 5.1.2.3 (L1) Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes' 




# [START CONTROL] 5.1.3.1 (L1) Ensure a dynamic group for guest users is created

Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.1.3.1 (L1) Ensure a dynamic group for guest users is created"
# Get all groups with dynamic membership
$groups = Get-MgGroup | Where-Object { $_.GroupTypes -contains "DynamicMembership" }

# Filter dynamic groups for guest users
$guestDynamicGroups = $groups | Where-Object { $_.MembershipRule -like "*user.userType -eq `"`Guest`"*" }
$allUsersDynamicGroups = $groups | Where-Object { $_.MembershipRule -notlike "*user.userType -eq `"`All Users`"*" }

Write-Output "-------------------"

if ($guestDynamicGroups) {
    Write-Output "Result: $compliant, dynamic group for guest users found."
    $guestDynamicGroups | Format-Table DisplayName, GroupTypes, MembershipRule
} elseif ($allUsersDynamicGroups) {
    Write-Output "Result: $compliant, dynamic group for all users found."
    Write-Output $allUsersDynamicGroups | Format-Table DisplayName, GroupTypes, MembershipRule
} else {
    Write-Output "Result: $notcompliant, no dynamic group for guest users found."
    Write-Output $notguestDynamicGroups | Format-Table DisplayName, GroupTypes, MembershipRule
}


# [END CONTROL] 5.1.3.1 (L1) Ensure a dynamic group for guest users is created


# [START CONTROL] 5.1.2.1 (L1) Ensure 'Per-user MFA' is disabled

Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.1.2.1 (L1) Ensure 'Per-user MFA' is disabled"

$allUsers = Get-MgUser -All

foreach ($user in $allUsers) {
    $mfaStatus = "Disabled"
    if ($null -ne $user.Id) {
        $mfaMethods = Get-MgUserAuthenticationMethod -UserId $user.Id
        if ($null -ne $mfaMethods -and $mfaMethods.Count -gt 0) {
            $mfaStatus = "Enabled"
        }
    }
    $customObject = [PSCustomObject]@{
        DisplayName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        "MFA Status" = $mfaStatus
    }
    if ($mfaStatus -eq "Enabled") {
        $customObject | Add-Member -NotePropertyName "Compliance" -NotePropertyValue $notcompliant
    } else {
        $customObject | Add-Member -NotePropertyName "Compliance" -NotePropertyValue $compliant
    }
    $customObject
}

# [END CONTROL] 5.1.2.1 (L1) Ensure 'Per-user MFA' is disabled