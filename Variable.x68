**************************************************************************************************
* Global Variable
BYTE_OUT                ds.b            $1      Byte out reserved variable
WORD_OUT                ds.w            $1      Word out reserved variable
READ_FROM               ds.l            $1      Variable to save read From (Inclusive)
READ_TO                 ds.l            $1      Varaible to save read To (Inclusive)
Current_Read            ds.l            $1      Varaible to save current read

* Variable specific for movem
REGISTER_LIST_MASK      ds.w            $1      Register list Mask Variable for MOVEM

* Bit Conversion reserved Area
CONVERSOIN_RESERVED     ds.b            $1

** 8 bit instruction saving place
DATA_EIGHT_BIT          ds.b            $1

** 3 bit instruction saving place
DEST_REGISTER           ds.b            $1
DEST_MODE               ds.b            $1
SRC_MODE                ds.b            $1
SRC_REGISTER            ds.b            $1

*REGISTER                ds.b            $1
*COUNT_REGISTER          ds.b            $1

* Long data saving place for src and dst
SRC_NUMBER_DATA         ds.l            $1
DST_NUMBER_DATA         ds.l            $1

** 2 bit instructoin savin place
*** 01 -- BYTE operation
*** 11 -- word operation
*** 10 -- long operation
SIZE                    ds.b            $1


* Local variable invoked
* Local variable which will be invoked
INITIAL_INSTRUCTION     ds.w            $1      Initial instruction variable
MAIN_LOOP_COUNT         ds.b            $1      Loop count variable for main function

* Variables - Alphabetical
END_HEX                 ds.l        $1
FLAG                    ds.b        $1
START_HEX               ds.l        $1
STRING                  ds.b        $8
SWAP_HEX                ds.l        $1
STR_LENGTH              ds.w        $1

**************************************************************************************************
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
