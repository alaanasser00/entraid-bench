# NOT WORKING, PER USER MFA FEATURE IS NOT AVAILABLE IN MS GRAPH API

function Check-PerUserMFA {
    [CmdletBinding()]
    param()

    Write-Output "------------------------------------------------------------------------"
    Write-Output "5.1.2.1 (L1) Ensure 'Per-user MFA' is disabled"
    Write-Output "------------------------------------------------------------------------`n"

    try {

        $controlTitle = "5.1.2.1 (L1) Ensure 'Per-user MFA' is disabled"
        $controlDescription = "Legacy per-user Multi-Factor Authentication (MFA) can be configured to require individual users to provide multiple authentication factors, such as passwords and additional verification codes, to access their accounts. It was introduced in earlier versions of Office 365, prior to the more comprehensive implementation of Conditional Access (CA)"

        $allUsers = Get-MgUser -All

        $mfaobject = foreach ($user in $allUsers) {
            $mfaStatus = "Disabled"
            if ($null -ne $user.Id) {
                $mfaMethods = Get-MgUserAuthenticationMethod -UserId $user.Id
                if ($null -ne $mfaMethods -and $mfaMethods.Count -gt 0) {
                    $mfaStatus = "Enabled"
                }
            }

            $compliant = "Compliant"
            $notcompliant = "Not Compliant"

            [PSCustomObject]@{
                DisplayName       = $user.DisplayName
                UserPrincipalName = $user.UserPrincipalName
                "MFA Status"      = $mfaStatus
                Compliance        = if ($mfaStatus -eq "Enabled") { $notcompliant } else { $compliant }
            }
        }

        $mfaobject | Export-Csv -Path "UserMFAStatus.csv" -NoTypeInformation
    }

    catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Check-PerUserMFA