#
# For windows hosts
#
winget install -e --id Git.Git
winget install -e --id jqlang.jq 
winget install -e --id cURL.cURL
winget install -e --id 7zip.7zip
winget install -e --id gnuplot.gnuplot
winget install -e --id Oracle.VirtualBox

https://www.debian.org/distrib/netinst (download amd64 or amr64 or ...)


#
# In the Host ou Guest systems
#

git clone https://github.com/fitteia/OneFit-Engine-APIs.git

curl http://192.92.147.107:8142/fit -F "file=@linear.txt" -F "function=y[-3<3](x[-10<10],a,b,c)=a\+b*x\+c*x*x" -F "download=All.pdf" --silent --output All.pdf && explorer All.pdf

fit() { curl http://192.168.64.40:8142/fit -F "file=@$1" -F "function=$2" -F "download=All.pdf" --silent --output All.pdf && explorer All.pdf; }

fit linear.txt "y[-3<3](x[-10<10],a,b,c)=a\+b*x\+c*x*x"

curl http://192.92.147.107:8142/fit/gul -F "file=@p96m.sav" -F "download=zip" -F "logx=yes" --silent --output OFE.zip

bash ../nmrd.sh gul p96p.sef

bash ../sdf.sh gul c12_60.sdf c:0.6 dum/1e7

bash ../stelar-sef.sh gul p96 c:0.6 dum/1e7

