# Project Title

Assignment 2:
Binary search tree project.
Since this is initialized as templete, we can always invoke this to other source
code also.

## Getting Started

Instruction from my instructor:

BinarySearchTree Program
Implement a BinarySearchTree based on the template below. BinarySearchTree must be able to handle different types of data. the provided sample ass2.cpp tests it using string and int

BinaryNode is already provided and should not be modified.

All the public functions of BinarySearchTree must be implemented

binarysearchtree.h
binarysearchtree.cpp – stub file to help compile

BinaryNode – use as provided. Do not modify. No need to comment further

binarynode.h
binarynode.cpp

Sample ass2.cpp file, expand it to suit your needs. Automated test will not run your ass2.cpp since it requires keyboard interaction.

ass2.cpp

As always expected when programming, comment clearly and thoroughly. Clearly state any assumptions you make in the beginning comment block of the appropriate place, e.g., the class definition. Comments in the class definition file should describe the ADT, all functionality, and assumptions so someone could use the class and understand behavior and restrictions. Pre and post conditions are fine, but not required. See the example on Assignments page for a well-documented program.

You do NOT need to handle data type errors due to bad input.

I will run my own main to test your code. The main function provided doesn’t test your program fully, so you need to supplement it.

Write one function at a time. Test it before moving on to the next function. I suggest starting with add Use valgrind to check for memory leaks as you develop the program. Much easier to fix things early on.

Submit a single zip file, ass2.zip with the following files:

Class names start with capital letters, but file names are all lowercase for compatibility

binarysearchtree.h
binarysearchtree.cpp
ass2.cpp – your own testing functions and main
output.txt - the script file, as defined in Connecting and compiling files on linux labs
comments.txt - your comments. Includes several bits of information

“Hours: XX” where XX is approximate number of hours it took you to complete this assignment

“Comments:” Optional comments, weird compiler error messages you got while developping, problems in setting things up etc. This is intended as for your information. If you want a response from me, email me instead.

You do not need to submit

binarynode.h
binarynode.cpp

These files should not be modified, so they must be as given in assignment.

### Prerequisites

```
g++ with supporting stardard 14
cmake with version higher than 3.9
make
```

### Installing

```
cmake CMakeLists.txt
make
```

## Running the tests

The test code is given to you in ass2.cpp.

Result:
```
A total of 33 tests 


* Testing: 1. Constructors: Empty, 1 parameter and Copy Constructor
1/33 OK: == for empty trees
2/33 OK: == for 1-node trees b1, b2
3/33 OK: == for 1-node trees b1, b3
4/33 OK: == for 5-node trees b1, b2
5/33 OK: copy constructor for 1-node trees b3, b4
6/33 OK: copy constructor for 5-node trees b1, b5
/**************************/
5
5
/**************************/
7/33 OK: 1-param constructor for 1-node trees b3, b7


* Testing: 2. Destructor, clear
8/33 OK: 0-node tree b1 after add/clear
9/33 OK: 4-node tree b1
10/33 OK: 0-node tree b1 after clear
11/33 OK: 0-node tree b1 after clear is empty
12/33 OK: 0-node tree b2
13/33 OK: 0-node tree b2 after clear
14/33 OK: 0-node tree b2 after clear is empty


* Testing: 3. isEmpty, getHeight, numberOfNodes, contains
15/33 OK: 0-node tree b1 has height 0
16/33 OK: 1-node tree b1 has height 1
17/33 OK: 2-node tree b1 has height 2
18/33 OK: 3-node tree b1 has height 3
19/33 OK: 4-node tree b1 has height 4
20/33 OK: 5-node tree b1 has height 4
21/33 OK: 6-node tree b1 has height 4
22/33 OK: 7-node tree b1 has height 4
23/33 OK: 7-node tree b1 does not have x
24/33 OK: 7-node tree b1 does have p
25/33 OK: 7-node tree b1 does have r
26/33 OK: 7-node tree after adding duplicate still 7
27/33 OK: 10-node tree b1 does have d
28/33 OK: 10-node tree b1 does have e
29/33 OK: 10-node tree b1 does have f
30/33 OK: 10-node tree b1 does have g


* Testing: 4. operator==, operator!=
Already tested


* Testing: 5. add
Already tested


* Testing: 6. inorderTraverse
* Visual inspection
b c d e f p q r 31/33 OK: 8-node tree b1, each node got visited


* Testing: 7. rebalance
* Visual inspection
32/33 OK: 7-node tree b1 has height 3
                r
            q
                p
        e
                d
            c
                b
33/33 OK: 8-node tree b1 has height 4
* Visual inspection
                    r
                q
            p
                f
        e
                d
            c
                b


* Testing: 8. readTree
* Visual inspection 7
                g
            f
                e
        d
                c
            b
                a
* Visual inspection 8
                    h
                g
            f
                e
        d
                c
            b
                a
* Visual inspection 9
                    i
                h
            g
                f
        e
                    d
                c
            b
                a
* Visual inspection 10
                    j
                i
            h
                    g
                f
        e
                    d
                c
            b
                a
* Visual inspection 11
                    k
                j
            i
                    h
                g
        f
                    e
                d
            c
                    b
                a
* Visual inspection 12
                    l
                k
                    j
            i
                    h
                g
        f
                    e
                d
            c
                    b
                a
* Visual inspection 15
                    o
                n
                    m
            l
                    k
                j
                    i
        h
                    g
                f
                    e
            d
                    c
                b
                    a
Done with test_08


* Testing: 9. memory leaks
Will leave that to valgrind


* Testing: 10. efficiency and complexity
Will leave that to grader


* Testing: 11. comments.txt - tested on CSS Linux Labs
Hope it is there


* Testing: 12. Coding style + ass2.zip constructed properly
Test and fix comments from cpplint and cppcheck when possible
Lines should be <= 80 characters long
*** NO LINES MORE THAN 80 CHARACTERS *** 
Lines should be <= 80 characters long
Total number of ERRs: 0/33
```


## Deployment

This is done as a course assignment.

## Authors

Haram Kwon

## Acknowledgments

* Prof. Yusuf Pisan
