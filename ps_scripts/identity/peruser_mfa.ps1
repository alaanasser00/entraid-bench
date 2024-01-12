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