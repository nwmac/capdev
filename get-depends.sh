#!/bin/bash

echo "Getting repos"

REPOS=(
  "automation:079c01bc68dc30275e51b909a38269cb03014b02"
  "salt:7c41eedc100f7e3bf4b0a208840d5ecf37f2a195"
  "velum:5664b456ef41b5dc5f9fa61e0ec7714ab39a4d9a"
  "caasp-container-manifests:dc67c61146189477543707b327bf533612bbeaab"
)

ORIG_DOMAIN="devenv.caasp.suse.net"
NEW_DOMAIN="devenv.capbristol.com"


function cloneOrUpdate {

  GIT_REPO="https://github.com/kubic-project/$1.git"
  BRANCH=$2
  echo "Git repo: ${GIT_REPO}, commit: ${BRANCH}"

  if [ ! -d ./$1 ]; then
    echo "Cloning: ${GIT_REPO}"
    git clone ${GIT_REPO} -b ${BRANCH}
  else
    echo "Updating: ${GIT_REPO}"
    pushd $1
    git fetch
    git reset --hard HEAD
    git clean -f
    git checkout ${BRANCH}
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

for repo in "${REPOS[@]}" ; do
    REPO=${repo%%:*}
    COMMIT=${repo#*:}
    cloneOrUpdate $REPO $COMMIT
done

# Get caasp automation repos
#cloneOrUpdate automation
#cloneOrUpdate salt
#cloneOrUpdate velum
#cloneOrUpdate caasp-container-manifests

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
