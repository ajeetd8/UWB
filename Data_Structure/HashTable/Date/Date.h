#ifndef __DATE_H_
#define __DATE_H_

/**
 * Date class which save the year, month, and day.
 */
class Date
{
private:
    int year;
    int month;
    int day;
public:
    // Constructors
    Date();
    Date(int year);
    Date(int year, int month);
    Date(int year, int month, int day);

    // Accessor
    int getYear() const;
    int getMonth() const;
    int getDay() const;

    // Modifier
    void setYear(int year);
    void setMonth(int month);
    void setDay(int day);

    // Arithematic operation. (compare)
    bool operator<(const Date&) const;
    bool operator>(const Date&) const;
    bool operator==(const Date&) const;
    bool operator!=(const Date&) const;
    bool operator<=(const Date&) const;
    bool operator>=(const Date&) const;

    // Destructor
    ~Date();
};

#endif