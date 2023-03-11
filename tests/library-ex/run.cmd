@echo off
call :MAIN %*
exit /b

:MAIN
setlocal
  if {%1}=={} (
    for %%s in (*.ref) do call :RUN_TEST %%s || exit /b 1
  ) else (
    for %%s in (%*) do call :RUN_TEST %%s || exit /b 1
  )
endlocal
goto :EOF

:RUN_TEST
setlocal
  echo Passing %1...
  refc %1
  set REF5RSL=..\..\lib
  echo Y| refgo %~n1+LibraryEx 2>__err.txt
  if errorlevel 1 (
    echo Parser failed, see __err.txt for details
    exit /b 1
  )
  echo.

  erase %~n1.rsl __err.txt
endlocal
goto :EOF
