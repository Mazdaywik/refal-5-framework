@for %%r in ("%~dp0lib\*.ref" "%~dp0lib\windows\*.ref") do refc "%%r"

@echo Framework for Refal-5 is prepared.
@echo.
@echo For using this framework add folders
@echo  - "%~dp0lib"
@echo  - "%~dp0lib\windows"
@echo to REF5RSL environment variable.
