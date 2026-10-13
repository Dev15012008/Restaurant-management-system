# Build:  make          Run:  ./restaurant        Clean:  make clean
CXX      = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -pedantic -O2
SRC      = $(wildcard src/*.cpp)

restaurant: $(SRC) $(wildcard src/*.h)
	$(CXX) $(CXXFLAGS) -o restaurant $(SRC)

test: restaurant
	cd tests && python3 run_tests.py

clean:
	rm -f restaurant restaurant.exe
