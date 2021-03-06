# This file is a main part of cv-gen tool.
# Do not change it unless you know what you are doing.


# The cv-gen tool working directory.
WORK_DIR := $(CURDIR)

# Include version file.
include $(WORK_DIR)/version.cfg

# Python3 virtual environment dir for weasyprint package.
VENV_DIR := $(WORK_DIR)/.venv

# Computed input files and directories.
INPUT_DIR := $(WORK_DIR)/in
ALL_INPUT_DIRS := $(wildcard $(INPUT_DIR)/*)
ALL_INPUT_FILES := $(wildcard $(INPUT_DIR)/*/cv.md)

# Computed output files and directories.
OUTPUT_DIR_PDF := $(WORK_DIR)/build/pdf
ALL_OUTPUT_FILES_PDF := $(patsubst $(INPUT_DIR)/%,$(notdir $(OUTPUT_DIR_PDF)/%_CV.pdf),$(ALL_INPUT_DIRS))

# An absolute pandoc binary path.
PANDOC_BIN := $(WORK_DIR)/pandoc/bin/pandoc

# Other pandoc options needed for md -> pdf conversion.
PANDOC_PDF_ENGINE := weasyprint
PANDOC_PDF_PARAMS := --pdf-engine=weasyprint

# Handling DEBUG cli param.
ifndef DEBUG
  DEBUG = 0
endif
ifeq ($(DEBUG), 0)
  _d = @
else ifeq ($(DEBUG), 1)
  _d =
else
  $(error [ERROR]: Wrong value for DEBUG parameter (DEBUG = $(DEBUG)). Allowed values: 0 or 1 only)
endif

# Handling VERBOSE cli param.
ifndef VERBOSE
  VERBOSE = 0
endif
ifeq ($(VERBOSE), 0)

else ifeq ($(VERBOSE), 1)

else
  $(error [ERROR]: Wrong value for VERBOSE parameter (VERBOSE = $(VERBOSE)). Allowed values: 0, 1 only)
endif


# If VERBOSE=1 then print some extra information.
ifeq ($(VERBOSE), 1)
  # Print some general variables.
  $(info WORK_DIR = $(WORK_DIR))
  $(info VENV_DIR = $(VENV_DIR))

  # Print all pandoc variables used while md -> pdf conversion.
  $(info PANDOC_BIN = $(PANDOC_BIN))
  $(info PANDOC_PDF_ENGINE = $(PANDOC_PDF_ENGINE))
  $(info PANDOC_PDF_PARAMS = $(PANDOC_PDF_PARAMS))

  # Print all computed input files and dirs.
  $(info INPUT_DIR = $(INPUT_DIR))
  $(info ALL_INPUT_DIRS = $(ALL_INPUT_DIRS))
  $(info ALL_INPUT_FILES = $(ALL_INPUT_FILES))

  # Print all computed output files and dirs.
  $(info OUTPUT_DIR_PDF = $(OUTPUT_DIR_PDF))
  $(info ALL_OUTPUT_FILES_PDF = $(ALL_OUTPUT_FILES_PDF))
endif


.DEFAULT_GOAL := help


# Kinda magic (1/4).
define RULE_template =
  $(1): $(2)
endef

# Kinda magic (2/4).
$(foreach f,$(ALL_OUTPUT_FILES_PDF),$(eval $(call RULE_template,$(f),$(OUTPUT_DIR_PDF)/$(f))))

# Kinda magic (3/4).
$(foreach d,$(ALL_INPUT_DIRS),$(eval $(call RULE_template,$(notdir $(d)),$(OUTPUT_DIR_PDF)/$(notdir $(d))_CV.pdf)))

# Kinda magic (4/4).
# https://www.gnu.org/software/make/manual/html_node/Eval-Function.html


# Generic rule used for md -> pdf conversion.
$(OUTPUT_DIR_PDF)/%_CV.pdf: $(INPUT_DIR)/%/cv.md $(INPUT_DIR)/%/style.css
	$(_d)mkdir -p $(OUTPUT_DIR_PDF)
	$(_d)echo "Generating $@ file..."
	$(_d)cp $(dir $<)/style.css $(dir $<)/tmp.style.css
	$(_d)sed "s%__GENERATED__%`date --iso-8601=s`%g" -i $(dir $<)/tmp.style.css
	$(_d)sed "s%__CV_GEN_VER__%$(__CV_GEN_VERSION)%g" -i $(dir $<)/tmp.style.css
	$(_d)source $(VENV_DIR)/bin/activate && \
		cd $(dir $<) && \
		$(PANDOC_BIN) \
		$(PANDOC_PDF_PARAMS) \
		--metadata pagetitle=$(notdir $@) \
		--css $(dir $<)/tmp.style.css \
		$< \
		-o $@
	$(_d)rm $(dir $<)/tmp.style.css
	$(_d)echo "File $@ generated succesfully."


.PHONY: all
all: $(ALL_OUTPUT_FILES_PDF)


.PHONY: clean
clean:
	$(_d)echo "Removing $(OUTPUT_DIR_PDF) directory..."
	$(_d)-rm -rf $(OUTPUT_DIR_PDF)
	$(_d)echo "Done"


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
	@echo "                         files to build/pdf/*_CV.pdf).      "
	@echo ""
	@echo "    make clean         - Remove all output files (clean the "
	@echo "                         output build/pdf/ directory).      "
	@echo ""
	@echo "    make help          - Print this help message and exit.  "
	@echo ""
	@echo "Extra options:"
	@echo "    VERBOSE=1          - Print additional info.             "
	@echo "    DEBUG=1            - Print most executed commands.      "
	@echo ""


# The end
