# [START CONTROL] 5.1.2.2 (L2) Ensure third party integrated applications are not allowed
Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.1.2.2 (L2) Ensure third party integrated applications are not allowed "


$controlScores = Get-MgSecuritySecureScore | Select-Object -First 1 -ExpandProperty ControlScores
$aad_third_party_apps = $controlScores | Where-Object { $_.ControlName -eq 'aad_third_party_apps' }

$aad_third_party_apps_AddProperties = $aad_third_party_apps.AdditionalProperties['implementationStatus']


Write-Output $aad_third_party_apps_AddProperties | fl


$aad_third_party_apps_Score = $aad_third_party_apps.AdditionalProperties['scoreInPercentage']

if ($aad_third_party_apps_Score -eq "100" -Or $aad_third_party_apps_Score -eq "100.00") {
    $aad_third_party_apps_ScoreResult =  $compliant
} else {
    $aad_third_party_apps_ScoreResult =  $notcompliant
}

Write-Output "--------------------------------------"
Write-Output "Result: $aad_third_party_apps_ScoreResult"


Write-Output "-----------------------------------------------------------------------------"
# [END CONTROL] 5.1.2.2 (L2) Ensure third party integrated applications are not allowed