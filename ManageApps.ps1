$apps= @{}
$apps.Add(1,@('Chrome','Google.Chrome'))
$apps.Add(2,@('Anydesk','AnyDeskSoftwareGmbH.AnyDesk'))
$apps.Add(3,@('TeamViewer','TeamViewer.TeamViewer'))
$apps.Add(4,@('7zip','7zip.7zip'))
$apps.Add(5,@('Powershell Core','Microsoft.PowerShell'))
$apps.Add(6,@('Zoom','Zoom.Zoom'))

function Manage-Application
{
    <#
        .SYNOPSIS 
        Manage Applications on windows OS with winget(Windows Package Manager)
        .DESCRIPTION 
        The Function usages winget to install, uninstall or update applications 
        .PARAMETER Id
        Application id 
        .PARAMETER Action
        Action parameter determine action need to take on application
        .EXAMPLE
        Manage-Application -ID 'Google.Chrome' -Action 'install'
        Manage-Application -ID 'Google.Chrome' -Action 'Uninstall'
        .NOTES
        Demo
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Id,
        [Parameter(Mandatory=$true)]
        [string]$Action
    )
    write-verbose "Passed id: $Id"
    write-verbose "Passed Action: $Action"
    if($Action -eq 'Install')
    {
        Write-Host "Installing $Id, Please Wait..." -ForegroundColor Magenta
        Winget Install --ID $Id |Out-Null
        Write-Host "Installed Sucessfully" -ForegroundColor Green
        Start-Sleep -Seconds 1
    }elseif($Action -eq 'Uninstall')
    {
        Write-Host "Uninstalling $Id, Please Wait..." -ForegroundColor Magenta
        Winget uninstall --ID $Id |Out-Null
        Write-Host "Uninstalled Sucessfully" -ForegroundColor Green
        Start-Sleep -Seconds 1
    }
}

Function Uninstall-WindowsApps()
{
    Manage-Application -ID 'Microsoft.SkypeApp_kzf8qxf38zg5c' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.Xbox.TCUI_8wekyb3d8bbwe' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.XboxApp_8wekyb3d8bbwe' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.XboxGameOverlay_8wekyb3d8bbwe' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.XboxGamingOverlay_8wekyb3d8bbwe' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.XboxIdentityProvider_8wekyb3d8bbwe' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.ZuneMusic_8wekyb3d8bbwe' -Action 'Uninstall'
    Manage-Application -ID 'Microsoft.YourPhone_8wekyb3d8bbwe' -Action 'Uninstall'
}


Clear-Host
$ex=0
while($ex -ne 20)
{
    Write-Host "---------------Menu---------------------" -ForegroundColor Cyan
    Write-Host "1.Install Winget(Windows Package Manager)" -ForegroundColor Cyan
    Write-Host "2.Install Apps" -ForegroundColor Cyan
    Write-Host "3.Uninstall Apps" -ForegroundColor Cyan
    Write-Host "4.Update All Apps" -ForegroundColor Cyan
    Write-Host "20.Exit" -ForegroundColor Cyan
    Write-Host "------------------------------------------" -ForegroundColor Cyan
    switch($ex=Read-Host "Select a menu item"){
        1{
            if (Get-Command -Name winget -ErrorAction SilentlyContinue) {
                Write-Host "winget is present in system"
            } else {
                Write-Host "winget is not installed on this system. Attempting to install..."
                try {
                    # Attempt to install winget
                    $progressPreference = 'silentlyContinue'
                    $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
                    $latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
                    Invoke-WebRequest -Uri $latestWingetMsixBundle -OutFile "$env:USERPROFILE\Downloads\winget.appxbundle"
                    Add-AppxPackage -Path "$env:USERPROFILE\Downloads\winget.appxbundle" -ForceApplicationShutdown
                    Write-Host "winget installed successfully."
                } catch {
                    Write-Warning "Failed to install winget. Error: $($_.Exception.Message)"
                }
            }
        }
        2{ 
            $exsub=0
            while ($exsub -ne 20) 
            {
                Write-Host "---------------SubMenu---------------------"
                    for($i=1;$i -le $apps.Count; $i++)
                    {
                        Write-Host "$i Install "$apps[$i][0]
                    }            
                Write-Host "20.Exit"
                Write-Host "------------------------------------------" -ForegroundColor DarkGray
                switch([int]$exsub=Read-Host "Select a sub-menu item"){ 
                    $exsub{
                        if($exsub -eq 20)
                        {
                            Write-Host "Ending" -ForegroundColor DarkGray
                        }
                        else {
                            Manage-Application -ID $apps[$exsub][1] -Action 'Install'
                        }                                
                    }
                    default {Write-Host "Invalid entry" -ForegroundColor DarkGray}
                }
            }
        }

        3{

            $exsub=0
            while ($exsub -ne 20) 
            {
                Write-Host "---------------SubMenu---------------------"
                Write-Host "0.Uninstall Windows Apps -" -ForegroundColor DarkGray
                for($i=1;$i -le $apps.Count; $i++)
                {
                    Write-Host "$i Uninstall "$apps[$i][0]
                }            
                Write-Host "20.Exit"
                Write-Host "------------------------------------------" -ForegroundColor DarkGray
                switch([int]$exsub=Read-Host "Select a sub-menu item"){ 
                    $exsub{
                        if($exsub -eq 20)
                        {
                            Write-Host "Ending" -ForegroundColor DarkGray
                        }elseif ($exsub -eq 0) {
                            Uninstall-WindowsApps
                        }
                        else {
                            Manage-Application -ID $apps[$exsub][1] -Action 'Uninstall' 
                        }                                
                    }
                    default {Write-Host "Invalid entry" -ForegroundColor DarkGray}
                }
            }

        }        
        4{
            Write-Host "Upgrading Installed apps, Please Wait..." -ForegroundColor Magenta
            winget upgrade --all            
        }       
        20{Write-Host "Ending" -ForegroundColor Cyan}
        default {Write-Host "Invalid entry" -ForegroundColor Cyan}
    }
}
    