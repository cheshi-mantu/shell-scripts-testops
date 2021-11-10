# Full back up and restore of volumes for Allure TestOps deployment

## Aim

To allow easy move of Allure TestOps installation via docker-compose from one machine to other.

## Dependencies

- Cool [yq](https://github.com/mikefarah/yq) tool is used. I could hardcode volumes' names but I didn't
- [Loomchild's volume backup](https://github.com/loomchild/volume-backup) is used to backup and restore the volumes

## How

1. Copy both `backup.sh` and `restore.sh` to the directory with `docker-compose.yml` and `.env`
2. On source machine make `backup.sh` executable like `chmod -x backup.sh`
3. Run `./backup.sh`
4. Copy full directory to target machine
   - `.env` file
   - `docker-compose.yml` file
   - newly created `backup` directory with all archives
   - `backup.sh` and `restore.sh`
5. On target machine  make `restore.sh` executable like `chmod -x restore.sh`
6. Run `./restore.sh`

## Installation of `yq`

[Described here](https://github.com/mikefarah/yq#install)

## Installation of loomchild/volume-backup

Docker will pull the image, you don't need to bother.