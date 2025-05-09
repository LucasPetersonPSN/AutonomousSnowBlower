#!/usr/bin/env python2
import rospy
from std_msgs.msg import String
from serial_communication.msg import serial_data
import serial
import threading
import json

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

pub = None

def callback(data):
    rospy.loginfo("Sent %s to Arduino", data.data)
    ser.write((data.data + "\n").encode('utf-8'))

def read_serial_loop():
    rate = rospy.Rate(15)
    while not rospy.is_shutdown():
        data = ser.readline().decode('utf-8').strip()
        try:
            if data:
                msg = serial_data()
                # Decode the string into JSON Format
                obj = json.loads(data)
                # Assign each variable
                msg.usB = usB = obj["usB"]
                msg.usL = obj["usL"]
                msg.usR = obj["usR"]
                msg.arduinoEStop = obj["arduinoEStop"]
                msg.per40 = obj["per40"]
                msg.per12 = obj["per12"]
                # Publish the message
                pub.publish(msg)
                rate.sleep()
        except ValueError as e:
            rospy.loginfo("Failed to decode JSON: " + str(e))

def main_loop():
    global pub
    rospy.init_node('serial_pubsub', anonymous=True)
    rospy.Subscriber('user_input', String, callback, queue_size=10)
    pub = rospy.Publisher('serial_data', serial_data, queue_size=10)
    rospy.loginfo("Started serial_pubsub node")

    # Start serial reading loop in a thread
    thread = threading.Thread(target=read_serial_loop)
    thread.daemon = True
    thread.start()

    rospy.spin()

if __name__ == '__main__':
    try:
        main_loop()
    except rospy.ROSInterruptException:
        pass

