# Instructions for running Tedlium dataset in Kaldi
* The changes of the original scripts
* The adaptions required for Local RHEL machine

## Process

```bash
vim run.sh
```

## Error Report
The following error appear in the mkgraph.md
Process 20541 (fstminimizeencoded) is killed therefore the shell scripts exit with 1, since it consume 1.7G memory and 1.65G swp. 
```bash
## Last Output that indicate the error 
utils/mkgraph.sh: line 92: 20539 Done                    fsttablecompose $lang/L_disambig.fst $lang/G.fst
tree-info exp/tri1/tree
fsttablecompose data/lang_nosp_test/L_disambig.fst data/lang_nosp_test/G.fst
fstminimizeencoded
fstpushspecial
fstdeterminizestar --use-log=true
WARNING (fstpushspecial[5.2.160~1-51042]:Iterate():push-special.cc:182) push-special: finished 200 iterations without converging.  Output will be inaccurate.
utils/mkgraph.sh: line 92: 20539 Done
# One process 20541 is killed therefore the shell scripts exit with 1
                    fsttablecompose $lang/L_disambig.fst $lang/G.fst
     20540                       | fstdeterminizestar --use-log=true
     20541 Killed                  | fstminimizeencoded
     20542                       | fstpushspecial
     20543                       | fstarcsort --sort_type=ilabel > $lang/tmp/LG.fst.$$

real    17m30.106s
user    12m1.151s
sys 3m2.491s
```

```bash
mkdir -p $lang/tmp
trap "rm -f $lang/tmp/LG.fst.$$" EXIT HUP INT PIPE TERM
# Note: [[ ]] is like [ ] but enables certain extra constructs, e.g. || in
# place of -o
if [[ ! -s $lang/tmp/LG.fst || $lang/tmp/LG.fst -ot $lang/G.fst || \
      $lang/tmp/LG.fst -ot $lang/L_disambig.fst ]]; then
  ## this is where error appear
  fsttablecompose $lang/L_disambig.fst $lang/G.fst | fstdeterminizestar --use-log=true | \
    fstminimizeencoded | fstpushspecial | \
    fstarcsort --sort_type=ilabel > $lang/tmp/LG.fst.$$ || exit 1;
  mv $lang/tmp/LG.fst.$$ $lang/tmp/LG.fst
  fstisstochastic $lang/tmp/LG.fst || echo "[info]: LG not stochastic."
fi
```

What I saw in the last several second that is a process is trying to use more than 100% CPU and the memeory is going up to consume the whole memory. Therefore, I think the problem is that mkgraph.sh require at least 8G memory and we only have 2G memeory