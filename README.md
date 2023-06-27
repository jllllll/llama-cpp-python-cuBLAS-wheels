# llama-cpp-python cuBLAS wheels
Wheels for [llama-cpp-python](https://github.com/abetlen/llama-cpp-python) compiled with cuBLAS support.

Currently, only includes 0.1.62 and 0.1.66.

Requirements:
- Windows and Linux x86_64
- CPU with support for AVX, AVX2 or AVX512
- CUDA 11.6 - 12.1
- CPython 3.7 - 3.11

Installation instructions:
---
To install, you can use this command:
```
python -m pip install llama-cpp-python==0.1.66+cu177 --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
```
This will install llama-cpp-python 0.1.66 for CUDA 11.7. You can change both instances of `cu117` to change the CUDA version.  
You can also change `AVX2` to `AVX` or `AVX512` based on what your CPU supports.

An example for installing 0.1.62 for CUDA 12.1 on a CPU without AVX2 support:
```
python -m pip install llama-cpp-python==0.1.62+cu121 --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX/cu121
```

If you are replacing an already existing installation, you may need to uninstall that version before running the command above.  
You can also replace the existing version in one command like so:
```
python -m pip install llama-cpp-python --force-reinstall --no-deps --index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
-OR-
python -m pip install llama-cpp-python==0.1.66 --force-reinstall --no-deps --index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
```
Using `--index-url` and `--no-deps`, you do not need to specify the additional `+cu177` in the version number.

---
### All wheels are compiled using GitHub Actions
