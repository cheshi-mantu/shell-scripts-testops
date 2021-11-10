#!/bin/bash

docker-compose down

if [ -e "docker-compose.yml" ]
then
    yq > /dev/null
    if [ "$?" -eq "0" ] 
    then
        echo "Properly shutting down docker-compose via 'down' command"
        docker-compose down

        volumes_list=$(yq eval '.volumes' docker-compose.yml | tr \: " ")
        echo "These will be restored"
        echo "${volumes_list}"
        for volume in ${volumes_list}
        do
            echo "Restoring ${PWD##*/}_${volume} from ./backup dir"
            docker run -v ${PWD##*/}_${volume}:/volume -v ${PWD}/backup:/backup --rm loomchild/volume-backup restore -f ${PWD##*/}_${volume}
        done
        echo "Bringing docker-compose back on-line via 'up -d'"
        docker-compose up -d
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
