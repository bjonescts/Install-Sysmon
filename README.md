# Install-Sysmon
Powershell Script to Install Sysmon as service with rules from SwiftonSecurity

.SYNOPSIS

Install-Sysmon downloads the Sysmon executables archive and installs Sysmon64.exe
with a configuration file.

.DESCRIPTION

PowerShell script or module to install Sysmon with configuration.

No parameters are needed for this script to function normally or run from a RMM.

.PARAMETER path

The path to the working directory.  Default is user's temp folder.

.EXAMPLE

Install-Sysmon -path C:\Users\example\Desktop
