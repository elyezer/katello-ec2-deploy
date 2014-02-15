#!/bin/bash

usage(){
  echo "Usage: <RH Portal Username> <RH Portal Password> <poolid> <keypath> <instanceurl>"
}

USERNAME=$1
PASSWORD=$2
POOLID=$3
KEYPATH=$4
INSTANCEURL=$5

if [ -z $USERNAME ]
then
  usage
  exit 1
fi

if [ -z $PASSWORD ]
then
  usage
  exit 2
fi

if [ -z $POOLID ]
then
  usage
  exit 3
fi

if [ -z $KEYPATH ]
then
  usage
  exit 4
fi

if [ -z $INSTANCEURL ]
then
  usage
  exit 5
fi

SSH_COMMAND="ssh -t -i $KEYPATH ec2-user@$INSTANCEURL"

$SSH_COMMAND "sudo yum-config-manager --disable \"rhui*\""
$SSH_COMMAND "sudo rpm -e epel-release"
$SSH_COMMAND "sudo rpm -e foreman-release"
$SSH_COMMAND "sudo rpm -e katello-repos"
$SSH_COMMAND "sudo rm -f /etc/yum.repos.d/scl.repo"

$SSH_COMMAND "sudo subscription-manager register --force --user=$USERNAME --password=$PASSWORD --autosubscribe"
$SSH_COMMAND "sudo subscription-manager subscribe --pool=$POOLID"

$SSH_COMMAND "sudo yum repolist"
$SSH_COMMAND "sudo yum -y --disablerepo=\"*\" --enablerepo=rhel-6-server-rpms install wget yum-utils"
$SSH_COMMAND "sudo yum-config-manager --disable \"*\""
$SSH_COMMAND "sudo yum-config-manager --enable rhel-6-server-rpms epel"
$SSH_COMMAND "sudo yum-config-manager --enable rhel-6-server-optional-rpms"

$SSH_COMMAND "sudo setenforce 0"
$SSH_COMMAND "if [ ! -e \"/etc/yum.repos.d/scl.repo\" ]
then
    sudo wget https://raw.github.com/Katello/katello-deploy/master/scl.repo
    sudo mv ./scl.repo /etc/yum.repos.d/
fi"

$SSH_COMMAND "sudo yum -y localinstall http://fedorapeople.org/groups/katello/releases/yum/nightly/RHEL/6Server/x86_64/katello-repos-latest.rpm 2> /dev/null"
$SSH_COMMAND "sudo yum -y localinstall http://mirror.pnl.gov/epel/6/x86_64/epel-release-6-8.noarch.rpm > /dev/null"
$SSH_COMMAND "sudo yum -y localinstall http://yum.theforeman.org/nightly/el6/x86_64/foreman-release.rpm 2> /dev/null"
$SSH_COMMAND "sudo yum -y install katello"
$SSH_COMMAND "sudo service iptables stop"
