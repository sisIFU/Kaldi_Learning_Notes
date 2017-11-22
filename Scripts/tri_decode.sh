#!/bin/bash

# Author Joshua Meyer (2016)
#        Xiaoting Fu (2017)
# Data Preparation:
# See voxforge_offline_model/experiment/cp_files.sh
# This script use existing models trained with voxforge dataset and select the best hypothesis
# Then it can also score the result provided there is a reference text
# Normally, if you are tested using the dataset, the reference can be found on:
# kaldi/egs/voxforge/s5/data/train/text
# USAGE:
#
#    $ kaldi/egs/voxforge/s5/tri_decode.sh
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
#    decode/
#        feats.ark
#        feats.scp
#        delta-feats.ark
#        lattices.ark
#        one-best-$decoder.tra
#        one-best-hypothesis-$decoder.txt

#decoder="tri2a"
model="voxforge_offline_model"
. ./path.sh
# make sure you include the path to the gmm bin(s)
# the following two export commands are what my path.sh script contains:
# export PATH=$PWD/utils/:$PWD/../../../src/bin:$PWD/../../../tools/openfst/bin:$PWD/../../../src/fstbin/:$PWD/../../../src/gmmbin/:$PWD/../../../src/featbin/:$PWD/../../../src/lm/:$PWD/../../../src/sgmmbin/:$PWD/../../../src/fgmmbin/:$PWD/../../../src/latbin/:$PWD/../../../src/nnet2bin/:$PWD:$PATH
# export LC_ALL=C
decoderList="tri2a tri2b tri2b_mmi tri3b tri3b_mmi"

for decoder in $decoderList; do
    echo ============================================================
    echo                    "compute-mfcc-feats"
    echo ============================================================
    compute-mfcc-feats \
        --config=$model/config/mfcc.conf \
        scp:$model/transcriptions/wav.scp \
        ark,scp:$model/transcriptions/feats.ark,$model/transcriptions/feats.scp

    if [ $decoder != "tri2a" ]; then
        echo ============================================================
        echo  "decode "$decoder
        echo ============================================================
        # COMPUTE CMVN
        compute-cmvn-stats \
           --spk2utt=ark:$model/transcriptions/spk2utt \
           scp:$model/transcriptions/feats.scp \
           ark,scp:$model/transcriptions/cmvn.ark,$model/transcriptions/cmvn.scp
        # SPLICE FEATS
        splice-feats \
            scp:$model/transcriptions/feats.scp \
            ark:$model/decode/splice-feats.ark   
        # TRANSFORM-FEATS
        transform-feats \
            $model/experiment/$decoder/final.mat \
            ark:$model/decode/splice-feats.ark \
            ark:$model/decode/splice-transform-feats.ark
        #GMM
        gmm-latgen-faster --max-active=14000 --beam=12.0 --lattice-beam=6.0 --acoustic-scale=0.083333 --allow-partial=true \
            --word-symbol-table=$model/experiment/$decoder/graph/words.txt \
            $model/experiment/$decoder/final.mdl \
            $model/experiment/$decoder/graph/HCLG.fst \
            ark:$model/decode/splice-transform-feats.ark \
                ark,t:$model/decode/lattices.ark
    elif [ $decoder == "tri2a" ]; then
        echo ============================================================
        echo  "decode "$decoder
        echo ============================================================
        add-deltas \
        scp:$model/transcriptions/feats.scp \
        ark:$model/decode/delta-feats.ark

        #GMM
        gmm-latgen-faster \
            --word-symbol-table=$model/experiment/$decoder/graph/words.txt \
            $model/experiment/$decoder/final.mdl \
            $model/experiment/$decoder/graph/HCLG.fst \
            ark:$model/decode/delta-feats.ark \
            ark,t:$model/decode/lattices.ark
    fi

    # LATTICE --> BEST PATH THROUGH LATTICE
    lattice-best-path \
        --word-symbol-table=$model/experiment/$decoder/graph/words.txt \
        ark:$model/decode/lattices.ark \
        ark,t:$model/decode/one-best-$decoder.tra

    # BEST PATH INTERGERS --> BEST PATH WORDS
    utils/int2sym.pl -f 2- \
        $model/experiment/$decoder/graph/words.txt \
        $model/decode/one-best-$decoder.tra \
        > $model/decode/one-best-hypothesis-$decoder.txt
done