# Install

In this section, we'll configure the installation for SROS2 for the raspberry pi that is included with the Turtlebot3 platform. However, please note that this setup process my be skipped by using the in pre-configured SD card image below:

#### Pre-configured image here [rpi_raspbain_turtlebot3_sros2.img](https://drive.google.com/file/d/11N21FfOptPTLIjoMRWppfzboiv9s85yj/view?usp=sharing)

##### SHA-256: `c765205d62f2532bb40ff7e87e61e4a648ad8ba6648b01748a2f4d25ea895b33`

## Setup

Be sure to read through this document before starting. Should you want to setup the image yourself, follow along with the documentation provided by Robotis.

* Turtlebot3 + ROS2:
  * http://emanual.robotis.com/docs/en/platform/turtlebot3/applications/#ros2
  * Install of `libssl-dev` before building FastRTPSand
  * Be sure to add the cmake flag `-DSECURITY=ON` when compiling

Next you'll want install ROS2 for the armhf target. Note building ROS2 on the target itself is a rather lengthy endeavor, you may wish to compile by chroot'ing into the image using qemu and compiling from your workstation instead. Please see the links in the references for more details.

* ROS2:
  * https://github.com/ros2/ros2/wiki/Installation

## Build

Next we'll need to clone and compile some additional ROS2 packages for the Turtlebot3. The forks used here include some small modifications for demo purposes.


``` shell
# Source ROS2 installation
source ~/ws/ros2/install/setup.bash

mkdir ~/ws/turtlebot3/src
cd ~/ws/turtlebot3/src

git clone https://github.com/ruffsl/hls_lfcd_lds_driver.git --branch sros2_demo --single-branch
git clone https://github.com/ruffsl/turtlebot3.git --branch sros2_demo --single-branch

cd ~/ws/turtlebot3
colcon build --symlink-install
```

## Configure

Now that you have the turtlebot3 workspace setup, you may source it when ever you start a new shell session on the pi. Note that sourcing this workspace may take tens of seconds on the resource limited pi. To check everyting is working so far, try launching rviz2 on your workstation connected to the same network as the turtlebot3, while starting the turtlebot3 bringup launch file on the pi.

You may also wish to change your `ROS_DOMAIN_ID` as to not collide with other ROS2 users on the same network.

``` shell
source ~/ws/ros2/turtlebot3/setup.bash
export ROS_DOMAIN_ID=0 # Can be an integer between 0-233
ros2 launch turtlebot3_bringup turtlebot3_remote.launch.py
```

Be sure to change the reference frame in rviz to something like `base_link`, given that no tf between the `map` and `base_scan` frame_ids may exist.

---

## References:

* [Shrinking images on Linux](https://softwarebakery.com/shrinking-images-on-linux)
* [create image of a USB drive without unallocated partition](https://serverfault.com/a/446540/487984)
* [How do you monitor the progress of dd?](https://askubuntu.com/a/685766/180643)
* [chroot-to-pi.sh](https://gist.github.com/htruong/7df502fb60268eeee5bca21ef3e436eb)
