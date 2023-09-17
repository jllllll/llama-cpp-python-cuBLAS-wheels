All workflows are configured to accept a llama-cpp-python release tag to build a specific version of the package.  
For the most part, they are written to account for changes in every version since 0.1.62.

Primary workflows used for new llama-cpp-python releases
----
- `build-wheels.yml`
  - This workflow will build around 192 wheels for various CUDA, Python and CPU configurations. After this, it will call the `build-wheels-cpu.yml` workflow.
- `build-wheels-full-release.yml`
  - This workflow calls these workflows in order: `build-wheels.yml build-wheels-oobabooga.yml build-wheels-rocm-full.yml build-wheels-macos.yml`
  - Somewhere around 370 wheels are produced in total, last I checked. This number will likely increase as additional builds, such as MacOS Metal, are eventually included.
- `build-wheels-prioritized-release.yml`
  - This workflow is much like `build-wheels-full-release.yml`, except `build-wheels.yml` and `build-wheels-oobabooga.yml` are incorporated into the workflow instead of being called due to minor modifications.
  - This workflow is configured to build the wheels used by [text-generation-webui](https://github.com/oobabooga/text-generation-webui) first. This is because the long runtime of the workflow (currently 5 - 6 hours) was causing significant delays in updating the project.
- `build-wheels-cpu.yml`
  - This workflow builds CPU-only wheels for all of the CPU configurations supported by the other workflows.
  - It was made because the wheels in the main repo are only built to support the default configuration of `AVX2`.

~~These workflows, and their dependents, were recently optimized to significantly reduce run times from 6 hours for the longest down to around 2 hours.~~  
Workflow optimizations have been made incompatible with llama-cpp-python 0.2.X+ due to abetlen switching the build backend to one that does not support modifications of the build process.  
Copies of the optimized workflows can be found in the `old_workflows` directory.

Renamed package workflows
----
These workflows produced renamed packages under different namespaces to allow for simultaneous installation with the main package.
- `build-wheels-oobabooga*.yml`
  - This workflow builds wheels with packages renamed to `llama_cpp_python_cuda`.
  - These wheels are to allow applications to simultaneously support both CPU and CUDA builds of llama-cpp-python.
  - As the name implies, this was made for text-generation-webui.
- `build-wheels-ggml*.yml`
  - This workflow was made to produce wheels for llama-cpp-python 0.1.78 under the name of `llama_cpp_python_ggml`.
  - This allows applications to maintain support for GGML while updating to newer versions of llama-cpp-python.
  - Intended to be a temporary measure until more models are converted to GGUF.

Configuration-specific workflows
----
- `*-basic.yml`
- `*-avx.yml`

These are copies of other workflows with build matrices limited to specific configurations.  
For the most part, I made these to rebuild previous versions of llama-cpp-python as needed to support new configurations that were added to the main workflows.

Batch build workflows
----
- `build-wheels-batch-*.yml`

These workflows accept a comma-separated string of llama-cpp-python release tags.  
They then use Powershell to parse the input and construct a JSON string that is used to form a job matrix.  
Associated workflows are then called as needed to build each version.  
Only one workflow is executed at a time due to the large number of jobs that can be generated.

Experimental workflows used for more specialized builds
----
- `build-wheel-rocm.yml`
  - This workflow builds Linux and Windows wheels for AMD GPUs using ROCm.
  - Linux wheels are built using these ROCm versions: `5.4.2  5.5  5.6.1`
  - Currently considered experimental until someone with an AMD GPU can confirm if the resulting wheels work.
- `build-wheels-oobabooga-rocm.yml`
  - This workflow is much like the previous. It additionally builds `llama_cpp_python_cuda` wheels.
- `build-wheels-rocm-full.yml`
  - This workflow is essentially a combination of the previous 2.
- `build-wheels-macos.yml`
  - This workflow builds wheels with MacOS Metal support for MacOS 11, 12 and 13.
  - Builds separate wheels for Intel and Apple Silicon CPU support.
  - Is currently experimental and may not produce functional Metal wheels. I do not have a Mac to test with, so I can only go off of build logs.

Utility workflows
----
- `deploy-index.yml`
  - This workflow is for deploying the package index to GitHub Pages.
  - It is configured to run automatically when the index's html files are altered.
- `build-wheels-test.yml`
  - This workflow is entirely for testing new workflow code and is changed frequently as needed.
