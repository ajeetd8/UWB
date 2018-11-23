#include "AdminManager.h"

using namespace std;

// load saved data (users, ranks, records)
AdminManager::AdminManager() {

}


// save data (users, ranks, records)
AdminManager::~AdminManager() {

}

bool AdminManager::isRegistered(string &id) {
    // check whether user id is registered
    User *user = this->users[id];

    // true if registered
    return user != nullptr;
}

void AdminManager::registerUser(string &id) {
    // register user and save
    User *user = new User{id, 0, 0};
    this->users[id] = user;
}