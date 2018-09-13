// Config

class Globals {

   static String GitRepo = 'https://github.com/psymonn/PublishInternalModule.git'

   static String ModuleName = 'PublishInternalModule'

   static String eMail = 'report.email@gmail.com'

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


// eMail Notification
def notifyBuild(status){
    status = status ?: 'SUCCESSFUL'
    emailext (
      to: "${Globals.eMail}",
      subject: "${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
               <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
    )
}
