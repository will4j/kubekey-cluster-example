#!/bin/bash

SHARE_DIR=/data/nfs_share

function set_etc_exports() {
  entry="$1 *(rw,sync,no_subtree_check,no_root_squash)"
  grep -q $1 /etc/exports && sed -i 's|'"$1"'.*|'"$entry"'|g' /etc/exports || echo $entry >> /etc/exports
}

if command -v apt-get >/dev/null; then
  apt install -y nfs-kernel-server
  systemctl start nfs-kernel-server.service
elif command -v yum >/dev/null; then
  yum install -y nfs-utils
  systemctl start nfs-server rpcbind
  systemctl enable nfs-server rpcbind
else
  echo "Current Linux Distro Not Supported"
  exit 1
fi

mkdir -p $SHARE_DIR
chown nobody:nogroup $SHARE_DIR
chmod 777 $SHARE_DIR

set_etc_exports $SHARE_DIR
exportfs -a

if command -v apt-get >/dev/null; then
  systemctl restart nfs-kernel-server.service
else
  systemctl restart nfs
fi
