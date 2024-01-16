function Check-BannedPasswordSettings {
    [CmdletBinding()]
    param()

    Write-Output "------------------------------------------------------------------------"
    Write-Output "5.2.3.2 (L1) Ensure custom banned passwords lists are used`n"
    Write-Output "------------------------------------------------------------------------`n"

    try {

        $controlTitle = "5.2.3.2 (L1) Ensure custom banned passwords lists are used"
        $controlDescription = "Creating a new password can be difficult regardless of one's technical background. It is common to look around one's environment for suggestions when building a password, however, this may include picking words specific to the organization as inspiration for a password. An adversary may employ what is called a 'mangler' to create permutations of these specific words in an attempt to crack passwords or hashes making it easier to reach their goal."
    
        # Retrieve the group setting
        $groupSetting = Get-MgGroupSetting

        # Find the "EnableBannedPasswordCheck" value
        $enableBannedPasswordCheckValue = $groupSetting.Values | Where-Object { $_.Name -eq "EnableBannedPasswordCheck" }

        # Check if EnableBannedPasswordCheck is enabled
        if ($enableBannedPasswordCheckValue -and $enableBannedPasswordCheckValue.Value -eq $true) {

            # Find the "BannedPasswordList" value
            $bannedPasswordListValue = $groupSetting.Values | Where-Object { $_.Name -eq "BannedPasswordList" }

            # Check if BannedPasswordList is empty
            if ($bannedPasswordListValue.Value -eq $null -or $bannedPasswordListValue.Value.Count -eq 0) {
                $controlFinding = "Custom banned passwords setting is enabled but the list of passwords is empty."
                return [PSCustomObject]@{
                    Control            = $controlTitle
                    ControlDescription = $controlDescription
                    Finding            = $controlFinding
                    Result             = "NOT COMPLIANT"
                }
            }
            else {            
                $controlFinding = "Custom banned passwords setting is enabled and the list of passwords is configured."
                return [PSCustomObject]@{
                    Control            = $controlTitle
                    ControlDescription = $controlDescription
                    Finding            = $controlFinding
                    Result             = "COMPLIANT"
                }
            }
        }
        else {
            $controlFinding = "Custom banned passwords setting is disabled."
            return [PSCustomObject]@{
                Control            = $controlTitle
                ControlDescription = $controlDescription
                Finding            = $controlFinding
                Result             = "NOT COMPLIANT"
            }
        }
    }
    catch {
        Write-Error "An error occurred while checking the settings: $_"
    }
}

. ../scanner.ps1
  
# Call the function to check the settings
Check-BannedPasswordSettings | Format-List
  