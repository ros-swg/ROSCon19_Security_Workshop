# SROS2 Tutorial

In this tutorial, we'll walk through the setup and demonstrate the use of SROS2 using the Turtlebot3 platform from Robotis.

## Installation and Setup

Read the `INSTALL.md` for setup instructions to configure your Turtlebot image.


## Provisioning Security artifacts

To gather the necessary security artifacts for using Secure DDS, i.e. the signed permission files, identity certificates and Certificate Authorities (CA), clone the demo keystore onto your workstaion and turtlebot.

``` shell
cd ~/
git clone https://github.com/ruffsl/keymint_ws.git --branch sros2_demo --single-branch
```

You can also germinate new keys using a new CAs as well. To quickly do this, we can use the Kemint CLI tool within a docker container on your workstation to update the local keystore. Not that you will need to re-sync the necessary public CA certs and updated key with turtlebot, say via ssh or rsync.

``` shell
export KEYMINT_WS=$HOME/keymint_ws
mkdir $KEYMINT_WS
docker run -it --rm \
    --workdir=$KEYMINT_WS \
    --volume=$KEYMINT_WS:$KEYMINT_WS:rw \
    --user=`id -u $USER` \
    keymint/keymint_tools

keymint keystore init # initializes new CAs
for f in src/*
do
  keymint keystore build_pkg $f
done
exit
```

## Running SROS2

To use ROS2 to secure the existing turtlebot demo, we'll set the necessary environmental variables on both the workstation and the turtlebot before launching the turtlebot bringup on the pi and rviz on the wrokstation

> On both systems

``` shell
source $HOME/ws/turtlebot3/install/setup.bash
export ROS_DOMAIN_ID=0
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export ROS_SECURITY_ROOT_DIRECTORY=$HOME/keymint_ws/install
export ROS_SECURITY_ENABLE=true
export ROS_SECURITY_STRATEGY=Enforce
```

> On the turtlebot
> Note we silence stdout due to a current issue with FastRTPS warnings

``` shell
ros2 launch turtlebot3_bringup turtlebot3_remote.launch.py > /dev/null 2>&1
```

> One the workstation

``` shell
rviz2
```

To switch back and disable security, simple update `ROS_SECURITY_ENABLE`:

``` shell
export ROS_SECURITY_ENABLE=false
```

## Keymint and ComArmor

For more information on Keymint and ComArmor, the supplemental development tools used to simplify the keystore setup, checkout the projects here:

 * [Keymint](https://github.com/keymint/keymint_tools)
 * [ComArmor](https://github.com/ComArmor/comarmor)
