multibranchPipelineJob('pipeline-safe_client_libs') {
    branchSources {
        github {
            checkoutCredentialsId('github_maidsafe_token_credentials')
            scanCredentialsId('github_maidsafe_token_credentials')
            repoOwner('maidsafe')
            repository('safe_client_libs')
        }
    }
    orphanedItemStrategy {
        discardOldItems {
            numToKeep(20)
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('scripts/Jenkinsfile')
        }
    }
}

multibranchPipelineJob('pipeline-jenkins_sample_lib') {
    branchSources {
        github {
            checkoutCredentialsId('github_maidsafe_token_credentials')
            scanCredentialsId('github_maidsafe_token_credentials')
            repoOwner('maidsafe')
            repository('jenkins_sample_lib')
        }
    }
    orphanedItemStrategy {
        discardOldItems {
            numToKeep(20)
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('Jenkinsfile')
        }
    }
}
