#!/bin/sh
# add ssh to default lxd image

if [ "X$1" = "X33" ]; then
  image=fedora-33
elif [ "X$1" = "X34" ]; then
  image=fedora-34
elif [ "X$1" = "X35" ]; then
  image=fedora-35
elif [ "X$1" = "X36" ]; then
  image=fedora-36
elif [ "X$1" = "X37" ]; then
  image=fedora-37
elif [ "X$1" = "X8" ]; then
  image=centos-8
else
  image=centos-7
fi
guest=default-$image
template="$image"-nossh
publishalias="$image"

lxc init $template $guest
lxc start $guest
openssl rand -base64 48 | perl -ne 'print "$_" x2' | lxc exec $guest -- passwd root

lxc exec $guest -- dhclient eth0
lxc exec $guest -- ping -c 1 8.8.8.8
if [ "X$1" != "X7" ]; then
  lxc exec $guest -- dnf -y upgrade
  lxc exec $guest -- dnf install -y openssh-server sudo ruby yum-utils
  lxc exec $guest -- dnf install -y python3 python3-pip openssl-devel python36-devel libffi-devel "@Development tools"
  lxc exec $guest -- pip3 install ansible
  lxc exec $guest -- ln -s /usr/bin/pip3 /usr/bin/pip
else
  lxc exec $guest -- yum -y upgrade
  lxc exec $guest -- yum install -y openssh-server sudo ruby yum-utils
fi
lxc exec $guest -- systemctl enable sshd
lxc exec $guest -- systemctl start sshd
lxc exec $guest -- mkdir /root/.ssh || true
lxc exec $guest -- gem install busser

lxc stop $guest --force
lxc publish $guest --alias $publishalias
lxc delete $guest
