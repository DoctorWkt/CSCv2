test.vcd: icarus_tb.out toprom.rom botrom.rom alu.rom
	vvp icarus_tb.out

icarus_tb.out: icarus_tb.v icarus_top.v alu.v botrom.v cscv2.v pc.v ram.v \
						register.v toprom.v alu.rom
	iverilog -o icarus_tb.out icarus_tb.v

toprom.rom: ../toprom.rom
	grep -v raw ../toprom.rom > toprom.rom

botrom.rom: ../botrom.rom
	grep -v raw ../botrom.rom > botrom.rom

alu.rom: ../alu.rom
	grep -v raw ../alu.rom > alu.rom

clean:
	rm -f *.vcd *.out

realclean:
	rm -f *.out *.vcd *.rom
