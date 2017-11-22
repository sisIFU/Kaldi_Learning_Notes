#!/bin/bash
# This script print all the results and calculate the word error rate
. ./path.sh
decoderList="tri2a tri2b tri2b_mmi tri3b tri3b_mmi"
for decoder in $decoderList; do
    echo $decoder
    cat /home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/one-best-hypothesis-$decoder.txt
    compute-wer --text --mode=present ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/text ark:/home/xfu7/kaldi/egs/voxforge/s5/voxforge_offline_model/decode/one-best-hypothesis-$decoder.txt
done
