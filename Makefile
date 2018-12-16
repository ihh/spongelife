# Edit to change path to Bracery
# BRACERY = bracery
BRACERY = $(HOME)/bracery/bin/bracery

# Data files
DATADIR = data
WEBDIR = web

SYMDIR = $(DATADIR)/symbols
TMPLDIR = $(DATADIR)/templates
MAIN_TEMPLATE = $(TMPLDIR)/main.bracery

ALL_TEMPLATES = $(WEBDIR)/markov.bracery
ALL_SYMBOLS = $(WEBDIR)/symbols.bracery

SYMBOLS_BRACERY = $(wildcard $(SYMDIR)/*.bracery)
SYMBOLS_JSON = $(wildcard $(SYMDIR)/*.json)
TEMPLATES = $(filter-out $(ALL_TEMPLATES),$(filter-out $(MAIN_TEMPLATE),$(wildcard $(TMPLDIR)/*.bracery)))

DEFS = -d $(ALL_SYMBOLS)
MARKOV = -m $(ALL_TEMPLATES)
QUIZ = -q $(ALL_TEMPLATES)

ifneq ($(SEED),)
RNDSEED = -R $(SEED)
endif

# Top-level target
all: demo

# Run modes
demo: compendium
	$(BRACERY) $(RNDSEED) $(DEFS) $(MARKOV)

tags: compendium
	$(BRACERY) $(RNDSEED) $(DEFS) $(MARKOV) -v1

vars: compendium
	$(BRACERY) $(RNDSEED) $(DEFS) $(MARKOV) -v2

game: compendium
	$(BRACERY) $(RNDSEED) $(DEFS) $(QUIZ)

debug: compendium
	$(BRACERY) $(RNDSEED) $(DEFS) $(QUIZ) -v2

# Intermediate files
compendium: $(ALL_TEMPLATES) $(ALL_SYMBOLS)

clean:
	rm $(ALL_TEMPLATES) $(ALL_SYMBOLS)

$(ALL_TEMPLATES): $(MAIN_TEMPLATE) $(TEMPLATES)
	@cat $(MAIN_TEMPLATE) >$@
	@for FILE in $(MAIN_TEMPLATE) $(TEMPLATES) ; do \
	 echo >>$@; \
	 cat $$FILE >>$@; \
	 echo \#\# RESET >>$@; \
	 done

$(ALL_SYMBOLS): $(SYMBOLS_BRACERY) $(SYMBOLS_JSON)
	@$(BRACERY) $(addprefix -d ,$(SYMBOLS_JSON)) -O $@
	@for FILE in $(SYMBOLS_BRACERY) ; do \
	 echo >>$@; \
	 cat $$FILE >>$@; \
	 echo \#\# RESET >>$@; \
	 done

# Web
webstart:
	npm install
	$(MAKE) web/bracery.js

web/bracery.js: node_modules/bracery/web/bracery.js
	cp $< $@

.SECONDARY:
