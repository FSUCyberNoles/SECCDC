# One-Liners

Here's a list of one-liners that I've found to discover certain things:

Jump to: [Linux](#linux)  /  [Windows](#windows)

## Linux

### Listening Processes

```
netstat -tulp4
```

Doesn't often return lots of results, but can be filtered out using grep.

Note that this removes IPv6 results, you can switch the 4 to a 6 to look at them.

### Detect Established Shells

```
netstat -tup
```

Detects basic meterpreter shells, will also output NetworkManager and other established connections.

Note that other forms of shells (like netcat listeners) will *not* show up since they're LISTENING connections. (Use [Listening Processes](#listening-processes) for this)

### Deleted & Running Processes

```
 lsof -u root | grep "deleted"
```

lsof can return thousands of results (even when filtering out for deleted files), so this will filter out for processes running as root.

root should not have any files running as deleted, any results are at minimum highly suspect.

### List Users

```
cat /etc/passwd | grep -ve nologin -e false | awk -F: '{print $1,$6,$7}'
```

 Lists users, excluding users with nologin or false flags. Includes the username, home directory, and startup shell.

### Check File Integrity

```
sudo debsums -x
```

> Only works for Debian and Debian-derived distros, requires installation via apt

Checks the integrity of all files by comparing its checksums against what they should be.

I got a few results regarding changelogs and copyright files, but no other critical results. Any binaries or scripts displayed on here should be re-installed from source.

## Windows

Most everything Windows is GUI-based, so just have SysInternals ready and be familiar with it. There are a few one-liners that can be helpful though.

> **NOTE: Most all of these should be run in _PowerShell_ NOT Command Prompt (cmd)**

### Unquoted Service Paths

This only affects services with spaces in their name (and this does not filter out paths w/o spaces), and we're assuming that the C:\Windows folder has proper permissions.

```
(Get-WmiObject win32_service).pathname | Where {$_ -notmatch '"*"|C:\\Windows\\'}
```

### Reset all user passwords

