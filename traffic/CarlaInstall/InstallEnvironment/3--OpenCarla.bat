@echo off

set "UnrealEnginePath=\carla_unreal\unreal\Engine\Binaries\Win64"
set "uprojectPath=\carla_unreal\carla1\Unreal\CarlaUE4\CarlaUE4.uproject"

for %%d in (C D E F G) do (
    if exist "%%d:%UnrealEnginePath%\" (
        cd /d "%%d:%UnrealEnginePath%"
        start "" "UE4Editor.exe" "%%d:%uprojectPath%"
        exit /b
    )
)
exit
pause