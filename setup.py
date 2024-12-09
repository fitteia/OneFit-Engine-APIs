from setuptools import setup, find_packages

setup(
    name="ofe",
    version="0.02.03",
    description="A Python module to use OFE.",
    packages=find_packages(),  
    install_requires=["requests"],
)
