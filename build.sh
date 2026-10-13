#!/bin/sh
# Linux / macOS build script
g++ -std=c++17 -Wall -Wextra -pedantic -O2 -o restaurant src/*.cpp && echo "Built: ./restaurant   (run it with ./restaurant)"
