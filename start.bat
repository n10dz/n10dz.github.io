@echo off
REM ���ɾ�̬�ļ�
hugo -D

REM �ύԴ��
git add .
git commit -m "����: %date% %time%"
git push  origin main

pause