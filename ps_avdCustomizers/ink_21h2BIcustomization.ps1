
Write-Host '*** WVD AIB CUSTOMIZER PHASE **************************************************************************************************'
Write-Host '*** WVD AIB CUSTOMIZER PHASE ***                                                                                            ***'
Write-Host '*** WVD AIB CUSTOMIZER PHASE *** Script: Win10ms_O365.ps1                                                                   ***'
Write-Host '*** WVD AIB CUSTOMIZER PHASE ***                                                                                            ***'
Write-Host '*** WVD AIB CUSTOMIZER PHASE **************************************************************************************************'

Write-Host '*** WVD AIB CUSTOMIZER PHASE *** Stop the custimization when Error occurs ***'
$ErroractionPreference='Stop'
#############################################################################################################################################
# Create devops temp folder to house installation files #

Write-Host '*** WVD AIB CUSTOMIZER PHASE *** CONFIG *** Create temp folder for software packages. ***'
New-Item -Path 'C:\devopstemp' -ItemType Directory -Force | Out-Null
New-Item -Path 'C:\temp' -ItemType Directory -Force | Out-Null
#############################################################################################################################################
# Install Chocolatey and install chocolatey apps #
Write-Host '*** WVD AIB CUSTOMIZER PHASE *** INSTALL *** Install Chocolatey ***'
Invoke-WebRequest -Uri 'https://chocolatey.org/install.ps1' -OutFile ( New-Item -Path "C:\devopstemp\chocolatey\chocolatey.ps1" -Force )
Invoke-Expression -Command 'C:\devopstemp\chocolatey\chocolatey.ps1'
Start-Sleep -Seconds 30

Write-Host '*** WVD AIB CUSTOMIZER PHASE *** INSTALL *** Run Chocolatey Commands ***'

choco feature enable -n allowGlobalConfirmation

choco install azcopy10

Start-Sleep -Seconds 5

choco install googlechrome --ignore-checksums

Start-Sleep -Seconds 5

choco install adobereader

Start-Sleep -Seconds 5

choco install fslogix

Start-Sleep -Seconds 5

choco install powerbi

choco feature disable -n allowGlobalConfirmation
#############################################################################################################################################
#
#
# Install r7insightagent from AVDRepo

azcopy copy 'https://inkuscestcorpapprepo001.blob.core.windows.net/r7insightagents/*?sp=rl&st=2022-01-05T17:18:17Z&se=2023-02-02T01:18:17Z&spr=https&sv=2020-08-04&sr=c&sig=BmBc1J7P1VD0slTFZYkeZCJTdoEupzQEPCzsRytTL6g%3D' c:\temp
#Install r7InsightAgent
Start-Process -filepath msiexec.exe -Wait -ErrorAction Stop -ArgumentList '/i', 'c:\temp\agentInstaller-x86_64.msi', '/quiet', '/qn'


# Install teamviewer from AVDRepo

azcopy copy 'https://inkuscestcorpapprepo001.blob.core.windows.net/ink-teamviewer/*?sp=rl&st=2022-04-28T18:49:52Z&se=2023-05-02T02:49:52Z&spr=https&sv=2020-08-04&sr=c&sig=tTIBgtdfgxcNS8d5wOpyBMnYxiybJKXhGsK0SQS%2FEK0%3D' c:\temp
#Install teamviewer
Start-Process -Wait -FilePath 'c:\temp\TeamViewer_Host_Setup.exe' -ArgumentList '/S', '/norestart' -PassThru


#############################################################################################################################################

############################################################################################################################################

# Windows customization and optimization #
Write-Host '*** WVD AIB CUSTOMIZER PHASE *** SET OS REGKEY *** Set up time zone redirection ***'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fEnableTimeZoneRedirection' -Value '1' -PropertyType DWORD -Force | Out-Null

Write-Host '*** WVD AIB CUSTOMIZER PHASE *** SET OS REGKEY *** Disable Storage Sense ***'
# reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 0 /f
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense' -Name 'AllowStorageSenseGlobal' -Value '0' -PropertyType DWORD -Force | Out-Null

# Final Cleanup #
Write-Host '*** WVD AIB CUSTOMIZER PHASE *** CONFIG *** Deleting temp folder. ***'
Get-ChildItem -Path 'C:\devopstemp' -Recurse | Remove-Item -Recurse -Force
Remove-Item -Path 'C:\devopstemp' -Force | Out-Null

Get-ChildItem -Path 'C:\temp' -Recurse | Remove-Item -Recurse -Force
Remove-Item -Path 'C:\temp' -Force | Out-Null

Write-Host '*** WVD AIB CUSTOMIZER PHASE ********************* END *************************'
#############################################################################################################################################




