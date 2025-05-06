@echo off
REM 生成静态文件
hugo -D

REM 提交源码
git add .
git commit -m "推送: %date% %time%"
git push  -f origin main

pause