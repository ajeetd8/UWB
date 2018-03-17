# Project Title

Assignment 3: Graph project.
Depth first serach
Breadth First search
Dijistra is implemented

## Getting Started

Graph Program
Implement a Graph class on the template below and test your class for depth-first search, breadth-first search and in djikstra’s shortest path.

All the public functions for Vertex, Edge and Graph have to be implemented. You can change the private variables and functions as needed. Your program shoulkd compile and run against ass3.cpp provided. You should write your own expanded version of ass3.

Fixed: getEdgeWeight in vertex.cpp had a default value of = 0 for string: 2/1

vertex.h, vertex.cpp, edge.h, edge.cpp, graph.h, graph.cpp, ass3.cpp

Graph file format
The format of the graph files is: an integer indicating the number of edges, followed by a series of lines of the from “fromVertex toVertex edgeEweight”. fromVertex and toVertex are strings, edgeWeight is an integer. All the edges are directed and have 0 or larger weights.

Sample graph files: graph0.txt, graph1.txt, graph2.txt

[[https://github.com/kharam1436/DataStructure/blob/master/UWB_Data_Structure_2/ASS_3_Graph/ass3-nodes.png|alt=octocat]]

### Prerequisites

```
g++ with supporting stardard 14
cmake with version higher than 3.9
make
```

### Installing

```
cmake CMakeLists.txt
make
```

## Running the tests

The test code is given to you in ass3.cpp.

Result:
```
testGraph0
OK: 3 vertices
OK: 3 edges
OK: DFS
OK: BFS
OK: Djisktra
testGraph1
OK: 10 vertices
OK: 9 edges
OK: DFS
OK: BFS
OK: Djisktra
OK: 21 vertices
OK: 24 edges
OK: DFS from A
OK: DFS from O
OK: BFS from A
OK: BFS from D
OK: DFS from U
OK: BFS from U
OK: Djisktra O
```


## Deployment

This is done as a course assignment.

## Authors

Haram Kwon

## Acknowledgments

* Prof. Yusuf Pisan
