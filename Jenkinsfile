pipeline {
  agent any

  environment {
    AWS_REGION    = credentials('AWS_REGION') ?: 'ap-south-1'
    AWS_ACCOUNTID = ''
    // Configure these in Jenkins > Credentials (type: Secret text or Username/Password as you prefer)
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    S3_BUCKET   = env.S3_BUCKET ?: 'my-codedeploy-artifacts-bucket'
    APP_NAME    = env.APP_NAME ?: 'fitness-website-app'
    DEPLOY_GRP  = env.DEPLOY_GRP ?: 'fitness-website-deploy-group'
    APP_ENV     = env.APP_ENV ?: 'prod'
    ARTIFACT    = "artifact-${env.BUILD_NUMBER}.zip"
  }

  options {
    ansiColor('xterm')
    timestamps()
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Package') {
      steps {
        sh '''
          set -e
          rm -f ${ARTIFACT}
          zip -r ${ARTIFACT} .                 -x ".git/*" ".github/*" "node_modules/*" "*.zip"
          echo "Created artifact: ${ARTIFACT}"
        '''
        archiveArtifacts artifacts: "${ARTIFACT}", fingerprint: true
      }
    }

    stage('Upload & Register (CodeDeploy)') {
      steps {
        withEnv(["AWS_DEFAULT_REGION=${env.AWS_REGION}"]) {
          sh '''
            set -e
            which aws || pip install --upgrade awscli --break-system-packages || pip install --user awscli
            aws s3 cp ${ARTIFACT} s3://${S3_BUCKET}/${APP_NAME}/${APP_ENV}/${ARTIFACT}
            aws deploy create-deployment                   --application-name ${APP_NAME}                   --deployment-group-name ${DEPLOY_GRP}                   --s3-location bucket=${S3_BUCKET},key=${APP_NAME}/${APP_ENV}/${ARTIFACT},bundleType=zip                   --description "Jenkins build ${BUILD_NUMBER}"
          '''
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished.'
    }
  }
}
