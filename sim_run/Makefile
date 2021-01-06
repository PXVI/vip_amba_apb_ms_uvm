################################
### Created By :P            ###
### Date       16 May, 2019  ###
################################

# **********************
# Arguments Declarations
# **********************

TESTNAME?=vip_amba_apb_master_sanity_test

FILENAME?=./dut_integration_top/vip_amba_apb_vip_dut_top.sv

COMPILE_FILELIST?=./comp_filelist/compile_filelist.list

REGRESS_LIST?=regression_list.list

REGRESS_DUMP_DEBUG?=0

CORES?=1

ifeq ($(REGRESS_DUMP_DEBUG),1)
DUMP?=0
DEBUG?=1
else
DUMP?=0
DEBUG?=0
endif

MONITORD?=0
MASTERD?=0
SEQD?=0
TESTD?=0

ifeq ($(DEBUG),1)
DEBUG_ARG=+define+VIP_MASTER_DEBUG +define+VIP_SEQUENCE_DEBUG +define+VIP_TEST_DEBUG +define+VIP_MONITOR_DEBUG
else
ifeq ($(MONITORD),1)
MONITORD_ARG=+define+VIP_MONITOR_DEBUG
endif
ifeq ($(MASTERD),1)
MASTERD_ARG=+define+VIP_MASTER_DEBUG
endif
ifeq ($(SEQD),1)
SEQD_ARG=+define+VIP_SEQUENCE_DEBUG
endif
ifeq ($(TESTD),1)
TESTD_ARG=+define+VIP_TEST_DEBUG
endif
DEBUG_ARG=$(MONITORD_ARG) $(MASTERD_ARG) $(SEQD_ARG) $(TESTD_ARG) 
endif

F_COVER?=0
ifneq ($(F_COVER),0)
COVER_COMP_ARG=+fcover +acc
COVER_SIM_ARGS=-cvgperinstance
COVER_MAKE_LABEL=vcover
COVER_MAKE_REGRESS_LABEL=vcover_merge
COVER_ARG_VAL=1
else
COVER_ARG_VAL=0
endif

WLF?=0

ifeq ($(WLF),1)
WLF_CMD=vcd2wlf *.vcd dump.wlf; rm -rf *.vcd;
else
endif

# ************
# "1 ns / 1ps"
# ************
ifdef $(TIME_SCALE)
TIME=-override_timescale $(TIME_SCALE)
else
TIME=-timescale "1 ns / 1 ps"
endif

WLF_NAME?=vsim

NO_COMP?=0

SEED?=0

ifeq ($(SEED),0)
RAND_SEED=$(shell date "+%N")
SV_SEED=-sv_seed $(RAND_SEED)
else
RAND_SEED=$(SEED)
SV_SEED=-sv_seed $(SEED)
endif

RANDOM_REGRESS_SEED?=0

ifneq ($(RANDOM_REGRESS_SEED),0)
RANDOM_REGRESS_SEED=1
else
RANDOM_REGRESS_SEED=0
endif

ifdef $(TIMEOUT)
else
TIMEOUT=20000
endif

ifdef $(COUNT)
else
COUNT=1
endif

ifeq ($(DUMP),1)
# DUMP_SWITCH=-wlf $(WLF_NAME).wlf Does not do much
MAKEFILE_DUMP_SWITCH=+define+MAKEFILE_DUMP_SWITCH
DUMP_CONVERT_LABEL=wave
endif

ifeq ($(DEBUG),1)
DEBUG_DEF=+define+VIP_DEBUG
DEBUG_LABEL=logs
endif

ifndef $(DUT_DUT)
ifndef $(VIP_DUT)
ifndef $(DUT_VIP)
ifndef $(VIP_VIP)
ENV_DEF=+define+VIP_VIP
endif
else #DUT_VIP
ENV_DEF=+define+DUT_VIP
endif
else #VIP_DUT
ENV_DEF=+define+VIP_DUT
endif
else #DUT_DUT
ENV_DEF=+define+DUT_DUT	
endif

ifdef $(DO_FILE)
DO_CMD= -do $(DO_FILE)
else
ifneq ($(F_COVER),0)
DO_CMD= -do "coverage save -onexit $(TESTNAME).ucdb; run -all; quit -f"
else
DO_CMD= -do "run -all; quit -f"
endif
endif

# **********************
# Labels Declarations
# **********************

ifeq ($(NO_COMP),1)
all : sim $(DUMP_CONVERT_LABEL) $(DEBUG_LABEL) $(COVER_MAKE_LABEL)
	@echo "Simulation Run Without Compilation!"
else
all : clean lib comp opt sim $(DUMP_CONVERT_LABEL) $(DEBUG_LABEL) $(COVER_MAKE_LABEL)
endif

comp_only : clean lib comp

# To Clean Redundant Files and Other Things
# --------------------------------------------
clean:
	@echo "Running Clean Command...";
	@rm -rf *.log *.vcd *.wlf *.ucdb covhtmlreport COVERAGE_REPORT;
	@rm -rf work questa.tops transcript;
	@rm -rf ./debug;
	@rm -rf ./regression_logs;

soft_clean:
	@echo "Running Clean Command...";
	@rm -rf *.log *.vcd *.wlf *.ucdb covhtmlreport COVERAGE_REPORT;
	@rm -rf work questa.tops;
	@rm -rf ./debug;
	@rm -rf ./regression_logs;

# This cleans all the Logs and Dumps generated during that particular test's simulation
# -------------------------------------------------------------------------------------
regress_clean:
	@echo "Running Regress Clean Command...";
	@echo "Removing the debug files and directories...";
	@rm -rf *debug.log *.vcd *.wlf *.ucdb covhtmlreport;
	@rm -rf transcript;
	@rm -rf ./debug;
	@rm -rf ./regression_logs;

# Compilation
# --------------------------------------------
comp:
	@echo "Compiling the files...";
	@vlog \
	-64 \
	-work ./work \
	+acc \
	-l compile.log \
	-sv \
	-vopt \
	-writetoplevels questa.tops \
	$(FILENAME) \
	-f $(COMPILE_FILELIST) \
	$(DEBUG_DEF) \
	$(DEBUG_ARG) \
	+define+COUNT=$(COUNT) \
	+define+TIMEOUT=$(TIMEOUT) \
	$(MAKEFILE_DUMP_SWITCH) \
	$(ENV_DEF);
	

# Simulation
# --------------------------------------------
sim:
	@echo "Starting Simulation...";
	@vsim \
	top_opt \
	$(DUMP_SWITCH) \
	$(DO_CMD) \
	-l $(TESTNAME).log \
	-64 \
	$(SV_SEED) \
	-c \
	+define+UVM_NO_DPI \
	+UVM_TESTNAME=$(TESTNAME);
	@./summary_script.sh $(TESTNAME).log $(TESTNAME);

# Coverage - Single Run
# --------------------------------------------
vcover:
	@echo "Creating the html coverage report...";
	@vcover \
	report \
	-html $(TESTNAME).ucdb;
	@mkdir COVERAGE_REPORT;
	@mv covhtmlreport ./COVERAGE_REPORT;

# Coverage - Merging Databases ( Regression )
# --------------------------------------------
vcover_merge:
	@echo "Merging UCDB Coverage Files...";
	@vcover \
	merge \
	-64 \
	regression_cov.ucdb \
	*.ucdb;
	@echo "Creating the html coverage report...";
	@vcover \
	report \
	-html regression_cov.ucdb;
	@mkdir COVERAGE_REPORT;
	@mv covhtmlreport ./COVERAGE_REPORT;

# Regression
# --------------------------------------------
regress: clean lib comp opt regress_sim $(COVER_MAKE_REGRESS_LABEL) regress_logs

# Regress Simulations
# --------------------------------------------
regress_sim:
	@echo "Firing the Regression Command...";
	@./regress_script.sh $(REGRESS_LIST) $(RAND_SEED) $(RANDOM_REGRESS_SEED) $(COVER_ARG_VAL) $(CORES);

# Regress Logs
# --------------------------------------------
regress_logs: regress_clean
	@echo "Moving Regression Test Logs...";
	@mkdir regression_logs;
	@mv *.log regression_logs/;

# Library Generation
# --------------------------------------------
lib:
	@echo "Making Work Directory...";
	@vlib work;

# For the Optimization
# --------------------------------------------
opt:
	@echo "Running Optimization...";
	@vopt \
	+acc \
	$(TIME_SCALE) \
	integration_top \
	-o top_opt;

# Generate WLF from VCD
# --------------------------------------------
wave:
	@echo "Converting dump.vcd file to dump.wlf...";
	@echo "Removing all the redundant dumps...";
	@echo "Complete!";
	@$(WLF_CMD)

# Move the Geberated Debug Logs
# --------------------------------------------
logs:
	@echo "Creating a new ./debug directory...";
	@mkdir ./debug;
	@mv *debug.log ./debug/;
	@echo "Moved all the logs successfully.";

# For the Qverilog Command
# --------------------------------------------
qv:
	qverilog \
	$(FILENAME);

qvc: clean qv
