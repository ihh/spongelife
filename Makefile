# Edit to change path to Bracery
BRACERY = bracery
# BRACERY = $(HOME)/bracery/bin/bracery

# Data files
DEFS = data/defs.txt
MARKOV = data/markov.txt

# Run modes
demo:
	$(BRACERY) -d $(DEFS) -m $(MARKOV)

tags:
	$(BRACERY) -d $(DEFS) -m $(MARKOV) -v1

vars:
	$(BRACERY) -d $(DEFS) -m $(MARKOV) -v2

game:
	$(BRACERY) -d $(DEFS) -q $(MARKOV)

debug:
	$(BRACERY) -d $(DEFS) -q $(MARKOV) -v2
