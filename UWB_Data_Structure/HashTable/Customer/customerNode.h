

#ifndef CUSTOMERNODE_H
#define CUSTOMERNODE_H

#include <vector>

class customerNode {
public:
    // Customer only allow to constructed with ID, and id #.
    customerNode(const std::string &name, int id);

    // Defulat destructor for customer Node.
    ~customerNode();

    //returns the customer's name
    std::string getName() const;

    //returns the customer's ID
    int getId() const;

    //adds a transaction to the customer's history vector
    bool addHistory(std::string history);

    //prints out the customer's  history
    //in chronological order (latest to earliest)
    void printHistory();

private:
    std::string name;
    int id;
    
    //a vector that stores a customer's transaction history
    std::vector<std::string> history;
};

#endif 
