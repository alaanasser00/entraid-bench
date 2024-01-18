
function Check-MicrosoftAuthenticatorFatigue {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Ensure Microsoft Authenticator is configured to protect against MFA fatigue"
        $controlDescription = "Microsoft has released additional settings to enhance the configuration of the Microsoft Authenticator application. These settings provide additional information and context to users who receive MFA passwordless and push requests, such as geographic location the request came from, the requesting application and requiring a number match. Ensure the following are Enabled.
        • Require number matching for push notifications
        • Show application name in push and passwordless notifications
        • Show geographic location in push and passwordless notifications"
    
        # Retrieve configuration for Microsoft Authenticator
        $authenticatorConfig = Get-MgPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId MicrosoftAuthenticator
        
        # Check if Microsoft Authenticator is disabled
        if ($authenticatorConfig.State -eq "disabled") {
            $controlFinding = "Microsoft Authenticator is disabled."

            return [PSCustomObject]@{
                Control               = $controlTitle
                ControlDescription    = $controlDescription
                Finding               = $controlFinding
                Result                = "NOT COMPLIANT"
            }
        } 
        
        # if Microsoft Authenticator is enabled, check for MFA fatigue resistance settings
        $featureSettings = $authenticatorConfig.AdditionalProperties.featureSettings
        $numberMatchingRequiredState = $featureSettings.numberMatchingRequiredState
        $displayLocationInformationRequiredState = $featureSettings.displayLocationInformationRequiredState
        $displayAppInformationRequiredState = $featureSettings.displayAppInformationRequiredState

        if ($numberMatchingRequiredState.State -eq "enabled" -And $displayLocationInformationRequiredState.State -eq "enabled" -And $displayAppInformationRequiredState.State -eq "enabled" ) {
            $controlFinding = "Microsoft Authenticator is configured to be resistant to MFA fatigue."

            return [PSCustomObject]@{
                Control               = $controlTitle
                ControlDescription    = $controlDescription
                Finding               = $controlFinding
                Result                = "COMPLIANT"
            }

        } else {
            $controlFinding = "Microsoft Authenticator is not configured to be resistant to MFA fatigue."

            return [PSCustomObject]@{
                Control               = $controlTitle
                ControlDescription    = $controlDescription
                Finding               = $controlFinding
                Result                = "NOT COMPLIANT"
            }
             
        }

    } catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Check-MicrosoftAuthenticatorFatigue