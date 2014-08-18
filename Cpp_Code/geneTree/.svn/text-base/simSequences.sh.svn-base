ms 30 1 -t 2  | tail -n+7 |sed 's/\(.\)/\1 /g' | sort | sed 's/^/ : /' | uniq -c | sed 's/ \+/ /g'  | sed 's/^/0/'  > sim.seq  && ./seq2tr  sim.seq  sim.tree
