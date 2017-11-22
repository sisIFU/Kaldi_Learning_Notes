# Progress and Output of Running Voxforge

Markdown Languages support in Github: https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
[Languages Supported by Github Flavored Markdown](http://www.rubycoloredglasses.com/2013/04/languages-supported-by-github-flavored-markdown/)


## Error Report 1

### Error 1: SRILM tools not installed
In step: Prepare ARPA LM and vocabulary using SRILM
=== Building a language model ...
--- Preparing a corpus from test and train transcripts ...

You appear to not have SRILM tools installed, either on your path,
or installed in /home/xfu7/kaldi/egs/voxforge/s5/../../../tools/srilm/bin/i686-m64. See tools/install_srilm.sh for installation
instructions.

```bash
[xfu7@lin-res30 tools]$ ./install_srilm.sh
This script cannot install SRILM in a completely automatic
way because you need to put your address in a download form.
Please download SRILM from http://www.speech.sri.com/projects/srilm/download.html
put it in ./srilm.tgz, then run this script.
```

### My solution
* Go to the website: http://www.speech.sri.com/projects/srilm/
* Signup and download to my macbook, then scp the file to the RHEL server.
* vim install_srilm.sh
* Change srilm.tgz to srilm.tar.gz of two places: LINE 17 and LINE 30
* Run ./install_srilm.sh again
* Installation of SRILM finished successfully
* Please source the tools/env.sh in your path.sh to enable it

### Error 2: The Sequitur was not found (Issue with Python3)
```bash
utils/make_absolute.sh: line 7: cd: /home/xfu7/kaldi/egs/voxforge/s5/../../../tools/sequitur/lib/python*: No such file or directory

The Sequitur was not found !
Go to /home/xfu7/kaldi/egs/voxforge/s5/../../../tools and execute extras/install_sequitur.sh
```


### Suggested solution
* Go to /home/xfu7/kaldi/egs/voxforge/s5/../../../tools and execute extras/install_sequitur.sh
```bash
[xfu7@lin-res30 tools]$ extras/install_sequitur.sh
Cloning into 'sequitur-g2p'...
remote: Counting objects: 80, done.
remote: Total 80 (delta 0), reused 0 (delta 0), pack-reused 80
Unpacking objects: 100% (80/80), done.
python setup.py build
Traceback (most recent call last):
  File "setup.py", line 29, in <module>
    import numpy
ImportError: No module named numpy
make: *** [build] Error 1
```

### Dependencies for sequitur-g2p
v Python (http://www.python.org)
  tested with 2.5
- SWIG (http://www.swig.org)
  tested with 1.3.31
- NumPy (http://numpy.scipy.org)
  tested with 1.0.4
v a C++ compiler that's recognized by Python's distutils.
  tested with GCC 4.1, 4.2 and 4.3
To install change to the source directory and type:
    python setup.py install --prefix /usr/local
You may substitue /usr/local with some other directory.  If you do so
make sure that some-other-directory/lib/python2.5/site-packages/ is in
your PYTHONPATH, e.g. by typing
    export PYTHONPATH=some-other-directory/lib/python2.5/site-packages

* Install numpy

```bash
sudo yum install python-numpy #install NumPy
sudo yum install swig.i386 #install SWIG
```

Installation of SEQUITUR finished successfully
Please source tools/env.sh in your path.sh to enable it

# Runing gmm-decode.sh on Voxforge Dataset

Error Message
```
ERROR (gmm-latgen-faster[5.2.160~1-51042]:LogLikelihoodZeroBased():decodable-am-diag-gmm.cc:50) Dim mismatch: data dim = 39 vs. model dim = 40

[ Stack-Trace: ]
gmm-latgen-faster() [0xb0adcc]
kaldi::MessageLogger::HandleMessage(kaldi::LogMessageEnvelope const&, char const*)
kaldi::MessageLogger::~MessageLogger()
kaldi::DecodableAmDiagGmmUnmapped::LogLikelihoodZeroBased(int, int)
kaldi::DecodableAmDiagGmmScaled::LogLikelihood(int, int)
kaldi::LatticeFasterDecoder::ProcessEmitting(kaldi::DecodableInterface*)
kaldi::LatticeFasterDecoder::Decode(kaldi::DecodableInterface*)
kaldi::DecodeUtteranceLatticeFaster(kaldi::LatticeFasterDecoder&, kaldi::DecodableInterface&, kaldi::TransitionModel const&, fst::SymbolTable const*, std::string, double, bool, bool, kaldi::TableWriter<kaldi::BasicVectorHolder<int> >*, kaldi::TableWriter<kaldi::BasicVectorHolder<int> >*, kaldi::TableWriter<kaldi::CompactLatticeHolder>*, kaldi::TableWriter<kaldi::LatticeHolder>*, double*)
main
__libc_start_main
gmm-latgen-faster() [0x891c09]

WARNING (gmm-latgen-faster[5.2.160~1-51042]:~HashList():util/hash-list-inl.h:117) Possible memory leak: 1023 != 1024: you might have forgotten to call Delete on some Elems
lattice-best-path --word-symbol-table=voxforge_offline/experiment/tri2b/graph/words.txt ark:voxforge_offline/transcriptions/lattices.ark ark,t:voxforge_offline/transcriptions/one-best.tra
LOG (lattice-best-path[5.2.160~1-51042]:main():lattice-best-path.cc:124) Overall cost per frame is -nan = -nan [graph] + -nan [acoustic] over 0 frames.
LOG (lattice-best-path[5.2.160~1-51042]:main():lattice-best-path.cc:128) Done 0 lattices, failed for 0
```

In run_with_time.sh
```
if [ $stage -le 5 ]; then
  # train and decode tri2b [LDA+MLLT]
  time steps/train_lda_mllt.sh --cmd "$train_cmd" 2000 11000 \
    data/train data/lang exp/tri1_ali exp/tri2b || exit 1;
  time utils/mkgraph.sh data/lang_test exp/tri2b exp/tri2b/graph
  time steps/decode.sh --config conf/decode.config --nj $njobs --cmd "$decode_cmd" \
    exp/tri2b/graph data/test exp/tri2b/decode
```

I searched online and find [the post](https://sourceforge.net/p/kaldi/discussion/1355348/thread/028ffd7f/) has the similar problem like me:

* I want to set up a project using my own audio files and language model, but keeping the acoustic model from Tedlium project.
First two decodings have completed successfully (mono and tri1), but I get this error when I try to run tri2 and tri3

* Here is Dan's answer:
since the data dim is 39 and the model dim is 40, I think it's
most likely that he is using delta+accel features but the model expected
LDA+MLLT features.
Lucian, have a look at the decoding command line that was used when you
decoded your original data where you trained the model. Most likely it
will have a splicing step (splice-feats) followed by a projection step
(transform-feats)- you should try to replicate that when you decode.
If you are using a decoding script, it will automatically pick up the
LDA+MLLT features if you copy the final.mat to the directory where your
final.mdl exists. Also make sure to copy splice_opts and cmvn_opts to that
directory.

* What I am missing?
splicing step (splice-feats)
projection step (transform-feats)

### In steps/decode.sh:
``` 
if [ -f $srcdir/final.mat ]; then feat_type=lda; else feat_type=delta; fi
echo "decode.sh: feature type is $feat_type";

case $feat_type in
  delta) feats="ark,s,cs:apply-cmvn $cmvn_opts --utt2spk=ark:$sdata/JOB/utt2spk scp:$sdata/JOB/cmvn.scp scp:$sdata/JOB/feats.scp ark:- | add-deltas $delta_opts ark:- ark:- |";;
  lda) feats="ark,s,cs:apply-cmvn $cmvn_opts --utt2spk=ark:$sdata/JOB/utt2spk scp:$sdata/JOB/cmvn.scp scp:$sdata/JOB/feats.scp ark:- | splice-feats $splice_opts ark:- ark:- | transform-feats $srcdir/final.mat ark:- ark:- |";;

 transform-feats [options] (<transform-rspecifier>|<transform-rxfilename>) <feats-rspecifier> <feats-wspecifier>
See also: transform-vec, copy-feats, compose-transforms
```

We have a TODO to create a page to answer this type of question. 
In general you have to go through the same sequence of steps that were 
used when preparing for the regular decoding process, except (if a 
single file) you'd probably want to use commands adapted from the 
commands in the logs. 

 It would go something like: 
 - create mfcc features 
 - create cmvn stats for that file 
 - decode the file 
However, it's a bit hard if you don't have a good understanding of how 
Kaldi works. 
