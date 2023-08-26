Set-Location $PSScriptRoot

$destinationDir = if (Test-Path $(Join-Path $(Resolve-Path '.') 'index')) {Join-Path '.' 'index' -resolve} else {(New-Item 'index' -ItemType 'Directory').fullname}
$destinationDir = if (Test-Path $(Join-Path $destinationDir 'textgen')) {Join-Path $destinationDir 'textgen'} else {(New-Item $(Join-Path $destinationDir 'textgen') -ItemType 'Directory').fullname}
$avxVersions = "AVX","AVX2","basic"
$cudaVersions = "11.7","11.8","12.0","12.1","12.2"
$packageVersions = "0.1.73","0.1.74","0.1.76","0.1.77","0.1.78","0.1.79"
$pythonVersions = "3.8","3.9","3.10","3.11"
$supportedSystems = 'linux_x86_64','win_amd64'
$wheelSource = 'https://github.com/jllllll/llama-cpp-python-cuBLAS-wheels/releases/download'
$packageName = 'llama_cpp_python_cuda'
$packageNameNormalized = 'llama-cpp-python-cuda'
$packageNameAlt = 'llama_cpp_python_ggml_cuda'
$packageNameAltNormalized = 'llama-cpp-python-ggml-cuda'
$packageAltVersions = @("0.1.78")

$avxVersions.foreach({Set-Variable "$_`Dir" $(if (Test-Path $(Join-Path $destinationDir $_)) {Join-Path $destinationDir $_} else {(New-Item $(Join-Path $destinationDir $_) -ItemType 'Directory').fullname})})

$indexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
Foreach ($avxVersion in $avxVersions)
{
	$wheelURL = $wheelSource.TrimEnd('/') + '/textgen-webui'
	$subIndexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
	ForEach ($cudaVersion in $cudaVersions)
	{
		$cu = $cudaVersion.replace('.','')
		$cuContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
		$cuContentAlt = "<!DOCTYPE html>`n<html>`n  <body>`n    "
		ForEach ($packageVersion in $packageVersions)
		{
			if ($avxVersion -eq 'basic' -and $packageVersion -eq '0.1.73') {continue}
			ForEach ($pythonVersion in $pythonVersions)
			{
				$pyVer = $pythonVersion.replace('.','')
				ForEach ($supportedSystem in $supportedSystems)
				{
					$wheel = if ($avxVersion -eq 'AVX') { "$packageName-$packageVersion+cu$cu$('avx')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} elseif ($avxVersion -eq 'basic') { "$packageName-$packageVersion+cu$cu$('basic')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} else {"$packageName-$packageVersion+cu$cu-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
					$wheelAlt = if ($avxVersion -eq 'AVX') { "$packageNameAlt-$packageVersion+cu$cu$('avx')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} elseif ($avxVersion -eq 'basic') { "$packageNameAlt-$packageVersion+cu$cu$('basic')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} else {"$packageNameAlt-$packageVersion+cu$cu-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
					if (!($packageVersion -eq '0.1.73' -and $avxVersion -eq 'AVX')) {$cuContent += "<a href=`"$wheelURL/$wheel`">$wheel</a><br/>`n    "}
					if ($packageVersion -in $packageAltVersions) {$cuContentAlt += "<a href=`"$wheelURL/$wheelAlt`">$wheelAlt</a><br/>`n    "}
				}
			}
			if (!($packageVersion -eq '0.1.73' -and $avxVersion -eq 'AVX')) {$cuContent += "`n    "}
			if ($packageVersion -in $packageAltVersions) {$cuContentAlt += "`n    "}
		}
		$cuDir = if (Test-Path $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "cu$cu")) {Join-Path $(Get-Variable "$avxVersion`Dir").Value "cu$cu"} else {(New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "cu$cu") -ItemType 'Directory').fullname}
		$packageDir = if (Test-Path $(Join-Path $cuDir $packageNameNormalized)) {Join-Path $cuDir $packageNameNormalized} else {(New-Item $(Join-Path $cuDir $packageNameNormalized) -ItemType 'Directory').fullname}
		$packageAltDir = if (Test-Path $(Join-Path $cuDir $packageNameAltNormalized)) {Join-Path $cuDir $packageNameAltNormalized} else {(New-Item $(Join-Path $cuDir $packageNameAltNormalized) -ItemType 'Directory').fullname}
		$subIndexContent += "<a href=`"cu$cu/`">CUDA $cudaVersion</a><br/>`n    "
		New-Item $(Join-Path $packageDir "index.html") -itemType File -value $($cuContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
		New-Item $(Join-Path $packageAltDir "index.html") -itemType File -value $($cuContentAlt.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
		New-Item $(Join-Path $cuDir "index.html") -itemType File -value $("<!DOCTYPE html>`n<html>`n  <body>`n    <a href=`"$packageNameNormalized/`">$packageName</a><br/>`n    <a href=`"$packageNameAltNormalized/`">$packageNameAlt</a>`n  </body>`n</html>`n") -force > $null
	}
	$indexContent += "<a href=`"$avxVersion/`">$avxVersion</a><br/>`n    "
	New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "index.html") -itemType File -value $($subIndexContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
}
New-Item $(Join-Path $destinationDir "index.html") -itemType File -value $($indexContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
#"<!DOCTYPE html>`n<html>`n  <head>`n    <meta http-equiv=`"refresh`" content=`"0; url='./AVX2/cu$cu'`" />`n  </head>`n  <body>`n    <a href=`"AVX2/cu$cu`">CUDA $cudaVersion</a><br/>`n  </body>`n</html>"

pause
