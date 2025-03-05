# examples for functions to help repeating fit procedures

ofe-list () { 
	if [ -n "$1" ]; then
      		curl http://192.92.147.107:8142/list/$1 
	else
      		curl http://192.92.147.107:8142/list 
	fi  
}

ofe-help () { 
	if [ -n "$2" ]; then
      		curl http://192.92.147.107:8142/help/$1/$2 
	elif [ -n "$1" ]; then
      		curl http://192.92.147.107:8142/help/$1 
	else
      		curl http://192.92.147.107:8142/help 
	fi  
}

fit () { 
	if [ -n "$3" ]; then 
		curl -F "file=@$1" -F "function=$2" -F "logx=no" -F "autox=no" -F "autoy=no"  -F "download=$3" http://192.92.147.107:8142/fit
	else
		curl -F "file=@$1" -F "function=$2" -F "logx=no" -F "autox=no" -F "autoy=no"  http://192.92.147.107:8142/fit
	fi
}

fit-logx () { 
	if [ -n "$3" ]; then 
		curl -F "file=@$1" -F "function=$2" -F "logx=yes" -F "autox=no" -F "autoy=no"  -F "download=$3" http://192.92.147.107:8142/fit
	else
		curl -F "file=@$1" -F "function=$2" -F "logx=yes" -F "autox=no" -F "autoy=no"  http://192.92.147.107:8142/fit
	fi
}
 
fit-exp-logx () { 
	if [ -n "$2" ]; then 
		curl -F "file=@$1" -F "function=a: one exponential" -F "logx=yes" -F "autox=no" -F "autoy=no"  -F "download=$2" http://192.92.147.107:8142/fit 
	else 
		curl -F "file=@$1" -F "function=a: one exponential" -F "logx=yes" -F "autox=no" -F "autoy=no"  http://192.92.147.107:8142/fit 
	fi
}

afit () { 
	if [ -n "$3" ]; then 
		curl -F "file=@$1" -F "function=$2" -F "logx=no" -F "autox=yes" -F "autoy=yes"  -F "download=$3" http://192.92.147.107:8142/fit
	else
		curl -F "file=@$1" -F "function=$2" -F "logx=no" -F "autox=yes" -F "autoy=yes"  http://192.92.147.107:8142/fit
	fi
}

afit-logx () { 
	if [ -n "$3" ]; then 
		curl -F "file=@$1" -F "function=$2" -F "logx=yes" -F "autox=yes" -F "autoy=yes"  -F "download=$3" http://192.92.147.107:8142/fit
	else
		curl -F "file=@$1" -F "function=$2" -F "logx=yes" -F "autox=yes" -F "autoy=yes"  http://192.92.147.107:8142/fit
	fi
}
 
afit-exp-logx () { 
	if [ -n "$2" ]; then 
		curl -F "file=@$1" -F "function=a: one exponential" -F "logx=yes" -F "autox=yes" -F "autoy=yes"  -F "download=$2" http://192.92.147.107:8142/fit 
	else 
		curl -F "file=@$1" -F "function=a: one exponential" -F "logx=yes" -F "autox=yes" -F "autoy=yes"  http://192.92.147.107:8142/fit 
	fi
}

