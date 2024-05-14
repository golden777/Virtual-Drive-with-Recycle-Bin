@echo off
chcp 65001>nul
title 虚拟磁盘带回收站 Virtual Drive with Recycle Bin

::powershell -Command "[guid]::NewGuid().ToString().ToUpper()"
:rech
echo 创建虚拟磁盘请输入1,给已经映射的网络盘符增加回收站请输入2,回车确认
echo Please enter 1 to create a virtual disk, enter 2 to add a recycle bin to the mapped network drive letter, and press Enter to confirm.
set /p choice=

echo %choice%



if "%choice%"=="1" (
    goto cho1
)

if "%choice%"=="2" (
    goto :cho2
)

cls
echo 输入错误,请重试
goto rech

pause


:cho1

FOR /F "tokens=* USEBACKQ" %%F IN (`powershell -Command "[guid]::NewGuid().ToString().ToUpper()"`) DO (
    SET uuid=%%F
)
rem echo %uuid%

set /p base_path=drag base folder here 把虚拟盘对应目录拖进来,目录名不能有中文:
rem echo %base_path%

set reg_base_path=%base_path:\=\\%
set reg_base_path=%reg_base_path:"=%
rem echo %reg_base_path%



@set /p Virtual_Drive=Drive letter 盘符:
rem echo %Virtual_Drive%

set filename="Creat Virtual Drive %Virtual_Drive% 创建虚拟盘%Virtual_Drive% (%uuid%).reg"
echo Windows Registry Editor Version 5.00>%filename%
echo.>>%filename%
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices]>>%filename%
echo "%Virtual_Drive%:"="\\??\\%reg_base_path%">>%filename%
echo.>>%filename%
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{%uuid%}]>>%filename%
echo "RelativePath"="%Virtual_Drive%:\\">>%filename%
echo "Category"=dword:00000004>>%filename%
echo "Name"="%Virtual_Drive%">>%filename%

rem 下面是删除

set filenamedel="Delete Virtual Drive %Virtual_Drive% 删除虚拟盘%Virtual_Drive% (%uuid%).reg"
echo Windows Registry Editor Version 5.00>%filenamedel%
echo.>>%filenamedel%
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices]>>%filenamedel%
echo "%Virtual_Drive%:"=->>%filenamedel%
echo.>>%filenamedel%
echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{%uuid%}]>>%filenamedel%



echo 导入注册表后需要重启生效
echo After importing the registry, it needs to be restarted to take effect.
pause 
%filename%

echo 按任意键继续添加或关闭退出
pause
cls
goto rech

:cho2
FOR /F "tokens=* USEBACKQ" %%F IN (`powershell -Command "[guid]::NewGuid().ToString().ToUpper()"`) DO (
    SET uuid=%%F
)
set /p netdriver= Network drive letter 网络驱动器盘符:

set filename="Add recycle bin to network drive %netdriver% 给网络驱动器%netdriver%增加回收站 (%uuid%).reg"
echo Windows Registry Editor Version 5.00>%filename%
echo.>>%filename%
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{%uuid%}]>>%filename%
echo "RelativePath"="%netdriver%:\\">>%filename%
echo "Category"=dword:00000004>>%filename%
echo "Name"="%netdriver%">>%filename%
rem 下面是删除

set filenamedel="Delete recycle bin to network drive %netdriver% 删除网络驱动器%netdriver%的回收站 (%uuid%).reg"
echo Windows Registry Editor Version 5.00>%filenamedel%
echo.>>%filenamedel%
echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{%uuid%}]>>%filenamedel%

echo 导入注册表后需要重启生效
echo After importing the registry, it needs to be restarted to take effect.
pause 
%filename%
echo 按任意键继续添加或关闭退出
pause
cls
goto rech