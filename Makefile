BIN_DIR = $(HOME)/bin
SCRIPTS = compCS42 openVSC42

install: $(BIN_DIR) $(SCRIPTS)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(SCRIPTS): %: %.sh
	cp $< $(BIN_DIR)/$@
	chmod +x $(BIN_DIR)/$@

.PHONY: install clean

clean:
	rm -f $(BIN_DIR)/compCS $(BIN_DIR)/openVSC
