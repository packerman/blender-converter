#!/usr/bin/env bash

apt-get update
apt-get install -y git build-essential cmake dos2unix

mkdir -p ~/blender-git
cd ~/blender-git
if ! [ -d blender ]; then
    git clone https://git.blender.org/blender.git
    cd blender
    git checkout v2.80
    git submodule update --init --recursive
    git submodule foreach git checkout master
    git submodule foreach git pull --rebase origin master

    # you can create a new patch by 'git diff > install_deps.sh.patch'
    dos2unix -n /vagrant/install_deps.sh.patch install_deps.sh.patch
    git apply install_deps.sh.patch
fi

cd ~/blender-git
./blender/build_files/build_environment/install_deps.sh --with-opencollada --build-python --force-python --build-numpy --force-numpy --no-confirm

mkdir -p ~/blender-git/build
cd ~/blender-git/build
cmake ../blender \
    -DWITH_PYTHON_INSTALL=OFF \
    -DWITH_PLAYER=OFF \
    -DWITH_PYTHON_MODULE=ON \
    -DWITH_INSTALL_PORTABLE=OFF \
    -DWITH_OPENAL=OFF \
    -DWITH_OPENCOLLADA=ON \
    -DPYTHON_SITE_PACKAGES=/opt/lib/python-3.7/lib/python3.7/site-packages \
    -DPYTHON_ROOT_DIR=/opt/lib/python-3.7

make install

ln -sf /opt/lib/python-3.7/bin/python3.7 /usr/local/bin/python-bpy
echo "Run python-bpy command"