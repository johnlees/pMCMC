#time mpirun -n 4 ./parallel_trees --master 1 --iterations 10 --waiting 1 --output out.txt --seed -1
#make
#make -f MakefileSerial
#time mpirun -n 3 ./parallel_trees --master 1 --iterations 100000 --waiting 1 --output out.txt --seed -1 --variance 1
#time  ./serial --master 0 --iterations 100000 --waiting 200000 --output out.txt --seed 0

mpirun -n 1 ./parallel_trees --master 1 --iterations 5000 --waiting 1 --output outPar.txt --seed 55 --variance 1.5 --acceptprob 0.2 --issamples 200
#time mpirun -n 1  ./parallel_trees --master 1 --iterations 10 --waiting 1  --output outPar.txt --seed 1 --variance 9 --acceptprob 0.1
#time mpirun -n 2  ./parallel_trees --master 1 --iterations 500 --waiting 1  --output outPar.txt --seed 1 --variance 9 --acceptprob 0.1
#time mpirun -n 3  ./parallel_trees --master 1 --iterations 500 --waiting 1  --output outPar.txt --seed 1 --variance 9 --acceptprob 0.44
#time mpirun -n 4  ./parallel_trees --master 1 --iterations 500 --waiting 1  --output outPar.txt --seed 1 --variance 9 --acceptprob 0.44
#694 9  8.331673224s
#  mpirun -n 2 valgrind --tool=callgrind  ./parallel_trees --master 1 --iterations 10 --waiting 4000000  --output outPar.txt --seed 1 --variance 8 --acceptprob 0.12
#6983
#./serial --master 1 --iterations 200000 --waiting 1 --output outSer.txt --seed 1 --variance .8 --acceptprob 0.2
#/114.881954749s
