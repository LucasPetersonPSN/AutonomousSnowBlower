source /opt/ros/melodic/setup.bash
source ~/snowblower/devel/setup.bash

roscore &
sleep 5

rosrun serial_communication serial_pubsub.py &
sleep 1

rosrun webapp server.py &
sleep 1

cd ~/snowblower/src/webapp/frontend
python -m SimpleHTTPServer 8080 
