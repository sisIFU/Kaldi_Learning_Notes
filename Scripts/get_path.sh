#!/bin/bash
#
# This script will print the cmd.sh script and store it in a document
# In cmd.sh it will specify the 

# Structure
# for every folder in egs 
# get the list of folder in egs folder
# for every folder in folder_list
# cd to that folder
# egs/example_dir/version_dir/cmd.sh

# find -name cmd.sh >> cmd_requirements.out

# cat 
# ## Don't even need this scripts
# $eDir=
#  for eDir in egs; do

#  	script=egs/$eDir/s5/cmd.sh
#     #dir=egs/$eDir/s5/path.sh
#     echo  >> ~/all_path.txt
#     $script >> ~/all_path.txt
#   done

#  for 
 list="./aishell/s5/cmd.sh
./ami/s5/cmd.sh
./ami/s5b/cmd.sh
./an4/s5/cmd.sh
./aspire/s5/cmd.sh
./aurora4/s5/cmd.sh
./babel/s5/cmd.sh
./babel/s5b/cmd.sh
./babel/s5c/cmd.sh
./babel/s5d/cmd.sh
./babel_multilang/s5/cmd.sh
./bn_music_speech/v1/cmd.sh
./callhome_egyptian/s5/cmd.sh
./chime1/s5/cmd.sh
./chime2/s5/cmd.sh
./chime3/s5/cmd.sh
./chime4/s5_1ch/cmd.sh
./chime4/s5_2ch/cmd.sh
./chime4/s5_6ch/cmd.sh
./cifar/v1/cmd.sh
./csj/s5/cmd.sh
./fame/s5/cmd.sh
./fame/v1/cmd.sh
./fame/v2/cmd.sh
./farsdat/s5/cmd.sh
./fisher_callhome_spanish/s5/cmd.sh
./fisher_english/s5/cmd.sh
./fisher_swbd/s5/cmd.sh
./gale_arabic/s5/cmd.sh
./gale_arabic/s5b/cmd.sh
./gale_mandarin/s5/cmd.sh
./gp/s5/cmd.sh
./hkust/s5/cmd.sh
./hub4_spanish/s5/cmd.sh
./iban/s5/cmd.sh
./librispeech/s5/cmd.sh
./lre/v1/cmd.sh
./lre07/v1/cmd.sh
./lre07/v2/cmd.sh
./mini_librispeech/s5/cmd.sh
./multi_en/s5/cmd.sh
./reverb/s5/cmd.sh
./rm/s5/cmd.sh
./sprakbanken/s5/cmd.sh
./sprakbanken_swe/s5/cmd.sh
./sre08/v1/cmd.sh
./sre10/v1/cmd.sh
./sre10/v2/cmd.sh
./sre16/v1/cmd.sh
./sre16/v2/cmd.sh
./svhn/v1/cmd.sh
./swahili/s5/cmd.sh
./swbd/s5/cmd.sh
./swbd/s5b/cmd.sh
./swbd/s5c/cmd.sh
./tedlium/s5/cmd.sh
./tedlium/s5_r2/cmd.sh
./tedlium/s5_r2_wsj/cmd.sh
./thchs30/s5/cmd.sh
./tidigits/s5/cmd.sh
./timit/s5/cmd.sh
./voxforge/s5/cmd.sh
./vystadial_cz/s5/cmd.sh
./vystadial_en/s5/cmd.sh
./wsj/s5/cmd.sh"

for i in $list; do
    cat $i >> list_req.txt
done