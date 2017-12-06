#!/bin/sh
path=$(cd "$(dirname "$0")"; pwd)
cd $path
$QUICK_V3_ROOT/quick/bin/compile_scripts.sh -i ../src -o $2/$1/files/src -m files -e xxtea_chunk -ek RAWSTONE_JNGAME -es 2016