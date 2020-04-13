# This file is a main part of cv-gen tool.
# Do not change it unless you know what you are doing.


# Main working directory
WORK_DIR := $(CURDIR)

# Include version file
include $(WORK_DIR)/version.cfg

# Python3 virtual environment dir for weasyprint package
VENV_DIR := $(WORK_DIR)/.venv

# Input files and directories
INPUT_DIR := $(WORK_DIR)/in
ALL_INPUT_DIRS := $(wildcard $(INPUT_DIR)/*)
ALL_INPUT_FILES := $(wildcard $(INPUT_DIR)/*/cv.md)

# Output files and directories
OUTPUT_DIR_PDF := $(WORK_DIR)/build/pdf
ALL_OUTPUT_FILES_PDF := $(patsubst $(INPUT_DIR)/%,$(notdir $(OUTPUT_DIR_PDF)/%_CV.pdf),$(ALL_INPUT_DIRS))

# The pandoc binary
PANDOC_BIN := $(WORK_DIR)/pandoc/bin/pandoc

# Other pandoc variables needed for md -> pdf conversion
PANDOC_PDF_ENGINE := weasyprint
PANDOC_PDF_PARAMS := --pdf-engine=weasyprint

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


# Kinda magic 1/4
define RULE_template =
  $(1): $(2)
endef

# Kinda magic 2/4
$(foreach f,$(ALL_OUTPUT_FILES_PDF),$(eval $(call RULE_template,$(f),$(OUTPUT_DIR_PDF)/$(f))))

# Kinda magic 3/4
$(foreach d,$(ALL_INPUT_DIRS),$(eval $(call RULE_template,$(notdir $(d)),$(OUTPUT_DIR_PDF)/$(notdir $(d))_CV.pdf)))

# Kinda magic 4/4
# https://www.gnu.org/software/make/manual/html_node/Eval-Function.html


$(OUTPUT_DIR_PDF)/%_CV.pdf: $(INPUT_DIR)/%/cv.md $(INPUT_DIR)/%/style.css
	$(Q)mkdir -p $(OUTPUT_DIR_PDF)
	$(Q)echo "Generating $@ file..."
	$(Q)cp $(dir $<)/style.css $(dir $<)/tmp.style.css
	$(Q)sed "s%__GENERATED__%`date --iso-8601=s`%g" -i $(dir $<)/tmp.style.css
	$(Q)sed "s%__CV_GEN_VER__%$(__CV_GEN_VERSION)%g" -i $(dir $<)/tmp.style.css
	$(Q)source $(VENV_DIR)/bin/activate && \
		cd $(dir $<) && \
		$(PANDOC_BIN) \
		$(PANDOC_PDF_PARAMS) \
		--metadata pagetitle=$(notdir $@) \
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


.PHNOY: version
version:
	@echo ""
	@echo "cv-gen $(__CV_GEN_VERSION)"
	@echo ""


.PHONY: help
help: version
	@echo "The simple CV generator and md -> pdf converter."
	@echo ""
	@echo "Usage:"
	@echo "    make               - Build the default target help (see "
	@echo "                         below).                            "
	@echo ""
	@echo "    make all           - Build all (convert all in/*/cv.md  "
	@echo "                         files to build/pdf/*_CV.pdf).         "
	@echo ""
	@echo "    make clean         - Remove all output files (clean the "
	@echo "                         output build/pdf/ directory).      "
	@echo ""
	@echo "    make help          - Print this help message and exit.  "
	@echo ""
	@echo "Extra options:"
	@echo "    VERBOSE=1          - Increase verbosity.                "
	@echo ""


# The end
