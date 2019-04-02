@echo off
setlocal
call make-sr.bat
set R05PATH=..\..\Refal-05\lib;..\..\Refal-05\src
call ..\..\Refal-05\c-plus-plus.conf.bat
..\..\Refal-05\bin\refal05c ^
  out\Main ^
  out\Lexer ^
  out\Parser ^
  out\Plainer ^
  out\Tests ^
  out\Transformer ^
  out\Utils ^
  Library ^
  refal05rts
erase *.obj *.tds
endlocal
