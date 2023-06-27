Set-Location $PSScriptRoot

$destinationDir = if (Test-Path $(Join-Path $(Resolve-Path '.') 'docs')) {Join-Path '.' 'docs' -resolve} else {(New-Item 'docs' -ItemType 'Directory').fullname}
$avxVersions = "AVX","AVX2"
$cudaVersions = "11.6","11.7","11.8","12.0","12.1"
$packageVersions = "0.1.62","0.1.66"
$pythonVersions = "3.7","3.8","3.9","3.10","3.11"
$supportedSystems = 'linux_x86_64','win_amd64'
$wheelSource = 'https://github.com/jllllll/llama-cpp-python-cuBLAS-wheels/releases/download/wheels'
$wheelSourceAVX = 'https://github.com/jllllll/llama-cpp-python-cuBLAS-wheels/releases/download/AVX'
$packageName = 'llama_cpp_python'
$packageNameNormalized = 'llama-cpp-python'

$AVXDir = if (Test-Path $(Join-Path $destinationDir 'AVX')) {Join-Path $destinationDir 'AVX'} else {(New-Item $(Join-Path $destinationDir 'AVX') -ItemType 'Directory').fullname}
$AVX2Dir = if (Test-Path $(Join-Path $destinationDir 'AVX2')) {Join-Path $destinationDir 'AVX2'} else {(New-Item $(Join-Path $destinationDir 'AVX2') -ItemType 'Directory').fullname}

$indexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
$wheelSource = $wheelSource.TrimEnd('/')
Foreach ($avxVersion in $avxVersions)
{
	$subIndexContent = "<!DOCTYPE html>`n<html>`n  <body>`n    "
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
					$wheel = if ($pyVer -eq '37') {"$packageName-$packageVersion+cu$cu-cp$pyVer-cp$pyVer`m-$supportedSystem.whl"} else {"$packageName-$packageVersion+cu$cu-cp$pyVer-cp$pyVer-$supportedSystem.whl"}
					if ($avxVersion -eq 'AVX') {$cuContent += "<a href=`"$wheelSourceAVX/$wheel`">$wheel</a><br/>`n    "}
					if ($avxVersion -eq 'AVX2') {$cuContent += "<a href=`"$wheelSource/$wheel`">$wheel</a><br/>`n    "}
				}
			}
			$cuContent += "`n    "
		}
		$cuDir = if (Test-Path $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "cu$cu")) {Join-Path $(Get-Variable "$avxVersion`Dir").Value "cu$cu"} else {(New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "cu$cu") -ItemType 'Directory').fullname}
		$packageDir = if (Test-Path $(Join-Path $cuDir $packageNameNormalized)) {Join-Path $cuDir $packageNameNormalized} else {(New-Item $(Join-Path $cuDir $packageNameNormalized) -ItemType 'Directory').fullname}
		$subIndexContent += "<a href=`"cu$cu/`">CUDA $cudaVersion</a><br/>`n    "
		New-Item $(Join-Path $packageDir "index.html") -itemType File -value $($cuContent.TrimEnd() + "`n  </body>`n</html>") -force > $null
		New-Item $(Join-Path $cuDir "index.html") -itemType File -value $("<!DOCTYPE html>`n<html>`n  <body>`n    <a href=`"$packageNameNormalized/`">$packageName</a>`n  </body>`n</html>") -force > $null
		if ($avxVersion -eq 'AVX2') {New-Item $(Join-Path $destinationDir "cu$cu.html") -itemType File -value $($cuContent.TrimEnd() + "`n  </body>`n</html>") -force > $null}
	}
	$indexContent += "<a href=`"$avxVersion/`">$avxVersion</a><br/>`n    "
	New-Item $(Join-Path $(Get-Variable "$avxVersion`Dir").Value "index.html") -itemType File -value $($subIndexContent.TrimEnd() + "`n  </body>`n</html>") -force > $null
}
New-Item $(Join-Path $destinationDir "index.html") -itemType File -value $($indexContent.TrimEnd() + "`n  </body>`n</html>") -force > $null
#"<!DOCTYPE html>`n<html>`n  <head>`n    <meta http-equiv=`"refresh`" content=`"0; url='./AVX2/cu$cu'`" />`n  </head>`n  <body>`n    <a href=`"AVX2/cu$cu`">CUDA $cudaVersion</a><br/>`n  </body>`n</html>"

pause
