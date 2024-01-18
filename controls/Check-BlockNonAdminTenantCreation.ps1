function Check-BlockNonAdminTenantCreation {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes'"
        $controlDescription = "Restricting tenant creation prevents unauthorized or uncontrolled deployment of resources and ensures that the organization retains control over its infrastructure. User generation of shadow IT could lead to multiple, disjointed environments that can make it difficult for IT to manage and secure the organization's data, especially if other users in the organization began using these tenants for business purposes under the misunderstanding that they were secured by the organization's security team."
    
        # Get Default User Role Permissions
        $defaultUserRolePermissions = (Get-MgPolicyAuthorizationPolicy).DefaultUserRolePermissions

        # Check if 'Restrict non-admin users from creating tenants' is set to 'Yes'
        $allowedToCreateTenants = $defaultUserRolePermissions | Select-Object -ExpandProperty AllowedToCreateTenants

        if ($allowedToCreateTenants -eq "Yes") {
            $controlFinding =  "Non-admin users are restricted from creating tenants"
            $controlResult = "COMPLIANT"
        } else {
            $controlFinding =  "Non-admin users are NOT restricted from creating tenants"
            $controlResult = "NOT COMPLIANT"
        }

        return [PSCustomObject]@{
            Control               = $controlTitle
            ControlDescription    = $controlDescription
            Finding               = $controlFinding
            Result                = $controlResult
        }

    } catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Check-BlockNonAdminTenantCreation