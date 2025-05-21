magnetization="$1m.sef" 									# Stelar sef magnetization file
profile="$1p.sef"											# Stelar sef profile file
fitresults="fit-results.txt" 								# fit results file
data="cT11T12.txt"											# data for gnuplot
c=$2														# c=1, c:0.5


rm -fr fitzip.zip OFE.zip OFE/ 								# rm previous temporary zip files and folder
zip -q fitzip.zip $magnetization $profile 					# creates z zip file with the magnetization and profiles sef files
curl http://192.168.64.40:8142/fit/ofe 						\
	-F "function=Mz[-2<2](									\
		t[1e-5<20],											\
   		M0[0<2],											\
		Mi=0.4[0<2], 										\
		$c[0.5<1], 											\
		T11[1e-3<0.2], 										\
		T12:0.5[1e-1<0.5])= 								\
		(BR<4e6) ? BR/1e7 : 1.0\\+ 							\
		((BR<4e6) ? (1-BR/1e7) : -(M0-1))*c*exp(-t/T11)\\+ 	\
		((BR<4e6) ? (1-BR/1e7) : -(M0-1))*(1-c)*exp(-t/T12)"\
	-F "file=@fitzip.zip" 									\
	-F "logx=yes" 											\
	-F "stelar-sef-Mz=yes"									\
	-F "SymbSize=0.25" 		   								\
	-F "download=zip" 		    							\
	-F "stelar-sef-R1=$profile" 		    				\
	--silent 												\
	--output OFE.zip 										# run curl and access the remote OneFit-Engine to perform the fit

unzip -joq OFE.zip -d OFE									# unzip OFE zip file with file paths removed (-j) to folder OFE 
cd OFE														# go to folder OFE
jq '."fit-results"' fitzip.json 							\
	| sed -e 's/\\n/\n/g' -e 's/"//g' 						\
	| tee $fitresults										# read fit-results fiedl from the jason file, insert newlines and remove '"' 

cat fit-results.txt 										\
	| awk -F ', '  											\
		-v p=$1 											\
		-v n=28 											\
		'/^p/ {print 	$4, 								\
						$9,							 		\
						$10*sqrt($3/n),						\
						1/$11, 								\
						$12*sqrt($3/n)/($11*$11), 			\
						1/$13, 								\
						$14*sqrt($3/n)/($13*$13)}			\
		' 	> $data											# create data file for gnuplot with frequency, c, err_c, T11, err_t11, T12, and err_T12 

open All.pdf												# open All.pdf
gnuplot -p -e "set term qt font 'Arial,12';					
	set logscale xy; 					
	plot '$data' using 1:2:3 with yerrorlines title 'c', 	
		'$data' using 1:4:5 with yerrorlines title 'T1', 	
		'$data' using 1:6:7 with yerrorlines title 'T12';"	# call gnuplot to plot values of c, T11, and T12


#open ./
#gnuplot -p -e 'set terminal pdfcairo; set output "lixo.pdf";
#	set logscale xy; 
#	plot "lixo.txt" using 1:2:3 with yerrorlines, 
#		"lixo.txt" using 1:4:5 with yerrorlines, 
#		"lixo.txt" using 1:6:7 with yerrorlines;'
#open lixo.pdf
