@pushd "%~dp0lib"
@call refcall.cmd || exit /b 1
@popd

@pushd "%~dp0src"
@call refcall.cmd || exit /b 1
@popd

@echo Framework for Refal-5 is prepared.
@echo.
@echo For using this framework add folders
@echo  - "%~dp0lib"
@echo  - "%~dp0lib\windows"
@echo to REF5RSL environment variable.
