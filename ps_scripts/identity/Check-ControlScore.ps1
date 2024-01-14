function Check-ControlScore {
    param(
        [Parameter(Mandatory = $true)]
        [string] $controlName,
        [Parameter(Mandatory = $true)]
        [string] $controlTitle
    )

    Write-Output "------------------------------------------------------------------------`n"
    Write-Output "$controlTitle`n"

    $controlScore = Get-MgSecuritySecureScore | Select-Object -First 1 -ExpandProperty ControlScores | Where-Object { $_.ControlName -eq $controlName }
    
    $controlDescription = $controlScore | Select-Object -ExpandProperty Description                              
    
    $AdditionalProperties = $controlScore.AdditionalProperties

    # to delete after finishing from it
    Write-Output $AdditionalProperties | fl
    
    $controlFinding = $AdditionalProperties['implementationStatus']
    $controlCount = $AdditionalProperties['count']
    $controlTotal = $AdditionalProperties['total']

    $controlScoreInPercentage = $AdditionalProperties['scoreInPercentage']
    $complianceResult = if ($controlScoreInPercentage -eq "100" -Or $controlScoreInPercentage -eq "100.00") { $compliant } else { $notcompliant }



    # Object Output
    $outputControlScore = [PSCustomObject]@{
        Control              = $controlTitle
        ControlDescription   = $controlDescription
        Finding              = $controlFinding
        ScoreInPercentage    = $controlScoreInPercentage
        Count                = $controlCount
        Cotal                = $controlTotal
        Result               = $complianceResult
    }

    return $outputControlScore
}


# Usage in your scripts:
. ../scanner.ps1

# Check-ControlScore -controlName 'aad_admin_consent_workflow' -controlTitle "Control Title"
