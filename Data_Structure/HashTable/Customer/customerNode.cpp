
#include <string>
#include "customerNode.h"
#include <iostream>

using namespace std;

//node constructor
customerNode::customerNode(const string &customerName, int customerId)
        : name(customerName), id(customerId) {
}

customerNode::~customerNode() {
    //delete the vector
}

//returns the customer's name
string customerNode::getName() const {
    return name;
}

//returns the customer's ID
int customerNode::getId() const {
    return id;
}

//adds a transaction to the customer's history vector
bool customerNode::addHistory(string historyString) {
    history.push_back(historyString);
    return true;
}

//prints out the customer's  history
//in chronological order (latest to earliest) 
void customerNode::printHistory() {
    // Print out the history of customer node.
    std::cout << "**** History of " << name << ": " << id << "****" << std::endl;
    for (auto ite = history.begin(); ite != history.end(); ite++)
        std::cout << *ite << std::endl;

    std::cout << "**** End of History ****" << std::endl << std::endl;
}

