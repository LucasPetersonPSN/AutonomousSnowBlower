#!/usr/bin/env python2
from SimpleWebSocketServer import SimpleWebSocketServer, WebSocket
import rospy
from std_msgs.msg import String
from webapp.msg import user_input

class ControlServer(WebSocket):
    pub = None  # Class-level publisher

    def handleMessage(self):
        # The received message is available in self.data
        message = self.data
        rospy.loginfo("Received: " + message)

        msg = user_input()  # Create a new message instance
        if message == "C":
            self.close()
        elif message == "B":
            msg.direction = "Backward"
        elif message == "F":
            msg.direction = "Forward"
        elif message == "R":
            msg.direction = "Right"
        elif message == "L":
            msg.direction = "Left"
        elif message == "S":
            msg.direction = "Stop"
        elif message == "25":
            msg.speed = "25"
        elif message == "50":
            msg.speed = "50"
        elif message == "75":
            msg.speed = "75"
        elif message == "100":
            msg.speed = "100"
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
    ControlServer.pub = rospy.Publisher('user_input', user_input, queue_size=10)
    
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

