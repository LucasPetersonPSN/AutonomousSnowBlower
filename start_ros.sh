source /opt/ros/melodic/setup.bash
source ~/snowblower/devel/setup.bash

roscore &
sleep 5

rosrun serial_communication serial_pubsub.py &
sleep 1

rosrun webapp server.py &
sleep 1

cd ~/snowblower/src/webapp/frontend
python -m SimpleHTTPServer 8080 &
sleep 2

cd ~/snowblower

rosrun raw_stereo_camera_publisher raw_video_publisher.py &
sleep 5

ROS_NAMESPACE=/stereo_camera rosrun stereo_image_proc stereo_image_proc &
sleep 5

#rosrun tf static_transform_publisher 0.4445 0.1143 0.3556 -1.5708 0 -1.5708 base_link camera_link 100 
#sleep 1

#rosrun tf2_ros static_transform_publisher 0 -0.03 0 0 0 0 1 camera_link left_camera 
#sleep 1

#rosrun tf2_ros static_transform_publisher 0 0.03 0 0 0 0 1 camera_link right_camera 
#sleep 1

#rosrun tf2_ros static_transform_publisher 0 0 0 0 0 0 1 camera_link camera 
#sleep 1

