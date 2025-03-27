#!/usr/bin/env python2
from SimpleWebSocketServer import SimpleWebSocketServer, WebSocket
import rospy
from std_msgs.msg import String
from webapp.msg import user_input



class ControlServer(WebSocket):
    pub = None  # Class-level publisher
    previousSpeed = "25"
    previousDirection = "S"
    def handleMessage(self):
        # The received message is available in self.data
        message = self.data
        rospy.loginfo("Received: " + message)

        msg = user_input()  # Create a new message instance
        if message == "C":
            self.close()
        elif message == "B":
            msg = "Backward"
            #msg.direction = self.previousDirection = "Backward"
            #msg.speed = self.previousSpeed
        elif message == "F":
            msg = "Forward"
            #msg.direction = self.previousDirection = "Forward"
            #msg.speed = self.previousSpeed
        elif message == "R":
            msg = "Right"
            #msg.direction = self.previousDirection = "Right"
            #msg.speed = self.previousSpeed
        elif message == "L":
            msg = "Left"
            #msg.direction = self.previousDirection = "Left"
            #msg.speed = self.previousSpeed
        elif message == "S":
            msg = "Stop"
            #msg.direction = self.previousDirection = "Stop"
            #msg.speed = self.previousSpeed
        elif message in ["25","50","75","100"] :
            msg = message
            #msg.speed = self.previousSpeed = "25"
            #msg.direction = self.previousDirection
        #elif message == "50":
            #msg.speed = self.previousSpeed = "50"
            #msg.direction = self.previousDirection
        #elif message == "75":
            #msg.speed = self.previousSpeed =  "75"
            #msg.direction = self.previousDirection
        #elif message == "100":
            #msg.speed = self.previousSpeed = "100"
            #msg.direction = self.previousDirection
        else:
            rospy.logwarn("Unknown command: " + message)
            return  # Exit without publishing
        
        rospy.loginfo("Published: " + str(msg))
        if self.pub:
            self.pub.publish(msg)

    def handleConnected(self):
        rospy.loginfo("Client connected: %s", self.address)

    def handleClose(self):
        rospy.loginfo("Client disconnected: %s", self.address)

def main_loop():
    rospy.init_node('webapp_node', anonymous=True)
    #ControlServer.pub = rospy.Publisher('user_input', user_input, queue_size=10)
    ControlServer.pub = rospy.Publisher('user_input', String, queue_size=10)
    server = SimpleWebSocketServer("0.0.0.0", 8765, ControlServer)
    rospy.loginfo("WebSocket server started on ws://0.0.0.0:8765")

    try:
        server.serveforever()  # This will block, but ROS will still run
    except KeyboardInterrupt:
        rospy.loginfo("Shutting down server...")

if __name__ == "__main__":
    try:
        main_loop()
    except rospy.ROSInterruptException:
        pass
