# Project Title

Assignment 4 Hash Table.


## Getting Started

Turtle Graphics as part of [Logo](https://en.wikipedia.org/wiki/Logo_(programming_language) was one of the first languages explicitly designed for teaching beginning programming.

A TurtleProgram is a set of instructions directing the on-screen turtle to draw graphics. To draw a square, one would execute:

To practice dynamically allocated arrays and operator overloading, create a TurtleProgram class that supports the following functionality. For simplicity, use “F” instead of “Forward” and “R” instead of “Right”.

Constructors and destructor

Overload <<, so programs can be printed as below

Overload equality and inequality operators: operator== and operator!=. Two programs are == if all their instructions are the same.

Overload the following operators: operator=, operator+ and operator+=. Adding 2 programs creates a longer program.

Multiplying a program with an integer creates a larger program where the same program is repeated that many times. Write the * and *= operators. Multiplying by 0 or negative numbers is not defined. You can silently ignore the operation, throw an error or handle it in a different way. Similarly, multiplying two TurtleProgram’s is not defined.

Index 0 of a program is defined as the first string in the program (i.e. for program [F 10] index 0 is "F". Implement getLength,  getIndex and setIndex so the program can be modified.

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

The test code is given to you in ass1.cpp.

Result:
```
tp1: []
tp2: [F 10]
tp1 now as tp2+tp3: [F 10 R 90]
tp1 now as tp2 * 3: [F 10 F 10 F 10]
tp4 is a copy of tp1: [F 10 F 10 F 10]
tp5: [F 10]
tp2 and tp5 are == to each other: true
tp2 and tp3 are != to each other: true
index 0 of tp2 is F
tp2 after 2 calls to setIndex: [R 90]
tp2 and tp3 are == to each other: true
tp1 after tp1+=tp3: [F 10 F 10 F 10 R 90]
tp1 after tp1*=2: [F 10 F 10 F 10 R 90 F 10 F 10 F 10 R 90]
tp2 = [R 90]
tp3 = [R 90]
tp4 = [F 10 F 10 F 10]
tp1= tp2+tp3+tp4 = [R 90 R 90 F 10 F 10 F 10]
tp1= tp3+tp4*4 = [R 90 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10]
Size of tp1 is 26
done
[R 90 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 R 90 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10]
```


## Deployment

This is done as a course assignment.

## Authors

Haram Kwon

## Acknowledgments

* Prof. Yusuf Pisan
