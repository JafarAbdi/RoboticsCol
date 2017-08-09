#!/usr/bin/env python  
import rospy

import numpy

import tf
import tf2_ros
import geometry_msgs.msg

def message_from_transform(T):
	msg = geometry_msgs.msg.Transform()
	q = tf.transformations.quaternion_from_matrix(T)
	p = tf.transformations.translation_from_matrix(T)
	msg.translation.x = p[0]
	msg.translation.y = p[1]
	msg.translation.z = p[2]
	msg.rotation.x = q[0]
	msg.rotation.y = q[1]
	msg.rotation.z = q[2]
	msg.rotation.w = q[3]
	return msg

def publish_transforms():
    object_transform = geometry_msgs.msg.TransformStamped()
    object_transform.header.stamp = rospy.Time.now()
    object_transform.header.frame_id = "base_frame"
    object_transform.child_frame_id = "object_frame"
    T_1 = tf.transformations.concatenate_matrices(tf.transformations.quaternion_matrix(tf.transformations.quaternion_from_euler(0.79,0.0,0.79)),tf.transformations.translation_matrix([0.0,1.0,1.0]))
    object_transform.transform = message_from_transform(T_1)
    br.sendTransform(object_transform)
    
    robot_transform = geometry_msgs.msg.TransformStamped()
    robot_transform.header.stamp = rospy.Time.now()
    robot_transform.header.frame_id = "base_frame"
    robot_transform.child_frame_id = "robot_frame"
    T_2 = tf.transformations.concatenate_matrices(tf.transformations.quaternion_matrix(tf.transformations.quaternion_from_euler(0.0,0.0,1.5)),tf.transformations.translation_matrix([0.0,-1.0,0.0]))
    robot_transform.transform = message_from_transform(T_2)
    br.sendTransform(robot_transform)
 
    camera_transform = geometry_msgs.msg.TransformStamped()
    camera_transform.header.stamp = rospy.Time.now()
    camera_transform.header.frame_id = "robot_frame"
    camera_transform.child_frame_id = "camera_frame"
    T_3 = tf.transformations.concatenate_matrices(tf.transformations.translation_matrix([0.0,0.1,0.1]),tf.transformations.quaternion_matrix(tf.transformations.quaternion_from_euler(0.,0.,0.)))
    Tr = tf.transformations.concatenate_matrices(tf.transformations.inverse_matrix(T_3),tf.transformations.inverse_matrix(T_2),T_1)
    p = tf.transformations.translation_from_matrix(Tr)
    dir = numpy.cross(numpy.array([1,0,0]),numpy.array([p[0],p[1],p[2]]))
    theta = numpy.arccos(p[0]/numpy.linalg.norm(numpy.array([p[0],p[1],p[2]])))
    T_3 = tf.transformations.concatenate_matrices(T_3,tf.transformations.rotation_matrix(theta,dir))
    #p = tf.transformations.translation_from_matrix(T_3)
    #theta = numpy.arccos(p[0]/numpy.linalg.norm(numpy.array([p[0],p[1],p[2]])))
    #T_3 = tf.transformations.concatenate_matrices(T_3,tf.transformations.quaternion_matrix(tf.transformations.quaternion_from_euler(theta,0.0,0.0)))
    
    camera_transform.transform = message_from_transform(T_3)
    br.sendTransform(camera_transform)

    # co = geometry_msgs.msg.TransformStamped()
    # co.header.stamp = rospy.Time.now()
    # co.header.frame_id = "camera_frame"
    # co.child_frame_id = "asd" 
    # Tr = tf.transformations.concatenate_matrices(tf.transformations.inverse_matrix(T_3),tf.transformations.inverse_matrix(T_2),T_1)
    # #p = tf.transformations.translation_from_matrix(Tr)
    # #theta = numpy.arccos(p[0]/numpy.linalg.norm(numpy.array([p[0],p[1],p[2]])))
    # co.transform = message_from_transform(Tr)
    # #Tr = tf.transformations.concatenate_matrices(Tr,tf.transformations.quaternion_matrix(tf.transformations.quaternion_from_euler(theta,0.0,0.0)))
    # br.sendTransform(co)
    
    

if __name__ == '__main__':
    rospy.init_node('project2_solution')

    br = tf2_ros.TransformBroadcaster()
    rospy.sleep(0.5)

    while not rospy.is_shutdown():
        publish_transforms()
        rospy.sleep(0.05)
