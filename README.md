# docker-wordpress-nginx-ssh

A Dockerfile that installs the latest wordpress, nginx, php-apc, php-fpm ans openssh.

This is a modified fork from [eugeneware](https://github.com/eugeneware/docker-wordpress-nginx). All credits should go to him.

## Installation

```
$ git clone https://github.com/oskarhane/docker-wordpress-nginx-ssh.git
$ cd docker-wordpress-nginx-ssh
$ sudo docker build -t="docker-wordpress-nginx-ssh" .
```

## Usage

To spawn a new instance of wordpress:

```bash
$ sudo docker run -p 80 -p 22 -d docker-wordpress-nginx-ssh
```

You'll see an ID output like:
```
d404cc2fa27b
```

Use this ID to check the port it's on:
```bash
$ sudo docker port d404cc2fa27b 80 # Make sure to change the ID to yours!
```

This command returns the container ID, which you can use to find the external port you can use to access Wordpress from your host machine:

```
$ docker port <container-id> 80
```

You can the visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:<port>
```

To get the SSH user `wordpress`'s password so you can login and edit files, check the top of the docker container logs for it.

```
$ docker logs <container-id>
```
