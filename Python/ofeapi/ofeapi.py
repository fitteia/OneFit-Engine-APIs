#!/usr/bin/env python3

import requests
import zipfile
import os
import json
import sys
import argparse
import shutil
from io import BytesIO
from pathlib import Path

#URL = "http://onefite-t.vps.tecnico.ulisboa.pt:8142/fit"  # Replace with the real URL
URL = "http://192.92.147.107:8142/fit"  # Replace with the real URL
FUNCTION = rf"Mz[-1.5<1.5](t,a,b,c[0.5<1],T11[0<4],T12[0<4]) = a \+ b*c*exp(-t/T11) \+ b*(1-c)*exp(-t/T12)"
PARAMS = {
    "download": "zip",
}
DOWNLOAD_FOLDER = "."

def set_URL(url):
    global URL
    URL = url

def set_FUNCTION(function):
    global FUNCTION
    FUNCTION = function

def set_PARAM(key,value):
    global PARAMS
    PARAMS[key]=value

def set_PARAMS(params):
    global PARAMS
    PARAMS=params

def set_DOWNLOAD_FOLDER(value):
    global DOWNLOAD_FOLDER
    DOWNLOAD_FOLDER = value

def fit(*args):
    file_path = args[0];
#    print(PARAMS,file_path, URL)
    try:
        if len(args)>1 and args[1]  == "-v":
            print(f"Uploading {file_path} and PARAMS = {PARAMS} to OneFit-Engine server: {URL}")
            
        with open(file_path, "rb") as file:
            files = {'file': file}  
            query = requests.post(URL, files=files, data=PARAMS)
        

        if query.status_code != 200:
            raise Exception(f"File upload failed: {query.status_code}, {query.text}")

        if len(args)>1 and args[1]  == "-v":
            print("File uploaded successfully. Downloading the onefite ZIP file...")

        content_type = query.headers.get('Content-Type', '')
        if "application/zip" not in content_type and "application/octet-stream" not in content_type:
            raise Exception(f"The query to {URL} does not contain a ZIP file.")
        
        os.makedirs(DOWNLOAD_FOLDER, exist_ok=True)  

        with zipfile.ZipFile(BytesIO(query.content)) as zip_file:
            if len(args)>1 and args[1]  == "-v":
                print(f"Extracting ZIP file to '{DOWNLOAD_FOLDER}'...")

            zip_path = zip_file.namelist();
            zip_file.extractall(DOWNLOAD_FOLDER)

        json_content = None
        if len(args)>1 and args[1]  == "-v":
            print (f"Download folder: {DOWNLOAD_FOLDER}/{zip_path[0]}")

        for root, _, files in os.walk(f"{DOWNLOAD_FOLDER}/{zip_path[0]}"):
            for file in files:
                if file.endswith(".json"):
                    json_file_path = os.path.join(root, file)
                    if len(args)>1 and args[1]  == "-v":
                        print(f"Found JSON file: {json_file_path}")

                    with open(json_file_path, "r", encoding="utf-8") as json_file:
                        json_content = json.load(json_file)  # Decode JSON
                    break  # Exit after finding the first JSON file

        tmp_folder = f"{zip_path[0]}"
        parts = tmp_folder.split("/")
        json_content["tmp_folder"]= f"{DOWNLOAD_FOLDER}/{parts[0]}"
        if json_content is None:
            raise Exception("No JSON file found in the extracted ZIP archive.")
        else:
            fit_results = json_content.get("fit-results")
#            if fit_results is not None:
#                if len(args)>1:
#                    print(fit_results)
#            else:
#                print("\nKey 'fit-results' not found in the JSON file.")

            return json_content

    except Exception as e:
        print(f"An error occurred: {e}")
        return None

def shcmd():
    parser = argparse.ArgumentParser()

    # Add arguments or options
    parser.add_argument(
        "--clean", 
        action="store_true",
        default=False,
        help="Remove dowload folder"
    )

    parser.add_argument(
        "input_file", 
        type=str, 
        help="Input file"
    )

    parser.add_argument(
        "--symbsize", 
        type=float,
        help="Symbol size"
    )

    parser.add_argument(
        "--download_folder", 
        type=str,
        default=".",
        help="Download_folder"
    )

    parser.add_argument(
        "--function", 
        type=str,
        default=FUNCTION,
        help="Fitting function"
    )

    parser.add_argument(
        "--autox", 
        action="store_true",
        default=False,
        help="autox"
    )
    parser.add_argument(
        "--autoy", 
        action="store_true",
        default=False,
        help="autoy"
    )

    parser.add_argument(
        "--logx", 
        action="store_true",
        default=False,
        help="logx"
    )

    parser.add_argument(
        "--logy", 
        action="store_true",
        default=False,
        help="logy"
    )
    
    parser.add_argument(
        "--globalfit", 
        action="store_true",
        default=False,
        help="global fit"
    )

    parser.add_argument(
        "--url", 
        type=str,
#        default=URL,
        help="OneFit-Engine URL"
    )
    parser.add_argument(
        "--verbose", 
        action="store_true",
        default=False,
        help="verbose"
    )

    parser.add_argument(
        "--json", 
        action="store_true",
        default=False,
        help="json"
    )

    # Parse the arguments and set PARAMS
    # Parse the arguments and set PARAMS
    args = parser.parse_args()

    if args.function:
        set_PARAM("function",args.function)

    if args.download_folder:
        set_DOWNLOAD_FOLDER(args.download_folder)
    
    if args.input_file.endswith(".hdf5"):
        set_PARAM("stelar-hdf5","yes")

    if args.input_file.endswith(".json"):
        del PARAMS["function"]

    if args.input_file.endswith(".sav"):
        del PARAMS["function"]

    if args.autox:
        set_PARAM("autox","yes")

    if args.autoy:
        set_PARAM("autoy","yes")
        
    if args.logx:
        set_PARAM("logx","yes")

    if args.logy:
        set_PARAM("logy","yes")

    if args.globalfit:
        set_PARAM("global","yes")

    if args.logy:
        set_PARAM("SymbSize",args.symbsize)
        
    if args.url:
        url=args.url
        set_URL(url)
        with open('ofeapi.etc', 'w') as file:
            file.write(url)
        
        print(f"set default server in ./ofeapi.etc {URL}")
#        print(URL)

    if os.path.isfile('ofeapi.etc'):
        with open('ofeapi.etc', 'r') as file:
            url=file.read()

        set_URL(url)
    else:
        with open('ofeapi.etc', 'w') as file:
            file.write(URL)

        print(f"set default server in ./ofeapi.etc: {URL}")

#    print(f"ofeapi exists {url}")
    print(f"using {URL} server set in ./ofeapi.etc")

    if args.verbose:
        verbose = "-v"
    else:
        verbose = ""

        
#### As an alternative  a static setting is possible
#
#    PARAMS = {'download': 'zip',
#              'function': rf"Mz[-1.5<1.5](t,a,b,c[0.5<1],T11[0<4],T12[0<4]) = a \+ b*c*exp(-t/T11) \+ b*(1-c)*exp(-t/T12)",
#              'autox': 'yes',
#              'logx': 'yes'
#              }
####


        
    json_file = fit(args.input_file,verbose)

    with open( Path(args.input_file).with_suffix(".json"),"w") as file:
        json.dump(json_file,file,indent=4)
   
    if args.json:
        print(json_file)

    else:
        print(json_file.get("fit-results"))

    folder = json_file.get("tmp_folder")

    if args.clean:
        shutil.rmtree(folder)
        print(f"Folder {folder} removed.")
    else:
        print(f"Folder {folder} not removed.")


if __name__ == "__main__":
    shcmd()

    
