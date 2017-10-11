# For a quick test, do a make all. Then set your terminal window to 100
# columns wide and run 		$ ./csim | less
#
# This will assemble and run the fibminsky.s program. You should see a list
# of Fibonacci numbers followed by a sine wave being printed.
#
all: alu.rom toprom.rom

alu.rom: gen_alu
	./gen_alu

toprom.rom: fibminsky.s
	./cas fibminsky.s

clean:
	rm -f *.rom *.img
