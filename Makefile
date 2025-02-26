BIN_DIR = $(HOME)/bin
SCRIPTS = compCS42 openVSC42
REPO_URL = https://raw.githubusercontent.com/jbdmc42/ScriptsInstallation/main

install: $(BIN_DIR) $(SCRIPTS)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(SCRIPTS): %: %.sh
	cp $< $(BIN_DIR)/$@
	chmod +x $(BIN_DIR)/$@

update:
	@for script in $(SCRIPTS); do \
		echo "Verificando $$script..."; \
		TEMP_FILE="/tmp/$$script.sh"; \
		wget -q -O $$TEMP_FILE $(REPO_URL)/$$script.sh; \
		if [ ! -f "$(BIN_DIR)/$$script" ] || ! cmp -s $$TEMP_FILE "$(BIN_DIR)/$$script"; then \
			echo "Atualizando $$script..."; \
			mv $$TEMP_FILE "$(BIN_DIR)/$$script"; \
			chmod +x "$(BIN_DIR)/$$script"; \
		else \
			echo "$$script já está atualizado."; \
			rm $$TEMP_FILE; \
		fi \
	done

.PHONY: install update clean

clean:
	rm -f $(BIN_DIR)/compCS42 $(BIN_DIR)/openVSC42

