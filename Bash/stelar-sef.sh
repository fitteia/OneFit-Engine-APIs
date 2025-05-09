rm -fr fitzip.zip OFE.zip 
zip -q fitzip.zip $1 $2 
curl http://192.92.147.107:8142/fit/ofe 					\
	-F "function=Mz[-2<2](									\
	t[1e-5<20],												\
   	M0[0<2],												\
	Mi=0.4[0<2], 											\
	c[0.5<1], 												\
	T11[1e-3<0.2], 											\
	T12:0.5[1e-1<0.5])= 									\
	(BR<4e6) ? BR/1e7 : 1.0\\+ 								\
	((BR<4e6) ? (1-BR/1e7) : -(M0-1))*c*exp(-t/T11)\\+ 		\
	((BR<4e6) ? (1-BR/1e7) : -(M0-1))*(1-c)*exp(-t/T12)"	\
	-F "file=@fitzip.zip" 									\
	-F "logx=yes" 											\
	-F "stelar-sef-Mz=yes"									\
	-F "SymbSize=0.25" 				    					\
	-F "download=zip" 				    					\
	-F "stelar-sef-R1=$2" 				    				\
	--silent 												\
	--output OFE.zip 										

rm -fr OFE 
unzip -joq OFE.zip -d OFE
cd OFE
jq '."fit-results"' fitzip.json | sed -e 's/\\n/\n/g' | sed -e 's/"//g'
open ./
open All.pdf
