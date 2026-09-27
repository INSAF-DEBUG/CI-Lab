pipeline {

    agent {
        label 'centos-build'
    }

    environment {
        // Application
        APP_DIR = 'ci-app'

        // Firefox graphique sur la VM CentOS
        DISPLAY = ':0'
        XAUTHORITY = '/home/insaf/.Xauthority'

        // SonarQube
        SONAR_HOST_URL = 'http://192.168.42.152:9000'

        // Nexus
        NEXUS_URL = 'http://192.168.42.154:8081'

        // JMeter
        JMETER_HOME = '/opt/jmeter'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '=== Checkout Git ==='

                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '=== Build Maven ==='

                dir("${APP_DIR}") {
                    sh '''
                        echo "=== Java ==="
                        java -version

                        echo "=== Maven ==="
                        mvn -version

                        echo "=== Build ==="
                        mvn clean package -DskipTests
                    '''
                }
            }
        }

        stage('Tests') {
            steps {
                echo '=== Tests Maven + Selenium Firefox ==='

                dir("${APP_DIR}") {
                    sh '''
                        set -e

                        echo "=== Environment graphique ==="
                        echo "DISPLAY=$DISPLAY"
                        echo "XAUTHORITY=$XAUTHORITY"

                        echo "=== Vérification Xauthority ==="
                        test -f "$XAUTHORITY"

                        xauth -f "$XAUTHORITY" list || true

                        echo "=== Firefox ==="
                        firefox --version

                        echo "=== Maven Tests ==="
                        mvn test
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '=== SonarQube Analysis ==='

                dir("${APP_DIR}") {
                    withSonarQubeEnv('SonarQube') {
                        sh '''
                            mvn sonar:sonar \
                              -Dsonar.host.url="$SONAR_HOST_URL" \
                              -Dsonar.projectKey=ci-app \
                              -Dsonar.projectName=ci-app
                        '''
                    }
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                echo '=== Deploy to Nexus ==='

                dir("${APP_DIR}") {
                    sh '''
                        echo "=== Déploiement Maven vers Nexus ==="

                        mvn deploy -DskipTests
                    '''
                }
            }
        }

        stage('JMeter Load Test') {
            steps {
                echo '=== JMeter Load Test ==='

                sh '''
                    if [ -x "$JMETER_HOME/bin/jmeter" ]; then
                        echo "=== JMeter trouvé ==="
                        "$JMETER_HOME/bin/jmeter" --version
                    else
                        echo "JMeter non trouvé dans $JMETER_HOME"
                        exit 1
                    fi
                '''
            }
        }

        stage('Archive') {
            steps {
                echo '=== Archive artifacts ==='

                archiveArtifacts artifacts: 'ci-app/target/*.war', fingerprint: true

                junit allowEmptyResults: true,
                      testResults: 'ci-app/target/surefire-reports/*.xml'
            }
        }
    }

    post {

        success {
            echo '=== CI SUCCESS ==='
            echo 'Build, tests, analyse et déploiement terminés.'
        }

        failure {
            echo '=== CI FAILURE ==='
            echo 'Une étape du pipeline a échoué.'
        }

        always {
            echo '=== Pipeline terminé ==='
        }
    }
}

