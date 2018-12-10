# Edit to change path to Bracery
# BRACERY = bracery
BRACERY = $(HOME)/bracery/bin/bracery

# Data files
DATADIR = data
SYMDIR = $(DATADIR)/symbols
TMPLDIR = $(DATADIR)/templates
MAIN_TEMPLATE = $(TMPLDIR)/main.bracery
ALL_TEMPLATES = $(TMPLDIR)/markov.bracery

SYMBOLS = $(wildcard $(SYMDIR)/*.bracery) $(wildcard $(SYMDIR)/*.json)
TEMPLATES = $(filter-out $(ALL_TEMPLATES),$(filter-out $(MAIN_TEMPLATE),$(wildcard $(TMPLDIR)/*.bracery)))

DEFS = $(addprefix -d ,$(SYMBOLS))
MARKOV = -m $(ALL_TEMPLATES)
QUIZ = -q $(ALL_TEMPLATES)

# Top-level target
all: demo

# Run modes
demo: templates
	$(BRACERY) $(DEFS) $(MARKOV)

tags: templates
	$(BRACERY) $(DEFS) $(MARKOV) -v1

vars: templates
	$(BRACERY) $(DEFS) $(MARKOV) -v2

game: templates
	$(BRACERY) $(DEFS) $(QUIZ)

debug: templates
	$(BRACERY) $(DEFS) $(QUIZ) -v2

# Intermediate files
templates: $(ALL_TEMPLATES)

clean:
	rm $(ALL_TEMPLATES)

$(ALL_TEMPLATES): $(MAIN_TEMPLATE) $(TEMPLATES)
	cat $(MAIN_TEMPLATE) >$@
	for FILE in $(MAIN_TEMPLATE) $(TEMPLATES) ; do \
	echo >>$@; \
	cat $$FILE >>$@; \
	done

.SECONDARY:
