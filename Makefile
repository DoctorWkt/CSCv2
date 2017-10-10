# For a quick test, do a make all. Then set your terminal window to 100
# columns wide and run 		$ ./csim -bcd | less
#
# This will assemble and run the fibminsky.s program. You should see a list
# of Fibonacci numbers followed by a sine wave being printed.
#
# To test the compiler, do a make minsky. Then set your terminal window to 100
# columns wide and run          $ ./csim -bcd | less
#
# This will compile the minsky.cl program, assemble the output and run the
# program. You will see a sine wave being printed.
#
all: alu.rom toprom.rom

alu.rom: gen_alu
	./gen_alu -bcd

toprom.rom: fibminsky.s
	./cas fibminsky.s

minsky: minsky.s cas
	./cas minsky.s
	cp toprom.rom minsky

minsky.s: minsky.cl clc
	./clc minsky.cl

fib: fib.s cas
	./cas fib.s
	cp toprom.rom fib

fib.s: genfibn
	./genfibn > fib.s

clean:
	rm -f *.rom *.img jim.s jim fib fib.s fibminsky.s \
	minsky minksy.s minsky.cl
