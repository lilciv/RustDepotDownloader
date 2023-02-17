# Rust Depot Downloader (v1.0.0) by lilciv#2944

#----------------------------------------------

#Title + Intro
$host.UI.RawUI.WindowTitle = "Rust Depot Downloader - lilciv#2944"
Write-Host "`n"
Write-Host "This script will install a Rust Client or Server on your computer from a Steam Manifest ID."
Write-Host "`n"
Write-Host "Manifest IDs can be found at https://steamdb.info"
Write-Host "`n"
Pause
Clear-Host

#----------------------------------------------

# SteamCMD Installation
function SteamCMD {
    $host.UI.RawUI.WindowTitle = "Installing SteamCMD..."
    Write-host "Enter the location you want SteamCMD installed (Default: C:\SteamCMD)"
    Write-Host "`n"
    $SteamCMD = Read-Host "Location"
    if ($SteamCMD -eq [string]::empty) {
        $SteamCMD = "C:\SteamCMD"
    }

    if (!(Test-Path $SteamCMD)) {
        New-Item $SteamCMD -ItemType Directory
        Write-Host "SteamCMD Folder Created"
    }
    Set-Location "$SteamCMD"
    Write-Host "`n"
    Invoke-WebRequest https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -OutFile 'SteamCMD.zip'
    Expand-Archive -Force SteamCMD.zip ./
    Remove-Item SteamCMD.zip
    Clear-Host
    Write-Host "SteamCMD installed!"
    Write-Host "`n"
    DLChoice
}

#----------------------------------------------

# Download Choice
function DLChoice {
    $host.UI.RawUI.WindowTitle = "Download Choice"

    do {
        Write-Host "`nWhat do you want to download?"
        Write-Host "`t1. Rust Client"
        Write-Host "`t2. Rust Server"
        
        $Choice = Read-Host "`nEnter 1 or 2"
        } until (($Choice -eq '1') -or ($Choice -eq '2'))
        switch ($Choice) {
        '1'{
                RustClient
        }
        '2'{
                RustServer
        }
    }
}

#----------------------------------------------

# Rust Client Install
function RustClient {
    Clear-Host
	$host.UI.RawUI.WindowTitle = "Downloading Rust Client..."
    Write-Host "WARNING: Be sure there is not an existing Rust Client installation in this directory"
    Write-Host "The folder should either be empty or non-existent."
    Write-Host "`n"
    Write-Host "Enter the location you want the Rust Client installed (Default: C:\RustClient)"
    $ClientDir = Read-Host "Location"
    if ($ClientDir -eq [string]::empty) {
        $ClientDir = "C:\RustClient"
    }
    
    if (!(Test-Path $ClientDir)) {
        New-Item $ClientDir -ItemType Directory
        Write-Host "Rust Client Folder Created"
    }
	
	Clear-Host
	# Default is May 5th, 2022 (Old Recoil)
	$CommonClient = Read-Host "Enter the Rust Client - Common Manifest ID"
	if ($CommonClient -eq [string]::empty) {
        $CommonClient = "5939934877855656786"
    }
	Write-Host "`n"
	$Win64Client = Read-Host "Enter the Rust Client - Windows 64 Manifest ID"
	if ($Win64Client -eq [string]::empty) {
        $Win64Client = "5702227544774217577"
    }
	Clear-Host
	
	$SteamUser = Read-Host "Enter your Steam username"
	if ($SteamUser -eq [string]::empty) {
        $SteamUser = "fakeuser"
    }
	$SteamPW = Read-Host "Enter your Steam password" -AsSecureString
	$SteamPWPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SteamPW))
	
	Clear-Host
	
    Set-Location "$SteamCMD"
    .\steamcmd.exe +login $SteamUser $SteamPWPlain +download_depot 252490 252494 $CommonClient +quit
	robocopy steamapps\content\app_252490\depot_252494 "$ClientDir" /mt /e /r:3 /w:5 /move
	.\steamcmd.exe +login $SteamUser $SteamPWPlain +download_depot 252490 252495 $Win64Client +quit
	robocopy steamapps\content\app_252490\depot_252495 "$ClientDir" /mt /e /r:3 /w:5 /move
	
	Clear-Host
	Write-Host "Rust Client Installed!"
	Write-Host "----------------------"
	Write-Host "`n"
	Write-Host "All finished! Your client files are located in $ClientDir"
	Write-Host "`n"
	Write-Host "Be sure to launch Rust.exe and NOT RustClient.exe!"
	Write-Host "`n"
	Pause
	exit
}

#----------------------------------------------

# Rust Server Install
function RustServer {
    Clear-Host
	$host.UI.RawUI.WindowTitle = "Downloading Rust Server..."
    Write-Host "WARNING: Be sure there is not an existing Rust Server installation in this directory."
    Write-Host "The folder should either be empty or non-existent."
    Write-Host "`n"
    Write-Host "Enter the location you want the Rust Server installed (Default: C:\RustServer)"
    $ServerDir = Read-Host "Location"
    if ($ServerDir -eq [string]::empty) {
        $ServerDir = "C:\RustServer"
    }
    
    if (!(Test-Path $ServerDir)) {
        New-Item $ServerDir -ItemType Directory
        Write-Host "Rust Server Folder Created"
    }
	
	Clear-Host
	# Default is May 5th, 2022 (Old Recoil)
	$CommonServer = Read-Host "Enter the Rust Dedicated - Common Manifest ID"
	if ($CommonServer -eq [string]::empty) {
        $CommonServer = "8568126655709130498"
    }
	Write-Host "`n"
	$Win64Server = Read-Host "Enter the Rust Dedicated - Windows 64 Manifest ID"
	if ($Win64Server -eq [string]::empty) {
        $Win64Server = "7513979545449517167"
    }
	
	Clear-Host
	
    Set-Location "$SteamCMD"
    .\steamcmd.exe +login anonymous +download_depot 258550 258554 $CommonServer +quit
	robocopy steamapps\content\app_258550\depot_258554 "$ServerDir" /mt /e /r:3 /w:5 /move
	.\steamcmd.exe +login anonymous +download_depot 258550 258551 $Win64Server +quit
	robocopy steamapps\content\app_258550\depot_258551 "$ServerDir" /mt /e /r:3 /w:5 /move
	
    Set-Location "$ServerDir"

    Clear-Host
    Write-Host "Rust Server Installed!"
	Write-Host "----------------------"
	Write-Host "`n"
    MapChoice
}

#----------------------------------------------

# Map Choice
function MapChoice {
    $host.UI.RawUI.WindowTitle = "Setting Up Your Server"
    do {
        Write-Host "`nWhich kind of map are you using?"
        Write-Host "`t1. Procedural Map"
        Write-Host "`t2. Custom Map"
        
        $Choice = Read-Host "`nEnter 1 or 2"
        } until (($Choice -eq '1') -or ($Choice -eq '2'))
        switch ($Choice) {
        '1'{
                StartProc
        }
        '2'{
                RustEditChoice
        }
    }
}

#----------------------------------------------

# RustEdit Choice
function RustEditChoice {
    Clear-Host
    do {
        Write-Host "`nWould you like to install the RustEdit DLL?"
        Write-Host "nYou usually need this for custom maps."
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                RustEditInstall
        }
        'N'{
                StartCustom
        }
    }
}

#----------------------------------------------

# RustEdit Install
function RustEditInstall {
    $host.UI.RawUI.WindowTitle = "Setting Up Your Server"
    Set-Location $ServerDir\RustDedicated_Data\Managed\
    Invoke-WebRequest https://github.com/k1lly0u/Oxide.Ext.RustEdit/raw/master/Oxide.Ext.RustEdit.dll -OutFile 'Oxide.Ext.RustEdit.dll'
    Clear-Host
    Write-Host "RustEdit DLL installed!"
    StartCustom
}

#----------------------------------------------

# Start Procedural
function StartProc {
    Clear-Host
    $host.UI.RawUI.WindowTitle = "Creating Your Startup File..."
    Set-Location "$ServerDir"
    $ServerPort = Read-Host "Enter your server port (Default: 28015)"
    if ($ServerPort -eq [string]::empty) {
        $ServerPort = "28015"
    }
    Write-Host "`n"
    $RCONPort =  Read-Host "Enter your RCON port (Default: 28016)"
    if ($RCONPort -eq [string]::empty) {
        $RCONPort = "28016"
    }
    Write-Host "`n"
    $QueryPort =  Read-Host "Enter your server query port (Default: 28017)"
    if ($QueryPort -eq [string]::empty) {
        $QueryPort = "28017"
    }
    Write-Host "`n"
    Write-Host "Don't have any spaces in the identity name!"
    $Identity = Read-Host "Enter your server identity (Default: RustServer)"
    if ($Identity -eq [string]::empty) {
        $Identity = "RustServer"
    }
    Write-Host "`n"
    $Seed = Read-Host "Enter your map seed (Default: 1337)"
    if ($Seed -eq [string]::empty) {
        $Seed = "1337"
    }
    Write-Host "`n"
    $WorldSize = Read-Host "Enter your world size (Default: 4500)"
    if ($WorldSize -eq [string]::empty) {
        $WorldSize = "4500"
    }
    Write-Host "`n"
    $MaxPlayers = Read-Host "Enter the max players (Default: 150)"
    if ($MaxPlayers -eq [string]::empty) {
        $MaxPlayers = "150"
    }
    Write-Host "`n"
    $Hostname = Read-Host "Enter your server's hostname (How it appears on the server browser)"
    if ($Hostname -eq [string]::empty) {
        $Hostname = "A Simple Rust Server"
    }
    Write-Host "`n"
    $Description = Read-Host "Enter your server's description"
    if ($Description -eq [string]::empty) {
        $Description = "An unconfigured Rust server."
    }
    Write-Host "`n"
    $RCONPW = Read-Host "Enter your RCON password (make it secure!)"
    if ($RCONPW -eq [string]::empty) {
        $RCONPW = "ChangeThisPlease"
    }
    Write-Host "`n"
    $ServerURL = Read-Host "Enter your Server URL (Ex: Your Discord invite link. Can be blank if you don't have one)"
    Write-Host "`n"
    $HeaderImage = Read-Host "Enter your Server Header Image (Can be blank if you don't have one)"
    $StartServer = "StartServer.bat"
    # Creating Start File (Procedural Map)
$StartProc = @"
@echo off
:start
RustDedicated.exe -batchmode ^
-logFile "$Identity-logs.txt" ^
+server.queryport $QueryPort ^
+server.port $ServerPort ^
+server.level "Procedural Map" ^
+server.seed $Seed ^
+server.worldsize $WorldSize ^
+server.maxplayers $MaxPlayers ^
+server.hostname "$Hostname" ^
+server.description "$Description" ^
+server.headerimage "$HeaderImage" ^
+server.url "$ServerURL" ^
+server.identity "$Identity" ^
+rcon.port $RCONPort ^
+rcon.password $RCONPW ^
+rcon.web 1
goto start
"@
    # Creating server.cfg (Procedural Map)
    Set-Content $StartServer $StartProc
    $CFGLocation = "$ServerDir\server\$Identity\cfg"
    if (!(Test-Path $CFGLocation)) {
        New-Item $CFGLocation -ItemType Directory
    }
    $ServerCFG = "server.cfg"
$ServerCFGContent = @"
fps.limit "60"
"@
    # Creating Wipe File (Procedural Map)
    Set-Location $CFGLocation
    Set-Content $ServerCFG $ServerCFGContent
    Set-Location $ServerDir
    $WipeServer = "WipeServer.bat"
$WipeServerContent = @"
@echo off
:start
REM WipeServer.bat by lilciv#2944
mode 110,20
color 02
echo This file will allow you to wipe your server. Be sure you want to continue.
echo.
pause
echo.
choice /c yn /m "Do you want to wipe Blueprints?: "
IF ERRORLEVEL 2 goto wipemap
IF ERRORLEVEL 1 goto wipebp
:wipebp
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP, PLAYER, AND BLUEPRINT DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del *.db
del *.db-journal
del *.db-wal
goto finishbp
:wipemap
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP AND PLAYER DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del player.deaths.*
del player.identities.*
del player.states.*
del player.tokens.*
del sv.files.*
goto finishmap
:finishbp
echo.
echo Server has been Map and BP Wiped!
echo.
echo Be sure to change your map seed in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
exit
:finishmap
echo.
echo Server has been Map Wiped!
echo.
echo Be sure to change your map seed in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
"@
    Set-Content $WipeServer $WipeServerContent
    # Admin Check
    Clear-Host
    do {
        Write-Host "`nDo you want to add yourself as an admin on the server now?"
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                Admin
        }
        'N'{
                Finish
        }
    }
}

#----------------------------------------------

# Start Custom
function StartCustom {
    $host.UI.RawUI.WindowTitle = "Creating Your Startup File (Custom Map)..."
    Set-Location "$ServerDir"
    $ServerPort = Read-Host "Enter your server port (Default: 28015)"
    if ($ServerPort -eq [string]::empty) {
        $ServerPort = "28015"
    }
    Write-Host "`n"
    $RCONPort =  Read-Host "Enter your RCON port (Default: 28016)"
    if ($RCONPort -eq [string]::empty) {
        $RCONPort = "28016"
    }
    Write-Host "`n"
    $QueryPort =  Read-Host "Enter your server query port (Default: 28017)"
    if ($QueryPort -eq [string]::empty) {
        $QueryPort = "28017"
    }
    Write-Host "`n"
    Write-Host "Don't have any spaces in the identity name!"
    $Identity = Read-Host "Enter your server identity (Default: RustServer)"
    if ($Identity -eq [string]::empty) {
        $Identity = "RustServer"
    }
    Write-Host "`n"
    $LevelURL = Read-Host "Enter your custom map URL (Must be a direct download link!)"
    if ($LevelURL -eq [string]::empty) {
        $LevelURL = "https://www.dropbox.com/s/ig1ds1m3q5hnflj/proc_install_1.0.map?dl=1"
    }
    Write-Host "`n"
    $MaxPlayers = Read-Host "Enter the max players (Default: 150)"
    if ($MaxPlayers -eq [string]::empty) {
        $MaxPlayers = "150"
    }
    Write-Host "`n"
    $Hostname = Read-Host "Enter your server's hostname (How it appears on the server browser)"
    if ($Hostname -eq [string]::empty) {
        $Hostname = "A Simple Rust Server"
    }
    Write-Host "`n"
    $Description = Read-Host "Enter your server's description"
    if ($Description -eq [string]::empty) {
        $Description = "An unconfigured Rust server."
    }
    Write-Host "`n"
    $RCONPW = Read-Host "Enter your RCON password (make it secure!)"
    if ($RCONPW -eq [string]::empty) {
        $RCONPW = "ChangeThisPlease"
    }
    Write-Host "`n"
    $ServerURL = Read-Host "Enter your Server URL (Ex: Your Discord invite link. Can be blank if you don't have one)"
    Write-Host "`n"
    $HeaderImage = Read-Host "Enter your Server Header Image (Can be blank if you don't have one)"
    # Creating Start File (Custom Map)
    $StartServer = "StartServer.bat"
$StartCustom = @"
@echo off
:start
RustDedicated.exe -batchmode ^
-logFile "$Identity-logs.txt" ^
-levelurl "$LevelURL" ^
+server.queryport $QueryPort ^
+server.port $ServerPort ^
+server.maxplayers $MaxPlayers ^
+server.hostname "$Hostname" ^
+server.description "$Description" ^
+server.headerimage "$HeaderImage" ^
+server.url "$ServerURL" ^
+server.identity "$Identity" ^
+rcon.port $RCONPort ^
+rcon.password $RCONPW ^
+rcon.web 1
goto start
"@
    # Creating server.cfg (Custom Map)
    Set-Content $StartServer $StartCustom
    $CFGLocation = "$ServerDir\server\$Identity\cfg"
    if (!(Test-Path $CFGLocation)) {
        New-Item $CFGLocation -ItemType Directory
    }
    $ServerCFG = "server.cfg"
$ServerCFGContent = @"
fps.limit "60"
"@
    # Creating Wipe File (Custom Map)
    Set-Location $CFGLocation
    Set-Content $ServerCFG $ServerCFGContent
    Set-Location $ServerDir
    $WipeServer = "WipeServer.bat"
$WipeServerContent = @"
@echo off
:start
REM WipeServer.bat by lilciv#2944
mode 110,20
color 02
echo This file will allow you to wipe your server. Be sure you want to continue.
echo.
pause
echo.
choice /c yn /m "Do you want to wipe Blueprints?: "
IF ERRORLEVEL 2 goto wipemap
IF ERRORLEVEL 1 goto wipebp
:wipebp
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP, PLAYER, AND BLUEPRINT DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del *.db
del *.db-journal
del *.db-wal
goto finishbp
:wipemap
echo.
echo WARNING: THIS WILL WIPE YOUR SERVER'S MAP AND PLAYER DATA. BE SURE YOU WANT TO CONTINUE.
pause
echo.
cd /d server/$Identity
del *.sav
del *.sav.*
del *.map
del player.deaths.*
del player.identities.*
del player.states.*
del player.tokens.*
del sv.files.*
goto finishmap
:finishbp
echo.
echo Server has been Map and BP Wiped!
echo.
echo Be sure to check your custom map link in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
exit
:finishmap
echo.
echo Server has been Map Wiped!
echo.
echo Be sure to check your custom map link in your startup batch file!
echo Don't forget to delete any necessary plugin data!
echo.
pause
"@
    Set-Content $WipeServer $WipeServerContent
    # Admin Check
    Clear-Host
    do {
        Write-Host "`nDo you want to add yourself as an admin on the server now?"
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                Admin
        }
        'N'{
                Finish
        }
    }
}

#----------------------------------------------

# Admin
function Admin {
    Clear-Host
    Write-Host "If you do not know your SteamID, please go here: https://www.businessinsider.com/how-to-find-steam-id"
    Write-Host "`n"
    Write-Host "Admin and Moderator users are stored in the users.cfg file located here: $ServerDir\server\$Identity\cfg"
    Write-Host "`n"
    # This is not a valid SteamID, don't worry!
    $SteamID = Read-Host "Enter your Steam64 ID"
    if ($SteamID -eq [string]::empty) {
        $SteamID = "12345678901234567"
    }
    Set-Location $CFGLocation
    $UsersCFG = "users.cfg"
$UsersCFGContent = @"
ownerid $SteamID "unknown" "no reason"
"@
    Set-Content $UsersCFG $UsersCFGContent
    Finish
}

#----------------------------------------------

# Finish
function Finish {
    Clear-Host
    Write-Host "All finished! You will see these two batch files in $ServerDir"
    Write-Host "`n"
    Write-Host "StartServer.bat is to launch your server."
    Write-Host "WipeServer.bat is to wipe your server. You will be given the choice of just a map or a full blueprint wipe."
    Write-Host "`n"
    do {
        Write-Host "`nDo you want to run your new server now?"
        Write-Host "`tY = Yes"
        Write-Host "`tN = No"
        
        $Choice = Read-Host "`nEnter Y or N"
        } until (($Choice -eq 'Y') -or ($Choice -eq 'N'))
        switch ($Choice) {
        'Y'{
                ServerStart
        }
        'N'{
                Exit
        }
    }
}

#----------------------------------------------

# Server Start
function ServerStart {
    Set-Location $ServerDir
    Start-Process StartServer.bat
}

#----------------------------------------------

# Main Function
function Main {
    SteamCMD
}

Main