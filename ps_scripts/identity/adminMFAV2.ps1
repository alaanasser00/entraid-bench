# [START CONTROL] 5.2.2.1 (L1) Ensure multifactor authentication is enabled for all users in administrative roles
Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.2.2.1 (L1) Ensure multifactor authentication is enabled for all users in administrative roles"


$controlScores = Get-MgSecuritySecureScore | Select-Object -First 1 -ExpandProperty ControlScores
$AdminMFAV2 = $controlScores | Where-Object { $_.ControlName -eq 'AdminMFAV2' }

$AdminMFAV2_AddProperties = $AdminMFAV2.AdditionalProperties['implementationStatus']

Write-Output $AdminMFAV2_AddProperties | fl

$AdminMFAV2_Score = $AdminMFAV2.AdditionalProperties['scoreInPercentage']

if ($AdminMFAV2_Score -eq "100" -Or $AdminMFAV2_Score -eq "100.00") {
    $AdminMFAV2_ScoreResult =  $compliant
} else {
    $AdminMFAV2_ScoreResult =  $notcompliant
}

Write-Output "--------------------------------------"
Write-Output "Result: $AdminMFAV2_ScoreResult"


Write-Output "-----------------------------------------------------------------------------"
# [END CONTROL] 5.2.2.1 (L1) Ensure multifactor authentication is enabled for all users in administrative roles