from setuptools import setup, find_packages

setup(
    name="ofeapi",
    version="0.9.2",
    description="A Pyhton module CLI API to fit data using OneFit-Engine (ofe)",
    packages=find_packages(),  
    install_requires=["requests"],
)
