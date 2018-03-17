# Project Title

Assignment 3: Graph project.

## Getting Started



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
tp1: []
tp2: [F 10]
tp1 now as tp2+tp3: [F 10 R 90]
tp1 now as tp2 * 3: [F 10 F 10 F 10]
tp4 is a copy of tp1: [F 10 F 10 F 10]
tp5: [F 10]
tp2 and tp5 are == to each other: true
tp2 and tp3 are != to each other: true
index 0 of tp2 is F
tp2 after 2 calls to setIndex: [R 90]
tp2 and tp3 are == to each other: true
tp1 after tp1+=tp3: [F 10 F 10 F 10 R 90]
tp1 after tp1*=2: [F 10 F 10 F 10 R 90 F 10 F 10 F 10 R 90]
tp2 = [R 90]
tp3 = [R 90]
tp4 = [F 10 F 10 F 10]
tp1= tp2+tp3+tp4 = [R 90 R 90 F 10 F 10 F 10]
tp1= tp3+tp4*4 = [R 90 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10]
Size of tp1 is 26
done
[R 90 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 R 90 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10 F 10]
```


## Deployment

This is done as a course assignment.

## Authors

Haram Kwon

## Acknowledgments

* Prof. Yusuf Pisan
