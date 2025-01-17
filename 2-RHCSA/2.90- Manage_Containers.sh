10-Manage containers
Find and retrieve container images from a remote registry
Inspect container images
Perform container management using commands such as podman and skopeo
Build a container from a Containerfile
Perform basic container management such as running, starting, stopping, and listing running containers
Run a service inside a container
Configure a container to start automatically as a systemd service
Attach persistent storage to a container
As with all Red Hat performance-based exams, configurations must persist after reboot without intervention.



yum module install container-tools
podman - buildah - scopio
rhel9 -> kernel -> cgroups,selinux,namespaces,seccomp
container-tools
podman
scopio - manage container images
buildah - build images
Container is a runtime instances of image

podman image tree httpd:latest
podman image inspect httpd:latest
Config": {
               "User": "1000",
               "Env": [
                    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
               ],
               "Cmd": [
                    "/usr/local/bin/podman_hello_world"

podman container list / podman ps / podman ps -a
podman container run -it httpd (interactive terminal)
podman container run -it httpd /bin/bash
podman container run --name=www -it httpd /bin/bash
podman container start www
podman ps -a
podman container attach www
podman container rm www
podman rmi httpd (remove image)
podman container prune (delete all containers)
podman container run --name=www -dit -p 8080:80 httpd (run it detached)
 cat /etc/subuid
 cat /etc/subgid
 mkdir web/index.html
  chcon -Rvt container_file_t web
changing security context of 'web/index.html'
changing security context of 'web'
# chcon -Rvt container_file_t web
[rupert@x230 ~]$ ls -lZ web/index.html
-rw-r--r--. 1 rupert rupert unconfined_u:object_r:container_file_t:s0 8 May 25 02:29 web/index.html
# [rupert@x230 ~]$ podman unshare chown 33:33 web
[rupert@x230 ~]$ ls -ld web
drwxr-xr-x. 2 100032 100032 24 May 25 02:29 web

# [rupert@x230 ~]$ podman container exec -it www /bin/bash
# root@63e03a5d574d:/usr/local/apache2#  grep www /etc/passwd
/ www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
 root@63e03a5d574d:/usr/local/apache2# exit
[rupert@x230 ~]$ podman ps

CTRL+r reverse search type
podman run container -v /local/dir:/container/dir:Z -d image:latest
# podman container run --name=www -dit -p 8080:80 
 # -v /home/rupert/web:/usr/local/apache2/htdocs httpd
 [rupert@x230 ~]$ !cu (last command which began with cu)
curl localhost:8080
my page

let systemd manage our containers
setsebool -P container_manage_cgroup on

CREATE IMAGE
 mkdir myweb
[rupert@x230 ~]$ cd myweb/
[rupert@x230 myweb]$ vim Dockerfile
           # FROM registry.fedoraproject.org/fedora:33
              RUN yum -y install httpd; yum clean all; systemctl enable httpd;
                RUN echo "Successful Web Server Test" | tee /var/www/html/index.html
                   RUN mkdir /etc/systemd/system/httpd.service.d/; echo -e '[Service]\nRestart=always' | tee /etc/systemd/system/httpd.service.d/httpd.conf
              EXPOSE 80
              CMD [ "/sbin/init" ]
[rupert@x230 myweb]$ podman image build --format=docker -t www-image .
# everytime we write RUN, we create a nested image
podman container run --name=www -dit -p 8080:80 www-image
CONTAINER ID  IMAGE                       COMMAND     CREATED             STATUS             PORTS                 NAMES
9795529d88ea  localhost/www-image:latest  /sbin/init  About a minute ago  Up About a minute  0.0.0.0:8080->80/tcp  www
podman container top www

podman pull docker.io/library/mariadb
 1010  podman ps -a
 1011  podman images
 1012  podman run -d mariadb:latest
 1013  podman ps -a
 1014  podman logs c119acd652fd
 1015  podman run -d -e MARIA_USER=azam -e MARIADB_PASSWORD=azam -e MARIADB_DATABASE=tubbies -e MARIADB_ROOT_PASSWORD=azam1 mariadb:latest
 1016  podman ps
 1017  podman stop harming_germain
 1018  podman stop 03fe1412d3d7
 1019  podman ps
 1020  podman rm 03fe1412d3d7
 1021  podman run -d -p 3306:3306 -e MARIA_USER=azam -e MARIADB_PASSWORD=azam -e MARIADB_DATABASE=tubbies -e MARIADB_ROOT_PASSWORD=azam1 mariadb:latest
 1022  podman ps
 1023  mysql
 1024  ip a
 1025  mariadb -h127.0.0.1 -uazam -pazam -P3306

 # podman exec -l uptime
 podman run --name=ww -dit -p 8080:80 --hostname localhost -v ~/html:/var/www/html:Z q
uay.io/redhattraining/httpd-parent:latest
# podman container exec -it ww cat /var/www/html/index.html


Configure a container to start automatically as a systemd service
# make it persistent enable ROOTLESS
mkdir -p ~/.config/systemd/user
mkdir ~/web
echo "Test Data" > ~/web/text.txt

podman run -dit --hostname localhost --name webit4 -p 8088:80 -v ~/web:/var/www/html:Z docker.io/centos/httpd:latest
  386  podman ps
  387  curl localhost:8088/test.txt
  388
  389  podman generate systemd webit4 > ~/.config/systemd/user/webit4-container.service
  390  # or
       podman generate systemd --name webit4 --files --new
       systemctl --user daemon-reload
  391  systemctl --user status webit4-container.service
  392  systemctl --user enable --now webit4-container.service
  393  ls
  394  ll
  395  vim .config/systemd/
  396  vim .config/systemd/user/webit4-container.service
  add to last line default.service
  397  systemctl --user enable --now webit4-container.service
  398  systemctl --user daemon-reload
  (if error, it means you didnt login withh sshh into user, you just switched user)
  solution --> export XDG_RUNTIME_DIR=run/user/$( id -u)
  399  systemctl --user enable --now webit4-container.service
  400  systemctl --user status webit4-container.service
  # delete podman container before starting systemd container 
  # loginctl enable-linger (start enabled process without even user loging in)
  loginctl disable-linger
  loginctl show-user rupert
  login file = ~/.config/systemd/user


# make it persistent enable for ROOT
podman run -d --name webit -p 8082:80 -v ~/web:/usr/local/apache2/htdocs:Z docker.io/library/httpd:latest
  989  curl localhost:8082
  990  podman generate systemd webit > /etc/systemd/system/webit-container.service
  991  systemctl daemon-reload

  copy # docker.io/library/httpd
  from podman images
  skopeo inspect docker://docker.io/library/httpd


  LAB 
  Q1) create a container as a system startup service
  a) container name = logserver with the images rsyslog stored in docker on paradise user
  b) container should be configured as system startup service
  c) container directory is container_journal should be created on paradise user

  Q2) Configure the container as persistant storage and create logs for container
  a) configure the container with persistent storage mounted on /var/log/journal to /home/paradise/container
  b) the container directory contains all journal files


skopeo inspect docker.io/httpd
TELLS which port to use on a container