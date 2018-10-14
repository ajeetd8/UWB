/**
 * This program is designed to test the LinkedList.
 * In the LinkedList.h file, the member variables and
 * functoins are defined. In the LinkedList.cpp.h,
 * the member functions are defined.
 *
 * Assumption: Send the <Object> as dynamically allocated memory address.
 */

#include <iostream>
#include "LinkedList.h"
#include <ctime>
#include <cstdlib>
#include <cstdio>
using namespace std;

int main()
{
	//Initializing the original list.
	LinkedList llist;
	srand(time(NULL));

	//Putting ramdom number into the array.
	for (int i = 0; i<20; i++)
	{
		llist.insert(new int(rand()));
	}

	//Using the copy constructor.
	LinkedList copyLlist = llist;

	//List Data container.
	int* data = 0;
	int* copy = 0;

	cout<<"Testing copy constructor"<<endl;

	//Testing, LFist, LNext, and LRemove.
	cout << '\t' << "original" << "\t\t";
	cout << "copied" << endl << endl;
	cout << '\t' << "Data" << "\t\t" << "Address" << "\t\t";
	cout << "Data" << "\t\t" << "Address" << endl;

	if ((data=llist.LFirst()) != NULL)
	{
		copyLlist.LFirst();
		copy = copyLlist.LRemove();

		cout << "1. \t";
		cout << *data << '\t' << data << '\t';
		cout << *copy << '\t' << copy << endl;
		delete copy;

		int i = 2;
		while ((data = llist.LNext()) != NULL)
		{

			copyLlist.LNext();
			copy = copyLlist.LRemove();

			cout << i++ << ". \t";
			cout << *data << '\t' << data << '\t';
			cout << *copy << '\t' << copy << endl;
			delete copy;
		}
	}
	//Conclusion.
	cout << "Notice that memory addresses are not duplicated" << endl;
	cout << "I delete the copied object, and list while displaying the reuslt" << endl;
	cout << "Copying is successful" << endl;
	cout << "LFirst, LNext, LRemove, and copy constructor is tested" << endl << endl << endl;

	//Testing getNumberOfData() function.
	cout << "Number of Data in the original list: " << llist.getNumberOfData() << endl;
	cout << "Number of Data in the copied list (should be 0): " << copyLlist.getNumberOfData() << endl;


	//Testing Recursive, and Iterate Reverse.
	cout << "Testing reverse two reverse functions" << endl;

	int values[3][20];
	int* pointers[3][20];

	//Saving the original data.
	if ((data = llist.LFirst()) != NULL)
	{
		values[0][0] = *data;
		pointers[0][0] = data;

		for(int i=1; (data = llist.LNext()) != NULL; i++)
		{
			values[0][i] = *data;
			pointers[0][i] = data;
		}
	}

	//Reverse it, recursively.
	llist.reverseRecursive();

	if ((data = llist.LFirst()) != NULL)
	{
		values[1][0] = *data;
		pointers[1][0] = data;

		for (int i = 1; (data = llist.LNext()) != NULL; i++)
		{
			values[1][i] = *data;
			pointers[1][i] = data;
		}
	}

	//Reverse it, iteratively.
	llist.reverseIterate();

	if ((data = llist.LFirst()) != NULL)
	{
		values[2][0] = *data;
		pointers[2][0] = data;

		for (int i = 1; (data = llist.LNext()) != NULL; i++)
		{
			values[2][i] = *data;
			pointers[2][i] = data;
		}
	}

	//Printing out the result of reverse functions.
	cout << '\t' << "Original ->" << "\t\t\t";
	cout << "Recursive Reverse ->" << "\t\t";
	cout << "Iterate Reverse" << endl;
	cout << '\t' << "Data" <<"\t\t"<< "Address" << '\t';
	cout << '\t' << "Data" << "\t\t" << "Address" << '\t';
	cout << '\t' << "Data" << "\t\t" << "Address" << endl;
	if ((data = llist.LFirst()) != NULL)
	{
		cout << "1. " << '\t';
		cout << values[0][0] << '\t' << pointers[0][0] << '\t';
		cout << values[1][0] << '\t' << pointers[1][0] << '\t';
		cout << values[2][0] << '\t' << pointers[2][0] << endl;

		for (int i = 1; (data = llist.LNext()) != NULL; i++)
		{
			cout << i+1 << ". " << '\t';
			cout << values[0][i] << '\t' << pointers[0][i] << '\t';
			cout << values[1][i] << '\t' << pointers[1][i] << '\t';
			cout << values[2][i] << '\t' << pointers[2][i] << endl;
		}
	}
	//conclusion
	cout << "Origianl is reversed by recursive revese function" << endl;
	cout << "The recursively reversed list is reversed by interation revese function" << endl;
	cout << endl << endl << endl;

	//Testing get(int i) functoin.
	cout << "From the below, I am going to test \"get(i)\" function" << endl;

	for(int i=0; i<20;i++)
	{
		cout << i+1 << ". " << *(llist.get(i)) << endl;
	}
	//conclusion.
	cout << "get \"i\" is tested" << endl << endl << endl;;

	//Testing apped funciton.
	//Appending test code.
	llist.append(9, new int(10));
	llist.append(19, new int(20));

	for(int i=0; i<llist.getNumberOfData(); i++)
	{
		cout << i + 1 << ". " << *(llist.get(i)) << endl;
	}
	//Conclusion.
	cout << "I added 10th and 20th to 10 and 20" << endl;
	cout << "it successfully shows the result." << endl << endl << endl;

	//Testing remove(i) function by deleting what I have added previously.
	cout << "Now I am going to delete what I have added" << endl;
	llist.remove(19);
	llist.remove(9);
	for (int i = 0; i<llist.getNumberOfData(); i++)
	{
		cout << i + 1 << ". " << *(llist.get(i)) << endl;
	}
	//Conclusion.
	cout << "I succesfully delete the object what I have added" << endl;
	cout << "\"remove(i)\" is tested" << endl << endl;

	//To sum up, Consequently.
	cout << "conclusion" << endl;
	cout << "Every function is successfully working" << endl;

	return 0;
}
