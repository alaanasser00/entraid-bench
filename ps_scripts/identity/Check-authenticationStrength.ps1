
function Check-AuthenticationStrength {
    [CmdletBinding()]
    param()

    Write-Output "------------------------------------------------------------------------`n"
    Write-Output "5.2.2.5 (L2) Ensure 'Phishing-resistant MFA strength' is required for Administrators (Manual)`n"

    try {

    $controlTitle = "5.2.2.5 (L2) Ensure 'Phishing-resistant MFA strength' is required for Administrators (Manual)"
    $controlDescription = "Authentication strength is a Conditional Access control that allows administrators to specify which combination of authentication methods can be used to access a resource. For example, they can make only phishing-resistant authentication methods available to access a sensitive resource. But to access a non-sensitive resource, they can allow less secure multifactor authentication (MFA) combinations, such as password + SMS. Microsoft has 3 built-in authentication strengths. MFA strength, Passwordless MFA strength, and Phishing-resistant MFA strength. Ensure administrator roles are using a CA policy with Phishing-resistant MFA strength."

        # Retrieve all Conditional Access policies
        $policies = Get-MgIdentityConditionalAccessPolicy | Sort-Object DisplayName

        foreach ($policy in $policies) {
            $authenticationStrength = $policy.GrantControls.AuthenticationStrength

            if ($authenticationStrength.id -eq "00000000-0000-0000-0000-000000000004") {
                # Phishing-resistant MFA Authentication strength is enabled, output details and stop
                $policyDetails = [PSCustomObject]@{
                    Control                  = $controlTitle
                    ControlDescription       = $controlDescription
                    DisplayName              = $policy.DisplayName
                    Id                       = $policy.Id
                    ModifiedDateTime         = $policy.ModifiedDateTime
                    State                    = $policy.State
                    Finding                  = "Phishing-resistant MFA strength is enabled for administrators"
                    AuthenticationStrength   = $authenticationStrength.DisplayName
                    AuthenticationStrengthId = $authenticationStrength.id
                    Result                   = "COMPLIANT"
                }
                Write-Output $policyDetails
                return  # Stop processing further policies
            }
        }

        # No policies with phishing-resistant MFA strength found for administrators
        $controlFinding = "No policies with phishing-resistant MFA strength found for administrators."

        $outputControlScore = [PSCustomObject]@{
            Control               = $controlTitle
            ControlDescription    = $controlDescription
            Finding               = $controlFinding
            Result                = "NOT COMPLIANT"
        }
    
        return $outputControlScore
    } catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
. ../scanner.ps1

Check-authenticationStrength | Format-List