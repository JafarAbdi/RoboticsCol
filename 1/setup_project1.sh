source /opt/ros/kinetic/setup.bash

export ROS_NODE_PORT=`get_free_port.py`
export ROS_MASTER_URI=http://localhost:$ROS_NODE_PORT

lf="ros.log"
if [ -e $lf ]; then
  \rm $lf
fi
touch $lf

echo "Starting roscore with port = $ROS_NODE_PORT..."
( ( (stdbuf -oL roscore -p $ROS_NODE_PORT) 1> >(stdbuf -oL sed 's/^/ROSCORE: /') 2>&1 ) >> $lf ) &

cd catkin_ws
catkin_make
source devel/setup.bash
rosrun two_int_talker two_int_talker.py &
cd ..
