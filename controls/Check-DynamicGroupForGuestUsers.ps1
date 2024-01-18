function Check-DynamicGroupForGuestUsers {
    [CmdletBinding()]
    param()

    try {

        $controlTitle = "Ensure a dynamic group for guest users is created"
        $controlDescription = "A dynamic group is a dynamic configuration of security group membership for Azure Active Directory. Administrators can set rules to populate groups that are created in Azure AD based on user attributes (such as userType, department, or country/region). Members can be automatically added to or removed from a security group based on their attributes. The recommended state is to create a dynamic group that includes guest accounts."

        # Get all groups with dynamic membership
        $groups = Get-MgGroup | Where-Object { $_.GroupTypes -contains "DynamicMembership" }

        # Filter dynamic groups for guest users
        $guestDynamicGroups = $groups | Where-Object { $_.MembershipRule -like "*user.userType -eq `"`Guest`"*" }
        $allUsersDynamicGroups = $groups | Where-Object { $_.MembershipRule -notlike "*user.userType -eq `"`All Users`"*" }

        if ($guestDynamicGroups) {
            $controlFinding = "Dynamic group for guest users found."
            $controlResult = "COMPLIANT"
            $findingDetails = $guestDynamicGroups | Select-Object DisplayName, GroupTypes, MembershipRule
        }
        elseif ($allUsersDynamicGroups) {
            $controlFinding = "Dynamic group for all users found."
            $controlResult = "COMPLIANT"
            $findingDetails = $allUsersDynamicGroups | Select-Object DisplayName, GroupTypes, MembershipRule
        }
        else {
            $controlFinding = "No dynamic group for guest users found."
            $controlResult = "NOT COMPLIANT"
            $findingDetails = $notguestDynamicGroups | Select-Object DisplayName, GroupTypes, MembershipRule
        }

        return [PSCustomObject]@{
            Control                     = $controlTitle
            ControlDescription          = $controlDescription
            Finding                     = $controlFinding
            DynamicGroupName            = $findingDetails.DisplayName
            DynamicGroupTypes           = $findingDetails.GroupTypes
            DynamicGroupMembershipRule  = $findingDetails.MembershipRule
            Result                      = $controlResult
        }

    }
    catch {
        Write-Error "An error occurred: $_"
    }
}


# Usage in your scripts:
Check-DynamicGroupForGuestUsers