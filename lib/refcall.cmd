@for %%r in (*.ref windows\*.ref) do @refc "%%~r" || exit /b 1
