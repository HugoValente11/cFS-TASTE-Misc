#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../opengeode || exit 1
pip install --user --upgrade . || exit 1