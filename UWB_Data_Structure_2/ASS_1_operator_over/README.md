# Project Title

Assignment 1 Turtle Project.

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

What things you need to install the software and how to install them

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

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

The test code is given to you in ass1.cpp.

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

This is done as a course assignment.

## Authors

Haram Kwon

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.


## Acknowledgments

* Prof. Yusuf Pisan
