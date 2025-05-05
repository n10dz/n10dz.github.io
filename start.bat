@echo off
REM 生成静态文件
hugo -D

REM 进入public目录提交
cd public
git add .
git commit -m "自动部署: %date% %time%"
git push origin gh-pages
cd ..

REM 提交源码（可选）
git add .
git commit -m "更新源码: %date% %time%"
git push origin main

pause