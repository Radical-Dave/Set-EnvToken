#Set-StrictMode -Version Latest
#####################################################
# Set-EnvToken
#####################################################
<#PSScriptInfo

.VERSION 0.1

.GUID 10ac2472-08ca-436c-bc34-0073ad06fcdd

.AUTHOR David Walker, Sitecore Dave, Radical Dave

.COMPANYNAME David Walker, Sitecore Dave, Radical Dave

.COPYRIGHT David Walker, Sitecore Dave, Radical Dave

.TAGS powershell token regex

.LICENSEURI https://github.com/Radical-Dave/Set-EnvToken/blob/main/LICENSE

.PROJECTURI https://github.com/Radical-Dave/Set-EnvToken

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#

.DESCRIPTION
 PowerShell Script to set EnvironmentVariables from .env files

.PARAMETER source
Source paths to process

#>
[CmdletBinding(SupportsShouldProcess)]
Param([Parameter(Mandatory=$false)][string[]]$paths)
process {
	$PSScriptName = (Split-Path $PSCommandPath -Leaf).Replace('.ps1','')
	try {
		#if (!$path) {$path = Get-Location}
		if (!$paths) {
			$currLocation = Get-Location
			$paths = @((Split-Path $profile -Parent),$PSScriptRoot,("$currLocation" -ne "$PSScriptRoot" ? $currLocation : ''))
		}
		$paths.foreach({
			$path = $_
			if ($path) {
				#if ($path.GetType() -ne 'Array') {Write-Verbose "wow:$($path.GetType())"}
				if (Test-Path "$path\*.env*") {
					Get-ChildItem -Path "$path\*.env*" | Foreach-Object {
						try {
							$f = $_
							$content = (Get-Content $f.FullName) # -join [Environment]::NewLine # -Raw
							$content | ForEach-Object {
								if (-not ($_ -like '#*') -and ($_ -like '*=*')) {
									$sp = $_.Split('=')
									[System.Environment]::SetEnvironmentVariable($sp[0], $sp[1])
								}
							}
						}
						catch {
							throw "ERROR $PSScriptName $path-$f"
						}
					}
				} else {
					Write-Verbose "skipped:$p no *.env* files found"
				}
			}
		})
	}
	catch {
		Write-Error "ERROR $PSScriptName $path" -InformationVariable results
	}
}