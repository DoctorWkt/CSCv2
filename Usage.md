# Crazy Small CPU Version 2 Software Usage

Here are the instructions on assembling a program
down to ROM images, running the *csim* simulator,
running the ROM images in Logisim, and burning the
ROM images to real EEPROMs.

## The *cas* assembler

You should first read the [Instructions.md](Instructions.md)
file for details of the assembly language files, as well as the
[description of the CPU architecture](http://minnie.tuhs.org/Programs/CrazySmallCPU/description.html). Next, you should look at some of the example programs in
the *Examples* directory. As an example, I will choose the
*fibminsky.s* program from the *Examples* directory.

To assemble *fibminsky.s*, run this command at the Linux command prompt:

```
./cas Examples/fibminsky.s
```

This will generate these ROM image files:
 * toprom.rom and toprom.img
 * botrom.rom and botrom.img

The **.rom* image files are used by [Logisim](http://www.cburch.com/logisim/).
The **.img* image files can be burned to real EEPROMs.

The *cas* assembler has a debug flag which outputs details of each instruction and
the ROM values in hexadecimal:

```
./cas -d Examples/fibminsky.s
00:     xxxx LCA   0 a800
01:     xxxx SMA   1 7a01
02:     xxxx SMA   5 7a05
03:     xxxx SMA   2 7a02
04:     xxxx SMA   6 7a06
05:     xxxx SMA   3 7a03
06:     xxxx SMA   7 7a07
07:     xxxx LCA   1 a801
    . . .
```

A double debug option also shows the control lines enabled for each instruction:

```
./cas -d -d Examples/fibminsky.s
00:     xxxx LCA   0 a800       Aload 
01:     xxxx SMA   1 7a01       RAMwrite Asel ALUpassa 
02:     xxxx SMA   5 7a05       RAMwrite Asel ALUpassa 
03:     xxxx SMA   2 7a02       RAMwrite Asel ALUpassa 
04:     xxxx SMA   6 7a06       RAMwrite Asel ALUpassa 
05:     xxxx SMA   3 7a03       RAMwrite Asel ALUpassa 
06:     xxxx SMA   7 7a07       RAMwrite Asel ALUpassa 
07:     xxxx LCA   1 a801       Aload 
```

# The *csim* simulator

Once you have the **.rom* output files from the assembler, you can run
them in the Perl simulator for the CPU, *csim*:

```
./csim | less
0002
0003
0005
0008
0013
0021
0034
0055
0089
0144
0233
0377
0610
0987
1597
2584
4181
6765
. . .
```

The *csim* simulator also has a debug option, which gives basic details of
what happens on each instruction:

```
./csim -d | less
PC 0 flags 0 address 0 cntrl a8 A now 0 
PC 1 flags 0 address 1 cntrl 7a PASSA: A 0 B 0 Cin 0 RAM 1 now 0, NZVC 4
PC 2 flags 4 address 5 cntrl 7a PASSA: A 0 B 0 Cin 0 RAM 5 now 0, NZVC 4
PC 3 flags 4 address 2 cntrl 7a PASSA: A 0 B 0 Cin 0 RAM 2 now 0, NZVC 4
PC 4 flags 4 address 6 cntrl 7a PASSA: A 0 B 0 Cin 0 RAM 6 now 0, NZVC 4
PC 5 flags 4 address 3 cntrl 7a PASSA: A 0 B 0 Cin 0 RAM 3 now 0, NZVC 4
PC 6 flags 4 address 7 cntrl 7a PASSA: A 0 B 0 Cin 0 RAM 7 now 0, NZVC 4
PC 7 flags 4 address 1 cntrl a8 A now 1 
PC 8 flags 4 address 4 cntrl 7a PASSA: A 1 B 0 Cin 0 RAM 4 now 1, NZVC 0
PC 9 flags 0 address 8 cntrl 7a PASSA: A 1 B 0 Cin 0 RAM 8 now 1, NZVC 0
PC a flags 0 address 4 cntrl e8 A now 1 
PC b flags 0 address 8 cntrl d8 B now 1 
PC c flags 0 address c cntrl 38 DADD: A 1 B 1 Cin 0 RAM c now 2, NZVC 0
```

If you want to slow the clock speed down in ```csim``, use this option:

```
./csim -c 1000
```

to set the clock speed to approximately 1,000Hz.

# Using Logisim

The *crazycpu.circ* is a version of the CPU that runs in the
[Logisim](http://www.cburch.com/logisim/) logic simulator.
Start Logisim from the command line, naming this file:

```
logisim crazycpu.circ
```

You will see this circuit:

![Logisim circuit](https://raw.githubusercontent.com/DoctorWkt/CSCv2/master/Figs/Logisim1.png)

Right-click on the ALUROM box and choose *Load Image* as follows:

![alurom choice](https://raw.githubusercontent.com/DoctorWkt/CSCv2/master/Figs/Logisim2.png)

Find and select the *alu.rom* file.

![load ROM file](https://raw.githubusercontent.com/DoctorWkt/CSCv2/master/Figs/Logisim3.png)

Click on *Open* to load the file into the ROM. Do the
same for the TOPROM and the *toprom.rom* file, and BOTROM and the *botrom.rom* file.

If you can't find the *alu.rom* file, run *make* which builds this file with the command:

```
./gen_alu
```

With all three ROM image files loaded, you are now ready to run the loaded program. Use
the *Simulate* drop-down menu at the top of the Logisim window, and choose *Ticks Enabled*
to start the program running. In the same menu, choose *Tick Frequency* to change the
speed of the CPU. In the same menu, choose *Ticks Enabled* to pause and restart the simulation.
In the same menu, choose *Reset Simulation* to restart the program.

# Burning the EEPROM images

This all depends on what EEPROM burner you have. I'm using the MiniPRO TL866xx
EEPROM programmer with this
[open-source burning software](https://github.com/vdudouyt/minipro).
Use the three **.img* files and write each one to a suitable EEPROM.
