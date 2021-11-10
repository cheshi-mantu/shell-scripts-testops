#!/bin/bash

if [ -e "docker-compose.yml" ]
then
    yq > /dev/null
    if [ "$?" -eq "0" ] 
    then
        echo "Properly shutting down docker-compose via 'down' command"
        docker-compose down

        volumes_list=$(yq eval '.volumes' docker-compose.yml | tr \: " ")
        echo "These will be backed up"
        echo "${volumes_list}"
        mkdir backup
        for volume in ${volumes_list}
        do
            echo "Backing up ${PWD##*/}_${volume} to ./backup dir"
            docker run -v ${PWD##*/}_${volume}:/volume -v ${PWD}/backup:/backup --rm loomchild/volume-backup backup ${PWD##*/}_${volume}
        done
        echo "Bring docker-compose back on-line if you need via 'up -d'"
        sleep 60
        #docker-compose up -d
    else
        clear        
        echo "You need to install 'yq'"
        echo "Please download and install 'yq' from https://github.com/mikefarah/yq/releases/"
        echo "wget https://github.com/mikefarah/yq/releases/download/v4.14.1/yq_linux_amd64 -O /usr/bin/yq"
        echo "Make 'yq' executable: 'chmod +x /usr/bin/yq'"
    fi
else
    echo "docker-compose.yml is not found in current directory please move this file to docker-compose project dir"
fi
