# my-first-docker-infrastructure
A small Docker infrastructure using NGINX to host a WordPress website. The goal of this project is to learn more about system administration. Inspired by the "42 Coding School" exercise "inception" (September 2022).</br>

##### _Diagram of the expected result:_
![grafik](https://user-images.githubusercontent.com/80413516/198715174-a8e484d7-c660-488f-ad47-723028cede52.png)
</br>

## Table of contents
* [Introduction](#introduction)
  * [General rules](#general-rules)
  * [Description](#description)
* [Prerequisites](#prerequisites)
* [How to launch](#how-to-launch)
* [Resources](#resources)
* [Notes](#notes)

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
Setup as shown in the [diagram](#diagram-of-the-expected-result):</br>

 * container with NGINX with TLSv1.2 or TLSv1.3
 * container with WordPress and php-fpm (it must be installed and configured) without NGINX!
 * container with MariaDB without NGINX!
 * volume that contains the WordPress database
 * volume that contains your WordPress website files
 * network that establishes the connection between the containers

</br></br></br>

## Prerequisites
###### <p align="right">Next: [How to launch](#how-to-launch)&emsp;Previous: [Introduction](#introduction)&emsp;&emsp;[[Contents](#table-of-contents)]</p>
"Text for Prerequisites"
</br></br></br>

## How to launch
###### <p align="right">Next: [Resources](#resources)&emsp;Previous: [Prerequisites](#prerequisites)&emsp;&emsp;[[Contents](#table-of-contents)]</p>
"Text for How to launch"
</br></br></br>

## Resources
###### <p align="right">Next: [Notes](#notes)&emsp;Previous: [How to launch](#how-to-launch)&emsp;&emsp;[[Contents](#table-of-contents)]</p>
"Text for Resources"
</br></br></br>

## Notes
###### <p align="right">Previous: [Resources](#resources)&emsp;&emsp;[[Contents](#table-of-contents)]</p>
"Text for Notes"
</br></br></br>
