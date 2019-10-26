prefix=/usr/local

all:
	@echo "usage: make install"
	@echo "       make uninstall"

install:
	@mkdir -p $(prefix)/bin/
	@echo '#!/bin/bash' > $(prefix)/bin/o
	@echo '##$(shell pwd)' >> $(prefix)/bin/o
	@echo 'exec "$(shell pwd)/o" "$$@"' >> $(prefix)/bin/o
	@chmod 755 $(prefix)/bin/o
	@chmod 755 lego
	@echo 'install finished! type "lego" to show usages.'
uninstall:
	@rm -f $(prefix)/bin/o
