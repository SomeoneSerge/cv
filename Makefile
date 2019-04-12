NAME = cv
NOTES_TEX = $(shell find . -type f -iname '*.tex')
MAIN_FILE = cv.tex

$(NAME).pdf: $(MAIN_FILE) $(NOTES_TEX) $(NAME).bbl
	xelatex -jobname=$(NAME) $< || rm -f $@
	xelatex -jobname=$(NAME) $< || rm -f $@


$(NAME).bcf $(NAME).aux: $(MAIN_FILE) $(NOTES_TEX)
	xelatex -jobname=$(NAME) $< || rm -f $@


# %.bbl: %.bcf
# 	bibtex $*

%.bbl: %.aux
	biber $*

.PHONY: clean view-pdf

clean:
	rm -rf $(NAME).{out,aux,toc,bcf,log,run.xml,toc,bbl,blg,pdf}

view-pdf: $(NAME).pdf
	xdg-open $(NAME).pdf 2>/dev/null >/dev/null &
