PROJ = top

DEVICE = lp8k
COMMON = ../../../common
SOURCES = ../$(PROJ).v ../sonar_test.v $(COMMON)/pll_50mhz.v $(COMMON)/uart.v $(COMMON)/hba_master.v $(COMMON)/hba_arbiter.v $(COMMON)/hba_or_masters.v $(COMMON)/hba_or_slaves.v ../../../serial_fpga/send_recv.v ../../../serial_fpga/serial_fpga.v ../../../hba_reg_bank/hba_reg_bank.v ../../../hba_sonar/hba_sonar.v ../../../hba_sonar/sr04.v 


PIN_DEF = $(COMMON)/pins.pcf

all: $(PROJ).rpt $(PROJ).bin

%.blif: $(SOURCES)
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $^

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d 8k -P cm81 -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%_tb: %_tb.v %.v
	iverilog -o $@ $^

%_tb.vcd: %_tb
	vvp -N $< +vcd=$@

%_syn.v: %.blif
	yosys -p 'read_blif -wideports $^; write_verilog $@'

%_syntb: %_tb.v %_syn.v
	iverilog -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

%_syntb.vcd: %_syntb
	vvp -N $< +vcd=$@

prog: $(PROJ).bin
	tinyprog -p $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo tinyprog -p $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.SECONDARY:
.PHONY: all prog clean
