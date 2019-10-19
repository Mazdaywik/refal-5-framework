@echo off
setlocal
call make-sr.bat
set R05PATH=..\..\Refal-05\lib;..\..\Refal-05\src
call ..\..\Refal-05\c-plus-plus.conf.bat
if exist main-r05.exe erase main-r05.exe
..\..\Refal-05\bin\refal05c ^
  out\Main ^
  lib\Refal5-Lexer ^
  lib\Refal5-Parser ^
  lib\R5FW-Plainer ^
  out\Tests ^
  lib\R5FW-Transformer ^
  lib\R5FW-Parser-Defs ^
  lib\Refal5-AST ^
  lib\LibraryEx ^
  Library ^
  refal05rts
erase *.obj *.tds
ren main.exe main-r05.exe
main-r05.exe _tests_
main-r05.exe Main.ref out/Main.r05.ref
main-r05.exe ../lib/Refal5-Parser.ref out/Parser.r05.ref
endlocal
