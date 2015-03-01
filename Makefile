# ---
# Universal Makefile for the convenvient plugin developer
# ---
# Author: gthub.com/doebi
# ---

OUTDIR=runtime
PLUGINS=Core ChatLog PerfPages mc-server-pvp

all: update build deploy

update:
	git submodule update --init

build:
	cmake --build MCServer/
	$(MAKE) -C MCServer/

deploy: deploy-server deploy-webadmin deploy-plugins

deploy-server:
	mkdir -p $(OUTDIR)
	cp settings/* $(OUTDIR)/
	cp MCServer/MCServer/MCServer $(OUTDIR)/MCServer

deploy-webadmin:
	cp webadmin/ $(OUTDIR)/ -r

deploy-plugins:
	if [ -d $(OUTDIR)/Plugins ]; then \
		rm -r $(OUTDIR)/Plugins ; \
	fi
	mkdir -p $(OUTDIR)/Plugins
	cp MCServer/MCServer/Plugins/InfoReg.lua $(OUTDIR)/Plugins/
	for plugin in $(PLUGINS); do \
		cp plugins/$$plugin/ $(OUTDIR)/Plugins/$$plugin/ -r ; \
	done

reload: deploy
	./run

clean:
	rm -rf $(OUTDIR)
