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

> *name*= *name2*;
> *name*= *constant*;
> *name*= *name2* *op* *constant*;
> *name*= *constant* *op* *name2*;
> *name*= *name2* *op* *name3*;

where the names are variables names and the constants are decimal constants;
The available operators are ```+```, ```-```, ```&```, ```|``` and ```^```
and are the same as the C operators.
```
