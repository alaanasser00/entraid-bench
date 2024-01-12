# [START CONTROL] 5.2.2.2 (L1) Ensure multifactor authentication is enabled for all users


Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.2.2.2 (L1) Ensure multifactor authentication is enabled for all users"


$controlScores = Get-MgSecuritySecureScore | Select-Object -First 1 -ExpandProperty ControlScores
$BlockLegAuth = $controlScores | Where-Object { $_.ControlName -eq 'BlockLegacyAuthentication' }

$BlockLegAuth_AddProperties = $BlockLegAuth.AdditionalProperties['implementationStatus']

Write-Output $BlockLegAuth_AddProperties | fl

$BlockLegAuth_Score = $BlockLegAuth.Score

if ($BlockLegAuth_Score -eq "10") {
    $BlockLegAuth_ScoreResult =  $compliant
} else {
    $BlockLegAuth_ScoreResult =  $notcompliant
}

Write-Output "--------------------------------------"
Write-Output "Result: $BlockLegAuth_ScoreResult" #>


Write-Output "-----------------------------------------------------------------------------"


# [END CONTROL] 5.2.2.2 (L1) Ensure multifactor authentication is enabled for all users