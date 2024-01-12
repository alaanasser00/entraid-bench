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