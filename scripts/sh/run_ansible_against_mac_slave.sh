#!/bin/bash

set -e

cloud_environment=$1
if [[ -z "$cloud_environment" ]]; then
    echo "A value must be supplied for the target environment. Valid values are 'vagrant', 'dev' or 'prod'."
    exit 1
fi

function get_jenkins_dns() {
    if [[ "$cloud_environment" == "prod" ]]; then
        jenkins_master_dns=$(aws ec2 describe-instances \
            --filters \
            "Name=tag:Name,Values=jenkins_master" \
            "Name=tag:environment,Values=$cloud_environment" \
            "Name=instance-state-name,Values=running" \
            | jq '.Reservations | .[0] | .Instances | .[0] | .PublicDnsName' \
            | sed 's/\"//g')
        echo "Jenkins master is at $jenkins_master_dns"
    fi
}

function run_ansible() {
    echo "Attempting Ansible run against macOS slave... (can be 10+ seconds before output)"
    ANSIBLE_SSH_PIPELINING=true ansible-playbook -i "environments/$cloud_environment/hosts" \
        --limit=rust_slave-osx-mojave-x86_64 \
        --vault-password-file=~/.ansible/vault-pass \
        --private-key=~/.ssh/id_rsa \
        -e "wg_server_endpoint=$jenkins_master_dns" \
        ansible/osx-rust-slave.yml
}

get_jenkins_dns
run_ansible
