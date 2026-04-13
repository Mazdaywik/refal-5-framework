@setlocal
@set REF5RSL=%~dp0..\lib;%~dp0..\src
@refgo desugar+LibraryEx+R5FW-Parser+R5FW-Transformer+R5FW-Plainer %*
@endlocal
