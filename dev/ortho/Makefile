all: tuk-CYR.automorf.bin #ara-cyr.lexc.hfst

%.lexc.hfst: %.lexc
	hfst-lexc $< -o $@

%.twol.hfst: %.twol
	hfst-twolc $< -o $@

lat-cyr.hfst: lat-cyr.lexc.hfst lat-cyr.twol.hfst
	hfst-compose-intersect -1 $< -2 lat-cyr.twol.hfst | hfst-minimise -o $@

tuk-CYR.autogen.hfst: ../../.deps/tuk.LR.hfst lat-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 lat-cyr.hfst -o $@

tuk-CYR.REVautomorf.hfst: ../../.deps/tuk.RL.hfst lat-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 lat-cyr.hfst -o $@

tuk-CYR.automorf.hfst: tuk-CYR.REVautomorf.hfst
	hfst-invert $< -o $@

%.att.gz: %.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

%.bin: %.att.gz
	zcat < $< > %.att
	lt-comp lr %.att $@

clean:
	rm *.hfst *.att *.att.gz *.bin
