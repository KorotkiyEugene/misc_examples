IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
SRC_FILES = tf_sin_gen_tb.v tf_sin_gen.v
OUT_FILE = tf_sin_gen_tb
VCD_FILE = tf_sin_gen_tb.vcd
SAV_FILE = tf_sin_gen_tb.sav

# Default target to run simulation and open GTKWave
all: sim view

# Compile Verilog files
sim: $(SRC_FILES)
	$(IVERILOG) -o $(OUT_FILE) $(SRC_FILES)

# Run simulation
run: sim
	$(VVP) $(OUT_FILE)

# Open the VCD file in GTKWave
view: run
	$(GTKWAVE) $(VCD_FILE) $(SAV_FILE)

# Clean up the generated files
clean:
	rm -f $(OUT_FILE) $(VCD_FILE)
