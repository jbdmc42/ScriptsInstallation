BIN_DIR = $(HOME)/bin
SCRIPTS = compCS42 openVSC42
REPO_URL = https://github.com/jbdmc42/ScriptsInstallation
REPO_DIR = $(HOME)/scripts_repo

install: $(BIN_DIR) $(SCRIPTS)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(SCRIPTS): %: %.sh
	cp $< $(BIN_DIR)/$@
	chmod +x $(BIN_DIR)/$@

update:
	@if [ -d "$(REPO_DIR)" ]; then \
		echo "Updating repository..."; \
		cd $(REPO_DIR) && git pull; \
	else \
		echo "Cloning repository..."; \
		git clone $(REPO_URL) $(REPO_DIR); \
	fi
	@for script in $(SCRIPTS); do \
		if ! cmp -s $(REPO_DIR)/$$script.sh $(BIN_DIR)/$$script; then \
			echo "Updating $$script..."; \
			cp $(REPO_DIR)/$$script.sh $(BIN_DIR)/$$script; \
			chmod +x $(BIN_DIR)/$$script; \
		else \
			echo "$$script is already up-to-date."; \
		fi \
	done

.PHONY: install update clean

clean:
	rm -f $(BIN_DIR)/compCS42 $(BIN_DIR)/openVSC42
