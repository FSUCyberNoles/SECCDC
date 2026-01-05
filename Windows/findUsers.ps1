param([String]$File='users.txt',[switch]$auto)

if ($auto -and !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Using the -Auto flag requires Administrator access"
    return ""
}

try {
    $users = Get-Content $File -ErrorAction Stop
}
catch {
    Write-Output "Could not open $File"
    if ($File -eq "users.txt") {
        Write-Output "Please create a users.txt file or specify the file name in the command line"
    }
    return ""
}

$localUsers = Get-LocalUser
if ($localUsers.Count -eq 0) {
    Write-Error "Got no users! Something is weird or wrong."
}
$hasActions = 0
$usersToDelete = [System.Collections.ArrayList]::new()
foreach ($user in $localUsers) {
    if ($user.Enabled -eq "True" -and $user.Name -notin $users) {
        [void]$usersToDelete.add($user.Name)
    }
}
if ($usersToDelete.Count -eq 0) {
    Write-Output "[$] No users to delete"
} else {
    $hasActions += 1
    Write-Output "[*] Users to Delete ------"
    foreach ($user in $usersToDelete) {
        Write-Output "  > $user"
    }
}


$addUsers = [System.Collections.ArrayList]::new()
foreach ($user in $users) {
    if ($user -notin $localUsers.Name) {
        [void]$addUsers.add($user)
    }
}
if ($addUsers.Count -eq 0) {
    Write-Output "[$] No users to add"
} else {
    $hasActions += 1
    Write-Output "[*] Users to Add ------"
    foreach ($user in $addUsers) {
        Write-Output "  > $user"
    }
}

if ($auto -and $hasActions -gt 0) {
    if ($addUser.Count -gt 0) {
        $pw = Read-Host -AsSecureString -Prompt "Enter a password to use"
    }
    foreach ($user in $addUsers) {
        New-LocalUser -Name $user -Password $pw
    }
    foreach ($user in $usersToDelete) {
        Remove-LocalUser -Name $user
    }
} elseif ($hasActions -gt 0) {
    Write-Output "Add the -Auto flag to perform these actions."
}