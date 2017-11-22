# List of Common Knowledege about Kaldi

## Use Kaldi Binaries
1. In order to run Kaldi binaries as a command, cd to the example folder and run the following command: which means specify the sources
```bash
. ./path.sh 
```


## Kaldi Keywords

### L.fst: The Phonetic Dictionary FST
L maps monophone sequences to words.

The file L.fst is the Finite State Transducer form of the lexicon with phone symbols on the input and word symbols on the output.

### G.fst: The Language Model FST
### HCLG.fst: final graph

## File formats in Kaldi

scp: kaldi script file
ark: archive file
oov: out of vocabulary

Kaldi is a WFST-based speech recognizer – it builds four different WFST/WFSAs:
H: maps multiple HMM states (a.k.a. transition-ids in Kaldi-speak) to contextdependent
triphones
C: maps triphone sequences to monophones
L: maps monophone sequences to words
G: FSA grammar (can be built from an n-gram grammar).

## Kaldi WER (%) Scoring
### How Kaldi Compute Word Error Rate

In the following file:
```
~/kaldi/src/bin/computer-wer.cc
```

#### Compute WER by comparing different transcriptions:
Takes two transcription files, in integer or text format, and outputs overall WER statistics to standard output.

#### Usage: compute-wer [options] <ref-rspecifier> <hyp-rspecifier>
E.g.: compute-wer --text --mode=present ark:data/train/text ark:hyp_text
What we need to provide is the hyp-rspecifier that can be used to compare with kaldi's reference file

file data/train/text is in the following format 
```
utt-id transcriptions
zlp-20100110-kgx-a0323 HE CONSIDERED THE VICTORY ALREADY HIS AND STEPPED FORWARD TO THE MEAT
zlp-20100110-kgx-a0324 IT WAS NOT RED EYE'S WAY TO FOREGO REVENGE SO EASILY
zlp-20100110-kgx-a0325 WHIZ ZIP BANG LOP EAR SCREAMED WITH SUDDEN ANGUISH
zlp-20100110-kgx-a0326 CHEROKEE IDENTIFIED HIMSELF WITH HIS INSTINCT
zlp-20100110-kgx-a0327 THEY WERE LESS STOOPED THAN WE LESS SPRINGY IN THEIR MOVEMENTS
zlp-20100110-kgx-a0328 THE FIRE PEOPLE LIKE OURSELVES LIVED IN CAVES
zlp-20100110-kgx-a0329 AH INDEED
zlp-20100110-kgx-a0330 RED EYE NEVER COMMITTED A MORE OUTRAGEOUS DEED
zlp-20100110-kgx-a0331 POOR LITTLE CROOKED LEG WAS TERRIBLY SCARED
zlp-20100110-lbe-b0509 HE HAD FULFILLED HIS DUTY AND PAID PROPERLY
zlp-20100110-lbe-b0510 HE KNEW WHAT TABOOS HE WAS VIOLATING
zlp-20100110-lbe-b0511 DO YOU VALUE YOUR HIDE
zlp-20100110-lbe-b0512 YOU SHOULD HAVE SEEN THEM WHEN THEY HEARD ME SPITTING CHINOOK
zlp-20100110-lbe-b0513 HE PLODDED ON FOR HALF AN HOUR WHEN THE HALLUCINATION AROSE AGAIN
zlp-20100110-lbe-b0514 TOMORROW OR THE NEXT DAY IT MIGHT BE GONE
zlp-20100110-lbe-b0515 BUT ALREADY HE HAD COMPOSED HIMSELF
zlp-20100110-lbe-b0516 ZILLA RELAXED HER SOUR MOUTH LONG ENOUGH TO SIGH HER SATISFACTION
zlp-20100110-lbe-b0517 EGGSHELL IS NOT GOOD TO EAT
zlp-20100110-lbe-b0518 BUT THERE WAS ALSO TALK OF WITCHCRAFT IN THE VILLAGE
zlp-20100110-ujo-a0025 I WAS ABOUT TO DO THIS WHEN COOLER JUDGMENT PREVAILED
zlp-20100110-ujo-a0026 IT OCCURRED TO ME THAT THERE WOULD HAVE TO BE AN ACCOUNTING
zlp-20100110-ujo-a0027 TO MY SURPRISE HE BEGAN TO SHOW ACTUAL ENTHUSIASM IN MY FAVOR
zlp-20100110-ujo-a0028 ROBBERY BRIBERY FRAUD
zlp-20100110-ujo-a0029 THEIR FORCES WERE ALREADY MOVING INTO THE NORTH COUNTRY
zlp-20100110-ujo-a0030 I HAD FAITH IN THEM
zlp-20100110-ujo-a0031 THEY WERE THREE HUNDRED YARDS APART
zlp-20100110-ujo-a0032 SINCE THEN SOME MYSTERIOUS FORCE HAS BEEN FIGHTING US AT EVERY STEP
zlp-20100110-ujo-a0033 HE UNFOLDED A LONG TYPEWRITTEN LETTER AND HANDED IT TO GREGSON
zlp-20100110-ujo-a0034 MEN OF SELDEN'S STAMP DON'T STOP AT WOMEN AND CHILDREN
zlp-20100110-vuh-b0479 VIOLATION OF THIS LAW WAS MADE A HIGH MISDEMEANOR AND PUNISHED ACCORDINGLY
zlp-20100110-vuh-b0480 WITHOUT DISCUSSION IT WAS THE AGENTS PROVOCATEURS WHO CAUSED THE PEASANT REVOLT
zlp-20100110-vuh-b0481 THE TASK WE SET OURSELVES WAS THREEFOLD
zlp-20100110-vuh-b0482 MANY OTHER SIMILAR DISCONCERTING OMISSIONS WILL BE NOTICED IN THE MANUSCRIPT
zlp-20100110-vuh-b0483 THE FLOWER OF THE ARTISTIC AND INTELLECTUAL WORLD WERE REVOLUTIONISTS
zlp-20100110-vuh-b0484 THIS THE IRON HEEL FORESAW AND LAID ITS SCHEMES ACCORDINGLY
zlp-20100110-vuh-b0485 THE MOB CAME ON BUT IT COULD NOT ADVANCE
zlp-20100110-vuh-b0486 BUT WHY CONTINUE THE TIRADE FOR TIRADE IT WAS
zlp-20100110-vuh-b0487 AFTER ALL SUPERFLUOUS FLESH IS GONE WHAT IS LEFT IS STRINGY AND RESISTANT
zlp-20100110-vuh-b0488 BEYOND REFUSING TO SELL US FOOD THEY LEFT US TO OURSELVES
zlp-20100110-wwn-b0201 I ALSO UNDERSTAND THAT SIMILAR BRANCH ORGANIZATIONS HAVE MADE THEIR APPEARANCE IN EUROPE
zlp-20100110-wwn-b0202 SOCIETY IS SHAKEN TO ITS FOUNDATIONS
zlp-20100110-wwn-b0203 A MONTH IN AUSTRALIA WOULD FINISH ME
zlp-20100110-wwn-b0204 DOWN THROUGH THE PERFUME WEIGHTED AIR FLUTTERED THE SNOWY FLUFFS OF THE COTTONWOODS
zlp-20100110-wwn-b0205 YOU WERE DESTROYING MY LIFE
zlp-20100110-wwn-b0206 HORSES AND RIFLES HAD BEEN HER TOYS CAMP AND TRAIL HER NURSERY
zlp-20100110-wwn-b0207 I'M AS GOOD AS A MAN SHE URGED
zlp-20100110-wwn-b0208 YOU READ THE QUOTATIONS IN TODAY'S PAPER
zlp-20100110-wwn-b0209 HE'S TERRIBLY TOUCHY ABOUT HIS BLACK WARDS AS HE CALLS THEM
zlp-20100110-wwn-b0210 WHATEVER HE GUESSED HE LOCKED AWAY IN THE TABOO ROOM OF NAOMI
```

#### Example scoring script: egs/wsj/s5/steps/score_kaldi.sh
```bash
[xfu7@lin-res30 scoring]$ cat ~/kaldi/egs/wsj/s5/steps/score_kaldi.sh

if [ $# -ne 3 ]; then
  echo "Usage: $0 [--cmd (run.pl|queue.pl...)] <data-dir> <lang-dir|graph-dir> <decode-dir>"
  echo " Options:"
  echo "    --cmd (run.pl|queue.pl...)      # specify how to run the sub-processes."
  echo "    --stage (0|1|2)                 # start scoring script from part-way through."
  echo "    --decode_mbr (true/false)       # maximum bayes risk decoding (confusion network)."
  echo "    --min_lmwt <int>                # minumum LM-weight for lattice rescoring "
  echo "    --max_lmwt <int>                # maximum LM-weight for lattice rescoring "
  exit 1;
fi
```


# My testing
```
10 input sentences in /home/xfu7/kaldi/egs/voxforge/s5/data/train/wav.scp file
10 reference sentences in /home/xfu7/kaldi/egs/voxforge/s5/data/train/text file
```
## Input
### wav.scp
```
zlp-20100110-wwn-b0201 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0201.wav
zlp-20100110-wwn-b0202 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0202.wav
zlp-20100110-wwn-b0203 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0203.wav
zlp-20100110-wwn-b0204 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0204.wav
zlp-20100110-wwn-b0205 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0205.wav
zlp-20100110-wwn-b0206 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0206.wav
zlp-20100110-wwn-b0207 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0207.wav
zlp-20100110-wwn-b0208 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0208.wav
zlp-20100110-wwn-b0209 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0209.wav
zlp-20100110-wwn-b0210 /home/xfu7/kaldi/egs/voxforge/s5/../../../egs/voxforge/s5/data/selected/zlp-20100110-wwn/wav/b0210.wav
```
### Reference
```
zlp-20100110-wwn-b0201 I ALSO UNDERSTAND THAT SIMILAR BRANCH ORGANIZATIONS HAVE MADE THEIR APPEARANCE IN EUROPE
zlp-20100110-wwn-b0202 SOCIETY IS SHAKEN TO ITS FOUNDATIONS
zlp-20100110-wwn-b0203 A MONTH IN AUSTRALIA WOULD FINISH ME
zlp-20100110-wwn-b0204 DOWN THROUGH THE PERFUME WEIGHTED AIR FLUTTERED THE SNOWY FLUFFS OF THE COTTONWOODS
zlp-20100110-wwn-b0205 YOU WERE DESTROYING MY LIFE
zlp-20100110-wwn-b0206 HORSES AND RIFLES HAD BEEN HER TOYS CAMP AND TRAIL HER NURSERY
zlp-20100110-wwn-b0207 I'M AS GOOD AS A MAN SHE URGED
zlp-20100110-wwn-b0208 YOU READ THE QUOTATIONS IN TODAY'S PAPER
zlp-20100110-wwn-b0209 HE'S TERRIBLY TOUCHY ABOUT HIS BLACK WARDS AS HE CALLS THEM
zlp-20100110-wwn-b0210 WHATEVER HE GUESSED HE LOCKED AWAY IN THE TABOO ROOM OF NAOMI
```
### Run tri_decode.sh
## Result
[xfu7@lin-res30 s5]$ time ./calaulate_wer.sh
### tri2a
```
zlp-20100110-wwn-b0201 I'VE HIGHER ALSO UNDERSTANDS TO SIMILAR BRANCH ORGANIZATIONS HIS MEAN DEAR PURE IN SEED YOUR IT I HOOF
zlp-20100110-wwn-b0202 I HIGH SOCIETY IS SHE HE CAN TO IS SUNDAY SHOOTS HA
zlp-20100110-wwn-b0203 I HUM ONE TO AUSTRALIA WISH FINISH LEAVE
zlp-20100110-wwn-b0204 OF DOWN STREW THE PERFUME THE ASS LIGHT ARE DO THE SNOW WE SLOW SOME THE CAUGHT TO OR THE SUCH HOOF
zlp-20100110-wwn-b0205 I HUSHED HIGH YOU WERE DESTROYING LIGHT LIKES HI HI
zlp-20100110-wwn-b0206 THE OR SAYS AN RIFLES AND AN HER TO ALWAYS HE EACH YOUTH AND TRAIL HER NURSERY IN HOOF
zlp-20100110-wwn-b0207 THIEF TO USE SHE ARE HUGE HALF
zlp-20100110-wwn-b0208 AT HALF YOU RID WAS IN TO YOU FOR HALF CALF
zlp-20100110-wwn-b0209 IF HYMNS HE'S TERRIBLY TIE SHE AND A HIS BLACK WARDS HAS TO ALL SOME WHOSE CAN LIVE HIS IS
zlp-20100110-wwn-b0210 AND WHOM DO WOULD EVERY GUESS TO HE LOCKED AWAY TO EEL ME HITCH HOOF
compute-wer --text --mode=present ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/text ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/one-best-hypothesis-tri2a.txt
%WER 118.09 [ 111 / 94, 50 ins, 2 del, 59 sub ]
%SER 100.00 [ 10 / 10 ]
Scored 10 sentences, 0 not present in hyp.
```
### tri2b
```
zlp-20100110-wwn-b0201 FIVE TO ELSE SO UNDERSTANDS THIS SIMILAR BRANCH ORGANIZATIONS HIS MEAN DEAR APPEARANCE IN EUROPE TO IF
zlp-20100110-wwn-b0202 FIGHT SOCIETY IS SHE CAN CHEW IS SUNDAY SHOOTS OF FISH
zlp-20100110-wwn-b0203 FROM MONTH A AUSTRALIA WHICH FINISH LEAVE FOR
zlp-20100110-wwn-b0204 FIVE GOWNS THROUGH THE CURSE HEWN THE ASKED SLID OR TO THIS A WEEKS LOSS OF THE CAUGHT HIM WAS SUCH FINE
zlp-20100110-wwn-b0205 HATCHED FEW WERE DESTROYING MY LIFE FOR
zlp-20100110-wwn-b0206 HOOF WAS SAYS AN RIFLES HIM THEN HER TOYS HIS HE A AND TRAIL HER NURSERY FIVE FOR
zlp-20100110-wwn-b0207 HAD FUN THE IF SHE ARE EACH FOR
zlp-20100110-wwn-b0208 FIVE FEW READ THE EACH IS IN TO FIGHT FIVE
zlp-20100110-wwn-b0209 PHONES HE'S TERRIBLY TOUCHY TO THE IS BLACK WARDS TO AS HE CALLS I'M HE VOTED
zlp-20100110-wwn-b0210 THE EVERY GUESSED HE LOCKED AWAY A TO A LEAF
compute-wer --text --mode=present ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/text ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/one-best-hypothesis-tri2b.txt
%WER 93.62 [ 88 / 94, 35 ins, 2 del, 51 sub ]
%SER 100.00 [ 10 / 10 ]
Scored 10 sentences, 0 not present in hyp.
```
### tri2b_mmi
```
zlp-20100110-wwn-b0201 I ALSO UNDERSTANDS A SIMILAR BRANCH ORGANIZATIONS HIS MEAN THEIR APPEARANCE IN YOU ARE OF FIGHT
zlp-20100110-wwn-b0202 SOCIETY IS SHRIEK AND TO IS FOUNDATIONS FISH FOR
zlp-20100110-wwn-b0203 I'M MONTH A AUSTRALIA WISH FISH LEAVE FUR
zlp-20100110-wwn-b0204 GOWNS THROUGH THE PURSE HUMAN WE EAR SLID ARE THIS A WE SAW US OF THE CALM WORSE
zlp-20100110-wwn-b0205 HAS YOU WERE DESTROYING MY LIFE'S A FOR
zlp-20100110-wwn-b0206 SOURCES AND RIFLES HIM IN HER TOYS HIS SHE AND TRAILS NURSERY
zlp-20100110-wwn-b0207 HE FROM SUEZ AS SHE ARE EACH FEAST FREE
zlp-20100110-wwn-b0208 FOR FEW RED PATIENCE AND CITIES PETER AS FOR
zlp-20100110-wwn-b0209 TO HE'S TERRIBLY TOUCHY ABOUT AS BLACK WARDS AS SHE SOME EASE
zlp-20100110-wwn-b0210 WORD EVERY GAS HE LOCKED AWAY A TABOO ROOM HAS A NAOMI
compute-wer --text --mode=present ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/text ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/one-best-hypothesis-tri2b_mmi.txt
%WER 77.66 [ 73 / 94, 21 ins, 2 del, 50 sub ]
%SER 100.00 [ 10 / 10 ]
Scored 10 sentences, 0 not present in hyp.
```
### tri3b
```
zlp-20100110-wwn-b0201 IF I ALSO UNDERSTAND SAYS SCYLLA BRANCH ORGANIZATIONS HIS ME AND A ARE CHEERS AS HE ARE OF FOOD
zlp-20100110-wwn-b0202 IF SOCIETIES CHIC AND TO IS FOUNDATION LEAST FOR
zlp-20100110-wwn-b0203 FROM MONTH AUSTRALIA WOULD FINISH LEAD FOR
zlp-20100110-wwn-b0204 FOOD ALICE RID OF CRUSH YOU OO WE A AIR ASKED SLID ARE THE SILL WEEKS LAW SO THE COTTONWOODS FOOD FOR
zlp-20100110-wwn-b0205 CURSED VIEW WERE DESTROYING MY LIFE SLIDE FOR
zlp-20100110-wwn-b0206 VIEW HORSES AND RIFLES IN IN HER TOYS IN HUGE AND TREE ALL HER NURSERY HE FOR
zlp-20100110-wwn-b0207 THAT FA IF SHE ARRANGE FOR
zlp-20100110-wwn-b0208 FIFTH FEW READ THE QUOTATIONS IN CITIES PEWTER HAD FOR
zlp-20100110-wwn-b0209 TO HE'S TERRIBLY TOUCHY TO AS BLACK WARDS HER TO A ALL SOME
zlp-20100110-wwn-b0210 THE EVERY GUESTS A HE LOT TO WHOM TO A LEAF TO
compute-wer --text --mode=present ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/text ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/one-best-hypothesis-tri3b.txt
%WER 96.81 [ 91 / 94, 34 ins, 5 del, 52 sub ]
%SER 100.00 [ 10 / 10 ]
Scored 10 sentences, 0 not present in hyp.
```
### tri3b_mmi
```
zlp-20100110-wwn-b0201 I ALSO UNDERSTAND THIS SCYLLA BRANCH ORGANIZATIONS HIS ME EITHER APPEARANCE IN YOU'RE IF
zlp-20100110-wwn-b0202 A SOCIETY IS CHIC AND TO IS FOUNDATION SO
zlp-20100110-wwn-b0203 A LAWN AUSTRALIA WOULD SHE TO SHOW HE
zlp-20100110-wwn-b0204 DOWN THROUGH THE PERFUME WEIGHTED AIR FLUTTERED THE SILL WEEKS LAW SO MORE THIS
zlp-20100110-wwn-b0205 YOU ARE DESTROYING MY LIKES
zlp-20100110-wwn-b0206 OR SAYS AND RIFLES HAD HER CHOICE OF HIS AND TRAIL HER NURSERY
zlp-20100110-wwn-b0207 I GOOD IS IF SHE URGED
zlp-20100110-wwn-b0208 YOU READ DO YOU SHOULD HIS IN CITIES P
zlp-20100110-wwn-b0209 HE'S TERRIBLY TOUCHY A BLACK IT'S A SEEK A ALSO A USES
zlp-20100110-wwn-b0210 WHERE EVERY GUESS HE LOCKED AWAY A TOWN WHO ELM HE A
compute-wer --text --mode=present ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/text ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/one-best-hypothesis-tri3b_mmi.txt
%WER 65.96 [ 62 / 94, 13 ins, 5 del, 44 sub ]
%SER 100.00 [ 10 / 10 ]
Scored 10 sentences, 0 not present in hyp.

real    0m0.300s
user    0m0.026s
sys 0m0.013s
```

