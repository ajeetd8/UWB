#include "Drama.h"

#include <sstream>

// Setting the static  variable for genre.
const std::string Drama::Genre = "Drama";
const std::string Drama::MovieType = "D";

#include <algorithm>

Drama::Drama()
        : Movie() {}

Drama::Drama(const std::string &title, const std::string &director,
             int stock, int year)
        : Movie(title, director, stock, year) {
}

Drama::Drama(std::string &infoString) : Movie() {

    // Save the data info stringstream.
    std::stringstream strInfo;
    strInfo << infoString;

    // Throughout the movie type letter.
    std::string movieType;
    strInfo >> movieType;

    //Gettting the Director, and title
    std::string director, title;

    // Get the movie information from the string.
    std::getline(strInfo, director, ',');
    std::getline(strInfo, title, ',');

    // Remove the white space from the first line.
    director.erase(0, 1);
    title.erase(0, 1);

    // Setting the title and director of the movie
    setTitle(title);
    setDirector(director);
}

Drama::~Drama() {
}

std::string Drama::getGenre() const {
    return Drama::Genre;
}

std::string Drama::toString() const {

    std::string infoString = std::to_string(getStock()) + ", " +getDirector() +
            ", " +getTitle() + ", "+std::to_string(getReleaseYear());

    return infoString;
}

void Drama::displayMovieInfo() const {
    std::cout << toString() << std::endl;
}

bool Drama::operator<(const Drama &rhs) const {
    return this->getDirector() == rhs.getDirector() ?
           this->getTitle() < rhs.getTitle() :
           this->getDirector() < rhs.getDirector();
}

bool Drama::operator>(const Drama &rhs) const {
    return rhs < *this;
}

bool Drama::operator==(const Drama &rhs) const {
    return (this->getDirector() == rhs.getDirector() &&
            this->getTitle() == rhs.getTitle());
}

bool Drama::operator!=(const Drama &rhs) const {
    return !(*this == rhs);
}

bool Drama::operator<=(const Drama &rhs) const {
    return ((*this < rhs) || *this == rhs);;
}

bool Drama::operator>=(const Drama &rhs) const {
    return (rhs <= *this);
}

std::istream &operator>>(std::istream &is, Drama &obj) {
    // Local variable to handle the information.
    std::string stock_str;
    std::string director;
    std::string title;
    std::string year_str;

    // Get each line from the front
    std::getline(is, stock_str, ',');
    std::getline(is, director, ',');
    std::getline(is, title, ',');
    std::getline(is, year_str, ',');

    // Remove the white space front.
    stock_str.erase(0, 1);
    director.erase(0, 1);
    title.erase(0, 1);
    year_str.erase(0, 1);

    // Save the stock and year to int.
    int stock = std::atoi(stock_str.c_str());
    int year = std::atoi(year_str.c_str());

    // Change the value in the string.
    obj.setTitle(title);
    obj.setDirector(director);
    obj.setYear(year);
    obj.setStock(stock);

    return is;
}
