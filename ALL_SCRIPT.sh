#!/bin/bash
set -e
set -o pipefail

deactivate
apt-get update -y
sudo apt-get install -y build-essential software-properties-common curl git git-lfs locales python3-venv python3-pip

sudo apt-get install -y gcc-11 g++-11
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 200
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 200

locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

add-apt-repository -y universe
apt-get update -y

export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

sudo apt-get update -y
sudo apt-get install -y ros-dev-tools
sudo apt-get upgrade -y

sudo apt-get install -y \
  ros-jazzy-desktop \
  python3-colcon-common-extensions \
  ros-jazzy-xacro \
  ros-jazzy-ros2-control \
  ros-jazzy-ros2-controllers \
  ros-jazzy-joint-state-publisher \
  
git clone https://github.com/isaac-sim/IsaacSim.git isaacsim
cd isaacsim
python3 -m venv isaac_venv
source isaac_venv/bin/activate
git lfs install
git lfs pull
./build.sh
cd ..

deactivate
git clone https://github.com/huggingface/lerobot.git
cd lerobot
python3 -m venv lerobot_venv
source lerobot_venv/bin/activate
pip install --upgrade pip
pip install -e .
pip install numpy==1.26.4
