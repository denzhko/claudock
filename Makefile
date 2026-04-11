INSTALL_DIR := $(HOME)/.local/bin
SCRIPT      := claudock

.PHONY: help install uninstall

help:
	@echo "Targets:"
	@echo "  install    Symlink $(SCRIPT) into $(INSTALL_DIR)"
	@echo "  uninstall  Remove $(SCRIPT) from $(INSTALL_DIR)"

install:
	@mkdir -p $(INSTALL_DIR)
	@ln -sf "$(CURDIR)/$(SCRIPT)" "$(INSTALL_DIR)/$(SCRIPT)"
	@echo "Installed: $(INSTALL_DIR)/$(SCRIPT)"
	@echo "Make sure $(INSTALL_DIR) is in your PATH."

uninstall:
	@rm -f "$(INSTALL_DIR)/$(SCRIPT)"
	@echo "Removed: $(INSTALL_DIR)/$(SCRIPT)"
