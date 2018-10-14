#include "Movie.h"
#include <string>

Movie::Movie(const std::string& title, const std::string& director,
    int stock, int year)
    : title(title), director(director), stock(stock), date(year, 0, 0)
{ }

Movie::Movie(const std::string & title, const std::string & director,
    int stock, int year, int month)
    : title(title), director(director), stock(stock), date(year, month, 0)
{
}

Movie::Movie(const std::string & title, const std::string & director,
    int stock, int year, int month, int day)
    : title(title), director(director), stock(stock), date(year, month, day)
{
}


//Movie::Movie(const std::string& title, const std::string& director, int stock,
//    int year, int month)
//    : title(title), director(director), stock(stock), date{ year, month }
//{ }
//
//Movie::Movie(const std::string& title, const std::string& director, int stock,
//    int year, int month, int day)
//    : title(title), director(director), stock(stock), date{ year, month, day }
//{ }

std::string Movie::getTitle() const
{
    return this->title;
}

std::string Movie::getDirector() const
{
    return this->director;
}

Date Movie::getReleaseDate() const
{
    return date;
}

int Movie::getReleaseYear() const
{
    return this->date.getYear();
}

int Movie::getReleaseMonth() const
{
    return date.getMonth();
}

int Movie::getReleaseDay() const
{
    return date.getDay();
}

int Movie::getStock() const
{
    return this->stock;
}

void Movie::setTitle(const std::string& title)
{
    this->title = title;
}

void Movie::setDirector(const std::string& director)
{
    this->director = director;
}

void Movie::setStock(const int& stock)
{
    this->stock = stock;
}

void Movie::setYear(const int& year)
{
    this->date.setYear(year);
}

void Movie::setMonth(const int& month)
{
    this->date.setMonth(month);
}

void Movie::setDay(const int& day)
{
    this->date.setDay(day);
}
