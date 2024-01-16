function Check-OnPremisesSync {
    [CmdletBinding()]
    param()

    Write-Output "------------------------------------------------------------------------"
    Write-Output "5.1.8.1 (L1) Ensure that password hash sync is enabled for hybrid deployments"
    Write-Output "------------------------------------------------------------------------`n"

    try {

        $controlTitle = "5.1.8.1 (L1) Ensure that password hash sync is enabled for hybrid deployments"
        $controlDescription = "Password hash synchronization helps by reducing the number of passwords your users need to maintain to just one and enables leaked credential detection for your hybrid accounts. Leaked credential protection is leveraged through Azure AD Identity Protection and is a subset of that feature which can help identify if an organization's user account passwords have appeared on the dark web or public spaces. Using other options for your directory synchronization may be less resilient as Microsoft can still process sign-ins to 365 with Hash Sync even if a network connection to your on-premises environment is not available."
    
        $organization = Get-MgOrganization
        $OnPremisesSyncEnabled = $organization.OnPremisesSyncEnabled
        $OnPremisesLastSyncDateTime = $organization.OnPremisesLastSyncDateTime

        if ($OnPremisesSyncEnabled) {
            $controlFinding = "On-Premises Sync is enabled."
            $complianceResult = "COMPLIANT"
        } else {
            $controlFinding = "On-Premises Sync is not enabled."
            $complianceResult = "NOT COMPLIANT"
        }

        return [PSCustomObject]@{
            Control               = $controlTitle
            ControlDescription    = $controlDescription
            Finding               = $controlFinding
            OnPremisesSyncEnabled = $OnPremisesSyncEnabled
            LastSyncDateTime      = $OnPremisesLastSyncDateTime
            Result                = $complianceResult
        }
    
    } catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
. ../scanner.ps1

Check-OnPremisesSync | Format-List