@echo off    
setlocal enabledelayedexpansion   
    
REM ��ȡ��ǰ�ű�������·��    
set "scriptPath=%~dp0"    
set "scriptDir=!scriptPath:~0,-1!"  REM ȥ��·��ĩβ�ķ�б�ܣ�����еĻ�    
    
REM ƴ����Ŀ¼·�����ű�·�������û�������UE4_ROOT    
set "UE4_ROOT=!scriptDir!\unreal"    
    
REM ��ʾ���õĻ�������    
echo ��������UE4_ROOT������Ϊ��!UE4_ROOT!    
    
REM �������·���б�    
set "RelativePaths=CMake\bin;dotnet;GnuWin32\bin;Python37;Python37\Scripts"    
  
  
:: ��ȡ��ǰ��Path��������ֵ  
for /f "tokens=2 delims==" %%a in ('set Path') do set "CurrentPath=%%a" 
REM ��ȡ��ǰ��Path��������  
set "currentPath=%path%"  
    
REM ��ÿ�����·��ת��Ϊ����·��������ӵ�newPath��    
for %%p in (%RelativePaths%) do (    
    set "absPath=!scriptDir!\%%p"    
    set "currentPath=!currentPath!;!absPath!"    
)  
REM ��ʱ���·����Path�����������ڵ�ǰ�Ự����Ч��  
set "path=%currentPath%"

  
REM ��ʾ���º��Path��������    
echo path���������Ѹ���Ϊ��    
echo !path!    

REM ��������ڵ�ǰ�ű���·��  
set "UnrealEnginePath=unreal\Engine\Binaries\Win64"  
set "uprojectPath=carla1\Unreal\CarlaUE4\CarlaUE4.uproject"  
  
REM ����������UnrealEnginePath��uprojectPath·��  
set "FullUnrealEnginePath=%~dp0!UnrealEnginePath!"  
set "FulluprojectPath=%~dp0!uprojectPath!"  
  
REM �л���UnrealEnginePathĿ¼�������Ҫ��  
if exist "!FullUnrealEnginePath!" (  
    cd /d "!FullUnrealEnginePath!"  
) else (  
    echo Unreal Engine path not found.  
    exit /b  
)  
  
REM ����UE4Editor.exe������uprojectPath������·��  
start "" "UE4Editor.exe" "!FulluprojectPath!"  
 

REM �������ػ�����������    
endlocal    
  
REM ע�⣺�˽ű����õĻ�������ֻ�ڵ�ǰ�����лỰ����Ч   
pause