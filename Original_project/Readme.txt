http://duffney.io/GettingStartedWithInvokeBuild
https://kevinmarquette.github.io/2018-03-06-Powershell-Managing-community-modules/

Pre-requisite:

Register-PSRepository -Default
or
Register-PSRepository -Name "PSGallery" -SourceLocation "https://www.powershellgallery.com/api/v2/" -InstallationPolicy Trusted

Register-PSRepository -Name LocalNuGetFeed -SourceLocation http://localhost:8087/nuget -PublishLocation http://localhost:8087/nuget -InstallationPolicy Trusted

get-packagesource
Get-PSRepository | Select *

Find-Module -Repository "LocalNuGetFeed" -IncludeDependencies
Find-Module -Repository "LocalNuGetFeed"
