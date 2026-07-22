MAIN       := main
LATEX      := lualatex
LATEXFLAGS := -interaction=nonstopmode -halt-on-error -synctex=1
LATEXMK    := latexmk

.PHONY: all pdf images clean distclean

all:
	@if command -v $(LATEXMK) > /dev/null 2>&1; then \
	    $(MAKE) pdf-latexmk; \
	else \
	    $(MAKE) pdf-manual; \
	fi

pdf-latexmk:
	$(LATEXMK) $(MAIN).tex

pdf-manual:
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	@echo "---"
	@echo "PDF generated: $(MAIN).pdf"

images:
	python3 code/analysis.py

clean:
	rm -f $(MAIN).aux  $(MAIN).log  $(MAIN).toc  $(MAIN).out  \
	       $(MAIN).synctex.gz $(MAIN).fls $(MAIN).fdb_latexmk \
	       $(MAIN).nav $(MAIN).snm $(MAIN).vrb

distclean: clean
	rm -f $(MAIN).pdf
