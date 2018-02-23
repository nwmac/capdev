#!/bin/bash

echo "Getting repos"

BRANCH=release-2.0

ORIG_DOMAIN="devenv.caasp.suse.net"
NEW_DOMAIN="devenv.capbristol.com"


function cloneOrUpdate {

  GIT_REPO="https://github.com/kubic-project/$1.git"

  echo "Git repo: ${GIT_REPO}"

  if [ ! -d ./$1 ]; then
    echo "Cloning: ${GIT_REPO}"
    git clone ${GIT_REPO} -b ${BRANCH}
  else
    echo "Updating: ${GIT_REPO}"
    pushd $1
    git fetch
    git reset --hard HEAD
    git clean -f
    git rebase
    popd
  fi	
}

function patchFile {
  FILE=$1
  echo "Patching ${FILE}"
  sed -i.bak "s@${ORIG_DOMAIN}@${NEW_DOMAIN}@g" ${FILE}
}

if [ -d ./automation/downloads ]; then
  mkdir -p .downloads
  cp -R ./automation/downloads .downloads
fi

# Get caasp automation repos
cloneOrUpdate automation
cloneOrUpdate salt
cloneOrUpdate velum
cloneOrUpdate caasp-container-manifests

# Patch files for our names

patchFile "./automation/caasp-kvm/cluster.tf"
patchFile "./automation/caasp-kvm/cloud-init/admin.cfg"
patchFile "./automation/caasp-kvm/tools/generate-environment"

sed -i.bak "s@kube-api-x\${masters}@kube-api@g" ./automation/caasp-kvm/tools/generate-environment

if [ -d .downloads ]; then
  mkdir -p ./automation/downloads
  cp -R .downloads ./automation/downloads
  rm -rf .downloads
fi
