all: uzb-CYR.automorf.bin #ara-cyr.lexc.hfst

%.lexc.hfst: %.lexc
	hfst-lexc $< -o $@

%.twol.hfst: %.twol
	hfst-twolc $< -o $@

lat-cyr.hfst: lat-cyr.lexc.hfst lat-cyr.twol.hfst
	hfst-compose-intersect -1 $< -2 lat-cyr.twol.hfst | hfst-minimise -o $@

uzb-CYR.autogen.hfst: ../../.deps/uzb.LR.hfst lat-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 lat-cyr.hfst -o $@

uzb-CYR.REVautomorf.hfst: ../../.deps/uzb.RL.hfst lat-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 lat-cyr.hfst -o $@

uzb-CYR.automorf.hfst: uzb-CYR.REVautomorf.hfst
	hfst-invert $< -o $@

%.att.gz: %.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

%.bin: %.att.gz
	zcat < $< > %.att
	lt-comp lr %.att $@

clean:
	rm *.hfst *.att *.att.gz *.bin
