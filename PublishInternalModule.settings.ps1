###############################################################################

# Customize these properties and tasks

###############################################################################

param(

    $Artifacts = '.\artifacts',

    $ModuleName = 'PublishInternalModule',

    $ModulePath = '.\PublishInternalModule',

    #$BuildNumber = $env:BUILD_NUMBER,
    $BuildNumber = '3'

)



###############################################################################

# Static settings -- no reason to include these in the param block

###############################################################################

$Settings = @{

    #SMBRepoName = 'LocalFileBase'
    #SMBRepoPath = 'C:\Data\App\LocalFileSharing'

    PublishRepoName = 'PSGallery'
    LocalRepoName = 'LocalNuGetFeed'
    ApiKey   = 'SECRETKEY'

    PackageDescription = "PublishInternalModule module pipeline demonstration"
    Repository = 'https://github.com/psymonn/PublishInternalModule.git'

}



###############################################################################

# Before/After Hooks for the Core Task: Clean

###############################################################################



# Synopsis: Executes before the Clean task.

task BeforeClean {}



# Synopsis: Executes after the Clean task.

task AfterClean {}



###############################################################################

# Before/After Hooks for the Core Task: Analyze

###############################################################################



# Synopsis: Executes before the Analyze task.

task BeforeAnalyse {}



# Synopsis: Executes after the Analyze task.

task AfterAnalyse {}



###############################################################################

# Before/After Hooks for the Core Task: Archive

###############################################################################



# Synopsis: Executes before the Archive task.

task BeforeArchive {}



# Synopsis: Executes after the Archive task.

task AfterArchive {}



###############################################################################

# Before/After Hooks for the Core Task: Publish

###############################################################################



# Synopsis: Executes before the Publish task.

task BeforePublish {}



# Synopsis: Executes after the Publish task.

task AfterPublish {}



###############################################################################

# Before/After Hooks for the Core Task: Test

###############################################################################



# Synopsis: Executes before the Test Task.

task BeforeTest {
    write-host "Hello before test"
}



# Synopsis: Executes after the Test Task.

task AfterTest {
    write-host "Hello after test"
}
