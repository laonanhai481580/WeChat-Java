@echo off
cd..
echo [INFO] ʹ��maven����pom.xml ��������jar��/WEB-INF/lib
call mvn clean dependency:copy-dependencies

pause