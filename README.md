# Todo
[Progressive Report 1](https://docs.google.com/document/d/1-1W64IIo_uXyICalOz1E2P9-dUlTqSkCL2gHTWVDDNQ/edit#heading=h.vu1ekqi6efad)
Due Saturday


## Requirework for each week.

1. flow-chart
2. machine code table
3. A subroutine that reads user input as string, and convert it to hexadecimal, Or suggest alternative way. The flow-chart for this subroutine should be also submitted.
4. Revised flow-chart
5. List of all the works that have not been finished, and a detailed schedule for the next week to complete the unfinished work.

* Get the input from the user.
    * for the starting address
    * for the ending address (Optional)
* would you like to disassemble again (Y/N)?
* Program should not crash. (No point)
* For the final, we have to use file->open data
* Domain diagram for the first week.
* should show scren by screen (may be 20 lines per time)
* Provide valid adress locatoin for test code.

# Note
1. Every instruction begins with 'word'
2. 68k assembly always use even addressing!s
3. Using log is good idea.
4. Illegal data could be 
5. Instruction trap 15: move.b(#0 ~ #14),d0 only
    * read input as ASCI.
    * Can give instruction Upper case and lower case on output.

# CSS422_Group_Work
CSS422 gropu work for Spr.2018

# Basic Setup
```
Stack Point(sp) = $100000
```

# Usage of each register
## Data Register
```
d0 -> Free (Not set)
d1 -> Free
d2 -> Free
d3 -> Free
d4 -> Free
d5 -> Byte data saving place from memory &7000 ~
d6 -> Arthematic (Free to use within the loop) 
d7 -> End Condition check
```
## Address Register
```
a0 -> Free (not set)
a1 -> Free
a2 -> Free
a3 -> Free
a4 -> Free
a5 -> Free
a6 -> Reading address (from $7000)
a7 -> Stack Pointer
```

# Required opcodes and addressing mode

Below are the list of instructions and addressing modes assigned for this project. 

## Effective Addressing Modes:

- Data Register Direct
- Address Register Direct
- Address Register Indirect
- Immediate Data
- Address Register Indirect with Post incrementing
- Address Register Indirect with Pre decrementing
- Absolute Long Address
- Absolute Word Address

## Instructions:
```
NOP
MOVE
MOVEA
MOVEQ
MOVEM
ADD
ADDA
ADDI
ADDQ
SUB
SUBI
MULS
MULU
DIVU
LEA
CLR
AND
OR
LSL
LSR
ASR
ASL
ROL
ROR
CMP
Bcc (BCC, BGT, BLE)
JSR
RTS
```

# Bug Page on Canvas
https://canvas.uw.edu/courses/1212491/pages/simulator-issues
# Instruction file
https://canvas.uw.edu/courses/1212491/pages/addendum