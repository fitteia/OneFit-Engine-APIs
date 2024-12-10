from setuptools import setup, find_packages

setup(
    name="ofeapi",
    version="0.8.0",
    description="A Pyhton module API to use OFE.",
    packages=find_packages(),  
    install_requires=["requests"],
)
