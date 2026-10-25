SHGVER := $(shell awk '/ProvidesPackage\{showhanmengrid\}/{getline; sub(/^ *\[/, ""); print $$2}' showhanmengrid.sty)

DOCS := showhanmengrid.pdf

.PHONY: ctanzip
ctanzip: showhanmengrid.zip ## Archive for CTAN upload
showhanmengrid.zip: clean $(DOCS)
	git archive --format=tar --prefix=showhanmengrid/ HEAD | gtar -x
	## remove unpacked files
	cd showhanmengrid/ && \
		rm -f .gitignore Makefile ctan.toml
	## then, now just make archive
	zip -9 -r showhanmengrid.zip showhanmengrid/*
	rm -rf showhanmengrid
	@echo finished

## Example pages included in the documentation
EXAMPLES := test-overflow-ujbook-uplatex.pdf test-jlreq-tate-uplatex.pdf \
  test-jfm-natural-lualatex.pdf test-jfm-lualatex.pdf

.PHONY: showhanmengrid.pdf
showhanmengrid.pdf: showhanmengrid.tex $(EXAMPLES)
	lualatex -interaction=nonstopmode -halt-on-error $<
	lualatex -interaction=nonstopmode -halt-on-error $<

test-overflow-ujbook-uplatex.pdf: test-overflow.tex test-common.tex showhanmengrid.sty
	uplatex -interaction=nonstopmode -jobname=$(basename $@) '\def\CLS{ujbook}\input test-overflow' >/dev/null
	dvipdfmx -q $(basename $@).dvi

test-jfm-lualatex.pdf: test-jfm.tex jfm-shgtest.lua test-common.tex showhanmengrid.sty
	lualatex -interaction=nonstopmode -jobname=$(basename $@) '\input test-jfm' >/dev/null

test-jfm-natural-lualatex.pdf: test-jfm.tex jfm-shgtest.lua test-common.tex showhanmengrid.sty
	lualatex -interaction=nonstopmode -jobname=$(basename $@) '\def\PITCH{natural}\input test-jfm' >/dev/null

test-jlreq-tate-uplatex.pdf: test-jlreq.tex test-common.tex showhanmengrid.sty
	uplatex -interaction=nonstopmode -jobname=$(basename $@) '\def\TATE{1}\input test-jlreq' >/dev/null
	dvipdfmx -q $(basename $@).dvi

## Run the test suite ($(SHGVER)):
##  * every test compiles without errors or showhanmengrid warnings
##  * SHG-EXPECT OK: the number of chars/lines, the writing direction and
##    the overflow are as expected
##  * SHG-POS OK: the first character sits in the top left square of the
##    grid (SKIP for tate on LuaLaTeX; see test-common.tex)
##  * SHG-NOTE OK (where checked): the note on the character pitch
## test-nojapanese and test-mag are checked separately: they must warn.
## A test is "<engine>:<jobname>:<input>".
TESTS := \
  platex:test-ptex-platex:'\input test-ptex' \
  platex:test-ptex-tate-platex:'\input test-ptex-tate' \
  platex:test-jlreq-platex:'\input test-jlreq' \
  platex:test-jlreq-tate-platex:'\def\TATE{1}\input test-jlreq' \
  platex:test-overflow-jbook-platex:'\def\CLS{jbook}\input test-overflow' \
  platex:test-overflow-jsbook-platex:'\def\CLS{jsbook}\input test-overflow' \
  uplatex:test-ptex-uplatex:'\input test-ptex' \
  uplatex:test-ptex-tate-uplatex:'\input test-ptex-tate' \
  uplatex:test-jlreq-uplatex:'\input test-jlreq' \
  uplatex:test-jlreq-tate-uplatex:'\def\TATE{1}\input test-jlreq' \
  uplatex:test-overflow-ujbook-uplatex:'\def\CLS{ujbook}\input test-overflow' \
  uplatex:test-overflow-jsbook-uplatex:'\def\CLS{jsbook}\input test-overflow' \
  uplatex:test-keys-uplatex:'\input test-keys' \
  lualatex:test-luatexja-lualatex:'\input test-luatexja' \
  lualatex:test-luatexja-tate-lualatex:'\input test-luatexja-tate' \
  lualatex:test-jlreq-lualatex:'\input test-jlreq' \
  lualatex:test-jlreq-tate-lualatex:'\def\TATE{1}\input test-jlreq' \
  lualatex:test-overflow-ltjbook-lualatex:'\def\CLS{ltjbook}\input test-overflow' \
  lualatex:test-overflow-ltjsbook-lualatex:'\def\CLS{ltjsbook}\input test-overflow' \
  lualatex:test-keys-lualatex:'\input test-keys' \
  platex:test-kanjiskip-platex:'\input test-kanjiskip' \
  platex:test-kanjiskip-natural-platex:'\def\PITCH{natural}\input test-kanjiskip' \
  uplatex:test-kanjiskip-uplatex:'\input test-kanjiskip' \
  uplatex:test-kanjiskip-natural-uplatex:'\def\PITCH{natural}\input test-kanjiskip' \
  lualatex:test-kanjiskip-lualatex:'\input test-kanjiskip' \
  lualatex:test-kanjiskip-natural-lualatex:'\def\PITCH{natural}\input test-kanjiskip' \
  lualatex:test-jfm-lualatex:'\input test-jfm' \
  lualatex:test-jfm-natural-lualatex:'\def\PITCH{natural}\input test-jfm' \
  platex:test-tombo-jbook-platex:'\def\CLS{jbook}\input test-tombo' \
  platex:test-tombo-jsbook-platex:'\def\CLS{jsbook}\input test-tombo' \
  platex:test-tombo-jlreq-platex:'\def\OPT{}\def\CLS{jlreq}\def\PKG{jlreq-trimmarks}\input test-tombo' \
  platex:test-tombo-jlreq-tate-platex:'\def\OPT{tate}\def\CLS{jlreq}\def\PKG{jlreq-trimmarks}\input test-tombo' \
  uplatex:test-tombo-utbook-uplatex:'\def\CLS{utbook}\input test-tombo' \
  uplatex:test-tombo-gentombow-uplatex:'\def\OPT{}\def\CLS{ujarticle}\def\PKG{gentombow}\input test-tombo' \
  lualatex:test-tombo-gentombow-lualatex:'\def\OPT{}\def\CLS{ltjsarticle}\def\PKG{gentombow}\input test-tombo' \
  lualatex:test-tombo-jlreq-lualatex:'\def\OPT{}\def\CLS{jlreq}\def\PKG{jlreq-trimmarks}\input test-tombo'

.PHONY: test
test:
	@set -e; \
	for t in $(TESTS); do \
	  eng=$${t%%:*}; rest=$${t#*:}; job=$${rest%%:*}; in=$${rest#*:}; \
	  echo "== $$eng $$job"; \
	  $$eng -interaction=nonstopmode -jobname=$$job "$$in" >/dev/null 2>&1 || true; \
	  if [ -f $$job.dvi ]; then dvipdfmx -q $$job.dvi; fi; \
	  if grep -q '^!' $$job.log; then echo "NG: error in $$job.log"; exit 1; fi; \
	  if grep -q 'showhanmengrid Warning' $$job.log; then \
	    echo "NG: showhanmengrid warning in $$job.log"; exit 1; fi; \
	  if grep -q '^SHG-.* NG' $$job.log; then grep '^SHG-.* NG' $$job.log; exit 1; fi; \
	  grep -q '^SHG-EXPECT OK' $$job.log || \
	    { echo "NG: no SHG-EXPECT OK in $$job.log"; exit 1; }; \
	  grep -q '^SHG-POS \(OK\|SKIP\)' $$job.log || \
	    { echo "NG: no SHG-POS in $$job.log"; exit 1; }; \
	done; \
	echo "== pdflatex test-nojapanese-pdflatex"; \
	pdflatex -interaction=nonstopmode -jobname=test-nojapanese-pdflatex test-nojapanese >/dev/null; \
	grep -q 'Neither pTeX nor LuaTeX-ja found' test-nojapanese-pdflatex.log || \
	  { echo "NG: no warning in test-nojapanese-pdflatex.log"; exit 1; }; \
	for eng in platex lualatex; do \
	  job=test-mag-$$eng; echo "== $$eng $$job"; \
	  $$eng -interaction=nonstopmode -jobname=$$job test-mag >/dev/null 2>&1 || true; \
	  if [ -f $$job.dvi ]; then dvipdfmx -q $$job.dvi; fi; \
	  if grep -q '^!' $$job.log; then echo "NG: error in $$job.log"; exit 1; fi; \
	  grep -q 'mag=1200 is not supported' $$job.log || \
	    { echo "NG: no warning in $$job.log"; exit 1; }; \
	  grep -q '^SHG-MAG OK' $$job.log || \
	    { echo "NG: no SHG-MAG OK in $$job.log"; exit 1; }; \
	done; \
	echo "All tests passed ($(SHGVER))"

.PHONY: clean
clean: ## Clean this repository
	rm -rf showhanmengrid.zip showhanmengrid
	rm -f *.aux *.log *.out *.toc *.dvi *.synctex.gz
	rm -f test-*.pdf
	find . -type f -name "*~" -delete
