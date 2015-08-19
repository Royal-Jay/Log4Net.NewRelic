$script:GitPath = 'C:\Program Files (x86)\Git\cmd\git.exe'
properties {

  #PARAMS
  $version = "1.0.0.0"
  $build_level = "Debug"

  #PATHS
  $build_dir = Split-Path $psake.build_script_file
  $solution_dir = Split-Path $build_dir
  $build_output = "$build_dir\artifacts"
  $srcDir = "$solution_dir\src"
  $nuget_dir = "$build_dir\..\src\packages\"
  $package_dir = "$build_dir\..\packages\"
  $artifacts_dir = "$build_dir\..\artifacts"

  $solution_name = "RoyalJay.Log4Net.NewRelic"
  $solution_file = "$srcDir\$solution_name.sln"
}

include tools\psake_utils.ps1
include tools\config-utils.ps1
include tools\nuget-utils.ps1
include tools\git-utils.ps1
include tools\ilmerge-utils.ps1

task default -depends Compile 

task Compile -depends Clean, Package-Restore {
  $script:build_level = $build_level
  $version = getVersion
  Exec {
  	msbuild "$solution_file" `
  	        /m /nr:false /p:VisualStudioVersion=12.0 `
  	        /t:Rebuild /nologo /v:m `
  	        /p:Configuration="$script:build_level" `
  	        /p:Platform="Any CPU" /p:TrackFileAccess=false
  }
}

task Clean {
  foreach($assembly in $assemblies + $client_apps + $web_apps + $tests){
    $bin = "$srcDir\$assembly\bin\"
    $obj = "$srcDir\$assembly\obj\"
    Write-Host "Removing $bin"
    Delete-Directory($bin)
    Write-Host "Removing $obj"
    Delete-Directory($obj)
  }
}
