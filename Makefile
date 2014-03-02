CXX=g++
tl: tl.cpp 
	$(CXX) -Wall -o tl tl.cpp -lreadline -std=c++11 -lcurl

install: tl
	cp -v tl /usr/bin/tl

uninstall:
	rm -v /usr/bin/tl
