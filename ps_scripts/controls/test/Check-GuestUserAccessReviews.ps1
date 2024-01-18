<# function Check-GuestUserAccessReviews {
  try {

    # Retrieve all access review definitions
    $accessReviewDefinitions = Get-MgIdentityGovernanceAccessReviewDefinition

    # Filter for access reviews targeting guest users
    $guestUserReviews = $accessReviewDefinitions | Where-Object {
      ($_.Scope.Type -eq 'AllGuestUsers') -or
      ($_.Scope.Type -eq 'Selected' -and $_.Scope.ReviewedEntityTypes -contains 'Guests')
    }

    # Check if any guest user access reviews are found
    if ($guestUserReviews) {
      Write-Host "Guest user access reviews are configured."

      # Display details of the configured reviews (optional)
      $guestUserReviews | ForEach-Object {
        Write-Host "Review Name: $($_.DisplayName)"
        Write-Host "Review Scope: $($_.Scope.Type)"
        Write-Host "Review Frequency: $($_.Schedule.Frequency)"
       # Add more properties as needed
      }
    } else {
      Write-Host "Guest user access reviews are not configured."
    }
  } catch {
    Write-Error "An error occurred while checking access reviews: $_"
  }
}

# Call the function to check the configuration
. ../scanner.ps1

Check-GuestUserAccessReviews #>