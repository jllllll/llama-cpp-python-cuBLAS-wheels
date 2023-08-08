# llama-cpp-python cuBLAS wheels
Wheels for [llama-cpp-python](https://github.com/abetlen/llama-cpp-python) compiled with cuBLAS support.

Requirements:
- Windows and Linux x86_64
- CUDA 11.6 - 12.2
- CPython 3.7 - 3.11

Experimental Windows ROCm build for AMD GPUs: https://github.com/jllllll/llama-cpp-python-cuBLAS-wheels/releases/tag/rocm

Installation instructions:
---
To install, you can use this command:
```
python -m pip install llama-cpp-python --prefer-binary --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
```
This will install the latest llama-cpp-python version available from here for CUDA 11.7. You can change `cu117` to change the CUDA version.  
You can also change `AVX2` to `AVX`, `AVX512` or `basic` based on what your CPU supports.  
`basic` is a build without `AVX`, `FMA` and `F16C` instructions for old or basic CPUs.  
CPU-only builds are also available by changing `cu117` to `cpu`. `basic` and `cpu` builds are currently only available for 0.1.77+.

You can install a specific version with:
```
python -m pip install llama-cpp-python==<version> --prefer-binary --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
```
An example for installing 0.1.62 for CUDA 12.1 on a CPU without AVX2 support:
```
python -m pip install llama-cpp-python==0.1.62 --prefer-binary --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX/cu121
```
List of available versions:
```
python -m pip index versions llama-cpp-python --index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
```

If you are replacing an already existing installation, you may need to uninstall that version before running the command above.  
You can also replace the existing version in one command like so:
```
python -m pip install llama-cpp-python --force-reinstall --no-deps --index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
-OR-
python -m pip install llama-cpp-python==0.1.66 --force-reinstall --no-deps --index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
-OR-
python -m pip install llama-cpp-python --prefer-binary --upgrade --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu117
```

Wheels can be manually downloaded from: https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels

---
### All wheels are compiled using GitHub Actions
