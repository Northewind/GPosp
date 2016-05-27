PROCD=tests
ORIGF=$(PROCD)/VL300_orig
PROCF=$(PROCD)/gposp_tmp
OUTF=$(PROCD)/gposp_out

all: clean

abs: mktmp
	octave -fq --eval 'CircIJConv("abs");' < $(PROCF) > $(OUTF)
	rm $(PROCF)

rad: mktmp
	octave -fq --eval 'CircIJConv("rad");' < $(PROCF) > $(OUTF)
	rm $(PROCF)

dly: mktmp
	octave -fq --eval "EndDelay();" < $(PROCF) > $(OUTF)
	rm $(PROCF)

mktmp:
	cp -n $(ORIGF) $(OUTF)
	cp $(OUTF) $(PROCF)
	
clean:
	rm -f $(PROCF) $(OUTF)

