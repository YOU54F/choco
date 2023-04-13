# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# 1. See the _TODO.md that is generated top level and read through that
# 2. Follow the documentation below to learn how to create a package for the package type you are creating.
# 3. In Chocolatey scripts, ALWAYS use absolute paths - $toolsDir gets you to the package's tools directory.
$ErrorActionPreference = 'Stop' # stop on all errors
#Items that could be replaced based on what you call chocopkgup.exe with
#{{PackageName}} - Package Name (should be same as nuspec file and folder) |/p
#{{PackageVersion}} - The updated version | /v
#{{DownloadUrl}} - The url for the native file | /u
#{{PackageFilePath}} - Downloaded file if including it in package | /pp
#{{PackageGuid}} - This will be used later | /pg
#{{DownloadUrlx64}} - The 64-bit url for the native file | /u64
#{{Checksum}} - The checksum for the url | /c
#{{Checksumx64}} - The checksum for the 64-bit url | /c64
#{{ChecksumType}} - The checksum type for the url | /ct
#{{ChecksumTypex64}} - The checksum type for the 64-bit url | /ct64

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pactVerifierCli = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  # fileType      = 'exe' 
  url           = 'https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v0.10.5/pact_verifier_cli-windows-x86_64.exe.gz'
  softwareName  = 'pact'
  # You can also use checksum.exe (choco install checksum) and use it
  # e.g. checksum -t sha256 -f path\to\file
  checksum      = 'a4d7270b29970cd50ad4ec6d98a87068e0bb1ad9df52e86b7d3174564ac7ca73'
  checksumType  = 'sha256' 
}
$pactMockServerCli = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  # fileType      = 'exe' 
  url           = 'https://github.com/pact-foundation/pact-reference/releases/download/pact_mock_server_cli-v1.0.0/pact_mock_server_cli-windows-x86_64.exe.gz'
  softwareName  = 'pact'
  checksum      = 'df69c9cbae0238c2f04a37afc9e390dd4379d59ac7fcbb2b1cc70a28b4b8af21'
  checksumType  = 'sha256' 
}
$pactRubyStandalone = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  # fileType      = 'exe' 
  url           = 'https://github.com/YOU54F/pact-ruby-standalone/releases/download/v1.92.0/pact-1.92.0-win32.zip'
  softwareName  = 'pact'
  checksum      = '805580f8da6c2feb8a4ad0508fcb62ca1c497b2f'
  checksumType  = 'sha1' 
}
 # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage
Install-ChocolateyZipPackage @pactVerifierCli
Install-ChocolateyZipPackage @pactMockServerCli
Install-ChocolateyZipPackage @pactRubyStandalone

# We need to exclude these from being shimmed to avoid polluting the users path
New-Item "$toolsDir\pact\lib\ruby\bin.real\rubyw.exe.ignore" -type file -force | Out-Null
New-Item "$toolsDir\pact\lib\ruby\bin.real\ruby.exe.ignore" -type file -force | Out-Null
Install-BinFile -Name 'pact.bat' -Path "$toolsDir\pact\bin\pact.bat"
Install-BinFile -Name 'pact-publish.bat' -Path "$toolsDir\pact\bin\pact-publish.bat"
Install-BinFile -Name 'pact-broker.bat' -Path "$toolsDir\pact\bin\pact-broker.bat"
Install-BinFile -Name 'pact-stub-service.bat' -Path "$toolsDir\pact\bin\pact-stub-service.bat"
Install-BinFile -Name 'pactflow.bat' -Path "$toolsDir\pact\bin\pactflow.bat"
Install-BinFile -Name 'pact-mock-service.bat' -Path "$toolsDir\pact\bin\pact-mock-service.bat"
Install-BinFile -Name 'pact-message.bat' -Path "$toolsDir\pact\bin\pact-message.bat"
Install-BinFile -Name 'pact-provider-verifier.bat' -Path "$toolsDir\pact\bin\pact-provider-verifier.bat"
# The following file is automatically shimmed
# Install-BinFile -Name 'pact-plugin-cli.exe' -Path "$toolsDir\pact\bin\pact-plugin-cli.exe"


