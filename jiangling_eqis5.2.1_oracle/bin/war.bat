@echo off
cd..
echo [INFO] ����war��
call mvn clean package -Dmaven.test.skip=true
@pause