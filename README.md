
# Rust Depot Downloader

This script will install a Rust Server or Client on your Windows machine using SteamDB Manifest IDs. All files are downloaded through SteamCMD.

## How Do I Find the Version I Want?
You can review the Facepunch Devblog (https://rust.facepunch.com/news/?category=devblog), which will have important dates that different versions of the game were released. You can take these dates over to SteamDB to find the corresponding Manifest IDs that you want.

Navigate to SteamDB. Determine whether you are downloading client files or server files.
**Client:** https://steamdb.info/app/252490/depots/
**Server:** https://steamdb.info/app/258550/depots/

Click on the Common and Windows 64 depots and locate the Manifest IDs that you want.
For example, May 5th, 2022 (Old Recoil) has the following Manifest IDs:

**Client (Common):** `5939934877855656786`
**Client (Windows 64):** `5702227544774217577`

**Server (Common):** `8568126655709130498`
**Server (Windows 64):** `7513979545449517167`

## How To Use
Right click on the RustDepotDownloader.ps1 file and choose "Run with PowerShell"
Follow the listed prompts. If you do not input Manifest IDs, it will use the default Old Recoil ones listed above.

This is not a way to download Rust for free. The server installation will allow anonymous install, however the client files of the game require Steam Authentication. All files are downloaded directly through Steam's servers.

For assistance, please message me on Discord: lilciv#2944  

Tested on Windows 10, and Windows Server 2019.
**NOTE**: For Windows 11, you will need to do the following beforehand:

1. Open PowerShell as Administrator
2. Enter the following command: `Set-ExecutionPolicy Unrestricted` - then press `A` to confirm.
3. Run the script. It will ask for confirmation. Press `R` to run it.
