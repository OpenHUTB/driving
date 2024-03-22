@echo off  
setlocal enabledelayedexpansion  
REM  虚幻引擎环境变量添加
REM 定义相对路径  
set "relativePath=\carla_unreal\unreal"  
set "fullPath="  
  
REM 遍历所有驱动器  
for %%d in (C D E F G) do (  
    REM 构造可能的完整路径  
    set "testPath=%%d:!relativePath!"  
      
    REM 检查路径是否存在  
    if exist "!testPath!\" (  
        set "fullPath=!testPath!"  
        echo 找到路径：!fullPath!  
        goto foundPath  
    )  
)  
  REM 如果没有找到路径，则输出错误消息  
if not defined fullPath (  
    echo 错误：指定的相对路径不存在于任何驱动器上。  
	goto :eof
) 
:foundPath  
REM 使用setx添加系统环境变量  
echo 正在尝试设置环境变量UE4_ROOT为 !fullPath!...  
setx /m UE4_ROOT "!fullPath!"  
if !errorlevel! eq 0 (  
    echo 环境变量UE4_ROOT已成功设置为 !fullPath!。  
    echo 请注意：新的环境变量设置需要新的命令行窗口或系统重启才能生效。  
) else (  
    echo 错误：无法设置环境变量UE4_ROOT。  
    echo 请确保以管理员身份运行此脚本。  
)  
exit
endlocal





