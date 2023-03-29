#Requires -RunAsAdministrator
Clear-Host
$ex=0

    while($ex -ne 20)
    {

        Write-Host "---------------Menu---------------------"
        Write-Host "1.Selenium -web automation"
        Write-Host "2.PS2EXE-Converts .ps1 files into .exe"
        Write-Host "3.ImportExcel -excel integration"
        Write-Host "4.PowerFGT -Fortigate Firewall "
        Write-Host "5.PowerShellAI -OpenAI Integration"
        Write-Host "6.PSGSuite -Google Workspace"
        Write-Host "20.Exit"
        Write-Host "------------------------------------------"
        switch($ex=Read-Host "Select a menu item"){
            1{ 
                Install-Module -Name Selenium
             }
            2{ 
                Install-Module -Name ps2exe
            }
            3{ 
                Install-Module -Name ImportExcel
            }
            4{ 
                Install-Module -Name PowerFGT
            }
            5{ 
                Install-Module -Name PowerShellAI
            }
            6{ 
                Install-Module -Name PSGSuite
            }            
             20 {"Ending"}
             default {"Invalid entry"}
            }
   }