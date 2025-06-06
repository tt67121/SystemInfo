@echo off
chcp 65001
:: 关闭资源管理器进程
taskkill /f /im explorer.exe

:: 暂停 2 秒，确保进程已停止
ping -n 2 127.0.0.1 >nul

:: 删除图标缓存文件
del /a /f /q "%localappdata%\IconCache.db"
del /a /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\iconcache_*.db"

:: 重启资源管理器进程
start explorer.exe

echo 图标缓存已清除。
pause