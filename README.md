# my-first-docker-infrastructure
A small Docker infrastructure using NGINX to host a WordPress website. The goal of this project is to learn more about system administration. Inspired by the "42 Coding School" exercise "inception" (September 2022).</br>

##### _Diagram of the expected result:_
![grafik](https://user-images.githubusercontent.com/80413516/198715174-a8e484d7-c660-488f-ad47-723028cede52.png)
</br></br>

## Table of contents
* [Introduction](#introduction)
  * [General rules](#general-rules)
  * [Description](#description)
* [Prerequisites](#prerequisites)
* [How to launch](#how-to-launch)
* [Notes](#notes)
</br>

## Introduction
###### <p align="right">Next: [Prerequisites](#prerequisites)&emsp;&emsp;[[Contents](#table-of-contents)]</p>

### General rules
 * the containers must be built from the penultimate stable version of Alpine Linux or from Debian Buster
 * the use of already made Docker images (e.g. from DockerHub) is not allowed (except for Alpine or Debian)
 * write one Dockerfile for each service
 * the Dockerfiles must be called in a docker-compose.yml by the Makefile
 * the containers have to restart in case of a crash
 * configure the domain name to point to the local IP address
 
### Description
Setup the infrastructure as shown in the [diagram](#diagram-of-the-expected-result):</br>

 * container with NGINX with TLSv1.2 or TLSv1.3
 * container with WordPress and php-fpm (it must be installed and configured) without NGINX!
 * container with MariaDB without NGINX!
 * volume that contains the WordPress database
 * volume that contains your WordPress website files
 * network that establishes the connection between the containers

</br></br>

## Prerequisites
###### <p align="right">Next: [How to launch](#how-to-launch)&emsp;Previous: [Introduction](#introduction)&emsp;&emsp;[[Contents](#table-of-contents)]</p>

* gcc (```sudo apt-get install gcc```)
* make (```sudo apt-get install make```)
* ssh (```sudo apt install openssh-server```)
* docker-compose (```sudo apt install docker-compose```)
* hostsed (```sudo apt install hostsed```)

</br></br>

## How to launch
###### <p align="right">Next: [Notes](#notes)&emsp;Previous: [Prerequisites](#prerequisites)&emsp;&emsp;[[Contents](#table-of-contents)]</p>
You can edit the variables at the top of the Makefile to customize the docker infrastructure. For example you could change the port for WordPress from ```9000``` to ```9001``` by changing the line ```WORDPRESS_PORT=9000``` to ```WORDPRESS_PORT=9001```. The default values for the user credentials can be deleted or commented out, to not have them apear as plain text. In this case you will get prompted for them later in the process.
</br>
When you are done editing or don't want to make any changes, use the command ```make``` in the root directory of the repository. It will automatically run ```make init```, which will create the .env and config files and ```make start``` which will launch the docker-compose file. If you have removed any of the default user credentials from the Makefile you will now be prompted for the missing information.
</br>
When the docker containers are running, you can open the website from you host machine by entering the domain (by default: ```aenglert.42.fr```) into your browser. This works because the domain gets added to the host addresses and redirects to the loopback address. Alternatively you could also use ```localhost``` or the loopback address (```127.0.0.1```) itself.
</br>
At first you will get a warning from your browser because of the self signed certificate. You will have to tell your browser that you want to open the page anyway (usually something like ```advanced -> accept risk```). Now you can surf the website (it's just the default WordPress example site). You could now go to https://aenglert.42.fr/wp-admin/ and login with the WordPress user or admin credentials and edit the website.
</br>
Use ```make stop``` to stop the running docker containers and take down the website. Start them again by using ```make start```. ```make clean``` will remove all the created docker images and ```make fclean``` will remove all the created docker images as well as the created volumes (if you made changes to the website they will be lost, as it will get deleted). It will also remove the domain from the host addresses.


</br></br>

## Notes
###### <p align="right">Previous: [How to launch](#how-to-launch)&emsp;&emsp;[[Contents](#table-of-contents)]</p>
ATTENTION! In a real scenario you should never have security sensitive information like for example the user credentials as plain text in the Makefile! You should comment out or delete the respective lines from the Makefile to get prompted for you custom credentials.
