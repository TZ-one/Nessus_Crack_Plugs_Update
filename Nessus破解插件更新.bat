@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

mode con cols=120 lines=40
title Nessus插件更新v0.7 by:清晨
color 0a

echo.
echo =============================================温馨提示=============================================
echo.
echo 如非默认安装路径，请修改update_config配置文件中的路径配置。
echo.
echo ==================================================================================================
echo.
echo ***请按任意键继续***
pause >nul

set "config=update_config"
set "nessuscli_path=C:\Program Files\Tenable\Nessus"
set "data_path=C:\ProgramData\Tenable\Nessus\nessus"

if exist "%config%" (
	echo.
	echo [*] 存在update_config文件，程序将使用update_config文件中配置的路径。
	for /f "usebackq tokens=1* delims==" %%a in ("%config%") do (
		set "%%a=%%b"
	)
) else ( echo.
	echo [-] 不存在update_config文件，将使用默认安装路径。
)

if exist "%nessuscli_path%\nessuscli.exe" (
	echo.
	echo [*] 存在nessuscli.exe程序，程序继续执行。
) else ( echo.
	echo [-] 没有找到nessuscli.exe程序，请确认update_config文件的nessuscli_path配置路径是否正确。
	echo.
	echo 请按任意键退出。
	pause >nul
	exit
)
if exist "%data_path%\plugins" (
	echo.
	echo [*] 存在plugins目录，程序继续执行。
) else ( echo.
	echo [-] 没有找到plugins目录，请确认update_config文件的data_path配置路径是否正确。
	echo.
	echo 请按任意键退出。
	pause >nul
	exit
)
:inputPluginPath
echo.
echo 输入插件包的绝对路径，如：C:\Users\Administrator\Desktop\all-2.0_202112192017.tar.gz
echo.
set /p plugin=请输入插件包的绝对路径：
if exist "%plugin%" goto start
echo.
echo [-] 输入的插件路径不存在，请重新输入！
goto inputPluginPath

:start
echo.
echo [*] 停止Nessus服务。
net stop "Tenable Nessus" >nul 2>&1
sc query "Tenable Nessus" 2>nul|find /i "STOPPED" >nul 2>&1 &&(
	echo [+] Nessus服务停止成功。
)||(
	echo [-] Nessus服务停止失败！程序将终止运行！
	echo 请按任意键退出。
	pause >nul
	exit
)
echo.
echo [*] 去掉之前安装的插件只读、隐藏和系统属性权限，请稍等。。。
echo.
attrib -s -r -h "%data_path%\plugins\*.*"
echo [*] 去掉plugin_feed_info.inc权限
echo.
attrib -s -r -h "%data_path%\plugin_feed_info.inc" >nul 2>&1
if exist "%data_path%\templates\settings.json" (
	echo [*] 去掉templates目录的json文件的权限
	echo.
	attrib -s -r -h "%data_path%\templates\*.json" >nul 2>&1
	attrib -s -r -h "%data_path%\templates\tmp\*.json" >nul 2>&1
)
echo [*] 安装/更新Nessus插件，请稍等。。。
echo.
"%nessuscli_path%\nessuscli.exe" update "%plugin%"
echo.
set /p ver=请输入上面插件更新后显示的插件版本(千万不要乱输或输错)：
echo.
echo [*] 修改plugin_feed_info.inc文件
echo PLUGIN_SET = "%ver%"; >%data_path%\plugins\plugin_feed_info.inc
echo PLUGIN_FEED = "HomeFeed (Non-commercial use only)"; >>%data_path%\plugins\plugin_feed_info.inc
echo PLUGIN_FEED_TRANSPORT = "Tenable Network Security Lightning"; >>%data_path%\plugins\plugin_feed_info.inc
echo PLUGIN_SET = "%ver%"; >%data_path%\plugin_feed_info.inc
echo PLUGIN_FEED = "HomeFeed (Non-commercial use only)"; >>%data_path%\plugin_feed_info.inc
echo PLUGIN_FEED_TRANSPORT = "Tenable Network Security Lightning"; >>%data_path%\plugin_feed_info.inc
echo.
echo [*] 增加插件只读、隐藏和系统属性权限，请稍等。。。
echo.
attrib +s +r +h "%data_path%\plugins\*.*"
echo [*] 增加plugin_feed_info.inc权限。
echo.
attrib +s +r +h "%data_path%\plugin_feed_info.inc"
echo [*] 去掉plugins目录下的plugin_feed_info.inc权限。
echo.
attrib -s -r -h "%data_path%\plugins\plugin_feed_info.inc"
echo [*] 启动Nessus服务。
echo.
net start "Tenable Nessus"
echo.
echo [+] Nessus插件更新完成！
echo.
echo 重启Nessus服务后，Nessus程序并没有完全启动，还需要等待几秒钟时间。
echo 等待10几秒后打开浏览器打开 https://127.0.0.1:8834/ 或者 https://localhost:8834/ 查看编译和插件更新情况。
echo.
echo 请按任意键退出。
pause >nul