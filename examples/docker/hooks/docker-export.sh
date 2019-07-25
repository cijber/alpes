#!/usr/bin/env bash
. "${CONFIG}";
mkdir -p "${ROOT}/var/alpes/docker";

# Allow the usage of other docker managers e.g. img
docker_exec="${docker_exec:-docker}";

echo "* Pulling images"
# Pull all images first
for image in $docker_import; do
    $docker_exec pull "$image";
done

echo "* Saving images"
$docker_exec save $docker_import | gzip -9 > "${ROOT}/var/alpes/docker/images"

echo "* Importing and enabling alpes-docker service"
cp "${CONFIG_DIR}/docker/files/alpes-docker" "${ROOT}/etc/init.d/alpes-docker";
chmod +x "${ROOT}/etc/init.d/alpes-docker"
chroot "${ROOT}" rc-update add alpes-docker default;
echo "* Fixing our custom docker service"
chmod +x "${ROOT}/etc/init.d/docker"
chroot "${ROOT}" rc-update add docker default;
echo "* Installing our run script"
cp "$docker_run" "${ROOT}/etc/alpes/alpes-docker"
chmod +x "${ROOT}/etc/alpes/alpes-docker"
