username=$1
shift
IP=192.92.147.107												# ofe server IP

folder=OFE

# Linux MacOS
#zip="zip -jq"
#unzip="unzip -joq $folder.zip -d $folder"
#open=open

# MS Windows winget install -e --id 7zip.7zip; winget install jqlang.jq:
zip="7z a"
unzip="7z e $folder.zip -o$folder"
open=explorer



rm -fr fitzip.zip $folder.zip $folder/ 
$zip fitzip.zip $* 
curl http://$IP:8142/fit  		\
	-F "function=R1 [0.1 < 1000] (			\
		f [5e3 < 1e8],							\
		B=5.94e9 [1e7 < 6e9],					\
		p0 [0 < 1.0],							\
		p1 [0 < 0.2],							\
		p2 [0 < 0.2],							\
		p3 [0 < 0.2],							\
		t0 [1e-10 < 1e-9],						\
		t1 [1e-9 < 1e-8],						\
		t2 [1e-8 < 1e-7],						\
		t3 [1e-7 < 1e-5],						\
		CNH:1.5e7 [1e5 < 1e8],					\
		tQ=9.2e-7 [9e-7 < 1e-6],				\
		fm=2.1e6 [1e6 < 2.5e6],				\
		fp=2.74e6 [2e6 < 3e6],					\
		teta:1.67 [0 < 1.65],					\
		fi:1.24 [0 < 1.5708]					\
		)=									\
		BPP(f,B*p0,t0) 		\\+				\
		BPP(f,B*p1,t1)      \\+				\
		BPP(f,B*p2,t2)     	\\+				\
		BPP(f,B*p3,t3)     	\\+				\
		R1CRsp1(f,CNH,tQ,fm,fp,teta,fi)"	\
	-F "file=@fitzip.zip" 					\
	-F "logx=yes"							\
	-F "logy=yes"							\
	-F "download=zip" 						\
	-F "Num=200"							\
	-F "SymbSize=0.35"						\
	--silent 								\
	--output $folder.zip

$unzip 
cd $folder
jq '."fit-results"' fitzip.json | sed -e 's/\\n/\n/g' | sed -e 's/"//g'
$open ./
$open All.pdf
