$config = Get-Content -Path .\config.json | ConvertFrom-Json
    foreach ( $module in $config.Modules )
    {
        $saveParam = @{
            Name = $module.Name
            Path = '.\downloads'
            Repository = 'PSGallery'
        }

        if ( $null -ne $module.RequiredVersion )
        {
            $saveParam.RequiredVersion = $module.RequiredVersion
        }

        Save-Module @saveParam
    }

    foreach( $module in $config.Modules )
    {
        $path = Join-Path .\downloads $module.Name
        Import-Module $path -Force
    }

    foreach($project in $config.TestOrder)
    {
        $project = 'PSHitchhiker'
        $repo = 'https://github.com/psymonn/{0}.git' -f $project
        $buildScript = '{0}.build.ps1' -f $project
        git clone $repo
        #& invoke-build -Task 'InstallDependencies' -f "$project/$buildScript"
        & invoke-build -Task 'Test' -f "$project/$buildScript"
    }

   foreach($module in $config.Modules)
    {
        $path = '.\downloads\{0}\*\{0}.psd1' -f $module.Name

        $publishParam = @{
            Name        = $path
            Repository  = 'LocalNuGetFeed'
            NuGetApiKey = "SECRETKEY"
            Force       = $true
        }
        Publish-Module @publishParam
    }
