DEFS = data/defs.txt
MARKOV = data/markov.txt

demo:
	bracery -d $(DEFS) -m $(MARKOV) -v6

game:
	bracery -d $(DEFS) -q $(MARKOV)

debug:
	bracery -d $(DEFS) -q $(MARKOV) -v6
