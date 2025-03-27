#!/usr/bin/env python2
import rospy
from sensor_msgs.srv import SetCameraInfo, SetCameraInfoResponse

def dummy_set_camera_info(req):
    rospy.loginfo("Dummy set_camera_info called")
    # Simply return success without doing anything
    return SetCameraInfoResponse(success=True, status_message="Dummy response")

if __name__ == "__main__":
    rospy.init_node('dummy_camera_info_server')
    # Advertise dummy services for both left and right cameras
    rospy.Service("/camera/left/set_camera_info", SetCameraInfo, dummy_set_camera_info)
    rospy.Service("/camera/right/set_camera_info", SetCameraInfo, dummy_set_camera_info)
    rospy.loginfo("Dummy camera_info services started. They will respond to set_camera_info calls.")
    rospy.spin()
