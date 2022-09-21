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

## Evaluation

### Simple Setup

#### Ensure that NGINX can be accessed by port 443 only

#### Ensure that a SSL/TLS certificate is used

#### Ensure that the WordPress website is properly installed and configured (you shouldn't see the WordPress Installation page).
To access it, open https://login.42.fr in your browser, where login is the login of the evaluated student. You shouldn't be able to access the site via http://login.42.fr.

### Docker Basics

#### Ensure that the Makefile has set up all the services via docker-compose. This means that the containers must have been built using docker-compose and that no crash happened. 

### Docker Network

#### Simple explanation of docker-network

### NGINX with SSL/TLS

#### Try to access the service via http (port 80) and verify that you cannot connect.

#### The use of a TLS v1.2/v1.3 certificate is mandatory and must be demonstrated. The SSL/TLS certificate doesn't have to be recognized.

### WordPress with php-fpm and its volume

#### add a comment using the available WordPress user

#### Sign in with the administrator account to access the Administration dashboard. The Admin username must not include 'admin' or 'Admin'.

#### From the Administration dashboard, edit a page. Verify on the website that the page has been updated.

### MariaDB and its volume

####  explain how to login into the database

#### Ensure that you can't login into the SQL database as root with no password

#### Login into the SQL database with the user account and its password

#### Verify that the database is not empty

### Persistence

#### reboot the virtual machine. Once it has restarted, launch docker-compose again. Then, verify that everything is functional, and that both WordPress and MariaDB are configured. The changes you made previously to the WordPress website should still be here.
