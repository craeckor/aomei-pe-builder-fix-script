@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('If the Script not Starts after you give CMD Admin Privilages, that means, you Run the Script not from the C: Drive, Please Copy the Script into the C: Drive, like C:\Users\%username%\ and run the Script again.' , '! Important !' , 0 , 48)"
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Also, if some Errors getting up, when the Script is running, like Connection gets Closed by the Remote Host: Close the Script and Run the Script again.' , '! Important !' , 0 , 48)"
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

title Fix Aomei PE Builder
goto Variables
::Set the Variables
:Variables
    Set InstallationPath=
::Deletes the Temp Folder and add it Again and Downloads wget
:wget
    rd /s /q "%Temp%\fix-aomei-pe-builder"
    rmdir "%Temp%\fix-aomei-pe-builder"
    mkdir "%Temp%\fix-aomei-pe-builder"
    powershell Invoke-WebRequest -Uri "http://87.106.126.182/pb/wget.exe" -OutFile "$env:temp\fix-aomei-pe-builder\wget.exe"
::Popping Up Introductions and Check, if Aomei PE Builder is in the Default Path
:Introduction
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('This Script works only, if you Installd the newest Version of Aomei PE Builder.' , '! Please Read the Introductions !' , 0 , 64)"
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('The Script Downloads a Custom hosts File to Bypass the Programm, but dont worry, the Script makes a Backup of your hosts File, so your Work is SAVE :).' , '! Please Read the Introductions !' , 0 , 64)"
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('It also starts the Aomei PE Builder automatically, after the start it stops the script and waits for the Process to finish, so you can do your ISO or Bootable USB Stick and after you finished the work and closed the Programm, the Script does a Rollback and Undo the Changes and Delete the Downloaded Files.' , '! Please Read the Introductions !' , 0 , 64)"
    if exist "C:\Program Files (x86)\AOMEI PE Builder 2.0\PEBuilder.exe" (
        goto EndIntroduction
    ) else (
        goto TypeInstallationPath
    )
::If the Programm Path is not the Default, it needs User Input.
:TypeInstallationPath
    cls
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('mmhhh, I cant find the program, did you install it in a different path?' , 'Programm not found or Programm is not in the Default Programm Path' , 0 , 48)"
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('If you didnt install the program, then why the hell did you download and run the script?, Nevermind, just install the program and after you install the program, just hit enter.' , 'Programm not found or Programm is not in the Default Programm Path' , 0 , 48)"
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('If you have already installed the program, please enter the installation path where you installed Aomei Pe Builder. At the end of the path you have to remove the backslash e.g. C:\Program Files\AOMEI PE Builder\ not C:\Program Files\AOMEI PE Builder\.' , 'Programm not found or Programm is not in the Default Programm Path' , 0 , 48)"
    cls
    echo Press Enter, if you Installed the Programm now or Enter the Programm Path without the \ at the End.
    set /p InstallationPath=
    if ["%InstallationPath%"]==[] (
        goto EndIntroduction
    ) else (
        powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('After this TextBox, the Script starts in 5 Seconds...' , 'Script starts...' , 0 , 64)"
        timeout /Nobreak /t 5
        cls
        goto Temp
    )
::It sets the Default Programm Path
:EndIntroduction
    set InstallationPath=C:\Program Files (x86)\AOMEI PE Builder 2.0
    powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('After this TextBox, the Script starts in 5 Seconds...' , 'Script starts...' , 0 , 64)"
    timeout /Nobreak /t 5
    cls
    goto Temp
::It create the Temp Folder
:Temp
    if exist "C:\Windows\Temp" (
        goto PBDownloadFolder
    ) else (
        mkdir "C:\Windows\Temp"
    )
::It create the PB Download Folder
:PBDownloadFolder
    if exist "C:\Windows\Temp\PB Download\" (
        goto x64Folder
    ) else (
        mkdir "C:\Windows\Temp\PB Download"
    )
::It create the x64 Folder
:x64Folder
    if exist "C:\Windows\Temp\PB Download\x64\" (
        goto x86Folder
    ) else (
        mkdir "C:\Windows\Temp\PB Download\x64"
    )
::It create the x86 Folder
:x86Folder
    if exist "C:\Windows\Temp\PB Download\x86\" (
        goto ISOx86
    ) else (
        mkdir "C:\Windows\Temp\PB Download\x86"
        goto PBDownloadx86
    )
::It checks, if the ISO x86 Files are existing
:ISOx86
    del /f "C:\Windows\Temp\PB Download\x86\FileList.txt"
    rd /s /q "C:\Windows\Temp\PB Download\x86\WimTemp"
    rmdir "C:\Windows\Temp\PB Download\x86\WimTemp"
    if exist "C:\Windows\Temp\PB Download\x86\ISO\Boot\boot.sdi" (
        dir /a-d /s /b "C:\Windows\Temp\PB Download\x86\ISO" | find /c ":" > "%Temp%\fix-aomei-pe-builder\x86files.tmp"
        find /c "9" "%Temp%\fix-aomei-pe-builder\x86files.tmp"
        if %errorlevel% equ 0 (
            goto ISOx64
        ) else (
            goto PBDownloadx86
        )
    ) else (
        goto PBDownloadx86
    )
::It checks, if the ISO x64 Files are existing
:ISOx64
    rd /s /q "C:\Windows\Temp\PB Download\x64\WimTemp"
    rmdir "C:\Windows\Temp\PB Download\x64\WimTemp"
    del /f "C:\Windows\Temp\PB Download\x64\FileList.txt"
    if exist "C:\Windows\Temp\PB Download\x64\ISO\bootmgr.efi" (
        dir /a-d /s /b "C:\Windows\Temp\PB Download\x64\ISO" | find /c ":" > "%Temp%\fix-aomei-pe-builder\x64files.tmp"
        find /c "17" "%Temp%\fix-aomei-pe-builder\x64files.tmp"
        if %errorlevel% equ 0 (
            goto PBDownloadTools
        ) else (
            goto PBDownloadx64
        )
    ) else (
        goto PBDownloadx64
    )
::It Downloads the ISO x86 Files and Extract it to the Right Place
:PBDownloadx86
    %Temp%\fix-aomei-pe-builder\wget.exe http://87.106.126.182/pb/ISOs/x86/ISO.zip -O "%Temp%\fix-aomei-pe-builder\ISOx86.zip"
    rd /s /q "C:\Windows\Temp\PB Download\x86\ISO"
    powershell Expand-Archive -LiteralPath "$env:temp\fix-aomei-pe-builder\ISOx86.zip" -DestinationPath 'C:\Windows\Temp\PB Download\x86'
    goto ISOx64
::It Downloads the ISO x64 Files and Extract it to the Right Place
:PBDownloadx64
    %Temp%\fix-aomei-pe-builder\wget.exe http://87.106.126.182/pb/ISOs/x64/ISO.zip -O "%Temp%\fix-aomei-pe-builder\ISOx64.zip"
    rd /s /q "C:\Windows\Temp\PB Download\x64\ISO"
    powershell Expand-Archive -LiteralPath "$env:temp\fix-aomei-pe-builder\ISOx64.zip" -DestinationPath 'C:\Windows\Temp\PB Download\x64'
    goto PBDownloadTools
::It Downloads the Tools, that needed to Bypass the Programm and Extract it to the Right Place
:PBDownloadTools
    %Temp%\fix-aomei-pe-builder\wget.exe http://87.106.126.182/pb/DownloadPath.ini -O "%InstallationPath%\DownloadPath.ini"
    copy /Y "C:\Windows\System32\drivers\etc\hosts" "%Temp%\fix-aomei-pe-builder\hosts"
    %Temp%\fix-aomei-pe-builder\wget.exe http://87.106.126.182/pb/hosts -O "C:\Windows\System32\drivers\etc\hosts"
    goto StartAomeiPE
::It Starts the Aomei PE Builder Programm and waits until the Process Ends to make the Rollback
:StartAomeiPE
    start "" /W "%InstallationPath%\PEBuilder.exe"
    goto Rollback
::It delets the Downloaded Files and Copy the Backup of the hosts File to the Right Place
:Rollback
    copy /Y "%Temp%\fix-aomei-pe-builder\hosts" "C:\Windows\System32\drivers\etc\hosts"
    rd /s /q "%Temp%\fix-aomei-pe-builder"
    rmdir "%Temp%\fix-aomei-pe-builder"
::It ends the Script, what do you expect of an end of a Script???
cls
pause
