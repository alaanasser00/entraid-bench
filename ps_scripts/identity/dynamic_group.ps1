# [START CONTROL] 5.1.3.1 (L1) Ensure a dynamic group for guest users is created

Write-Output "-----------------------------------------------------------------------------"
Write-Output "5.1.3.1 (L1) Ensure a dynamic group for guest users is created"
# Get all groups with dynamic membership
$groups = Get-MgGroup | Where-Object { $_.GroupTypes -contains "DynamicMembership" }

# Filter dynamic groups for guest users
$guestDynamicGroups = $groups | Where-Object { $_.MembershipRule -like "*user.userType -eq `"`Guest`"*" }
$allUsersDynamicGroups = $groups | Where-Object { $_.MembershipRule -notlike "*user.userType -eq `"`All Users`"*" }

Write-Output "-------------------"

if ($guestDynamicGroups) {
    Write-Output "Result: $compliant, dynamic group for guest users found."
    $guestDynamicGroups | Format-Table DisplayName, GroupTypes, MembershipRule
} elseif ($allUsersDynamicGroups) {
    Write-Output "Result: $compliant, dynamic group for all users found."
    Write-Output $allUsersDynamicGroups | Format-Table DisplayName, GroupTypes, MembershipRule
} else {
    Write-Output "Result: $notcompliant, no dynamic group for guest users found."
    Write-Output $notguestDynamicGroups | Format-Table DisplayName, GroupTypes, MembershipRule
}


# [END CONTROL] 5.1.3.1 (L1) Ensure a dynamic group for guest users is created