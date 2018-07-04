
#include <map>

#ifndef CUSTOMERHANDLER_H
#define CUSTOMERHANDLER_H

#include <string>
#include "customerNode.h"
#include "../HashTable/Table.h"

class customerHandler {
public:
    //constructor, creates a hashtable of size 13
    customerHandler();

    //inputs customers from the file
    bool readFile(std::string filename);

    //adds a new customer to the customerHashTable
    bool addCustomer(std::string customerName, int customerId);

    //adds history to a certain customer
    bool addHistory(int customerId, std::string history, std::string bOrR);

    //finds if a customer exists
    bool customerExists(int customerId);

    //prints out the history of a given customer
    bool printHistory(int customerId);

private:
    //A vector of vectors that stores the customers and sorts
    //using a hashing function
    Table<int, customerNode> customerHashTable;
};

#endif 
