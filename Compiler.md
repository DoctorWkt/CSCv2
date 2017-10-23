# Crazy CPU Compiler Details

This is the documentation for the *clc* compiler, which takes a sort of
high level language and converts it into the assembly language understood
by the *cas* assembler. An example usage is

```
./clc Examples/minsky.cl
./cas Examples/minsky.s
```

and ```Examples/minsky.cl``` is an example program written in the high-level
language.

This document covers the *clc* compiler as it existed on October 23, 2017.

## Input Structure

First and foremost, you need to realise that *clc* is not a well-written
robust compiler, so the input that it can recognise is very particular.

*clc* parses one line at a time: there is no tokenisation. Whitespace is
generally ignored, and the compiler supports C-style // comment lines.

In the following, *italics* represent an abstraction which you need to
replace with something concrete.

## Variable Declaration.

Variables in the language are 8-bit and signed. To declare a variable,
use the syntax:

> var *name*;

Technically, *name* can be any non-whitespace characters, but I would
stick with the C-style variable naming conventions. Example:

```
  var x;
  var y;
  var i;
  var tmp;
```

## Expressions and Variable Assignment

The language only supports one operator on the right-hand side of an
assignment operation. Here is the available syntax:

<blockquote>
*name*= *name2*;<br>
*name*= *constant*;<br>
*name*= *name2* *op* *constant*;<br>
*name*= *constant* *op* *name2*;<br>
*name*= *name2* *op* *name3*;
</blockquote>

where the names are variables names and the constants are decimal constants;
The available operators are ```+```, ```-```, ```&```, ```|``` and ```^```
and are the same as the C operators. There are no multiply or divide operators.

## Right Shift Four Operation

Because I needed a 4-bit right shift and this is easy to do on a 4-bit CPU,
there is this syntax:

> *name*= *name2* >> 4;

## Postincrement Operation

This syntax is supported:

> *name*++;

## Exiting the Program

If you want your program to stop in the *csim* simulator, or go into an
infinite loop on the real hardware, use this line:

> exit;

which inserts an infinite loop into the output.

## If Statement

The language supports if statements that are on one line:

> if (*name1* *op* *name2*) {

where the names are variables and the operations include ```==```, ```!=```,
```<```, ```>```, ```<=``` and ```>=```.

## Else Statement

This has the syntax:

> } else {

and obviously must come after an if statement.

## While Loop

There is a while loop with the syntax:

> while (*name1* *op* *name2*) {

and there is a second syntax for an infinite loop:

> while (1) {

## Ending Loops and If Statements

A closed curly bracket on a line by itself ends the most recent if
statement or while loop:

> }

The compiler keeps a stack of if statements and while loops, so that you
can nest them.

## Breaking Out of a Loop

To break out of a loop, use the syntax:

> break;

just like the C command.

## Printing out Characters

The *putchar()* syntax allows you to print out certain things:


<blockquote>
putchar(*name*);<br>
putchar('*x*');<br>
putchar('\n');
</blockquote>

where *name* is a variable and *x* is a single character. Note: when printing
a variable, its value in decimal is **not** printed out. Instead, the ASCII
character with the *name*'s value is printed out. So:

```
   var x;
   x= 61;
   putchar(x);
```

will print out an uppercase 'A'.
