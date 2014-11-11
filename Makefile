BUSTED?=busted

LUNEC:=bin/lunec
LUNEFILES:=$(shell find -type f -name '*.lune')
LUAFILES:=$(LUNEFILES:%.lune=%.lua)

test: all
	$(BUSTED)

all: $(LUAFILES)

%.lua: %.lune
	bin/lunec $< $@

.PHONY: test all $(LUNEFILES)

