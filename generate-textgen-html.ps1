Set-Location $PSScriptRoot

$destinationDir = if (Test-Path $(Join-Path $(Resolve-Path '.') 'index')) {Join-Path '.' 'index' -resolve} else {(New-Item 'index' -ItemType 'Directory').fullname}
$destinationDir = if (Test-Path $(Join-Path $destinationDir 'textgen')) {Join-Path $destinationDir 'textgen'} else {(New-Item $(Join-Path $destinationDir 'textgen') -ItemType 'Directory').fullname}
$avxVersions = "AVX","AVX2","basic"
$cudaVersions = "11.7","11.8","12.0","12.1","12.2","rocm5.4.2","rocm5.5","rocm5.5.1","rocm5.6.1"
$packageVersions = (73..74+76..85).foreach({"$_".Insert(0,'0.1.')}) + (0..11+14..20).foreach({"$_".Insert(0,'0.2.')})
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
		if ($cudaVersion.StartsWith('rocm')) {$wheelURL = $wheelSource.TrimEnd('/') + '/rocm'}
		$cu = if ($cudaVersion.StartsWith('rocm')) {$cudaVersion} else {'cu' + $cudaVersion.replace('.','')}
		$cuContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
		$cuContentAlt = "<!DOCTYPE html>`n<html>`n  <body>`n    "
		ForEach ($packageVersion in $packageVersions)
		{
			if ($avxVersion -eq 'basic' -and $packageVersion -eq '0.1.73') {continue}
			if ($cudaVersion.StartsWith('rocm') -and [version]$packageVersion -lt [version]"0.1.80") {continue}
			if ($cudaVersion.StartsWith('rocm') -and $avxVersion -ne 'AVX2' -and [version]$packageVersion -lt [version]"0.2.7") {continue}
			ForEach ($pythonVersion in $pythonVersions)
			{
				$pyVer = $pythonVersion.replace('.','')
				ForEach ($supportedSystem in $supportedSystems)
				{
					if ($cudaVersion.StartsWith('rocm') -and $cudaVersion.Split('rocm')[-1] -ne '5.5.1' -and $supportedSystem -eq 'win_amd64') {continue}
					if ($cudaVersion.StartsWith('rocm') -and $cudaVersion.Split('rocm')[-1] -eq '5.5.1' -and $supportedSystem -eq 'linux_x86_64') {continue}
					if ([version]$packageVersion -gt [version]"0.1.85" -and $supportedSystem -eq 'linux_x86_64') {$supportedSystem = 'manylinux_2_31_x86_64'}
					$wheel = if ($avxVersion -eq 'AVX') { "$packageName-$packageVersion+$cu$('avx')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} elseif ($avxVersion -eq 'basic') { "$packageName-$packageVersion+$cu$('basic')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} else {"$packageName-$packageVersion+$cu-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
					$wheelAlt = if ($avxVersion -eq 'AVX') { "$packageNameAlt-$packageVersion+$cu$('avx')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} elseif ($avxVersion -eq 'basic') { "$packageNameAlt-$packageVersion+$cu$('basic')-cp$pyVer-cp$pyVer-$supportedSystem.whl"
					} else {"$packageNameAlt-$packageVersion+$cu-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
					if (!($packageVersion -eq '0.1.73' -and $avxVersion -eq 'AVX')) {$cuContent += "<a href=`"$wheelURL/$wheel`">$wheel</a><br/>`n    "}
					if ($packageVersion -in $packageAltVersions -and !$cudaVersion.StartsWith('rocm')) {$cuContentAlt += "<a href=`"$wheelURL/$wheelAlt`">$wheelAlt</a><br/>`n    "}
				}
			}
			if (!($packageVersion -eq '0.1.73' -and $avxVersion -eq 'AVX')) {$cuContent += "`n    "}
			if ($packageVersion -in $packageAltVersions) {$cuContentAlt += "`n    "}
		}
		$cuDir = if (Test-Path $(Join-Path $(Get-Variable "$avxVersion`Dir").Value $cu)) {Join-Path $(Get-Variable "$avxVersion`Dir").Value $cu} else {(New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value $cu) -ItemType 'Directory').fullname}
		$packageDir = if (Test-Path $(Join-Path $cuDir $packageNameNormalized)) {Join-Path $cuDir $packageNameNormalized} else {(New-Item $(Join-Path $cuDir $packageNameNormalized) -ItemType 'Directory').fullname}
		$packageAltDir = if (Test-Path $(Join-Path $cuDir $packageNameAltNormalized)) {Join-Path $cuDir $packageNameAltNormalized} elseif (!$cudaVersion.StartsWith('rocm')) {(New-Item $(Join-Path $cuDir $packageNameAltNormalized) -ItemType 'Directory').fullname}
		$cuLabel = if ($cudaVersion.StartsWith('rocm')) {'ROCm'+' '+$cudaVersion.Split('rocm')[-1]} else {"CUDA $cudaVersion"}
		$subIndexContent += "<a href=`"$cu/`">$cuLabel</a><br/>`n    "
		New-Item $(Join-Path $packageDir "index.html") -itemType File -value $($cuContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
		if (!$cudaVersion.StartsWith('rocm')) {New-Item $(Join-Path $packageAltDir "index.html") -itemType File -value $($cuContentAlt.TrimEnd() + "`n  </body>`n</html>`n") -force > $null}
		$packageIndexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    <a href=`"$packageNameNormalized/`">$packageName</a><br/>`n"
		if (!$cudaVersion.StartsWith('rocm')) {$packageIndexContent += "    <a href=`"$packageNameAltNormalized/`">$packageNameAlt</a>`n"}
		New-Item $(Join-Path $cuDir "index.html") -itemType File -value $($packageIndexContent + "  </body>`n</html>`n") -force > $null
	}
	$indexContent += "<a href=`"$avxVersion/`">$avxVersion</a><br/>`n    "
	New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "index.html") -itemType File -value $($subIndexContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
}
New-Item $(Join-Path $destinationDir "index.html") -itemType File -value $($indexContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
#"<!DOCTYPE html>`n<html>`n  <head>`n    <meta http-equiv=`"refresh`" content=`"0; url='./AVX2/cu$cu'`" />`n  </head>`n  <body>`n    <a href=`"AVX2/cu$cu`">CUDA $cudaVersion</a><br/>`n  </body>`n</html>"

pause
