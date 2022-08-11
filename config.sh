#/bin/bash

LANG=es_CO.UTF-8
KEYMAP=la-latin1
HOSTNAME=developer
TIMEZONE=America/Bogota

PARTUUID=$(blkid -s PARTUUID -o value /dev/sda3)

ln -s /usr/shared/zoneinfo/$TIMEZONE > /etc/localtime

echo LANG=$LANG > /etc/locale.conf
echo KEYMAP=$KEYMAP > /etc/vconsole.conf
echo $HOSTNAME > /etc/hostname

echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.0.1    $HOSTNAME" >> /etc/hosts

# Instalamos el boot
bootctl --path=/boot install

# Configuramos el boot
echo -e "default arch\neditor 0\ntimeout 0" > /boot/loader/loader.conf
echo -e "title ArchLinux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$PARTUUID rw" > /boot/loader/entries/arch.conf

# Seteamos la contraseña root
passwd

# Agregamos nuevo usuario
useradd -m wil
passwd wil

