@echo off
mode con cols=120 lines=40
title Nessus插件更新v0.5 by:清晨
color 0a
echo.
echo =============================================温馨提示=============================================
echo.
echo 1）本程序只能更新（或安装）默认安装在C盘的Nessus插件。
echo.
echo 2）本程序运行需要以管理员身份运行，请右键以管理员身份运行本程序。
echo.
echo ==================================================================================================
echo.
echo ***请按任意键继续***
pause >nul

if exist "C:\Program Files\Tenable\Nessus\nessuscli.exe" (
	echo.
	echo [*] 存在nessuscli.exe程序，程序继续执行。
) else ( echo.
	echo [-] 您的系统没有安装Nessus或者Nessus没有根据默认安装在C盘。
	echo.
	echo 请按任意键退出。
	pause >nul
	exit
)
if exist "C:\ProgramData\Tenable\Nessus\nessus\plugins" (
	echo.
	echo [*] 存在plugins目录，程序继续执行。
) else ( echo.
	echo [-] 没有找到plugins目录，系统安装Nessus可能不正确。
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
echo.
net stop "Tenable Nessus"
echo [*] 去掉之前安装的插件只读、隐藏和系统属性权限，请稍等。。。
echo.
attrib -s -r -h "C:\ProgramData\Tenable\Nessus\nessus\plugins\*.*"
echo [*] 去掉plugin_feed_info.inc权限
echo.
attrib -s -r -h "C:\ProgramData\Tenable\Nessus\nessus\plugin_feed_info.inc"
if exist "C:\ProgramData\Tenable\Nessus\nessus\templates\settings.json" (
	echo [*] 去掉templates目录的json文件的权限
	echo.
	attrib -s -r -h "C:\ProgramData\Tenable\Nessus\nessus\templates\*.json"
	attrib -s -r -h "C:\ProgramData\Tenable\Nessus\nessus\templates\tmp\*.json"
	echo.
)
echo [*] 安装/更新Nessus插件，请稍等。。。
echo.
"C:\Program Files\Tenable\Nessus\nessuscli.exe" update "%plugin%"
echo.
set /p ver=请输入上面插件更新后显示的插件版本(千万不要乱输或输错)：
echo.
echo [*] 修改plugin_feed_info.inc文件
echo PLUGIN_SET = "%ver%"; >C:\ProgramData\Tenable\Nessus\nessus\plugins\plugin_feed_info.inc
echo PLUGIN_FEED = "ProfessionalFeed (Direct)"; >>C:\ProgramData\Tenable\Nessus\nessus\plugins\plugin_feed_info.inc
echo PLUGIN_FEED_TRANSPORT = "Tenable Network Security Lightning"; >>C:\ProgramData\Tenable\Nessus\nessus\plugins\plugin_feed_info.inc
echo PLUGIN_SET = "%ver%"; >C:\ProgramData\Tenable\Nessus\nessus\plugin_feed_info.inc
echo PLUGIN_FEED = "ProfessionalFeed (Direct)"; >>C:\ProgramData\Tenable\Nessus\nessus\plugin_feed_info.inc
echo PLUGIN_FEED_TRANSPORT = "Tenable Network Security Lightning"; >>C:\ProgramData\Tenable\Nessus\nessus\plugin_feed_info.inc
echo.
echo [*] 增加插件只读、隐藏和系统属性权限，请稍等。。。
echo.
attrib +s +r +h "C:\ProgramData\Tenable\Nessus\nessus\plugins\*.*"
echo [*] 增加plugin_feed_info.inc权限。
echo.
attrib +s +r +h "C:\ProgramData\Tenable\Nessus\nessus\plugin_feed_info.inc"
echo [*] 去掉plugins目录下的plugin_feed_info.inc权限。
echo.
attrib -s -r -h "C:\ProgramData\Tenable\Nessus\nessus\plugins\plugin_feed_info.inc"
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