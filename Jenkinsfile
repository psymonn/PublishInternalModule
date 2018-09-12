// Config

class Globals {

   static String GitRepo = 'https://github.com/psymonn/PublishInternalModule.git'

   static String ModuleName = 'PublishInternalModule'

   static String JenkinsChannel = '#jenkins-channel'

}



// Workflow Steps

node('master') {

  try {

    checkout scm



    notifyBuild('STARTED')



    stage('Stage 0: Clone') {

      git url: Globals.GitRepo

    }

    stage('Stage 1: Clean') {

      posh 'Invoke-Build Clean'

    }


    stage('Stage: Save dependencies') {

      posh 'Invoke-Build SaveDependency'

    }

    stage('Stage: Import dependencies') {

      posh 'Invoke-Build ImportDependency'

    }
        
    stage('Stage 3: Test') {

      posh 'Invoke-Build RunTests'

    }

    
    stage('Stage 5: Publish') {

      timeout(20) {

        posh 'Invoke-Build Publish'

      }

    }

  } catch (e) {

    currentBuild.result = "FAILED"

    throw e

  } finally {

    notifyBuild(currentBuild.result)

  }

}



// Helper function to run PowerShell Commands

def posh(cmd) {

  bat 'powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "& ' + cmd + '"'

}



// Helper function to Broadcast Build to Slack

def notifyBuild(String buildStatus = 'STARTED') {



  buildStatus = buildStatus ?: 'SUCCESSFUL'



  def colorCode = '#FF0000' // Failed : Red

  if (buildStatus == 'STARTED') { colorCode = '#FFFF00' } // STARTED: Yellow

  else if (buildStatus == 'SUCCESSFUL') { colorCode = '#00FF00' } // SUCCESSFUL: Green



  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"

  def summary = "${subject} (${env.BUILD_URL})"



  //slackSend (color: colorCode, channel: "${Globals.JenkinsChannel}", message: summary)

}
