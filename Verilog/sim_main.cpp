#include <iostream>

#include "Vicarus_top.h"
#include "verilated.h"
// #include "verilated_vcd_sc.h"
int main(int argc, char **argv, char **env) {
    int i;

    Verilated::commandArgs(argc, argv);
    Vicarus_top* top = new Vicarus_top;

#ifdef TRACE
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open("simx.vcd");
#endif

    for (i=0; i < 800000; i++) {
      top->dblclk ^= 1; top->eval();
#ifdef TRACE
      tfp->dump(i);
#endif
    }

#ifdef TRACE
    tfp->close();
#endif
    delete top;
    exit(0);
}
