magnetization="$1" 									# Stelar sef magnetization file
c=$2														# c=1, c:0.5
Minf=$3														# Minf can be also something like "dum/1e7" 

IP=192.92.147.107												# ofe server IP

fitresults="fit-results.txt" 								# fit results file
data="cT11T12.txt"											# data for gnuplot
folder=OFE

# Linux and MacOS
#zip="zip -jq"
#unzip="unzip -joq $folder.zip -d $folder"
#open=open

# MS Windows winget install -e --id 7zip.7zip; winget install jqlang.jq:
zip="7z a"
unzip="7z e OFE.zip -oOFE"
open=explorer

rm -fr fitzip.zip folder.zip $folder/ 								# rm previous temporary zip files and folder
$zip fitzip.zip $magnetization $profile 					# creates z zip file with the magnetization and profiles sef files

curl http://$IP:8142/fit/ofe 						\
	-F "function=Mz [-2 < 2] (								\
		t [1e-5 < 20],										\
   		M0 [0 < 2],											\
		Mi=0.4 [0 < 2], 									\
		$c [0.5 < 1], 										\
		T11 [1e-3 < 0.5], 									\
		T12:0.5 [1e-1 < 3] )= 								\
		(dum<4e6) ? $Minf : 1.0\\+ 							\
		((dum<4e6) ? (1-$Minf) : -(M0-1))*c*exp(-t/T11)\\+ 	\
		((dum<4e6) ? (1-$Minf) : -(M0-1))*(1-c)*exp(-t/T12)"\
	-F "file=@fitzip.zip" 									\
	-F "logx=yes" 											\
	-F "SymbSize=0.25" 		   								\
	-F "download=zip" 		    							\
	--silent 												\
	--output $folder.zip 										# run curl and access the remote OneFit-Engine to perform the fit

$unzip 														# unzip OFE zip file with file paths removed (-j) to folder OFE 
cd $folder														# go to folder OFE
jq '."fit-results"' fitzip.json 							\
	| sed -e 's/\\n/\n/g' -e 's/"//g' 						\
	| tee $fitresults										# read fit-results fiedl from the jason file, insert newlines and remove '"' 

cat fit-results.txt 										\
	| awk -F ', '  											\
		'!/#/ && NF >0 {print 	$4, 								\
						$9,							 		\
						$10*sqrt($3),						\
						1/$11, 								\
						$12*sqrt($3)/($11*$11), 			\
						1/$13, 								\
						$14*sqrt($3)/($13*$13)}			\
		' 	> $data											# create data file for gnuplot with frequency, c, err_c, T11, err_t11, T12, and err_T12 

$open All.pdf												# open All.pdf
gnuplot -p -e "set term qt font 'Arial,12';					
	set logscale xy; 					
	plot '$data' using 1:2:3 with yerrorlines pt 2 title 'c', 	
		'$data' using 1:4:5 with yerrorlines pt 6 title 'R11', 	
		'$data' using 1:6:7 with yerrorlines pt 8 title 'R12';"	# call gnuplot to plot values of c, T11, and T12

