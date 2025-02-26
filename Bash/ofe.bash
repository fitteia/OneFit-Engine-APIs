#!/usr/bin/env bash

ofe () { 
	curl -F"file=@$1" -F "function=a: one exponential" -F "logx=yes" -F "autox=yes" http://192.92.147.107:8142/fit 
}
ofe2i () { 
	curl -F"file=@$1" -F "function=$2" -F "logx=yes" -F "autox=yes" hhttp://192.92.147.107:8142/fit
}

