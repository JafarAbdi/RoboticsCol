source /opt/ros/indigo/setup.bash

export ROS_NODE_PORT=`get_free_port.py`
export ROS_MASTER_URI=http://localhost:$ROS_NODE_PORT

lf="ros.log"
if [ -e $lf ]; then
  \rm $lf
fi
touch $lf

echo "Starting roscore with port = $ROS_NODE_PORT..."
( ( (stdbuf -oL roscore -p $ROS_NODE_PORT) 1> >(stdbuf -oL sed 's/^/ROSCORE: /') 2>&1 ) >> $lf ) &

sleep 1

echo "Running web publisher..."
( ( (stdbuf -oL rosrun tf2_web_republisher tf2_web_republisher) 1> >(stdbuf -oL sed 's/^/PUB: /') 2>&1 ) >> $lf ) &

sleep 1

echo "Launching RosBridge server..."
( ( (stdbuf -oL ./launch_rosbridge_server.py) 1> >(stdbuf -oL sed 's/^/BR: /') 2>&1 ) >> $lf ) &

cd catkin_ws
catkin_make
source devel/setup.bash
cd ..

( ( (stdbuf -oL rosrun marker_publisher marker_publisher) 1> >(stdbuf -oL sed 's/^/ASN1: /') 2>&1 ) >> $lf ) &