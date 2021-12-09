# Full back up and restore of volumes for Allure TestOps deployment

## Aim

To allow easy move of Allure TestOps installation via docker-compose from one machine to other.

## Dependencies

- Cool [yq](https://github.com/mikefarah/yq) tool is used. I could hardcode volumes' names but I didn't
- [Loomchild's volume backup](https://github.com/loomchild/volume-backup) is used to backup and restore the volumes

## How

1. Copy both `vbackup.sh` and `vrestore.sh` to the directory with `docker-compose.yml` and `.env`
2. On source machine make `vbackup.sh` executable like `chmod -x vbackup.sh`
3. Run `./vbackup.sh`
4. Copy full directory to target machine
   - `.env` file
   - `docker-compose.yml` file
   - newly created `backup` directory with all archives
   - `vbackup.sh` and `vrestore.sh`
5. On target machine  make `vrestore.sh` executable like `chmod -x vrestore.sh`
6. Execute `docker login --username qametaaccess`, enter your password.
7. Execute `docker-compose up -d`
8. Wait till Allure TestOps is fully up and running.
   - give it 2-3 minutes to start up
   - check the readiness: `clear && docker-compose logs | grep "is running!"`
   - you must see 3 lines 
9.  Run `./vrestore.sh`

## Installation of `yq`

[Described here](https://github.com/mikefarah/yq#install)

## Installation of loomchild/volume-backup

Docker will pull the image, you don't need to bother.