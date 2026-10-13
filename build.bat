@echo off
rem Windows build script (needs MinGW g++ 9 or newer, e.g. from MSYS2 / Code::Blocks / Dev-C++ TDM-GCC)
g++ -std=c++17 -Wall -Wextra -pedantic -O2 -o restaurant.exe src\*.cpp
if %errorlevel%==0 (echo Built: restaurant.exe - run it with restaurant.exe) else (echo Build failed)
pause
