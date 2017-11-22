#!/bin/bash

# Author Joshua Meyer (2016)

# USAGE:
#    $ kaldi/egs/your-model/your-model-1/gmm-decode.sh
#
#    This script is meant to demonstrate how an existing GMM-HMM
#    model and its corresponding HCLG graph, build via Kaldi,
#    can be used to decode new audio files.
#    Although this script takes no command line arguments, it assumes
#    the existance of a directory (./transcriptions) and an scp file
#    within that directory (./transcriptions/wav.scp). For more on scp
#    files, consult the official Kaldi documentation.

# INPUT:
#    transcriptions/
#        wav.scp
#
#    config/
#        mfcc.conf
#
#    experiment/
#        triphones_deldel/
#            final.mdl
#
#            graph/
#                HCLG.fst
#                words.txt

# OUTPUT:
#    transcriptions/
#        feats.ark
#        feats.scp
#        delta-feats.ark
#        lattices.ark
#        one-best.tra
#        one-best-hypothesis.txt


. ./path.sh
# make sure you include the path to the gmm bin(s)
# the following two export commands are what my path.sh script contains:
# export PATH=$PWD/utils/:$PWD/../../../src/bin:$PWD/../../../tools/openfst/bin:$PWD/../../../src/fstbin/:$PWD/../../../src/gmmbin/:$PWD/../../../src/featbin/:$PWD/../../../src/lm/:$PWD/../../../src/sgmmbin/:$PWD/../../../src/fgmmbin/:$PWD/../../../src/latbin/:$PWD/../../../src/nnet2bin/:$PWD:$PATH
# export LC_ALL=C


# AUDIO --> FEATURE VECTORS
# For LDA training, you have to add one more step
compute-mfcc-feats \
    --config=offline/config/mfcc.conf \
    scp:offline/transcriptions/wav.scp \
    ark,scp:offline/transcriptions/feats.ark,offline/transcriptions/feats.scp

# COMPUTE CMVN
compute-cmvn-stats \
   --spk2utt=ark:offline/transcriptions/spk2utt \
   scp:offline/transcriptions/feats.scp \
   ark,scp:offline/transcriptions/cmvn.ark,offline/transcriptions/cmvn.scp

# SPLICE FEATS
splice-feats \
    scp:offline/transcriptions/feats.scp \
    ark:offline/decode/splice-feats.ark

# TRANSFORM-FEATS
transform-feats \
    offline/experiment/tri2b/final.mat \
    ark:offline/decode/splice-feats.ark \
    ark:offline/decode/splice-transform-feats.ark 

#GMM
gmm-latgen-faster --max-active=14000 --beam=12.0 --lattice-beam=6.0 --acoustic-scale=0.083333 --allow-partial=true \
    --word-symbol-table=offline/experiment/tri2b/graph/words.txt \
    offline/experiment/tri2b/final.mdl \
    offline/experiment/tri2b/graph/HCLG.fst \
    ark:offline/decode/splice-transform-feats.ark \
        ark,t:offline/decode/lattices.ark

# gmm-latgen-faster \
#     --word-symbol-table=offline/experiment/tri2b/graph/words.txt \
#     offline/experiment/tri2b/final.mdl \
#     offline/experiment/tri2b/graph/HCLG.fst \
#     ark:offline/transcriptions/lda-feats.ark \
#     ark,t:offline/transcriptions/lattices.ark

# LATTICE --> BEST PATH THROUGH LATTICE
lattice-best-path \
    --word-symbol-table=offline/experiment/tri2b/graph/words.txt \
    ark:offline/decode/lattices.ark \
    ark,t:offline/decode/one-best.tra

# BEST PATH INTERGERS --> BEST PATH WORDS
utils/int2sym.pl -f 2- \
    offline/experiment/tri2b/graph/words.txt \
    offline/decode/one-best.tra \
    > offline/decode/one-best-hypothesis.txt
                                                                                                       1,12          Top