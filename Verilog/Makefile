test.vcd: cscv2_tb.out alu.rom toprom.rom botrom.rom
	vvp cscv2_tb.out | less

alu.rom: ../alu.rom
	grep -v raw ../alu.rom > alu.rom

toprom.rom: ../toprom.rom
	grep -v raw ../toprom.rom > toprom.rom

botrom.rom: ../botrom.rom
	grep -v raw ../botrom.rom > botrom.rom

cscv2_tb.out: cscv2_tb.v alu.v botrom.v cscv2.v pc.v ram.v register.v toprom.v
	iverilog -o cscv2_tb.out cscv2_tb.v

clean:
	rm -f *.out *.vcd *.rom
