Set-Location $PSScriptRoot

$destinationDir = if (Test-Path $(Join-Path $(Resolve-Path '.') 'docs')) {Join-Path '.' 'docs' -resolve} else {(New-Item 'docs' -ItemType 'Directory').fullname}
$cudaVersions = "11.6","11.7","11.8","12.0","12.1"
$packageVersions = "0.1.62","0.1.66"
$pythonVersions = "3.7","3.8","3.9","3.10","3.11"
$supportedSystems = 'linux_x86_64','win_amd64'
$wheelSource = 'https://github.com/jllllll/llama-cpp-python-cuBLAS-wheels/releases/download/wheels'
$indexName = 'index'


$indexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
$wheelSource = $wheelSource.TrimEnd('/')
ForEach ($cudaVersion in $cudaVersions)
{
	$cu = $cudaVersion.replace('.','')
	$cuContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
	ForEach ($packageVersion in $packageVersions)
	{
		ForEach ($pythonVersion in $pythonVersions)
		{
			$pyVer = $pythonVersion.replace('.','')
			ForEach ($supportedSystem in $supportedSystems)
			{
				$wheel = if ($pyVer -eq '37') {"llama_cpp_python-$packageVersion+cu$cu-cp$pyVer-cp$pyVer`m-$supportedSystem.whl"} else {"llama_cpp_python-$packageVersion+cu$cu-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
				$cuContent += "<a href=`"$wheelSource/$wheel`">$wheel</a><br/>`n    "
			}
		}
		$cuContent += "`n    "
	}
	$indexContent += "<a href=`"cu$cu`">CUDA $cudaVersion</a><br/>`n    "
	$cuContent.TrimEnd() + "`n  </body>`n</html>" > $(Join-Path $destinationDir "cu$cu.html")
}
$indexContent.TrimEnd() + "`n  </body>`n</html>" > $(Join-Path $destinationDir "$indexName.html")

pause
