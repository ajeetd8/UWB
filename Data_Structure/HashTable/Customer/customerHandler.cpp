
#include <string>
#include "customerHandler.h"
#include "../HashTable/Table.h"
#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

//the hashing function used by the table
int customerHashFunc(int customerId) {
    return customerId % 13;
}

//constructor, creates a hashtable of size 13
customerHandler::customerHandler()
        : customerHashTable(13, customerHashFunc) {

}

//inputs customers from the file
bool customerHandler::readFile(std::string filename) {
    std::ifstream file(filename);
    string customerId;
    string firstName;
    string lastName;
    string name;
    string s;
    //if the file is open, then add the contents in
    if (file.is_open()) {
        //while a new line exists
        while (getline(file, s)) {
            //creates a stringstream object to be split
            istringstream lineToSplit(s);
            lineToSplit >> customerId;
            lineToSplit >> firstName;
            lineToSplit >> lastName;
            //combines first and last name
            name = firstName + " " + lastName;
            //adds the customer to the table
            addCustomer(name, stoi(customerId));
        }

        return true;
    }

    return false;
}

//adds a new customer to the customerHashTable
bool customerHandler::addCustomer(string customerName, int customerId) {
    //creates a new customer node
    customerNode newNode(customerName, customerId);
    //inserts the node to the table
    return customerHashTable.insert(customerId, newNode);
}

//adds history to a certain customer
bool customerHandler::addHistory(int customerId, string history, string borrowOrReturn) {
    //attempts to find the customer
    customerNode *temp = customerHashTable.search(customerId);

    // Removing stock informatoin from the history.
    std::stringstream historyStream;
    int trash;
    historyStream<<history;
    historyStream >> trash;
    std::getline(historyStream, history);
    history.erase(0, 2);

    if (temp == nullptr) {
        std::cout << "The customer ID: " << customerId << " does not exist" << std::endl;
        return false;
    }

    //adds whether the transaction was a Borrow
    //or return to the transaction string
    string transaction;
    if (borrowOrReturn == "B") {
        transaction = "Borrow";
        transaction += ": ";
        transaction += history;
    } else {
        transaction = "Return";
        transaction += ": ";
        transaction += history;
    }
    //adds the transaction to the customer's history
    temp->addHistory(transaction);

    // We've successfully added the history.
    return true;

}

//finds if a customer exists
bool customerHandler::customerExists(int customerId) {
    //attempts to find a customer
    customerNode *temp = customerHashTable.search(customerId);
    if (temp == nullptr) {
        //if the customer doesn't exist
        //return false
        return false;
    }
    //the customer was found, so return true
    return true;
}

//prints out the history of a given customer
bool customerHandler::printHistory(int customerId) {
    //finds the customer
    customerNode *temp = customerHashTable.search(customerId);

    //if the customer was found, it prints his history
    //this step is redundant since this method will never be called
    //unless a customer exists
    if (temp == nullptr) {
        std::cout << "The customer ID: " << customerId << " does not exist" << std::endl;
        return false;
    }

    // Printing the history of specific customer
    temp->printHistory();
    return true;
}




