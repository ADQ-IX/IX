
:: ��ֹ�����������(����Ŀ¼��������ʱ��������룬����仰�ų���)
:: chcp 65001

:: �л�����ǰbat���ڵ�Ŀ¼
cd /d %~dp0

:: ���õ�ǰbat����Ŀ¼Ϊվ������Ŀ¼
@set "sitePath=%cd%\"

:: ����IISWebվ������
@set WebSiteName="NuGetServer" 

:: ����Ӧ�ó�������� 
@set ApplicationPool_Name="NuGetServer"

:: ����Ӧ�ó����.NETCLR�汾  ʾ����""(���йܴ���),"v4.0","v2.0"
@set ApplicationPool_NETCLRVersion="v4.0"

:: ����IISվ��˿�
@set WebSitePort=9999

:: ����32λӦ�ó���;Ĭ�ϣ�false;֧�� true ���� false;
@set Enable32BitAppOnWin64="true"

@echo off 
echo= 
@echo ---------------------------------------------------
@echo Start Deploy WebSite %WebSiteName% 
echo= 

:: �½�Ӧ�ó����
@echo Create IIS ApplicationPool start...
@C:\Windows\System32\inetsrv\appcmd.exe add apppool /name:%ApplicationPool_Name% /managedRuntimeVersion:%ApplicationPool_NETCLRVersion% /Enable32BitAppOnWin64:%Enable32BitAppOnWin64%
@echo Create IIS ApplicationPool finished...
echo= 

:: �½�IISվ�� �������˿�
@echo Create IIS Web Site start...
@C:\Windows\System32\inetsrv\appcmd.exe add site /name:%WebSiteName% /bindings:http/*:%WebSitePort%: /applicationDefaults.applicationPool:%ApplicationPool_Name% /physicalPath:%sitePath%
@echo Create IIS Web Site finished...
echo= 

:: ֹͣһ��IISվ��
@echo stop WebSite start...
@C:\Windows\System32\inetsrv\appcmd.exe stop site %WebSiteName%
@echo stop WebSite finished...
echo= 

:: ����IISվ��
@echo Restart WebSite start...
@C:\Windows\System32\inetsrv\appcmd.exe start site %WebSiteName%
@echo Restart WebSite finished...
echo= 

:: ��վ��Ŀ¼��everyone����Ȩ�ޣ�����iis�޷�����վ�㷢��Ŀ¼
@echo Access Configuration start...
cacls %sitePath% /t /e /g everyone:f 
@echo Access Configuration finished...
echo= 

:: �鿴����վ��
@C:\Windows\System32\inetsrv\appcmd.exe list site

:: �鿴����Ӧ�ó����
@C:\Windows\System32\inetsrv\appcmd.exe list apppool

@echo Finished Deploy WebSite %WebSiteName%
echo= 
@echo ---------------------------------------------------
echo=



::������ʾ
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
rem echo say the name of the colors, don't read
:start
rem cls
call :ColorText 02 "---------------- ��ϲ�㣬�����ɹ�--------------------"
echo.
call :ColorText 02 "-----------------------------------------------------"
echo.
call :ColorText 02 "---------�����������������ַ���з�����վ------------"
echo.
echo http://127.0.0.1:%WebSitePort%
echo.
pause
goto :eof
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof
echo.
echo.


Pause