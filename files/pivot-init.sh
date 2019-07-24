#!/bin/busybox sh

fail(){
	echo -e "$1"
	/bin/sh
}

cat <<"EOF"
      _       __                         
     / \     [  |                        
    / _ \     | | _ .--.   .---.  .--.   
   / ___ \    | |[ '/'`\ \/ /__\\( (`\]  
 _/ /   \ \_  | | | \__/ || \__., `'.'.  
|____| |____|[___]| ;.__/  '.__.'[\__) ) 
                 [__|                    
    
    a moonshot really
---
EOF

echo "~ Setting up Alpes"
# Mount psuedo filesystems
mount -t proc -o nosuid,noexec,nodev proc /proc >/dev/null || fail "x Unable to mount /proc"
mount -t sysfs -o nosuid,noexec,nodev sysfs /sys >/dev/null || fail "x Unable to mount /sys"
mount -t devtmpfs -o mode=0755,noexec,nosuid,strictatime devtmpfs /dev >/dev/null || fail "x Unable to mount /dev"
mkdir /dev/pts
mount -t devpts -o gid=5,mode=620,noexec,nosuid devpts /dev/pts >/dev/null || fail "x Unable to mount /dev/pts"
mkdir /dev/shm
mount -t tmpfs -o mode=1777,noexec,nosuid,nodev,strictatime tmpfs /dev/shm >/dev/null || fail "x Unable to mount /dev/shm"
mount -t tmpfs -o mode=0755,nosuid,nodev,strictatime tmpfs /run >/dev/null || fail "x Unable to mount /run"
# Mount /var/lib/docker for speedy containers
mkdir -p /var/lib/docker
mount -t tmpfs -o mode=0755,nosuid,nodev,noatime tmpfs /var/lib/docker >/dev/null || fail "x Unable to mount /var/lib/docker"
echo "~ Initializing random seed..."
cp /var/lib/random-seed /dev/urandom >/dev/null 2>&1 || true
x="$@"
if [ -n "$x" ]; then
  x="[$x]"
fi

echo "~ Starting OpenRC init $x"
exec /sbin/init "$@"