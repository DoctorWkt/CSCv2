# For a quick test, do a make all. Then set your terminal window to 100
# columns wide and run 		$ ./csim | less
#
# This will assemble and run the fibminsky.s program. You should see a list
# of Fibonacci numbers followed by a sine wave being printed.
#
all: alu.rom toprom.rom

alu.rom: gen_alu
	./gen_alu

toprom.rom: Examples/fibminsky.s
	./cas Examples/fibminsky.s

minsky: Examples/minsky.s cas alu.rom
	./cas Examples/minsky.s
	cp toprom.rom minsky

Examples/minsky.s: Examples/minsky.cl clc
	./clc Examples/minsky.cl

clean:
	rm -f *.rom *.img minsky Examples/minsky.s
