# inception

## ISO

https://www.bodhilinux.com/download/

in bodhi terminal: right-click -> Settings -> Behaviour -> uncheck "Bell rings"

## VirtualBox VM settings

### General

Linux
Debian (64-bit)

### System

#### Motherboard:
Base Memory 50% of host

#### Processor:
Processor(s) 50% of recommended (green) CPUs

### Display

#### Screen:
Video Memory 100% of host

### Network

#### Adapter 1
Attached to: Bridge Adapter

## Packages Client

sudo apt install -y openssh-client

## Packages Remote Computer

sudo apt update && \
sudo apt install -y \
openssh-server \
docker-compose \
git \
hostsed

Check if ssh is running: ```sudo systemctl status ssh``` has to show "active (running)". Otherwise start it manually via ```sudo systemctl start ssh```.

Determine IP address of remote computer: ```ip a``` (look for inet in eth0)

Check if port 22 is open: ```sudo lsof -i -P -n | grep LISTEN``` has to show ":22 (LISTEN)". If the firewallis blocking it, open it with ```sudo ufw allow 22```. Check via ```sudo ufw status``` (has to show "22 ALLOW".

## Connecting

```ssh remote-computer-username@remote-computer-IP-address```
Are you sure you want to continue connecting? ```yes```
password (doesnt show typing)

## Copy SSH Key for github access

on computer with SSH Key:
```cat ~/.ssh/id_rsa | ssh remote-computer-username@remote-computer-IP-address 'umask 0077; mkdir -p .ssh; cat > .ssh/id_rsa && echo "Private Key copied"'```
```cat ~/.ssh/id_rsa.pub | ssh remote-computer-username@remote-computer-IP-address 'umask 0077; mkdir -p .ssh; cat > .ssh/id_rsa.pub && echo "Public Key copied"'```
