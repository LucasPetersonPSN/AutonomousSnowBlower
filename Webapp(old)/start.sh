#!/bin/bash

#while [ ! -c /dev/ttySCM0 ]; do
#	echo "Waiting for /dev/ttyACM0..."
#	sleep 2
#done

#echo "/dev/ttyACM0 is ready. Starting the server..."

cd /home/jetson/Desktop/Webapp/backend
python3 server.py &

cd /home/jetson/Desktop/Webapp/frontend
python3 -m http.server 8080
