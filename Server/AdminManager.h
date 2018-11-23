#ifndef ADMIN_MANAGER_H
#define ADMIN_MANAGER_H
/*
 * Administrator class which takes care of admin information
 * to the client.
 */

#include <map>
#include <vector>
#include <iostream>
#include <string>

class AdminManager {
public:
    AdminManager();
    ~AdminManager();

    bool isRegistered(std::string &id);
    void registerUser(std::string &id);

private:
    struct User {
        std::string id;
        int numWin;
        int numLoss;
    };

    std::map<std::string, User*> users;



};

#endif