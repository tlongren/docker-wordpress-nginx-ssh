# docker-wordpress-nginx-ssh
A Dockerfile that installs the latest wordpress, nginx, php-apc and php-fpm, and openssh. Based heavily on [this](https://registry.hub.docker.com/u/oskarhane/docker-wordpress-nginx-ssh/).

###Todo:

1. Add OpenSSH
2. Requests?

## Installation

The easiest way to get this docker image installed is to pull the latest version from the [Docker Hub Registry](https://registry.hub.docker.com/u/tlongren/docker-wordpress-nginx-ssh/):

```bash
$ docker pull tlongren/docker-wordpress-nginx-ssh
```

If you'd like to build the image yourself then:

```bash
$ git clone https://github.com/tlongren/docker-wordpress-nginx-ssh.git
$ cd docker-wordpress-nginx-ssh
$ sudo docker build -t="tlongren/docker-wordpress-nginx-ssh"
```

## Usage

To spawn a new instance of wordpress on port 80.  The -p 80:80 maps the internal docker port 80 to the outside port 80 of the host machine.

```bash
$ sudo docker run -p 80:80 --name docker-name -d tlongren/docker-wordpress-nginx-ssh
```

Start your newly created container, named *docker-name*.

```
$ sudo docker start docker-name
```

After starting the container docker-wordpress-nginx-ssh checks to see if it has started and the port mapping is correct.  This will also report the port mapping between the docker container and the host machine.

```
$ sudo docker ps

0.0.0.0:80 -> 80/tcp docker-name
```

You can the visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:80
```

You can view logs like this:

```
$ sudo docker logs docker-name
```