<#
.SYNOPSIS
Install-Sysmon downloads the Sysmon executables archive and installs Sysmon64.exe
with a configuration file.
.DESCRIPTION
PowerShell script or module to install Sysmon with configuration 
.PARAMETER path
The path to the working directory.  Default is user Documents.
.EXAMPLE
Install-Sysmon -path C:\Users\example\Desktop
#>
#Check for sysmon already installed
$ServiceName = 'Sysmon64'
$sysmon64installed = Get-Service -Name $ServiceName

[CmdletBinding()]

#Establish parameters for path
param (
    [string]$path=$env:TEMP   
)

#Test path and create it if required

if(!(test-path $path))
{
	Write-Information -MessageData "Path does not exist.  Creating Path..." -InformationAction Continue;
	New-Item -ItemType Directory -Force -Path $path | Out-Null;
	Write-Information -MessageData "...Complete" -InformationAction Continue
}

if ($sysmon64installed.Status -eq 'Running'){
    Set-Location $path
    Write-Host "Retrieving and Updating Configuration File..."
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml -Outfile sysmonconfig-export.xml
    Start-Process -NoNewWindow -FilePath "$env:SystemRoot\sysmon64.exe" -ArgumentList "-c sysmonconfig-export.xml"
    Write-Host "Configuration updated!"
    Exit 0}

[CmdletBinding()]

#Establish parameters for path
param (
    [string]$path=$env:TEMP   
)

#Test path and create it if required

If(!(test-path $path))
{
	Write-Information -MessageData "Path does not exist.  Creating Path..." -InformationAction Continue;
	New-Item -ItemType Directory -Force -Path $path | Out-Null;
	Write-Information -MessageData "...Complete" -InformationAction Continue
}

Set-Location $path

Write-Host "Location set $path"

Write-Host "Retrieving Sysmon..."

$exists = test-path $path\sysmon.zip

if ($exists -eq $true) {
    Write-Host "Cleaning up old files"
    Remove-Item $path\sysmon.zip -Force
    Remove-Item $path\sysmon -Force -Recurse}

Invoke-WebRequest -Uri https://download.sysinternals.com/files/Sysmon.zip -Outfile Sysmon.zip

Write-Host "Sysmon Retrived"

Write-Host "Unzip Sysmon..."

Expand-Archive Sysmon.zip

Set-Location $path\Sysmon

Write-Host "Unzip Complete."

Write-Host "Retrieving Configuration File..."

Invoke-WebRequest -Uri https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml -Outfile sysmonconfig-export.xml

Write-Host "Configuration File Retrieved."

Write-Host "Installing Sysmon..."

.\sysmon64.exe -accepteula -i sysmonconfig-export.xml

Write-Host "Sysmon Installed!"
