# Kaldi (or in general): How to split a long audio file into short uttrances

### Uttrance: Several sentences speaked by one person, or sometimes it can be separted by slience between sentences

## Similar Question in Kaldi-help

### 1. [Split the long audio file into utterances](https://groups.google.com/forum/#!topic/kaldi-help/jiff9IstTmg)

* Question Summary
```
Feb 9, 2017

Hello,

I'm sorry that I couldn't find the answer in this forum on my plain question.. tried to search "make utterances", "split into utterances" - no results.

I'm currently using "online2-wav-nnet2-latgen-faster" online decoder with Fisher-English recipe. I have the service that does SR as the job on MessageQueue.

Here are my issues:
currently, I don't split into utterances, so my entire long audio files are run as the 1 utterance
default sample-rate in mfcc.conf is 8000 in that recipe. I tried with 16000 but it fails (exceeded max. memory 5000000 bytes etc.) and dont recognize the full speech (only some random part of it)
it's obvious that the longer audio file, the longer it takes to recognize as single utterance (also consumes like 3-4 Gb of RAM). For example, 44min audio takes 1hour:24min
So I have several questions:
I believe, I should split into utterances and have a "wav.scp" file where (<utterance_id><path to the chunk of audio file>). How to do it properly? AFAIK, it should somewhere in /steps/cleanup.. (The worst case, I can split it manually via ffmpeg but it'll be abrupt split)
Is online-decoding actually right solution for my case? Maybe I should create the pipeline myself? Like "make mfcc" -> "decode" etc. If so, then please navigate me if you have time for that
If I could split the audio into utterances, then I believe, I could return the recognition result utterance by utterance (with API GET request), currently until the entire audio is recognized, there is no result.

Thanks for reading this question :)
```

```
Feb 13, 2017
Thanks,

I was able to re-use that Python script (~/kaldi/egs/aspire/local/multi_condition/create_uniform_segments.py) to split into uniform segments. 

But I did this thing:

I created the folder, and put there my WAV file (~ 44 min)
My service doesnt know anything about the speakers etc. So I have to create "wav.scp" and add there only 1 utterance.
$ echo "utt1 <abs-path-to-wav-file>" > wav.scp

Then this script created "segments" , "spk2utt", "utt2spk" files
Now I have 2 ways of decoding "online", and here are my concerns:
Segmented audio async output: With such as 10-sec and 0-sec overlap segments recognition I'm getting worse results. I also wanted to get the recognized text async (that was the reason of choosing segmentation), but even with this last argument in command below, I'm getting results only after the online2-wav-nnet2-latgen-faster is completed.

online2-wav-nnet2-latgen-faster --online=false \
 --do-endpointing=false -- \
 --config=/opt/kaldi/egs/fisher_english/s5/exp/nnet2_online/nnet_a_gpu_online/conf/online_nnet2_decoding.conf \
 --max-active=7000 \
 --beam=15.0 \
 --lattice-beam=6.0 \
 --acoustic-scale=0.1 \
 --word-symbol-table=/opt/kaldi/egs/fisher_english/s5/exp/tri5a/graph/words.txt \
 /opt/kaldi/egs/fisher_english/s5/exp/nnet2_online/nnet_a_gpu_online/final.mdl \
 /opt/kaldi/egs/fisher_english/s5/exp/tri5a/graph/HCLG.fst \
 ark:/tmp/wav/spk2utt \
 'ark,s,cs:extract-segments scp,p:/tmp/wav/wav.scp /tmp/wav/segments ark:- |' \
 'ark:|/opt/kaldi/src/latbin/lattice-best-path --acoustic-scale=0.1 ark:- ark,t:- | /opt/kaldi/egs/fisher_english/s5/utils/int2sym.pl -f 2-  /opt/kaldi/egs/fisher_english/s5/exp/tri5a/graph/words.txt > /tmp/kaldi_output.txt'

Unsegmented audio: 

Now with this command below (--do-endpointing=true) and with specifying the only 1 wav file -- I'm getting satisfying results, but this consumes rather big resource of RAM.

online2-wav-nnet2-latgen-faster --online=false \
 --do-endpointing=true -- \
 --config=/opt/kaldi/egs/fisher_english/s5/exp/nnet2_online/nnet_a_gpu_online/conf/online_nnet2_decoding.conf \
 --max-active=7000 \
 --beam=15.0 \
 --lattice-beam=6.0 \
 --acoustic-scale=0.1 \
 --word-symbol-table=/opt/kaldi/egs/fisher_english/s5/exp/tri5a/graph/words.txt \
 /opt/kaldi/egs/fisher_english/s5/exp/nnet2_online/nnet_a_gpu_online/final.mdl \
 /opt/kaldi/egs/fisher_english/s5/exp/tri5a/graph/HCLG.fst \
  'ark:echo utterance-id1 utterance-id1|' \
  'scp:echo utterance-id1 /tmp/audio_file.wav|' \
 'ark:|/opt/kaldi/src/latbin/lattice-best-path --acoustic-scale=0.1 ark:- ark,t:- | /opt/kaldi/egs/fisher_english/s5/utils/int2sym.pl -f 2-  /opt/kaldi/egs/fisher_english/s5/exp/tri5a/graph/words.txt > /tmp/kaldi_output.txt'


Question: So for my application, should I actually use online-decoding with segmented audio in 1st option above? (There is no necessity to have async recognized text, I just want to free up RAM in that way to have at least 3 jobs for ASR)

Thanks,
Sabr
```

* Suggested Solutions

```
Feb 9, 2017
You can use the approach used in Aspire to create uniform segments and decode them.

https://github.com/kaldi-asr/kaldi/blob/master/egs/aspire/s5/local/multi_condition/prep_test_aspire.sh

kaldi/egs/aspire/s5/local/multi_condition/create_uniform_segments.py

Vimal
```

```
Feb 9, 2017
BTW, you can't mix-and-match the sampling rates.  If your data is sampled at 16kHz but the system is built for 8kHz then you should use sox or a similar tool to downsample your data.
Dan

```


### 2.[Re: [kaldi-help] create a corpus from not aligned audio and text](https://groups.google.com/forum/#!starred/kaldi-help/7i0K0g8vT_E)

* Question Summary

```
Jun 21, 2017
Hello,

I am starting to work with Kaldi on my project which will treat on ASR.
I would like to prepare a speech corpus based on initially not aligned audio and transcriptions - something conceptually similar to what has been done for LibriSpeech.

As the initial training data, I would like to use an existing corpus.
I have some audio split into short fragments and a full text (containing all utterances from audio files combined together).
I would like to obtain ASR hypotheses and try to align them with the original transcription to get audio-text alignment.

What is the best approach to obtain the ASR hypotheses for these audio files?
Should I use the offline decoding and obtain the hypotheses from the log files?
If so, what should I put into transcriptions (text) file when preparing test data? (I do not have exact transcriptions yet, but in the beginning I don't care about the WER score, I only want the hypotheses).

My final goal is to semi-automatically prepare a new speech corpus.

Best regards,
Artur Zygadlo
```

```
Dec 1, 2017

Hello Dan,

Thank you for your answer, I am coming back to this topic which I had to postpone for some months.

I will check the solution you suggested. However, I had another approach in mind and would like to ask for your opinion on it.

Assuming I use an existing acoustic model and generate an n-gram LM from the given text only:
1. splitting the audio on silence into short utterances first (instead of running ASR on the whole long audio files and aligning text to them as you did for LibriSpeech)
2. obtaining ASR hypotheses for the short utterances and taking them as initial approximate transcriptions
3. running Smith-Waterman algorithm for local sequence alignment to improve the quality of transcriptions for cases with errors "in the middle" (e.g. if the original text says "A B C D E" and I get "A B F G E" I am able to make it correct with S-W algorithm)
4. creating the transcriptions from the obtained word sequences, including for example (and excluding cases which are obviously wrong):
- those cases where a hypothesis and the sequence is an exact match
- those cases where their beginning and end of hyp and sequence are the same but have been improved in step 3
6. trying to improve the quality of all other cases in next iterations of ASR (by iteratively extending the training set with the data obtained in the previous step)

I tried this approach and I got surprisingly good results in the first iteration even for the simplest trainings (mono, tri1).

Do you think such approach is worse than the one that uses alignment to long audio files?

Artu
```
* Suggested Solutions

```
There is a solution for this.  Vimal finished it recently.

It's the script local/cleanup/segment_long_utterances.sh which works out the alignment of long transcripts to long unsegmented audio.
You then follow up by steps/cleanup/clean_and_segment_data.sh to remove any bits where the transcript is not high enough quality.

There is an example in the WSJ setup, as local/run_segmentation_long_utts.sh.

If your audio is already split into short segments and you have the text as one long piece,  then it may be best to use the 7-argument form of segment_long_utterances.sh, where you provide the text as one "text" file that has the long transcripts one per line, and an "utt2text" file that maps your shorter audio segments to the long-transcript which is belongs to.  It's OK if there is just one long-transcript.  And it's OK if it's extremely long.  This algorithm is designed to be efficient in that case.

This script has not beeen used very much so there may still be bugs.  Let us know and we'll fix them promptly.

Dan
```

```bash
kaldi/egs/wsj/s5/local/run_segmentation_long_utts.sh
```

### 3. [Truncating long utterance to short utterances and extracting MFCC features](https://groups.google.com/forum/#!starred/kaldi-help/EmQ21SNxKDQ)
* Question Summary

```
Hello Dan,

I'm looking to truncate long wav file to fixed 10sec segment and extract MFCC features. Could you please advise me how we can do that?


Many thanks and best regards,
K.Ahilan


    

11/21/15


Dear Vijay,

Thanks a lot. 

Can we also able to do using this command extract-segments?                                                                                                                      

 extract-segments call-861225-A-0050-0065 call-861225-A 0.0 10.0  
                                                                                  
""                                                  
Extract segments from a large audio file in WAV format.                                                                               
Usage:  extract-segments [options] <wav-rspecifier> <segments-file> <wav-wspecifier>                                                  
e.g. extract-segments scp:wav.scp segments ark:- | <some-other-program>                                                               
 segments-file format: each line is either                                                                                            
<segment-id> <recording-id> <start-time> <end-time>                                                                                   
e.g. call-861225-A-0050-0065 call-861225-A 5.0 6.5                                                                                    
or (less frequently, and not supported in scripts):                                                                                   
<segment-id> <wav-file-name> <start-time> <end-time> <channel>                                                                        
where <channel> will normally be 0 (left) or 1 (right)                                                                                
e.g. call-861225-A-0050-0065 call-861225 5.0 6.5 1                                                                                    
And <end-time> of -1 means the segment runs till the end of the WAV file                                                              
See also: extract-rows, which does the same thing but to feature files,                                                               
 wav-copy, wav-to-duration 
""

I look forward to hearing from you.


Hi Vijay

Is the segments file created manually? In my case, I do not know this and the only input is the source audio file. In that case, can I use the script to generate fixed length segments from my long audio file and then generate MFCC on them
```
* Suggested Solutions

```
11/21/15


You could create a segments file in your data directory and then use steps/make_mfcc.sh command on that data directory.

You can look at line for an example.
 
--Vijay

That's what that script is supposed to do (hence the 'uniform' part).
Perhaps what you want is a script that will do speech/nonspeech segmentation.
If you have a transcript, there is a script in steps/cleanup/split_long_utterance.sh that can segment a long utterance into smaller pieces.  If not - then we don't have a script currently that does what you want.  Typically if we need this we'd decode using a small model and then figure out the segmentation from the decoding output.  Eventually we will add scripts to do this.
Dan


I think create_uniform_segments.py should still be applicable here-- try it.
Dans
```

