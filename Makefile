# This file is part of cv-gen tool.
# Do not change it unless you know what you are doing.

# Main working directory
WORK_DIR := $(CURDIR)

# Python3 virtual environment dir for weasyprint package
VENV_DIR := $(WORK_DIR)/.venv

# Input files and directories
INPUT_DIR := $(WORK_DIR)/in
ALL_INPUT_DIRS := $(wildcard $(INPUT_DIR)/*)
ALL_INPUT_FILES := $(wildcard $(INPUT_DIR)/*/cv.md)

# Output files and directories
OUTPUT_DIR_PDF := $(WORK_DIR)/build/pdf
ALL_OUTPUT_FILES_PDF := $(patsubst $(INPUT_DIR)/%,$(notdir $(OUTPUT_DIR_PDF)/%.pdf),$(ALL_INPUT_DIRS))

# The pandoc binary
PANDOC_BIN := $(WORK_DIR)/pandoc/bin/pandoc

# Other pandoc variables needed for md -> pdf conversion
PANDOC_PDF_ENGINE := weasyprint
PANDOC_PDF_PARAMS := --pdf-engine=weasyprint --quiet

# Handling cli param VERBOSE=1
ifeq ($(VERBOSE), 1)
  Q=

  # Print some general variables
  $(info WORK_DIR = $(WORK_DIR))
  $(info VENV_DIR = $(VENV_DIR))

  # Print all pandoc variables used while md -> pdf conversion
  $(info PANDOC_BIN = $(PANDOC_BIN))
  $(info PANDOC_PDF_ENGINE = $(PANDOC_PDF_ENGINE))
  $(info PANDOC_PDF_PARAMS = $(PANDOC_PDF_PARAMS))

  # Print all variables related to input files and dirs
  $(info INPUT_DIR = $(INPUT_DIR))
  $(info ALL_INPUT_DIRS = $(ALL_INPUT_DIRS))
  $(info ALL_INPUT_FILES = $(ALL_INPUT_FILES))

  # Print all variables related to output pdf files
  $(info OUTPUT_DIR_PDF = $(OUTPUT_DIR_PDF))
  $(info ALL_OUTPUT_FILES_PDF = $(ALL_OUTPUT_FILES_PDF))
else
  Q=@
endif


.DEFAULT_GOAL := help


# Kinda magic 1/3
define RULE_template =
  $(1): $(2)
endef

# Kinda magic 2/3
$(foreach f,$(ALL_OUTPUT_FILES_PDF),$(eval $(call RULE_template,$(f),$(OUTPUT_DIR_PDF)/$(f))))

# Kinda magic 3/3
# https://www.gnu.org/software/make/manual/html_node/Eval-Function.html


$(OUTPUT_DIR_PDF)/%.pdf: $(INPUT_DIR)/%/cv.md $(INPUT_DIR)/%/style.css
	$(Q)mkdir -p $(OUTPUT_DIR_PDF)
	$(Q)echo "Generating $@ file..."
	$(Q)cp $(dir $<)/style.css $(dir $<)/tmp.style.css
	$(Q)sed "s%__GENERATED__%`date --iso-8601=s`%g" -i $(dir $<)/tmp.style.css
	$(Q)source $(VENV_DIR)/bin/activate && \
		cd $(dir $<) && \
		$(PANDOC_BIN) \
		$(PANDOC_PDF_PARAMS) \
		--css $(dir $<)/tmp.style.css \
		$< \
		-o $@
	$(Q)rm $(dir $<)/tmp.style.css
	$(Q)echo "File $@ generated succesfully."


.PHONY: all
all: $(ALL_OUTPUT_FILES_PDF)


.PHONY: clean
clean:
	$(Q)echo "[INFO]: Removing $(OUTPUT_DIR_PDF) directory..."
	$(Q)-rm -rf $(OUTPUT_DIR_PDF)
	$(Q)echo "[INFO]: Done"


.PHONY: help
help:
	@echo ""
	@echo "This is the top-level Makefile of cv-gen tool."
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "    make               - The default target (see below) "
	@echo ""
	@echo "    make all           - Build all                      "
	@echo ""
	@echo "    make clean         - Remove all output dirs         "
	@echo ""
	@echo "    make help          - Print this help message        "
	@echo ""


# The end
