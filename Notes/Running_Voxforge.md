# Progress and Output of Running Voxforge

Markdown Languages support in Github: https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
[Languages Supported by Github Flavored Markdown](http://www.rubycoloredglasses.com/2013/04/languages-supported-by-github-flavored-markdown/)


## Error Report
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