pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_PEER', defaultValue: "twblockchain/fabric-peer:latest")
        string(name: 'IMAGE_ORDERER', defaultValue: "twblockchain/fabric-orderer:latest")
        string(name: 'IMAGE_CA', defaultValue: "twblockchain/fabric-ca:latest")
        string(name: 'IMAGE_TOOLS', defaultValue: "twblockchain/fabric-tools:latest")
        string(name: 'IMAGE_CCENV', defaultValue: "twblockchain/fabric-ccenv:latest")
        choice(name: 'BYFN_CA', choices: ['no', 'yes'])
        string(name: 'START_FABCAR_TIMEOUT_MINS', defaultValue: '10')
    }

    environment {
        IMAGE_PEER = "${params.IMAGE_PEER}"
        IMAGE_ORDERER = "${params.IMAGE_ORDERER}"
        IMAGE_CA = "${params.IMAGE_CA}"
        IMAGE_TOOLS = "${params.IMAGE_TOOLS}"
        IMAGE_CCENV = "${params.IMAGE_CCENV}"
        BYFN_CA = "${params.BYFN_CA}"
    }

    stages {
        stage('Prepare') {

            steps {
                sh 'aws ecr get-login-password | docker login --username AWS --password-stdin ${DOCKER_REGISTRY}'
                sh '''
                docker pull $IMAGE_PEER
                docker pull $IMAGE_ORDERER
                docker pull $IMAGE_CA
                docker pull $IMAGE_TOOLS
                docker pull $IMAGE_CCENV

                docker tag $IMAGE_PEER hyperledger/fabric-peer:latest
                docker tag $IMAGE_ORDERER hyperledger/fabric-orderer:latest
                docker tag $IMAGE_CA hyperledger/fabric-ca:latest
                docker tag $IMAGE_TOOLS hyperledger/fabric-tools:latest
                docker tag $IMAGE_CCENV hyperledger/fabric-ccenv:latest
                '''

                echo "Clean fabcar"
                sh '''
                make fabcar-clean
                '''
            }

        }

        stage('Start Fabric') {

            steps {

                echo "Start fabcar"
                timeout(params.START_FABCAR_TIMEOUT_MINS as int) {
                    sh '''
                    make fabcar
                    '''
                }
            }

        }

        stage('Test Chaincode') {

            steps {

                echo "Test Chaincode"
                sh '''
                docker exec cli peer chaincode query -C mychannel -n fabcar -c '{"Args":["queryAllCars"]}'
                '''

            }

        }
	
        stage('Test Go SDK') {

            steps {

                echo "Test Go SDK"
                sh '''
                make sdk-test
                '''

            }

        }
    }

    post {

        always {

            echo "Clean fabcar"
            sh '''
            make fabcar-clean
            '''

        }
    }
}

