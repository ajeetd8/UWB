* Const variable we need to invoke
STACK                   equ             $100000
DISASSEMBLE_FROM        equ             $7000
BS                      equ             $08         Backspace
HT                      equ             $09         Tab (horizontal 5 characters)
LF                      equ             $0A         New line (line feed)
VT                      equ             $0B         Vertical tab (4 lines)
FF                      equ             $0C         Form Feed (Always end printing with a Form Feed.)
CR                      equ             $0D         Carriage Return

** Size variable for size.
LONG                    equ             $10
WORD                    equ             $11
BYTE                    equ             $01