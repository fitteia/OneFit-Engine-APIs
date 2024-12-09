import os
import json
import argparse
import shutil
from ofeapi import *

def main():
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
        "--function", 
        type=str,
#        default=ofeapi.FUNCTION,
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
        "--download_folder", 
        type=str,
        default=".",
        help="dowload folder"
    )
    print(ofeapi.FUNCTION)
    # Parse the arguments
    args = parser.parse_args()

    ofeapi.set_PARAMS("function",args.function)

    ofeapi.set_DOWNLOAD_FOLDER(args.download_folder)
    
    if args.input_file.endswith(".hdf5"):
        ofeapi.set_PARAMS("stelar-hdf5","yes")

    if args.autox:
        ofeapi.set_PARAMS("autox","yes")

    if args.autoy:
        ofeapi.set_PARAMS("autoy","yes")
        
    if args.logx:
        ofe.set_PARAMS("logx","yes")

    if args.logy:
        ofeapi.set_PARAMS("logy","yes")

    print(ofeapi.PARAMS)

    json_file = ofeapi.fit(args.input_file)
    folder = json_file.get("tmp_folder")

    if args.clean:
        shutil.rmtree(folder)
        print(f"Folder {folder} removed.")
    else:
        print(f"Folder {folder} not removed.")


if __name__ == "__main__":
    main()
