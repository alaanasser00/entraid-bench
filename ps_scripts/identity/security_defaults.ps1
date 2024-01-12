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