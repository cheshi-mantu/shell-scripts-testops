#!/bin/bash
# available options for *ux
#  allurectl_darwin_amd64
#  allurectl_linux_386
#  allurectl_linux_amd64
#  allurectl_linux_arm64

logfile=allurectl-update.log

TIME_STAMP=$(date +%Y%m%d-%H%M%S)
CURRENT_OS=$(uname -s)
OS_BITS=$(uname -m)
BINARY="allurectl"
CURRENT_VERSION=$(./${BINARY} --version)

echo "${TIME_STAMP} Current version is ${CURRENT_VERSION}" | tee -a ${logfile}

if [ ${CURRENT_OS} = "Linux" ]; then
        BINARY=${BINARY}"_linux_"
    if [ ${OS_BITS} = "x86_64" ]; then
        BINARY="${BINARY}amd64"
    elif [ ${OS_BITS} = "aarch64" ]; then
        BINARY="${BINARY}arm64"
    else
        BINARY="${BINARY}386"
    fi
elif [ ${CURRENT_OS} = "Darwin" ]; then
    BINARY=${BINARY}"_darwin_amd64"
fi

echo "${TIME_STAMP} checking if ${BINARY} exists in latest release stream" | tee -a ${logfile}

wget --spider "https://github.com/allure-framework/allurectl/releases/latest/download/${BINARY}"

if [ $? -eq 0 ]; then
    echo "Binary exists, downloading"
    
    wget "https://github.com/allure-framework/allurectl/releases/latest/download/${BINARY}"
    chmod +x ${BINARY}
    UPDATED_VERSION=$(./${BINARY} --version)
    
    if [ "${CURRENT_VERSION}" = "${UPDATED_VERSION}" ]; then
        echo "No updated version available. Skipping." | tee -a ${logfile}
        rm ${BINARY}
        echo "${TIME_STAMP} existing ${CURRENT_VERSION} is the same as the update ${UPDATED_VERSION}" | tee -a ${logfile}
    else
        echo "$(date +%Y%m%d-%H%M%S) Removing previous version" | tee -a ${logfile}
        rm allurectl
        mv ${BINARY} allurectl
        echo "${TIME_STAMP} upgrated ${CURRENT_VERSION} >> ${UPDATED_VERSION}" | tee -a ${logfile}
        echo "Just in case $(./allurectl --version)" | tee -a ${logfile}
        echo "############## weeee ####################"  | tee -a ${logfile}
    fi
fi
