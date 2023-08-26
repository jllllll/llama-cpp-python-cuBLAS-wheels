Set-Location $PSScriptRoot

$destinationDir = if (Test-Path $(Join-Path $(Resolve-Path '.') 'index')) {Join-Path '.' 'index' -resolve} else {(New-Item 'index' -ItemType 'Directory').fullname}
$avxVersions = "AVX","AVX2","AVX512","basic"
$cudaVersions = "11.6","11.7","11.8","12.0","12.1","12.2","cpu"
$packageVersions = "0.1.62","0.1.66","0.1.67","0.1.68","0.1.69","0.1.70","0.1.71","0.1.72","0.1.73","0.1.74","0.1.76","0.1.77","0.1.78","0.1.79"
$pythonVersions = "3.7","3.8","3.9","3.10","3.11"
$supportedSystems = 'linux_x86_64','win_amd64'
$wheelSource = 'https://github.com/jllllll/llama-cpp-python-cuBLAS-wheels/releases/download'
$packageName = 'llama_cpp_python'
$packageNameNormalized = 'llama-cpp-python'
$packageNameAlt = 'llama_cpp_python_ggml'
$packageNameAltNormalized = 'llama-cpp-python-ggml'
$packageAltVersions = @("0.1.78")

$avxVersions.foreach({Set-Variable "$_`Dir" $(if (Test-Path $(Join-Path $destinationDir $_)) {Join-Path $destinationDir $_} else {(New-Item $(Join-Path $destinationDir $_) -ItemType 'Directory').fullname})})

$indexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
Foreach ($avxVersion in $avxVersions)
{
	if ($avxVersion -eq 'AVX2') {$wheelURL = $wheelSource.TrimEnd('/') + '/wheels'} else {$wheelURL = $wheelSource.TrimEnd('/') + "/$avxVersion"}
	$subIndexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
	ForEach ($cudaVersion in $cudaVersions)
	{
		$cu = if ($cudaVersion -eq 'cpu') {$cudaVersion} else {'cu' + $cudaVersion.replace('.','')}
		if ($cudaVersion -eq 'cpu') {$wheelURL = $wheelSource.TrimEnd('/') + '/cpu'}
		$cuContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
		$cuContentAlt = "<!DOCTYPE html>`n<html>`n  <body>`n    "
		ForEach ($packageVersion in $packageVersions)
		{
			if (($avxVersion -eq 'basic' -or $cudaVersion -eq 'cpu') -and [version]$packageVersion -lt [version]"0.1.70") {continue}
			ForEach ($pythonVersion in $pythonVersions)
			{
				$pyVer = $pythonVersion.replace('.','')
				ForEach ($supportedSystem in $supportedSystems)
				{
					$wheelTag = if ($cudaVersion -eq 'cpu') {"+cpu$($avxVersion.ToLower())"} else {"+$cu"}
					$wheel = if ($pyVer -eq '37') {"$packageName-$packageVersion$wheelTag-cp$pyVer-cp$pyVer`m-$supportedSystem.whl"} else {"$packageName-$packageVersion$wheelTag-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
					$wheelAlt = if ($pyVer -eq '37') {"$packageNameAlt-$packageVersion$wheelTag-cp$pyVer-cp$pyVer`m-$supportedSystem.whl"} else {"$packageNameAlt-$packageVersion$wheelTag-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
					$cuContent += "<a href=`"$wheelURL/$wheel`">$wheel</a><br/>`n    "
					if ($packageVersion -in $packageAltVersions) {$cuContentAlt += "<a href=`"$wheelURL/$wheelAlt`">$wheelAlt</a><br/>`n    "}
				}
			}
			$cuContent += "`n    "
			if ($packageVersion -in $packageAltVersions) {$cuContentAlt += "`n    "}
		}
		$cuDir = if (Test-Path $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "$cu")) {Join-Path $(Get-Variable "$avxVersion`Dir").Value "$cu"} else {(New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "$cu") -ItemType 'Directory').fullname}
		$packageDir = if (Test-Path $(Join-Path $cuDir $packageNameNormalized)) {Join-Path $cuDir $packageNameNormalized} else {(New-Item $(Join-Path $cuDir $packageNameNormalized) -ItemType 'Directory').fullname}
		$packageAltDir = if (Test-Path $(Join-Path $cuDir $packageNameAltNormalized)) {Join-Path $cuDir $packageNameAltNormalized} else {(New-Item $(Join-Path $cuDir $packageNameAltNormalized) -ItemType 'Directory').fullname}
		$cuLabel = if ($cudaVersion -eq 'cpu') {$cudaVersion} else {"CUDA $cudaVersion"}
		$subIndexContent += "<a href=`"$cu/`">$cuLabel</a><br/>`n    "
		New-Item $(Join-Path $packageDir "index.html") -itemType File -value $($cuContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
		New-Item $(Join-Path $packageAltDir "index.html") -itemType File -value $($cuContentAlt.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
		New-Item $(Join-Path $cuDir "index.html") -itemType File -value $("<!DOCTYPE html>`n<html>`n  <body>`n    <a href=`"$packageNameNormalized/`">$packageName</a>`n    <a href=`"$packageNameAltNormalized/`">$packageNameAlt</a>`n  </body>`n</html>`n") -force > $null
		if ($avxVersion -eq 'AVX2') {New-Item $(Join-Path $destinationDir "$cu.html") -itemType File -value $($cuContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null}
	}
	$indexContent += "<a href=`"$avxVersion/`">$avxVersion</a><br/>`n    "
	New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "index.html") -itemType File -value $($subIndexContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
}
New-Item $(Join-Path $destinationDir "index.html") -itemType File -value $($indexContent.TrimEnd() + "`n  </body>`n</html>`n") -force > $null
#"<!DOCTYPE html>`n<html>`n  <head>`n    <meta http-equiv=`"refresh`" content=`"0; url='./AVX2/cu$cu'`" />`n  </head>`n  <body>`n    <a href=`"AVX2/cu$cu`">CUDA $cudaVersion</a><br/>`n  </body>`n</html>"

pause
