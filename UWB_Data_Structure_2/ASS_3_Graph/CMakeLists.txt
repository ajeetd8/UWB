cmake_minimum_required(VERSION 3.9)
project(Ass_3_Graph)

set(CMAKE_CXX_STANDARD 14)

add_executable(Ass_3_Graph
        ass3.cpp
        Graph/edge.cpp
        Graph/edge.h
        Graph/graph.cpp
        Graph/graph.h
        Graph/vertex.cpp
        Graph/vertex.h)
