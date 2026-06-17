## latexmk configuration file — LuaLaTeX Japanese build
##
## latexmk reads this file automatically when run in the same directory.
## Settings here override latexmk's built-in defaults.
## ============================================================

## Compile with LuaLaTeX
## %O = extra options passed by latexmk; %S = the source file name
$lualatex = 'lualatex -interaction=nonstopmode -halt-on-error -synctex=1 %O %S';

## PDF generation mode:
##   1 = pdflatex   2 = ps2pdf   3 = dvipdf   4 = lualatex/xelatex
$pdf_mode = 4;

## PDF viewer to open after a successful build (change to match your system)
## Linux:   evince, okular, zathura
## macOS:   open
## Windows: start
$pdf_previewer = 'evince';

## Do not auto-open the PDF viewer on every build (set to 1 to enable)
$preview_continuous_mode = 0;

## Default input file(s) when latexmk is run without arguments
@default_files = ('main.tex');
