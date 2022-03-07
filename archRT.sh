#!/bin/bash

# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts
CONFIGS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/configs
set +a
echo -ne "
-------------------------------------------------------------------------
      _____             _     ______ _______ 
    (   _   )          | |   (_____ (_______)
    | ( _ ) | ____ ____| |__  _____) )  _    
    |  ___  |/ ___) ___)  _ \|  __  /  | |   
    | |   | | |  ( (___| | | | |  \ \  | |   
    |_|   |_|_|   \____)_| |_|_|   |_| |_|   
                                       
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Scripts are in directory named ArchRT
"
    ( bash $SCRIPT_DIR/scripts/startup.sh )|& tee startup.log
      source $CONFIGS_DIR/setup.conf
    ( bash $SCRIPT_DIR/scripts/0-preinstall.sh )|& tee 0-preinstall.log
    ( arch-chroot /mnt $HOME/ArchRT/scripts/1-setup.sh )|& tee 1-setup.log
    if [[ ! $DESKTOP_ENV == server ]]; then
      ( arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/ArchRT/scripts/2-user.sh )|& tee 2-user.log
    fi
    ( arch-chroot /mnt $HOME/ArchRT/scripts/3-post-setup.sh )|& tee 3-post-setup.log
    cp -v *.log /mnt/home/$USERNAME

echo -ne "
-------------------------------------------------------------------------
      _____             _     ______ _______ 
    (   _   )          | |   (_____ (_______)
    | ( _ ) | ____ ____| |__  _____) )  _    
    |  ___  |/ ___) ___)  _ \|  __  /  | |   
    | |   | | |  ( (___| | | | |  \ \  | |   
    |_|   |_|_|   \____)_| |_|_|   |_| |_|   
                                       
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
-------------------------------------------------------------------------
                Done - Please Eject Install Media and Reboot
"
