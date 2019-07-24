# Alpes

> _**Montes Alpes** is a mountain range in the northern part of the Moon's near side. It was named after the Alps in Europe._

---

An _alpine in an initrd_ provisioner.

## Building

```bash
sudo ./alpes
ls ./out
```

## Running

```bash
kernel="[put your wanted kernel here]"
qemu-system-x86_64 \
    -kernel $kernel \
    -initrd out/initrd \
    -append 'console=ttyS0 root=yolo debug loglevel=7 ro' \
    -nographic \
    -m 1G \
    -net nic \
    -net user
```

## Config (`alpes-config`)

```bash
# Packages that should be installed
pkgs="alpine-base bash util-linux bind-tools shadow coreutils docker iptables rng-tools"
# Alpine version
version="v3.10"
# rootfsversion
rootfsversion="3.10.1"
# Location to copy /lib/modules from
modules="/dev/empty"
```