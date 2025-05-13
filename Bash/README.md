Use:

host-prompt> source ofe.sh

or

host-prompt> source ofe-named-options.sh

remote-prompt> bash stelar-sef.sh Mz.sef R1.sef

or

remte-prompt> fit() { bash stelar-sef.sh $1.msef $1.psef; }
remote-prompt fit <file-prefix>

To fit a data file with an exponential
host-prompt> fit-exp-logx <datafile>  

