CXX = mpiCC
CPPFLAGS =  -O3 -I/usr/local/include     # put pre-processor settings (-I, -D, etc) here
CXXFLAGS = -Wall -L/usr/local/lib    # put compiler settings here
LDFLAGS =   -lgsl -lgslcblas -lm -lrt       # put linker settings here


parallel_trees: parallel_trees.o utilities.o optimal_tree.o likelihood.o 
	    $(CXX) -o $@ $(CXXFLAGS) parallel_trees.o utilities.o optimal_tree.o likelihood.o $(LDFLAGS)
	    #mpirun -n 2 ./parallel_trees
		#./timing.sh
		#   make -f MakefileSerial #Hackjob change this

.cpp.o:
	    $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c parallel_trees.cpp
	    $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c utilities.cpp
	    $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c optimal_tree.cpp
	    $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c likelihood.cpp

clean: 
	rm parallel_trees.o
	rm utilities.o
	rm optimal_tree.o
