
:: 防止中文输出乱码(虚拟目录存在中文时会出现乱码，把这句话放出来)
:: chcp 65001

:: 切换到当前bat所在的目录
cd /d %~dp0

:: 设置当前bat所在目录为站点所在目录
@set "sitePath=%cd%\"

:: 设置IISWeb站点名称
@set WebSiteName="NuGetServer" 

:: 设置应用程序池名称 
@set ApplicationPool_Name="NuGetServer"

:: 设置应用程序池.NETCLR版本  示例：""(无托管代码),"v4.0","v2.0"
@set ApplicationPool_NETCLRVersion="v4.0"

:: 设置IIS站点端口
@set WebSitePort=9999

:: 启用32位应用程序;默认：false;支持 true 或者 false;
@set Enable32BitAppOnWin64="true"

@echo off 
echo= 
@echo ---------------------------------------------------
@echo Start Deploy WebSite %WebSiteName% 
echo= 

:: 新建应用程序池
@echo Create IIS ApplicationPool start...
@C:\Windows\System32\inetsrv\appcmd.exe add apppool /name:%ApplicationPool_Name% /managedRuntimeVersion:%ApplicationPool_NETCLRVersion% /Enable32BitAppOnWin64:%Enable32BitAppOnWin64%
@echo Create IIS ApplicationPool finished...
echo= 

:: 新建IIS站点 绑定域名端口
@echo Create IIS Web Site start...
@C:\Windows\System32\inetsrv\appcmd.exe add site /name:%WebSiteName% /bindings:http/*:%WebSitePort%: /applicationDefaults.applicationPool:%ApplicationPool_Name% /physicalPath:%sitePath%
@echo Create IIS Web Site finished...
echo= 

:: 停止一下IIS站点
@echo stop WebSite start...
@C:\Windows\System32\inetsrv\appcmd.exe stop site %WebSiteName%
@echo stop WebSite finished...
echo= 

:: 启动IIS站点
@echo Restart WebSite start...
@C:\Windows\System32\inetsrv\appcmd.exe start site %WebSiteName%
@echo Restart WebSite finished...
echo= 

:: 给站点目录赋everyone访问权限，避免iis无法访问站点发布目录
@echo Access Configuration start...
cacls %sitePath% /t /e /g everyone:f 
@echo Access Configuration finished...
echo= 

:: 查看所有站点
@C:\Windows\System32\inetsrv\appcmd.exe list site

:: 查看所有应用程序池
@C:\Windows\System32\inetsrv\appcmd.exe list apppool

@echo Finished Deploy WebSite %WebSiteName%
echo= 
@echo ---------------------------------------------------
echo=



::高亮显示
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
rem echo say the name of the colors, don't read
:start
rem cls
call :ColorText 02 "---------------- 恭喜你，发布成功--------------------"
echo.
call :ColorText 02 "-----------------------------------------------------"
echo.
call :ColorText 02 "---------在浏览器输入以下网址进行访问网站------------"
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