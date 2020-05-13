#!/bin/bash
source ~/.bashrc
set -e
export GIT_SSL_NO_VERIFY=true 
export TASTE_IN_DOCKER=1 
apt install -y --force-yes xvfb 
Xvfb & 
git fetch
git checkout -f "${CI_COMMIT_BRANCH}" 
./Update-TASTE.sh
cd dmt
git log | head
/etc/init.d/postgresql start 
./configure
pip3 install --upgrade .
pip3 uninstall --yes typing 
PATH=$PATH:/asn1scc/ LANG=C LC_ALL=C make
cd ..
cd kazoo 
export DISPLAY=:0 
make test || exit 1
cd ..
cd opengeode
make test-ada || exit 1
