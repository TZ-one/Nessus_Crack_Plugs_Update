@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"

mode con cols=120 lines=40
title Nessus�������v0.7 by:�峿
color 0a

echo.
echo =============================================��ܰ��ʾ=============================================
echo.
echo ���Ĭ�ϰ�װ·�������޸�update_config�����ļ��е�·�����á�
echo.
echo ==================================================================================================
echo.
echo ***�밴���������***
pause >nul

set "config=update_config"
set "nessuscli_path=C:\Program Files\Tenable\Nessus"
set "data_path=C:\ProgramData\Tenable\Nessus\nessus"

if exist "%config%" (
	echo.
	echo [*] ����update_config�ļ�������ʹ��update_config�ļ������õ�·����
	for /f "usebackq tokens=1* delims==" %%a in ("%config%") do (
		set "%%a=%%b"
	)
) else ( echo.
	echo [-] ������update_config�ļ�����ʹ��Ĭ�ϰ�װ·����
)

if exist "%nessuscli_path%\nessuscli.exe" (
	echo.
	echo [*] ����nessuscli.exe���򣬳������ִ�С�
) else ( echo.
	echo [-] û���ҵ�nessuscli.exe������ȷ��update_config�ļ���nessuscli_path����·���Ƿ���ȷ��
	echo.
	echo �밴������˳���
	pause >nul
	exit
)
if exist "%data_path%\plugins" (
	echo.
	echo [*] ����pluginsĿ¼���������ִ�С�
) else ( echo.
	echo [-] û���ҵ�pluginsĿ¼����ȷ��update_config�ļ���data_path����·���Ƿ���ȷ��
	echo.
	echo �밴������˳���
	pause >nul
	exit
)
:inputPluginPath
echo.
echo ���������ľ���·�����磺C:\Users\Administrator\Desktop\all-2.0_202112192017.tar.gz
echo.
set /p plugin=�����������ľ���·����
if exist "%plugin%" goto start
echo.
echo [-] ����Ĳ��·�������ڣ����������룡
goto inputPluginPath

:start
echo.
echo [*] ֹͣNessus����
net stop "Tenable Nessus" >nul 2>&1
sc query "Tenable Nessus" 2>nul|find /i "STOPPED" >nul 2>&1 &&(
	echo [+] Nessus����ֹͣ�ɹ���
)||(
	echo [-] Nessus����ֹͣʧ�ܣ�������ֹ���У�
	echo �밴������˳���
	pause >nul
	exit
)
echo.
echo [*] ȥ��֮ǰ��װ�Ĳ��ֻ�������غ�ϵͳ����Ȩ�ޣ����Եȡ�����
echo.
attrib -s -r -h "%data_path%\plugins\*.*"
echo [*] ȥ��plugin_feed_info.incȨ��
echo.
attrib -s -r -h "%data_path%\plugin_feed_info.inc" >nul 2>&1
if exist "%data_path%\templates\settings.json" (
	echo [*] ȥ��templatesĿ¼��json�ļ���Ȩ��
	echo.
	attrib -s -r -h "%data_path%\templates\*.json" >nul 2>&1
	attrib -s -r -h "%data_path%\templates\tmp\*.json" >nul 2>&1
)
echo [*] ��װ/����Nessus��������Եȡ�����
echo.
"%nessuscli_path%\nessuscli.exe" update "%plugin%"
echo.
set /p ver=���������������º���ʾ�Ĳ���汾(ǧ��Ҫ��������)��
echo.
echo [*] �޸�plugin_feed_info.inc�ļ�
echo PLUGIN_SET = "%ver%"; >%data_path%\plugins\plugin_feed_info.inc
echo PLUGIN_FEED = "HomeFeed (Non-commercial use only)"; >>%data_path%\plugins\plugin_feed_info.inc
echo PLUGIN_FEED_TRANSPORT = "Tenable Network Security Lightning"; >>%data_path%\plugins\plugin_feed_info.inc
echo PLUGIN_SET = "%ver%"; >%data_path%\plugin_feed_info.inc
echo PLUGIN_FEED = "HomeFeed (Non-commercial use only)"; >>%data_path%\plugin_feed_info.inc
echo PLUGIN_FEED_TRANSPORT = "Tenable Network Security Lightning"; >>%data_path%\plugin_feed_info.inc
echo.
echo [*] ���Ӳ��ֻ�������غ�ϵͳ����Ȩ�ޣ����Եȡ�����
echo.
attrib +s +r +h "%data_path%\plugins\*.*"
echo [*] ����plugin_feed_info.incȨ�ޡ�
echo.
attrib +s +r +h "%data_path%\plugin_feed_info.inc"
echo [*] ȥ��pluginsĿ¼�µ�plugin_feed_info.incȨ�ޡ�
echo.
attrib -s -r -h "%data_path%\plugins\plugin_feed_info.inc"
echo [*] ����Nessus����
echo.
net start "Tenable Nessus"
echo.
echo [+] Nessus���������ɣ�
echo.
echo ����Nessus�����Nessus����û����ȫ����������Ҫ�ȴ�������ʱ�䡣
echo �ȴ�10������������� https://127.0.0.1:8834/ ���� https://localhost:8834/ �鿴����Ͳ�����������
echo.
echo �밴������˳���
pause >nul