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
                    set -e

                    echo "=== Vérification JMeter ==="
                    "$JMETER_HOME/bin/jmeter" --version

                    echo "=== Vérification du fichier JMX ==="

                    ls -lh "$WORKSPACE/tests/jmeter/ci-app-load-test.jmx"

                    echo "=== Préparation des résultats ==="

                    mkdir -p "$WORKSPACE/jmeter-results"

                    sudo mkdir -p /home/jmeterapp/jmeter-results

                    sudo chown -R jmeterapp:jmeterapp \
                        /home/jmeterapp/jmeter-results

                    echo "=== Nettoyage anciens résultats ==="

                    sudo rm -f \
                        /home/jmeterapp/jmeter-results/jenkins-jmeter.jtl

                    sudo rm -f \
                        /home/jmeterapp/jmeter-results/jenkins-jmeter.log

                    echo "=== Lancement JMeter ==="

                    sudo -u jmeterapp "$JMETER_HOME/bin/jmeter" -n \
                        -t "$WORKSPACE/tests/jmeter/ci-app-load-test.jmx" \
                        -l /home/jmeterapp/jmeter-results/jenkins-jmeter.jtl \
                        -j /home/jmeterapp/jmeter-results/jenkins-jmeter.log

                    echo "=== Copie des résultats vers Jenkins ==="

                    sudo cp \
                        /home/jmeterapp/jmeter-results/jenkins-jmeter.jtl \
                        "$WORKSPACE/jmeter-results/"

                    sudo cp \
                        /home/jmeterapp/jmeter-results/jenkins-jmeter.log \
                        "$WORKSPACE/jmeter-results/"

                    sudo chown -R "$(id -u):$(id -g)" \
                        "$WORKSPACE/jmeter-results"

                    echo "=== Résultats JMeter ==="

                    ls -lh "$WORKSPACE/jmeter-results"

                    echo "=== Aperçu du fichier JTL ==="

                    head -5 \
                        "$WORKSPACE/jmeter-results/jenkins-jmeter.jtl"

                    echo "=== Vérification des erreurs ==="

                    ERRORS=$(grep -c ',false,' \
                        "$WORKSPACE/jmeter-results/jenkins-jmeter.jtl" || true)

                    echo "Nombre d'erreurs JMeter : $ERRORS"

                    if [ "$ERRORS" -ne 0 ]; then

                        echo "=== JMeter FAILURE ==="

                        cat \
                            "$WORKSPACE/jmeter-results/jenkins-jmeter.jtl"

                        exit 1
                    fi

                    echo "=== JMeter SUCCESS ==="
                    echo "Toutes les requêtes JMeter sont réussies."
                '''
            }
        }

        stage('Archive') {
            steps {
                echo '=== Archive artifacts ==='

                archiveArtifacts artifacts: 'ci-app/target/*.war',
                                  fingerprint: true

                archiveArtifacts artifacts: 'jmeter-results/*.jtl,jmeter-results/*.log',
                                  allowEmptyArchive: false,
                                  fingerprint: true

                junit allowEmptyResults: true,
                      testResults: 'ci-app/target/surefire-reports/*.xml'
            }
        }
    }

    post {

        success {
            echo '=== CI SUCCESS ==='
            echo 'Build, tests, analyse, déploiement et JMeter terminés.'
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
