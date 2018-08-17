//Assignment_1 turtleprogram.cpp
//turtleptrogram class member - and - friend function defition.
#include "turtleprogram.h"
#include <iostream>
#include <string>

TurtleProgram::TurtleProgram()
	:turtleArr(NULL), size(0) { }

//Copy constructor for class TurtleProgram.
TurtleProgram::TurtleProgram(const TurtleProgram & obj)
{
	size = obj.size;
	turtleArr = new std::string[size];

	for (int i = 0; i < size; i++)
	{
		turtleArr[i] = obj.turtleArr[i];
	}
}

//Constructor with string::direction and string::distance.
TurtleProgram::TurtleProgram(std::string direction, std::string distance)
	: size(2)
{
	turtleArr = new std::string[size];
	turtleArr[0] = direction;
	turtleArr[1] = distance;
}

//Destructor for class TurtleProgram
TurtleProgram::~TurtleProgram()
{ 
	//cout << "destructor is called" << endl;
	delete[] turtleArr;
}

//Get the index of the given value.
//param: index of the string.
//return the string value of the index.
std::string TurtleProgram::getIndex(const int index) const
{
	if (size <= index)
		return NULL;

	return this->turtleArr[index];
}

int TurtleProgram::getLength() const
{
	return this->size;
}

//Set the index of the string with given string.
//param index: index of the value, string: string of the turtle.
//Return whether it is successful or not.
bool TurtleProgram::setIndex(int index, std::string str)
{
	if (size <= index)
		return false;

	this->turtleArr[index] = str;

	return true;
}

//ostream overloading.
std::ostream & operator<<(std::ostream & os, const TurtleProgram & obj)
{
	os << '[';

	for (int i = 0; i < obj.size; i++)
	{
		os << obj.turtleArr[i] << ' ';
	}

	if (obj.size != 0)
		os << '\b';

	os << ']';

	return os;
}

//'+' operator overloading.
TurtleProgram TurtleProgram::operator+(const TurtleProgram & obj) const
{
	TurtleProgram newObj;
	newObj.size = this->size + obj.size;
	newObj.turtleArr = new std::string[newObj.size];

	for (int i = 0; i < newObj.size; i++)
	{
		if (i < this->size)
			newObj.turtleArr[i] = this->turtleArr[i];
		else
			newObj.turtleArr[i] = obj.turtleArr[i - this->size];
	}

	return newObj;
}

TurtleProgram TurtleProgram::operator=(const TurtleProgram & obj)
{
	//Free up the memory first
	delete[] turtleArr;

	//Assigned new size, and memory.
	size = obj.size;
	turtleArr = new std::string[size];

	for (int i = 0; i < size; i++)
	{
		turtleArr[i] = obj.turtleArr[i];
	}

	return *this;
}

//'*' operator overloading.
TurtleProgram TurtleProgram::operator*(const int num)
{
	//Excpetion handling (silently)
	if (num <= 0)
		return *this;

	TurtleProgram newObj;
	newObj.size = this->size*num;
	newObj.turtleArr = new std::string[newObj.size];

	int k = 0;	//newObj turtle index variable;
	for (int i = 0; i < num; i++)
	{
		for (int j = 0; j < this->size; j++)
		{
			newObj.turtleArr[k++] = this->turtleArr[j];
		}
	}

	return newObj;;
}

//Determine if the two turtle is equal.
bool TurtleProgram::operator==(const TurtleProgram & obj) const
{
	bool criteria = false;

	if (this->size == obj.size)
	{
		for (int i = 0; i < this->size; i++)
		{
			if (this->turtleArr[i] != obj.turtleArr[i])
				break;

			if (i == this->size - 1)
				criteria = true;
		}
	}

	return criteria;
}

//Determine whether two turtle are different or not.
bool TurtleProgram::operator!=(const TurtleProgram & obj) const
{
	return !(*this == obj);
}

//'+=' operator overloading.
TurtleProgram TurtleProgram::operator+=(const TurtleProgram & obj)
{
	int newSize = this->size + obj.size;
	std::string * newTurtle = new std::string[newSize];
	
	for (int i = 0; i < newSize; i++)
	{
		if (i < this->size)
			newTurtle[i] = this->turtleArr[i];
		else
			newTurtle[i] = obj.turtleArr[i - this->size];
	}

	//Free up the allocated memory.
	delete[] this->turtleArr;

	//Assign new value to LHS.
	this->size = newSize;
	this->turtleArr = newTurtle;	

	return *this;
}

//'*=' operator overloading.
TurtleProgram TurtleProgram::operator*=(const int num)
{
	//Excpetion handling silently
	if (num <= 0)
		return *this;

	int newSize = size * num;
	std::string * newTurtle = new std::string[newSize];

	int k = 0;	//newObj turtle index variable;
	for (int i = 0; i < num; i++)
	{
		for (int j = 0; j < size; j++)
		{
			newTurtle[k++] = turtleArr[j];
		}
	}

	//Free up the allocated memory.
	delete[] turtleArr;

	//Allocated memory space.
	size = newSize;
	turtleArr = newTurtle;

	return *this;
}
