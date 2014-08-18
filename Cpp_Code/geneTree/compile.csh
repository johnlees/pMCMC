# Version 1.0 13/8/97
rm *.o
cc -w  -c  sublike.c uniform.c multiple.c filearg.c integrat.c two.c  general.c lu.c paths.c seq2tr.c treepic.c 
#cc -w -O -o treepic -DTREEPIC -DGENETREE -DPSVIEW treepic.c -lm
#cc -w -O -o seq2tr -DSEQTOTR seq2tr.c -lm
#rm *.o
./genetree sim.tree 
