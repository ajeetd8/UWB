cmake_minimum_required(VERSION 3.5)
project(ass4)

set(CMAKE_CXX_STANDARD 14)

add_executable(ass4
        ass4.cpp
        "BSTree/Binarynode.h"
        "BSTree/Binarynode.hpp"
        "BSTree/Binarysearchtree.h"
        "BSTree/Binarysearchtree.hpp"
        Movie/Classic.cpp
        Movie/Classic.h
        Movie/Comedy.cpp
        Movie/Comedy.h
        Customer/customerHandler.cpp
        Customer/customerHandler.h
        Customer/customerNode.cpp
        Customer/customerNode.h
        Date/Date.cpp
        Date/Date.h
        Movie/Drama.cpp
        Movie/Drama.h
        Movie/Movie.cpp
        Movie/Movie.h
        Movie/movieHandler.cpp
        Movie/movieHandler.h
        storeHandler.cpp
        storeHandler.h
        HashTable/Table.h
        HashTable/Table.hpp)
