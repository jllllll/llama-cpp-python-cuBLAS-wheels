# llama-cpp-python cuBLAS wheels
Wheels for llama-cpp-python compiled with cuBLAS support.

Currently, only includes 0.1.62 and 0.1.66.

Requirements:
- Windows and Linux x86_64
- CUDA 11.6 - 12.1
- CPython 3.7 - 3.11

Installation instructions:
---
To install, you can use this command:
```
python -m pip install llama-cpp-python==0.1.66+cu117 --find-links=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/cu117
```
This will install llama-cpp-python 0.1.66 for CUDA 11.7. You can change both instances of `cu117` to change the CUDA version.

An example for installing 0.1.62 for CUDA 12.1:
```
python -m pip install llama-cpp-python==0.1.62+cu121 --find-links=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/cu121
```
---
### All wheels are compiled using GitHub Actions
