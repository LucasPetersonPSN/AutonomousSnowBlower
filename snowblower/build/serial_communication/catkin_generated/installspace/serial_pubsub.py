#!/usr/bin/env python2
import rospy
from std_msgs.msg import String
from serial_communication.msg import ultrasonic_data
import serial

#data = '225/12/43'
ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)
def main_loop():
	pub = rospy.Publisher('raw_ultrasonic_data',ultrasonic_data,queue_size=10)
	rospy.init_node('serial_pubsub', anonymous=True)
	rate = rospy.Rate(15)
	rospy.loginfo("Started serial_pubsub node")
	previousL = 0
	previousR = 0
	previousB = 0
	while not rospy.is_shutdown():
		data = ser.readline().decode('utf-8').strip()
		if data:
			rospy.loginfo(data)
			msg = ultrasonic_data()
			if "L" in data:
				msg.l = previousL = int(data[1:])
				msg.r = previousR
				msg.b = previousB
			if "R" in data:
				msg.l = previousL
				msg.r = previousR = int(data[1:])
				msg.b = previousB
			if "B" in data:
				msg.l = previousL
				msg.r = previousR
				msg.b = previousB = int(data[1:])
			
			pub.publish(msg)
			rate.sleep()

if __name__ == '__main__':
	try:
		main_loop()
	except rospy.ROSInterruptException:
		pass
