###############################################################################
## Makefile for apertium-uzb
###############################################################################

LANG1=uzb
BASENAME=apertium-$(LANG1)

TARGETS_COMMON = $(LANG1).automorf.hfst $(LANG1).autogen.hfst \
	$(LANG1).automorf.bin $(LANG1).autogen.bin \
	$(LANG1).automorf.att.gz $(LANG1).autogen.att.gz \
	$(LANG1)_guesser.automorf.bin $(LANG1)_guesser.automorf.hfst \
	$(LANG1).autopgen.bin \
        $(LANG1).rlx.bin

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Uzbek transducer
###############################################################################

####
## Guesser
####

.deps/$(LANG1).guesser.hfst: $(BASENAME).$(LANG1).guesser .deps/.d
	hfst-xfst -p  -e "source $<" -e "save stack $@" -E "hyvästi" 

.deps/$(LANG1)_guesser.lexc.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/$(LANG1).guesser.hfst .deps/.d 
	hfst-substitute -i .deps/$(LANG1).LR.lexc.hfst -o $@ -f '{🂡}:{🂡}' -T .deps/$(LANG1).guesser.hfst

.deps/$(LANG1).restrict_guesser.hfst: $(BASENAME).$(LANG1).rest .deps/.d
	hfst-regexp2fst $< -o $@

.deps/$(LANG1)_guesser.hfst: .deps/$(LANG1)_guesser.lexc.hfst .deps/$(LANG1).twol.hfst 
	hfst-compose-intersect -1 .deps/$(LANG1)_guesser.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

$(LANG1)_guesser.automorf.hfst: .deps/$(LANG1)_guesser.hfst .deps/$(LANG1).spellrelax.hfst .deps/$(LANG1).restrict_guesser.hfst 
	cat .deps/$(LANG1)_guesser.hfst | hfst-invert | hfst-compose -1 - -2 .deps/$(LANG1).restrict_guesser.hfst | hfst-invert | hfst-compose-intersect -1 - -2 .deps/$(LANG1).spellrelax.hfst | hfst-invert | hfst-fst2fst -w -o $@

$(LANG1)_guesser.automorf.bin: $(LANG1)_guesser.automorf.hfst .deps/.d
	hfst-fst2txt $(LANG1)_guesser.automorf.hfst   > .deps/$(LANG1)_guesser.autogen.att
	lt-comp lr .deps/$(LANG1)_guesser.autogen.att $@

#### 
## Spellrelax
####

.deps/$(LANG1).spellrelax.hfst: $(BASENAME).$(LANG1).spellrelax 
	hfst-regexp2fst -S -o $@ < $<

.deps/$(LANG1).twol.hfst: $(BASENAME).$(LANG1).twol .deps/.d
	hfst-twolc $< -o $@

.deps/$(LANG1).twoc.hfst: $(BASENAME).$(LANG1).twoc .deps/.d
	hfst-twolc $< -o $@

.deps/$(LANG1).RL.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/LR' > $@

.deps/$(LANG1).LR.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' > $@

.deps/$(LANG1).RL.lexc.hfst: .deps/$(LANG1).RL.lexc
	hfst-lexc $< -o $@ -v

.deps/$(LANG1).LR.lexc.hfst: .deps/$(LANG1).LR.lexc
	hfst-lexc $< -o $@ -v

.deps/$(LANG1).RL.hfst: .deps/$(LANG1).RL.lexc.hfst .deps/$(LANG1).twol.hfst .deps/$(LANG1).twoc.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).RL.lexc.hfst -2 .deps/$(LANG1).twol.hfst | hfst-compose-intersect -1 - -2 .deps/$(LANG1).twoc.hfst | hfst-minimise > $@

.deps/$(LANG1).LR.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/$(LANG1).twol.hfst .deps/$(LANG1).twoc.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).LR.lexc.hfst -2 .deps/$(LANG1).twol.hfst | hfst-compose-intersect -1 - -2 .deps/$(LANG1).twoc.hfst | hfst-minimise > $@

$(LANG1).autogen.hfst: .deps/$(LANG1).RL.hfst
	hfst-fst2fst -w $< -o $@

$(LANG1).automorf.hfst: .deps/$(LANG1).LR.hfst .deps/$(LANG1).spellrelax.hfst
	hfst-compose-intersect -1 $< -2 .deps/$(LANG1).spellrelax.hfst -o .deps/$(LANG1).LR.relaxed.hfst
	hfst-subtract -1 .deps/$(LANG1).LR.relaxed.hfst -2 .deps/$(LANG1).LR.hfst | hfst-reweight -a 1 -e -o .deps/$(LANG1).LR.errors.hfst
	hfst-union -1 .deps/$(LANG1).LR.hfst -2 .deps/$(LANG1).LR.errors.hfst | hfst-invert | hfst-fst2fst -w -o $@

$(LANG1).autogen.att.gz: $(LANG1).autogen.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).automorf.att.gz: $(LANG1).automorf.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

###############################################################################
## Debugging transducers (for testvoc)
###############################################################################

debug: .deps/$(LANG1).LR-debug.hfst .deps/$(LANG1).lexc.hfst

.deps/$(LANG1).LR-debug.hfst: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' | grep -v 'Use/Circ' > .deps/$(LANG1).LR-debug.lexc
	hfst-lexc .deps/$(LANG1).LR-debug.lexc -o .deps/$(LANG1).LR-debug.lexc.hfst -v
	hfst-compose-intersect -1 .deps/$(LANG1).LR-debug.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

.deps/$(LANG1).lexc.hfst: .deps/$(LANG1).RL.lexc.hfst
	hfst-fst2fst -w -i $< -o $@

###############################################################################
## Postgeneration
###############################################################################
$(LANG1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp lr $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx $(CGCOMP)
	$(CGCOMP) $< $@

###############################################################################
## Spell checker
###############################################################################

$(LANG1).zhfst: .deps/acceptor.default.hfst .deps/errmodel.default.hfst
	rm -f $@
	zip -j $@ .deps/acceptor.default.hfst .deps/errmodel.default.hfst speller/index.xml

.deps/errmodel.default.hfst: .deps/words.default.hfst .deps/strings.default.hfst
	python dev/editdist.py -v -s -d 1 -e '@0@' -i speller/editdist.default.txt -a .deps/acceptor.default.hfst \
	| hfst-txt2fst  -e '@0@' -o .deps/editdist.default.hfst
	hfst-disjunct .deps/strings.default.hfst .deps/editdist.default.hfst \
	| hfst-minimise | hfst-repeat -f 1 -t 2 -o .deps/editstrings.default.hfst
	hfst-disjunct .deps/words.default.hfst .deps/editstrings.default.hfst \
	| hfst-fst2fst  -f olw -o $@

.deps/words.default.hfst: speller/words.default.txt
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j -o $@

.deps/strings.default.hfst: speller/strings.default.txt .deps/anystar.hfst
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j | hfst-concatenate .deps/anystar.hfst - |\
	hfst-concatenate - .deps/anystar.hfst -o $@

.deps/anystar.hfst:
	echo "?*;" | hfst-regexp2fst -S -o $@

.deps/acceptor.default.hfst: $(LANG1).autogen.hfst
	cat $< | hfst-fst2fst -t | hfst-project  --project=lower | hfst-minimise |hfst-fst2fst  -f olw -o $@


###############################################################################
## Distribution
###############################################################################
EXTRA_DIST=$(BASENAME).$(LANG1).lexc \
	   $(BASENAME).$(LANG1).twol \
	   $(BASENAME).$(LANG1).rlx  \
	   $(BASENAME).post-$(LANG1).dix  \
	   modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_uzb_dir: This is where the compiled binaries go
#   apertium_uzb_srcdir: This is where the source files go

apertium_uzbdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_uzb_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_uzb_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS) $(LANG1).prob

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
	$(INSTALL_DATA) $(BASENAME).$(LANG1).lexc $(DESTDIR)$(apertium_uzb_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).twol $(DESTDIR)$(apertium_uzb_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_uzb_srcdir)
	$(INSTALL_DATA) $(BASENAME).post-$(LANG1).dix $(DESTDIR)$(apertium_uzb_srcdir)

###############################################################################
## Cleanup
###############################################################################


CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

test: all
	apertium-regtest test
