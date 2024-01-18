function Check-SecurityDefaultStatus {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Ensure Security Defaults is disabled on Azure Active Directory"
        $controlDescription = "Security defaults provide secure default settings that are managed on behalf of organizations to keep customers safe until they are ready to manage their own identity security settings.
        For example, doing the following:
        • Requiring all users and admins to register for MFA.
        • Challenging users with MFA - mostly when they show up on a new device or app, but more often for critical roles and tasks.
        • Disabling authentication from legacy authentication clients, which can’t do MFA."

        # Get Security Defaults policy and check if it's disabled
        $securityDefaultsPolicy = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy | Select-Object -ExpandProperty IsEnabled

        if ($securityDefaultsPolicy -eq $true) {
            $controlFinding = "Security Defaults are enabled."
            $controlResult = "NOT COMPLIANT"
        }
        else {
            $controlFinding = "Security Defaults are disabled."
            $controlResult = "COMPLIANT"
        }

        return [PSCustomObject]@{
            Control            = $controlTitle
            ControlDescription = $controlDescription
            Finding            = $controlFinding
            Result             = $controlResult
        }

    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Usage in your scripts:
Check-SecurityDefaultStatus