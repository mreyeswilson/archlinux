#!/bin/bash

# install.sh para hacer la instalacion base de arch

# Seteamos el teclado latinoamericano.
loadkeys=la-latin1

# checkeamos el disco
lsblk | grep "sda0"

# creamos la tabla de particiones
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  g # create new GPT partition table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk 
  +100M # 100 MB boot parttion
  n # new partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +8G # 8 GB swap memory
  n # new partition
  3 # partion number 3
    # default, start immediately after preceding partition
  +100G # 100 GB root
  n # new partition
  4 # partion number 4
    # default, start immediately after preceding partition
    # default, end
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Formateamos las particiones
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4

# Montamos la particiones
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir -p /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home


# Instalamos el sistema base y algunas herramientas
pacstrap /mnt linux linux-firmware base base-devel git nano vim sudo bash-completion networkmanager xorg

