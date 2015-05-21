# docker-wordpress-nginx-ssh

[![Join the chat at https://gitter.im/tlongren/docker-wordpress-nginx-ssh](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/tlongren/docker-wordpress-nginx-ssh?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A Dockerfile that installs the latest wordpress, nginx, php-apc and php-fpm, and openssh. Based heavily on [this](https://registry.hub.docker.com/u/oskarhane/docker-wordpress-nginx-ssh/). **NOW INCLUDING A WORKING SSH SETUP!**

###Todo:

1. Tighten permissions up a bit maybe, may not be worth the effort. If anyone has suggestions please [let me know](http://longren.io/contact/).
2. Implement [Docker Compose](https://docs.docker.com/compose/) for a quicker setup.
3. Clean up README.
4. Requests?

## Installation

The easiest way to get this docker image installed is to pull the latest version from the [Docker Hub Registry](https://registry.hub.docker.com/u/tlongren/docker-wordpress-nginx-ssh/):

```bash
$ docker pull tlongren/docker-wordpress-nginx-ssh
```

If you'd like to build the image yourself:

```bash
$ git clone https://github.com/tlongren/docker-wordpress-nginx-ssh.git
$ cd docker-wordpress-nginx-ssh
$ sudo docker build -t="tlongren/docker-wordpress-nginx-ssh"
```

## Usage

The -p 80:80 maps the internal docker port 80 to the outside port 80 of the host machine. The other -p sets up sshd on port 2222.

```bash
$ sudo docker run -p 80:80 -p 2222:22 --name docker-name -d tlongren/docker-wordpress-nginx-ssh
```

Start your newly created container, named *docker-name*.

```
$ sudo docker start docker-name
```

After starting the container docker-wordpress-nginx-ssh checks to see if it has started and the port mapping is correct.  This will also report the port mapping between the docker container and the host machine.

```
$ sudo docker ps

0.0.0.0:80->80/tcp, 3306/tcp, 0.0.0.0:2222->22/tcp
```

You can then visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:80
```

You can also SSH to your container on 127.0.0.1:2222. The default password is *wordpress*, and can also be found in .ssh-default-pass.

```
$ ssh -p 2222 wordpress@127.0.0.1
```

Now that you've got SSH access, you can setup your FTP client the same way, or the SFTP Sublime Text plugin, for easy access to files.


You can view logs like this:

```
$ sudo docker logs docker-name
```