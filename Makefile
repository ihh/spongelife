# Edit to change path to Bracery
BRACERY = bracery
# BRACERY = $(HOME)/bracery/bin/bracery

# Data files
SYMBOLS = $(wildcard data/symbols/*.txt)
TEMPLATES = $(wildcard data/templates/*.txt)

DEFS = $(addprefix -d ,$(SYMBOLS))
MARKOV = $(addprefix -m ,$(TEMPLATES))
QUIZ = $(addprefix -q ,$(TEMPLATES))

# Run modes
demo:
	$(BRACERY) $(DEFS) $(MARKOV)

tags:
	$(BRACERY) $(DEFS) $(MARKOV) -v1

vars:
	$(BRACERY) $(DEFS) $(MARKOV) -v2

game:
	$(BRACERY) $(DEFS) $(QUIZ)

debug:
	$(BRACERY) $(DEFS) $(QUIZ) -v2
