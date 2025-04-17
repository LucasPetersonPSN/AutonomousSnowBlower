#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function
import rospy
import cv2
from sensor_msgs.msg import Image, CameraInfo
from cv_bridge import CvBridge, CvBridgeError

def get_left_camera_info():
    cam_info = CameraInfo()
    cam_info.width = 640
    cam_info.height = 480
    cam_info.distortion_model = "plumb_bob"
    cam_info.D = [-0.039602, 0.108813, -0.000909, -0.002740, 0.0]
    cam_info.K = [553.38223, 0.0, 325.31049,
                  0.0, 738.22565, 235.65476,
                  0.0, 0.0, 1.0]
    cam_info.R = [0.99820136, -0.00532355, 0.05971345,
                  0.00557445, 0.99997632, -0.00403594,
                  -0.05969055, 0.00436155, 0.9982074]
    cam_info.P = [528.77433, 0.0, 271.43559, 0.0,
                  0.0, 528.77433, 257.2193, 0.0,
                  0.0, 0.0, 1.0, 0.0]
    return cam_info

def get_right_camera_info():
    cam_info = CameraInfo()
    cam_info.width = 640
    cam_info.height = 480
    cam_info.distortion_model = "plumb_bob"
    cam_info.D = [-0.055511, 0.144900, -0.000295, -0.003473, 0.0]
    cam_info.K = [565.43018, 0.0, 332.60695,
                  0.0, 756.05793, 280.64969,
                  0.0, 0.0, 1.0]
    cam_info.R = [0.99839711, -0.00690663, 0.05617395,
                  0.00667051, 0.99996812, 0.00438983,
                  -0.05620248, -0.00400808, 0.99841135]
    cam_info.P = [528.77433, 0.0, 271.43559, -31.60917,
                  0.0, 528.77433, 257.2193, 0.0,
                  0.0, 0.0, 1.0, 0.0]
    return cam_info

def gstreamer_pipeline(sensor_id=0):
    return (
        "nvarguscamerasrc sensor-id={} ! video/x-raw(memory:NVMM), "
        "width=640, height=480, format=NV12, framerate=15/1 ! "
        "nvvidconv flip-method=0 ! video/x-raw, format=BGRx ! "
        "videoconvert ! video/x-raw, format=BGR ! appsink"
    ).format(sensor_id)

def main():
    rospy.init_node('stereo_camera_publisher', anonymous=True)

    left_image_pub = rospy.Publisher('/stereo_camera/left/image_raw', Image, queue_size=1)
    right_image_pub = rospy.Publisher('/stereo_camera/right/image_raw', Image, queue_size=1)
    left_info_pub = rospy.Publisher('/stereo_camera/left/camera_info', CameraInfo, queue_size=1)
    right_info_pub = rospy.Publisher('/stereo_camera/right/camera_info', CameraInfo, queue_size=1)

    bridge = CvBridge()

    # Open the left and right cameras using GStreamer pipelines.
    left_cam = cv2.VideoCapture(gstreamer_pipeline(sensor_id=1), cv2.CAP_GSTREAMER)
    right_cam = cv2.VideoCapture(gstreamer_pipeline(sensor_id=0), cv2.CAP_GSTREAMER)

    if not left_cam.isOpened():
        rospy.logerr("Failed to open left camera")
    if not right_cam.isOpened():
        rospy.logerr("Failed to open right camera")
        return

    # Create camera info messages
    left_cam_info = get_left_camera_info()
    right_cam_info = get_right_camera_info()

    rate = rospy.Rate(15)  # 30 Hz
    while not rospy.is_shutdown():
        ret_left, left_frame = left_cam.read()
        ret_right, right_frame = right_cam.read()

        if ret_left and ret_right:
            try:
                left_img_msg = bridge.cv2_to_imgmsg(left_frame, "bgr8")
                right_img_msg = bridge.cv2_to_imgmsg(right_frame, "bgr8")
                now = rospy.Time.now()
                left_img_msg.header.stamp = now
                right_img_msg.header.stamp = now
                left_cam_info.header.stamp = now
                right_cam_info.header.stamp = now

                # Set frame IDs for images and camera info
                left_img_msg.header.frame_id = "camera"
                right_img_msg.header.frame_id = "camera"
                left_cam_info.header.frame_id = "camera"
                right_cam_info.header.frame_id = "camera"

                left_image_pub.publish(left_img_msg)
                right_image_pub.publish(right_img_msg)
                left_info_pub.publish(left_cam_info)
                right_info_pub.publish(right_cam_info)
            except CvBridgeError as e:
                rospy.logerr("CvBridge error: %s", e)
        else:
            rospy.logwarn("Failed to capture images from one or both cameras")

        rate.sleep()

    left_cam.release()
    right_cam.release()

if __name__ == '__main__':
    main()

