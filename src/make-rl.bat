@echo off
set SOURCES=Main R5FW-Parser R5FW-Parser-Defs R5FW-Transformer ^
  R5FW-Plainer Tests R5FW-Parser-Defs LibraryEx
set TARGEXE=Main-1.exe

if exist ..\rsls\Main-1.exe call :TEST NUL || exit /b 1

call :SRMAKE Main.ref
move Main.exe %TARGEXE%

call :TEST MAKE-OUT || exit /b 1

echo ===TEST OUT===
set TARGEXE=Main-2.exe
call :TEST MAKE-OUT || exit /b 1

goto :EOF

:TEST
  call :RUN_TRANSFORMER _tests_
  echo.
  for %%s in (%SOURCES%) do call :TRANSFORM %%s %1 || exit /b 1

  if {%1}=={MAKE-OUT} (
    erase out\*.rasl
    pushd out
    call :SRMAKE Main.ref
    popd
    move out\Main.exe Main-2.exe
  )
goto :EOF

:TRANSFORM
  set SOURCE=%1.ref
  if not exist %SOURCE% set SOURCE=..\lib\%SOURCE%
  mkdir out >NUL 2>NUL
  mkdir lib >NUL 2>NUL
  set TARGET=out\%SOURCE%
  if {%2}=={NUL} set TARGET=NUL
  call :RUN_TRANSFORMER %SOURCE% %TARGET% || exit /b 1
  echo.
  set RASL=out\%SOURCE:.ref=.rasl%
  set RASL=%RASL:\lib\=\out\%
  if {%2}=={MAKE-OUT} (
    pushd out
    call rlc -C %SOURCE%
    popd
    if not exist %RASL% call :FAILED
  )
goto :EOF

:RUN_TRANSFORMER
  %TARGEXE% %* || call :FAILED
  if exist __dump.txt erase __dump.txt
goto :EOF

:FAILED
  echo FAILED
  type __dump.txt
  erase ..\rsls\Main.rsl
  exit /b 1
goto :EOF

:SRMAKE
  setlocal
  set RLMAKE_FLAGS=-d ../lib
  call rlmake %*
  endlocal
  if exist *.rasl erase *.rasl
  if exist ..\lib\*.rasl erase ..\lib\*.rasl
  if exist *.cpp erase *.cpp
  if exist ..\lib\*.cpp erase ..\lib\*.cpp
  if exist *.obj erase *.obj
  if exist *.tds erase *.tds
goto :EOF
