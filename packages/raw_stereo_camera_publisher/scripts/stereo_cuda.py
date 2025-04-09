#!/usr/bin/env python2
import cv2
import rospy
import message_filters
from sensor_msgs.msg import Image
from cv_bridge import CvBridge

bridge = CvBridge()

def stereo_callback(left_msg, right_msg):
    left_img = bridge.imgmsg_to_cv2(left_msg, "bgr8")
    right_img = bridge.imgmsg_to_cv2(right_msg, "bgr8")

    # Convert to grayscale
    left_gray = cv2.cvtColor(left_img, cv2.COLOR_BGR2GRAY)
    right_gray = cv2.cvtColor(right_img, cv2.COLOR_BGR2GRAY)

    # Use CUDA StereoBM
    stereo = cv2.cuda.createStereoBM(numDisparities=64, blockSize=9)
    left_cuda = cv2.cuda_GpuMat()
    right_cuda = cv2.cuda_GpuMat()

    left_cuda.upload(left_gray)
    right_cuda.upload(right_gray)

    disparity_cuda = stereo.compute(left_cuda, right_cuda)
    disparity = disparity_cuda.download()

    # Convert disparity to ROS Image and publish
    disparity_msg = bridge.cv2_to_imgmsg(disparity, encoding="32FC1")
    disparity_pub.publish(disparity_msg)

rospy.init_node('stereo_cuda_node')
disparity_pub = rospy.Publisher("/camera/disparity", Image, queue_size=1)

# Use message_filters to synchronize left and right images
left_sub = message_filters.Subscriber("/camera/left/image_raw", Image)
right_sub = message_filters.Subscriber("/camera/right/image_raw", Image)

ts = message_filters.ApproximateTimeSynchronizer([left_sub, right_sub], queue_size=10, slop=0.1)
ts.registerCallback(stereo_callback)

rospy.spin()

