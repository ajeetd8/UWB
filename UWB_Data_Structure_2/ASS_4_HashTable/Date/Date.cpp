#include "Date.h"

/**
 * Defualt constructor, set year, month day equal to zero.
 */
Date::Date()
    : year(0), month(0), day(0) {}

/**
 * Constructor with year.
 * @param year set to year.
 */
Date::Date(int year)
    : year(year), month(0), day(0) {}

/**
 * Constructor with year, and month.
 * @param year year info.
 * @param month month info.
 */
Date::Date(int year, int month)
    : year(year), month(month), day(0) {}

/**
 * Constructor with year, month, and day.
 * @param year year info.
 * @param month month info.
 * @param day day info.
 */
Date::Date(int year, int month, int day)
    : year(year), month(month), day(day) {}

/**
 * Get the year
 * @return year.
 */
int Date::getYear() const
{
    return year;
}

/**
 * Get month
 * @return month.
 */
int Date::getMonth() const
{
    return month;
}

/**
 * Get day.
 * @return day.
 */
int Date::getDay() const
{
    return day;
}

/**
 * Set the year to given info.
 * @param year year.
 */
void Date::setYear(int year)
{
    this->year = year;
}

/**
 * Set the month to given info.
 * @param month month.
 */
void Date::setMonth(int month)
{
    this->month = month;
}

/**
 * Set the day to given info.
 * @param day day.
 */
void Date::setDay(int day)
{
    this->day = day;
}

bool Date::operator<(const Date & rhs) const
{
    int dateL, dateR;
    dateL = getYear()*10000 + getMonth()*100 + getDay();
    dateR = rhs.getYear()*10000 + getMonth()+100 + getDay();

    return dateL < dateR;
}

bool Date::operator>(const Date & rhs) const
{
    return rhs < *this;
}

bool Date::operator==(const Date & rhs) const
{
    if (this->year == rhs.year &&
        this->month == rhs.month &&
        this->day == rhs.day)
        return true;

    return false;
}

bool Date::operator!=(const Date & rhs) const
{
    return !(*this == rhs);
}

bool Date::operator<=(const Date & rhs) const
{
    return (*this < rhs || *this == rhs);
}

bool Date::operator>=(const Date & rhs) const
{
    return (rhs <= *this);
}

Date::~Date() { }
