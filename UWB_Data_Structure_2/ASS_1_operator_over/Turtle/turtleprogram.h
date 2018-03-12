//Assigment_1 turtleprogram.h
//Turtle class definition with overloaded operators.
//Author: Haram_Kwon

/**
  * The code implement the TurtleProgram class with turtleprogram.h and turtleprogram.cpp
  * The program dynamically allocate the turtle position, and it support arithmatic
  * operations such that '+', '-', '*', '+=', '==', and '!='. Furthermore it also provides
  * accessor, 'getLength()' , and getIndex(int) function.
  * modifiers such that setIndex(int, std::string).
  */

#ifndef __TURTLE_PROGRAM_
#define __TURTLE_PROGRAM_

#include <iostream>
#include <string>

class TurtleProgram
{
	//ostream overloading.
	friend std::ostream& operator<<(std::ostream& os, const TurtleProgram& obj);

public:
	//Consturctor and destructor
	TurtleProgram();		//Default constructor.
	TurtleProgram(const TurtleProgram& obj);	//Copy constructor.
	TurtleProgram(std::string direction, std::string distance); //Constructor with string
	~TurtleProgram();	//Destructor.

	//Accessor
	std::string getIndex(const int index) const;
	int getLength() const;

	//Modifier
	bool setIndex(int index, std::string str);

	//Arithmatic operation
	TurtleProgram operator+(const TurtleProgram& obj) const;
	TurtleProgram operator=(const TurtleProgram& obj);
	TurtleProgram operator*(const int num);
	bool operator==(const TurtleProgram& obj) const;
	bool operator!=(const TurtleProgram& obj) const;
	TurtleProgram operator+=(const TurtleProgram& obj);
	TurtleProgram operator*=(const int num);
	
private:
	std::string * turtleArr;
	int size;
};

#endif