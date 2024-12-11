import sys
import json
from ofeapi import ofeapi

if __name__ == "__main__":
    ofeapi.shcmd()


    ofeapi.PARAMS = {'download': 'zip',
                     'function': rf"Mz[-1.5<1.5](t,a,b,c[0.5<1],T11[0<4],T12[0<4]) = a \+ b*c*exp(-t/T11) \+ b*(1-c)*exp(-t/T12)",
                     'autox': 'yes',
                     'logx': 'yes'
                     }

    print(f"\nUploading {sys.argv[1]}  and PARAMS: {ofeapi.PARAMS} to OneFit-Engine server {ofeapi.URL}\n")
    json_file = ofeapi.fit(sys.argv[1])
    print(json.dumps(json_file,indent=4))
    print(json_file.get("fit-results"))


