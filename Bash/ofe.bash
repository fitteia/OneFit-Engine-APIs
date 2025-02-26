#!/usr/bin/env bash

fit () { 
	curl -F"file=@$1" -F "function=$2" "logx=no" -F "autox=yes" -F "autoy=yes" http://192.92.147.107:8142/fit
}

fit-logx () { 
	curl -F"file=@$1" -F "function=$2" -F "logx=yes" -F "autox=yes" -F "autoy=yes" http://192.92.147.107:8142/fit
}

fit-exp-logx () { 
	curl -F"file=@$1" -F "function=a: one exponential" -F "logx=yes" -F "autox=yes" -F "autoy=yes" http://192.92.147.107:8142/fit 
}


