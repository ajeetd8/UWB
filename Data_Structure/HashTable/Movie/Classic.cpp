#include "Classic.h"
#include "../Date/Date.h"

#include <sstream>

// Setting the static  variable for Genre, and MovieType.
const std::string Classic::Genre = "Classic";
const std::string Classic::MovieType = "C";

Classic::Classic()
        : Movie() {
}

Classic::Classic(const std::string &title, const std::string &director,
                 std::string majorActor, int stock, int year, int month)
        : Movie(title, director, stock, year, month) {
}

Classic::Classic(std::string &infoString) : Movie() {

    // Save the data info stringstream.
    std::stringstream strInfo;
    strInfo << infoString;

    // Throughout the movie type letter.
    std::string movieType;
    strInfo >> movieType;

    // Variable to save sorting criteria variables
    int month, year;
    std::string firstName;
    std::string lastName;

    // stirng to variable.
    strInfo >> month;
    strInfo >> year;
    strInfo >> firstName;
    strInfo >> lastName;

    std::string majorActor = firstName + " " + lastName;

    // Setting the title and director of the movie
    setMonth(month);
    setYear(year);
    addMajorActor(majorActor);
}

Classic::~Classic() {
}

std::string Classic::getGenre() const {
    return Classic::Genre;
}

std::string Classic::toString() const {
    std::string actors = "";
    for (auto ite = majorActors.begin(); ite != majorActors.end(); ite++) {
        actors += *ite;
        if(ite+1 != majorActors.end())
            actors += " | ";
    }

    return std::to_string(getStock()) + ", " + getDirector() + ", " +
           getTitle() + ", " + "("+ actors + ")" + " " +
           std::to_string(getReleaseMonth()) + " " +
           std::to_string(getReleaseYear());
}

void Classic::displayMovieInfo() const {
    std::cout << toString() << std::endl;
}

std::vector<std::string> Classic::getMajorActors() const {
    return majorActors;
}

void Classic::addMajorActor(std::string majorActor) {
    if (majorActor != "")
        majorActors.push_back(majorActor);
    else
        std::cout << "empty major actor is invalid" << std::endl;
}

void Classic::addMajorActors(std::vector<std::string> majorActors) {
    for (auto ite = majorActors.begin();
         ite != majorActors.end(); ite++) {
        this->addMajorActor(*ite);
    }
}

bool Classic::operator<(const Classic &rhs) const {
    if ((getReleaseDate() == rhs.getReleaseDate())) {
        for (auto ite = majorActors.begin();
             ite != majorActors.end(); ite++) {
            for (auto iteR = rhs.majorActors.begin();; iteR++) {

                // If one of LHS surpass RHSs.
                if (iteR == rhs.majorActors.end())
                    return true;

                // One of the LHS is small or equal.
                if (*ite >= *iteR)
                    break;
            }
        }
    } else
        return (getReleaseDate() < rhs.getReleaseDate());

    // RHS is equal or larger.
    return false;
}

bool Classic::operator>(const Classic &rhs) const {
    return rhs < *this;
}

bool Classic::operator==(const Classic &rhs) const {

    // Compared the release date, and none of the major
    // Acotr overlap each other return true.
    if (getReleaseDate() == rhs.getReleaseDate()) {
        for (auto ite = majorActors.begin();
             ite != majorActors.end(); ite++) {
            for (auto iteR = rhs.majorActors.begin();
                 iteR != rhs.majorActors.end(); iteR++) {
                if (*ite == *iteR)
                    return true;
            }
        }
    }

    return false;
}

bool Classic::operator!=(const Classic &rhs) const {
    return !(*this == rhs);
}

bool Classic::operator<=(const Classic &rhs) const {
    return (*this < rhs || *this == rhs);
}

bool Classic::operator>=(const Classic &rhs) const {
    return (rhs <= *this);
}

std::istream &operator>>(std::istream &is, Classic &obj) {
    // Local variable to handle the informatoin.
    std::string stock_str;
    std::string director;
    std::string title;
    std::string majorActor_FName;
    std::string majorActor_LName;
    int year;
    int month;

    // Get the line from the front.
    std::getline(is, stock_str, ',');
    std::getline(is, director, ',');
    std::getline(is, title, ',');
    is >> majorActor_FName;
    is >> majorActor_LName;
    is >> month;
    is >> year;


    // Remove the white space front.
    stock_str.erase(0, 1);
    director.erase(0, 1);
    title.erase(0, 1);

    // Save the stock and year and month to int.
    int stock = std::atoi(stock_str.c_str());

    // Change the value in the string.
    obj.setTitle(title);
    obj.setDirector(director);
    obj.addMajorActor(majorActor_FName + " " + majorActor_LName);
    obj.setYear(year);
    obj.setMonth(month);
    obj.setStock(stock);

    return is;
}