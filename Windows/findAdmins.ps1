param([String]$File='admins.txt',[switch]$auto)

if ($auto -and !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Using the -Auto flag requires Administrator access"
    return ""
}

$adminGroups = @("Administrators","Domain Admin")
$whitelist = @("Users")
$hostname = $env:COMPUTERNAME

try {
    $admins = Get-Content $File -ErrorAction Stop
}
catch {
    Write-Output "Could not open $File"
    if ($File -eq "admins.txt") {
        Write-Output "Please create an admins.txt file or specify the file name in the command line"
    }
    return ""
}

$localUsers = Get-LocalUser
if ($localUsers.Count -eq 0) {
    Write-Error "Got no users! Something is weird or wrong."
}
$groups = Get-LocalGroup
if ($groups.Count -eq 0) {
    Write-Error "Got no groups! Something is weird or wrong."
}

$localAdmins = [System.Collections.ArrayList]::new()

foreach($group in $groups) {
    $groupName = $group.Name

    $members = Get-LocalGroupMember -Name $groupName
    foreach ($user in $localUsers) {
        if ($user.Enabled -eq $true -and "$hostname\$user" -in $members.Name) {
            if ($groupName -in $adminGroups) {
                [void]$localAdmins.add($user)
            } elseif ($groupName -notin $whitelist) {
                Write-Output "[!] WARN: Found user '$user' member of group '$groupName' not in whitelist"
            }
        }
    }
}

$adminsToDelete = [System.Collections.ArrayList]::new()
$adminsToAdd = [System.Collections.ArrayList]::new()
$hasActions = 0

foreach ($admin in $localAdmins) {
    if ($admin.Name -notin $admins) {
        [void]$adminsToDelete.add($admin.Name)
    }
}

foreach ($admin in $admins) {
    if ($admin -notin $localAdmins.Name) {
        [void]$adminsToAdd.add($admin)
    }
}

if ($adminsToDelete.Count -gt 0) {
    Write-Output "[*] People who should not be Admins:"
    $hasActions += 1
    foreach ($admin in $adminsToDelete) {
        Write-Output "  > $admin"
    }
} else {
    Write-Output "[$] No admins to delete :)"
}

if ($adminsToAdd.Count -gt 0) {
    Write-Output "[*] People who should be Admins:"
    $hasActions += 1
    foreach ($admin in $adminsToAdd) {
        Write-Output "  > $admin"
    }
} else {
    Write-Output "[$] No admins to add :)"
}

if ($auto -and $hasActions -gt 0) {
    Write-Output "Autoing...."
    foreach ($admin in $adminsToDelete) {
        # Revoke admin perms
        foreach ($group in $adminGroups) {
            Remove-LocalGroupMember -Group $group -Member $admin    
        }
    }
    foreach ($admin in $adminsToAdd) {
        # Add admin perms
        foreach ($group in $adminGroups) {
            Add-LocalGroupMember -Group $group -Member $admin
        }
    }
} elseif ($hasActions -gt 0) {
    Write-Output "Add the -Auto flag to perform these actions."
}