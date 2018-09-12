function Update-BuildManifest

{

    [CmdletBinding()]

    Param

    (

        [Parameter(Mandatory = $true)]

        [string] $ModuleName,


        [Parameter(Mandatory = $true)]

        [int] $BuildNumber

    )

    $moduleDirectory = Join-Path $pwd "$ModuleName"

    $manifest = Join-Path $moduleDirectory "$ModuleName.psd1"

    $version = (Get-Module -FullyQualifiedName $manifest -ListAvailable).Version | Select-Object Major, Minor

    $newVersion = New-Object Version -ArgumentList $version.major, $version.minor, $BuildNumber

    Update-ModuleManifest -Path $manifest -ModuleVersion $newVersion
}


#Set Global Scope Preference
#We can remove the function and keep the body it will works best.
#This is just a poc
function InitPreferenceSingle
{
    [CmdletBinding()]
    param ()

    if (-not $PSBoundParameters.ContainsKey('ErrorAction'))
    {
        #can use either one of them:
        #$ErrorActionPreference = $PSCmdlet.GetVariableValue('ErrorActionPreference')
        $ErrorActionPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ErrorActionPreference')
    }

    Write-Host "Init-PreferenceSingle Function: ErrorActionPreference = $ErrorActionPreference"
}

function InitPreferenceMultiple
{
    [CmdletBinding()]
    param ()

    . .\Get-CallerPreference.ps1

    #can be define here or from the caller
    #$script:ErrorActionPreference = 'SilentlyContinue'
    #$script:PsymonPeferenceVariable = 'Who am I?'

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Name 'ErrorActionPreference', 'PsymonPeferenceVariable'

    Write-Host "Init-PreferenceMultiple Function: ErrorActionPreference = $ErrorActionPreference"
    Write-Host "PsymonPeferenceVariable: $PsymonPeferenceVariable"
}

#download modules from LocalNuGetFeed to a folder
function Save-Dependency
{

    [CmdletBinding()]

    Param

    (
        [Parameter(Mandatory = $true)]
        [string] $PubRepoName,

        [Parameter(Mandatory = $true)]
        [string] $Artifacts,

        [Parameter(Mandatory = $true)]
        [PSCustomObject] $config

    )

    try
    {

        Write-Host "Save-Dependency Function: ErrorActionPreference = $ErrorActionPreference"
        Write-Host "PsymonPeferenceVariable: $PsymonPeferenceVariable"

        foreach ( $module in $config.Modules )
        {

            $saveParam = @{
                Name       = $module.Name
                Path       = $Artifacts
                Repository = $PubRepoName
            }

            if ( $null -ne $module.RequiredVersion )
            {
                $saveParam.RequiredVersion = $module.RequiredVersion
            }

            Save-Module @saveParam -ErrorAction stop -Verbose
        }
    }
    catch [System.Exception]
    {

        #Write-Error "Save Dependencie Modules Failed: $_.Exception"

        throw($_.Exception)

    }

}

function Import-Dependency
{
    Write-Host "Import-Dependency Function: ErrorActionPreference = $ErrorActionPreference"
    #import the downloaded modules ready to use
    foreach ( $module in $config.Modules )
    {
        $path = Join-Path .\artifacts $module.Name
        Import-Module $path -Force
    }
}

function Test-Dependency
{
    #test all my projects that depend on these modules
    #assuming all modules have a build.ps1
    [CmdletBinding()]
    Param

    (

        [Parameter(Mandatory = $true)]

        [PSCustomObject] $config

    )

    Write-Host "Test-Dependency Function: ErrorActionPreference = $ErrorActionPreference"

    foreach ($project in $config.TestOrder)
    {
        #$project = 'PSHitchhiker'
        #    $repo = 'https://github.com/psymonn/{0}.git' -f $project
        $buildScript = '{0}.build.ps1' -f $project
        write-host "BuildScript: $buildScript"
        #   git clone $repo
        try
        {
            #& invoke-build -Task 'InstallDependencies' -f "$project/$buildScript"
            #just need to perform pester test.
            & invoke-build -Task 'Test' -f "$project/$buildScript"
        }
        catch
        {
            Write-Host "Skipe error project (non existing project?) : $project"
            Write-Host "Within Catch block: ErrorActionPreference = $ErrorActionPreference"
        }

    }
}

function Publish-Depedency
{
    [CmdletBinding()]

    Param

    (
        [Parameter(Mandatory = $true)]
        [string] $LocalRepoName,

        [Parameter(Mandatory = $true)]
        [string] $RepoApiKey,

        [Parameter(Mandatory = $true)]
        [string] $Artifacts
    )
    #publish the packages into our Local Nuget Feed
    Write-Host "Publish-Depedency Function: ErrorActionPreference = $ErrorActionPreference"
    foreach ($module in $config.Modules)
    {
        $path = "$Artifacts\{0}\*\{0}.psd1" -f $module.Name
        #$path = '.\artifacts\{0}\{0}.psd1' -f $module.Name

        $publishParam = @{
            Name        = $path
            Repository  = $LocalRepoName
            NuGetApiKey = $RepoApiKey
            Force       = $true
        }

        try
        {

            Publish-Module @publishParam

        }
        catch [System.Exception]
        {

            Write-Warning "Publish Dependencie Modules Failed: $_.Exception"

            #throw($_.Excepti on)

        }

    }
}
