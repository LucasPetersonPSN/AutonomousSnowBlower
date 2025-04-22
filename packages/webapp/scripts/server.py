#!/usr/bin/env python2
from SimpleWebSocketServer import SimpleWebSocketServer, WebSocket
import rospy
from std_msgs.msg import String
from sensor_msgs.msg import Image
from webapp.msg import user_input, serial_data
from cv_bridge import CvBridge, CvBridgeError
import cv2
import threading
import base64

connected_clients = []
bridge = CvBridge()

class ControlServer(WebSocket):
    pub = None
    previousSpeed = "25"
    previousDirection = "S"

    def handleMessage(self):
        message = self.data
        rospy.loginfo("Received: " + message)

        msg = user_input()
        if message == "C":
            self.close()
        elif message == "B":
            msg = "Backward"
        elif message == "F":
            msg = "Forward"
        elif message == "R":
            msg = "Right"
        elif message == "L":
            msg = "Left"
        elif message == "S":
            msg = "Stop"
        elif message in ["25", "50", "75", "100"]:
            msg = message
        elif message == "Estop":
            msg = "JetEStop"
        elif message == "JetAllClear":
            msg = "JetAllClear"
        elif message == "BLADES_ON":
            msg = "GoAug"
        elif message == "BLADES_OFF":
            msg = "CeaseAug"
        else:
            rospy.logwarn("Unknown command: " + message)
            return

        rospy.loginfo("Published: " + str(msg))
        if self.pub:
            self.pub.publish(msg)

    def handleConnected(self):
        rospy.loginfo("Client connected: %s", self.address)
        connected_clients.append(self)

    def handleClose(self):
        rospy.loginfo("Client disconnected: %s", self.address)
        if self in connected_clients:
            connected_clients.remove(self)

def camera_callback(msg):
    try:
        cv_image = bridge.imgmsg_to_cv2(msg, desired_encoding='bgr8')
        _, jpeg = cv2.imencode('.jpg', cv_image)
        b64 = base64.b64encode(jpeg.tobytes()).decode('utf-8')
        message = "data:image/jpeg;base64," + b64
        for client in connected_clients:
            try:
                client.sendMessage(message)
            except Exception as e:
                rospy.logwarn("Failed to send image: %s", str(e))
    except CvBridgeError as e:
        rospy.logerr("CvBridge Error: %s", str(e))

def serial_callback(data):
    message = "battery_data:{},{}".format(data.per40, data.per12)
    for client in connected_clients:
        try:
            client.sendMessage(message)
        except Exception as e:
            rospy.logwarn("Failed to send battery data: %s", str(e))

def start_camera_stream():
    rospy.Subscriber("/stereo_camera/left/image_raw", Image, camera_callback)

def start_serial_subscriber():
    rospy.Subscriber("/serial_data", serial_data, serial_callback)

def main_loop():
    rospy.init_node('webapp_node', anonymous=True)
    ControlServer.pub = rospy.Publisher('user_input', String, queue_size=10)

    server = SimpleWebSocketServer("0.0.0.0", 8765, ControlServer)
    rospy.loginfo("WebSocket server started on ws://0.0.0.0:8765")

    threading.Thread(target=start_camera_stream).start()
    threading.Thread(target=start_serial_subscriber).start()

    try:
        server.serveforever()
    except KeyboardInterrupt:
        rospy.loginfo("Shutting down server...")

if __name__ == "__main__":
    try:
        main_loop()
    except rospy.ROSInterruptException:
        pass

