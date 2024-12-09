OneFit-Engine python API CLI

This is a Python module to create command line interfaces to the OneFit-Engine server.

install:

python3 -m venv ~/.venv
source ~/.venv/bin/activate
python3 -m pip install .

(Windows PowerShell run: ~/.venv/bin/Activate.ps1)

upgrades:

python3 -m pip install --upgrade .

Usage:

python3 ofe/main.py

Help:

python3
>>> import ofe
>>> help(ofe)
>>> exit
