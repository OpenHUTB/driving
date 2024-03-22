@echo off  
setlocal enabledelayedexpansion  
 
:: 定义要查找的相对路径列表，用分号分隔  
SET "RelativePaths=carla_unreal\CMake\bin;carla_unreal\dotnet;carla_unreal\GnuWin32\bin;carla_unreal\Python37;carla_unreal\Python37\Scripts"  
  
:: 初始化一个变量来存储找到的绝对路径列表  
SET "FoundPaths="  
  
:: 遍历所有的逻辑驱动器  
FOR %%d IN (C D E F G) DO (  
    IF EXIST "%%d:\" (  
        :: 遍历每个相对路径  
        FOR %%p IN (!RelativePaths!) DO (  
            :: 构造完整的路径并检查是否存在  
            SET "FullPath=%%d:\%%p"  
            IF EXIST "!FullPath!" (  
                :: 如果路径存在，则添加到FoundPaths列表中  
                IF "!FoundPaths!"=="" (  
                    SET "FoundPaths=!FullPath!"  
                ) ELSE (  
                    SET "FoundPaths=!FoundPaths!;!FullPath!"  
                )  
            )  
        )  
    )  
)  
:: 检查是否找到了任何路径  
IF "!FoundPaths!"=="" (  
    ECHO No paths were found.  
    GOTO :EOF  
)  

:: 获取当前的Path环境变量值  
for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path') do set "currentPath=%%b"  
  
:: 检查是否获取到了Path值，如果没有获取到则跳出脚本  
if "!currentPath!"=="" (  
    echo Failed to retrieve the current Path environment variable.  
    echo Please run this script as an administrator.  
    pause  
    exit /b  
)  
  
:: 如果Path环境变量不为空，则添加新的路径到现有Path中，用分号分隔  
set "FoundPaths=!currentPath!;!FoundPaths!"  
  
:: 将新的Path环境变量值写回到注册表中  
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "!FoundPaths!" /f  
  
:: 提示用户需要重启计算机或重新登录以使更改生效  
echo Path environment variable updated successfully for the system.  
echo Please restart your computer or log off and log on again for the changes to take effect.  
exit