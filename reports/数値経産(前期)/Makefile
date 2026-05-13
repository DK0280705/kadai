## ============================================================
## Makefile — LuaLaTeX Japanese Report Build
##
## A Makefile defines named targets (e.g. 'all', 'clean').
## Run a target with: make <target>
## Each target block has the form:
##   target: dependencies
##   <TAB> shell command
##
## Usage:
##   make          → build the PDF
##   make clean    → remove intermediate files
##   make distclean → remove intermediate files AND the PDF
##   make images   → pre-generate figures with Python
## ============================================================

MAIN       := main
LATEX      := lualatex
LATEXFLAGS := -interaction=nonstopmode -halt-on-error -synctex=1
LATEXMK    := latexmk

.PHONY: all pdf images clean distclean

## Default target: prefer latexmk if available, otherwise fall back to manual build
## 'command -v' checks whether a program exists on the PATH
all:
	@if command -v $(LATEXMK) > /dev/null 2>&1; then \
	    $(MAKE) pdf-latexmk; \
	else \
	    $(MAKE) pdf-manual; \
	fi

## latexmk build (recommended) — latexmk reruns LaTeX as many times as needed
## to resolve cross-references, ToC, and bibliography automatically
pdf-latexmk:
	$(LATEXMK) $(MAIN).tex

## Manual build — run LuaLaTeX twice so cross-references (\ref, \cite)
## are written on the first pass and resolved on the second pass
pdf-manual:
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	@echo "---"
	@echo "PDF generated: $(MAIN).pdf"

## Generate images/temperature.png using Python (run before compiling the PDF)
images:
	python3 code/analysis.py

## Remove intermediate files produced by LaTeX (safe to delete; rebuilt each compile)
## .aux  = cross-reference data  .log  = compiler log  .toc = table of contents
## .fls/.fdb_latexmk = latexmk tracking files  .synctex.gz = SyncTeX source map
clean:
	rm -f $(MAIN).aux  $(MAIN).log  $(MAIN).toc  $(MAIN).out  \
	       $(MAIN).synctex.gz $(MAIN).fls $(MAIN).fdb_latexmk \
	       $(MAIN).nav $(MAIN).snm $(MAIN).vrb

## Remove everything including the final PDF (full clean slate)
distclean: clean
	rm -f $(MAIN).pdf
