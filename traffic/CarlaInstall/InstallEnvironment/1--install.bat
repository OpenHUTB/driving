@echo off  
setlocal enabledelayedexpansion  
REM  ������滷���������
REM �������·��  
set "relativePath=\carla_unreal\unreal"  
set "fullPath="  
  
REM ��������������  
for %%d in (C D E F G) do (  
    REM ������ܵ�����·��  
    set "testPath=%%d:!relativePath!"  
      
    REM ���·���Ƿ����  
    if exist "!testPath!\" (  
        set "fullPath=!testPath!"  
        echo �ҵ�·����!fullPath!  
        goto foundPath  
    )  
)  
  REM ���û���ҵ�·���������������Ϣ  
if not defined fullPath (  
    echo ����ָ�������·�����������κ��������ϡ�  
	goto :eof
) 
:foundPath  
REM ʹ��setx���ϵͳ��������  
echo ���ڳ������û�������UE4_ROOTΪ !fullPath!...  
setx /m UE4_ROOT "!fullPath!"  
if !errorlevel! eq 0 (  
    echo ��������UE4_ROOT�ѳɹ�����Ϊ !fullPath!��  
    echo ��ע�⣺�µĻ�������������Ҫ�µ������д��ڻ�ϵͳ����������Ч��  
) else (  
    echo �����޷����û�������UE4_ROOT��  
    echo ��ȷ���Թ���Ա������д˽ű���  
)  
exit
endlocal





