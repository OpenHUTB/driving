@echo off  
setlocal enabledelayedexpansion  
 
:: ����Ҫ���ҵ����·���б��÷ֺŷָ�  
SET "RelativePaths=carla_unreal\CMake\bin;carla_unreal\dotnet;carla_unreal\GnuWin32\bin;carla_unreal\Python37;carla_unreal\Python37\Scripts"  
  
:: ��ʼ��һ���������洢�ҵ��ľ���·���б�  
SET "FoundPaths="  
  
:: �������е��߼�������  
FOR %%d IN (C D E F G) DO (  
    IF EXIST "%%d:\" (  
        :: ����ÿ�����·��  
        FOR %%p IN (!RelativePaths!) DO (  
            :: ����������·��������Ƿ����  
            SET "FullPath=%%d:\%%p"  
            IF EXIST "!FullPath!" (  
                :: ���·�����ڣ�����ӵ�FoundPaths�б���  
                IF "!FoundPaths!"=="" (  
                    SET "FoundPaths=!FullPath!"  
                ) ELSE (  
                    SET "FoundPaths=!FoundPaths!;!FullPath!"  
                )  
            )  
        )  
    )  
)  
:: ����Ƿ��ҵ����κ�·��  
IF "!FoundPaths!"=="" (  
    ECHO No paths were found.  
    GOTO :EOF  
)  

:: ��ȡ��ǰ��Path��������ֵ  
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path') do set "currentPath=%%b"  
  
:: ����Ƿ��ȡ����Pathֵ�����û�л�ȡ���������ű�  
if "!currentPath!"=="" (  
    echo Failed to retrieve the current Path environment variable.  
    echo Please run this script as an administrator.  
    pause  
    exit /b  
)  
  
:: ���Path����������Ϊ�գ�������µ�·��������Path�У��÷ֺŷָ�  
set "FoundPaths=!currentPath!;!FoundPaths!"  
  
:: ���µ�Path��������ֵд�ص�ע�����  
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "!FoundPaths!" /f  
  
:: ��ʾ�û���Ҫ��������������µ�¼��ʹ������Ч  
echo Path environment variable updated successfully for the system.  
echo Please restart your computer or log off and log on again for the changes to take effect.  
exit