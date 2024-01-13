#!/bin/bash
if [ $# != 1 ];then
    echo -e "\033[31m please select project::release.sh <am3358 am6254 am5718 stm32h750 h6>. \033[0m"
    exit 0
fi

case $1 in
    "am6254" )
            cmake -B build/$1 -DMY_BOARD=$1 -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=./cmake/$1.cmake -G "Unix Makefiles" -S .
            make  -C build/$1 --no-print-directory
            ;;
    *)
            echo -e "\033[31m The $1 boards will be supported in the future. \033[0m"
            ;;
esac
