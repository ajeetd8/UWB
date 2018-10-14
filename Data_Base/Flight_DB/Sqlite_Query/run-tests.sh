#!/bin/bash

echo "Removing old binaries and databases"
rm -f tst/*.class
rm -rf out/
mkdir out/
rm -f tmp.db

echo "Checking files"
if [ ! -f "sql/create-tables.sql" ]; then
    echo "MISSING FILE: sql/create-tables.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q1.sql" ]; then
    echo "MISSING FILE: sql/hw1-q1.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q2.sql" ]; then
    echo "MISSING FILE: sql/hw1-q2.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q3.sql" ]; then
    echo "MISSING FILE: sql/hw1-q3.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q4.sql" ]; then
    echo "MISSING FILE: sql/hw1-q4.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q5.sql" ]; then
    echo "MISSING FILE: sql/hw1-q5.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q6.sql" ]; then
    echo "MISSING FILE: sql/hw1-q6.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q7.sql" ]; then
    echo "MISSING FILE: sql/hw1-q7.sql"
    exit 1
fi
if [ ! -f "sql/hw1-q8.sql" ]; then
    echo "MISSING FILE: sql/hw1-q8.sql"
    exit 1
fi

echo "Compiling"
javac -cp lib/junit-4.12.jar:lib/sqlite-jdbc-3.23.1.jar:lib/hamcrest-core-1.3.jar:out -d out tst/*.java

cd out;
jar -cvf out.jar *
cd -;

echo "Running tests"
echo ";" | sqlite3 tmp.db
java -cp lib/junit-4.12.jar:lib/sqlite-jdbc-3.23.1.jar:lib/hamcrest-core-1.3.jar:out/out.jar org.junit.runner.JUnitCore Grader
