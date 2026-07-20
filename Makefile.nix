# Exporta sbc.org → sbc.pdf usando Emacs+Org via Nix
#
# Pré-requisito: Nix instalado
#   https://nixos.org/download
#
# O arquivo sbc-template.sty deve estar no mesmo diretório que sbc.org
# (ou em um caminho indicado por TEXINPUTS).
#
# Uso:
#   make        # exporta sbc.org → sbc.pdf
#   make clean  # remove sbc.pdf e arquivos intermediários do LaTeX

ORG_SRC = sbc.org
PDF_OUT = sbc.pdf

# Ferramentas LaTeX disponíveis no ambiente Nix (packages.all)
LATEX_CMD = nix run .#latexTools -- latexmk

.PHONY: all clean

all: $(PDF_OUT)

$(PDF_OUT): $(ORG_SRC)
	@echo ">> Exportando $< → $@"
	TEXINPUTS=".:$$TEXINPUTS" \
	EMACSLOADPATH=".:$$EMACSLOADPATH" \
	nix run . -- emacs --batch "$<" \
		--eval '(setq org-babel-no-eval-on-ctrl-c-ctrl-x t)' \
		--eval '(setq org-latex-pdf-process (list "latexmk -pdf %f"))' \
		--eval '(org-latex-export-to-pdf)'

clean:
	rm -f $(PDF_OUT) $(PDF_OUT:.pdf=.tex) $(PDF_OUT:.pdf=.aux) \
	      $(PDF_OUT:.pdf=.log) $(PDF_OUT:.pdf=.out) $(PDF_OUT:.pdf=.bbl) \
	      $(PDF_OUT:.pdf=.blg) $(PDF_OUT:.pdf=.toc) $(PDF_OUT:.pdf=.lot) \
	      $(PDF_OUT:.pdf=.lof) $(PDF_OUT:.pdf=.fls) $(PDF_OUT:.pdf=.fdb_latexmk)
