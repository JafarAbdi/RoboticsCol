#!/usr/bin/env python

from copy import deepcopy
import math
import numpy
import random
from threading import Thread, Lock
import sys

import actionlib
import control_msgs.msg
import geometry_msgs.msg
import moveit_commander
import moveit_msgs.msg
import moveit_msgs.srv
import rospy
import sensor_msgs.msg
import tf
import trajectory_msgs.msg

def convert_to_message(T):
    t = geometry_msgs.msg.Pose()
    position = tf.transformations.translation_from_matrix(T)
    orientation = tf.transformations.quaternion_from_matrix(T)
    t.position.x = position[0]
    t.position.y = position[1]
    t.position.z = position[2]
    t.orientation.x = orientation[0]
    t.orientation.y = orientation[1]
    t.orientation.z = orientation[2]
    t.orientation.w = orientation[3]        
    return t

def convert_from_message(msg):
    R = tf.transformations.quaternion_matrix((msg.orientation.x,
                                              msg.orientation.y,
                                              msg.orientation.z,
                                              msg.orientation.w))
    T = tf.transformations.translation_matrix((msg.position.x, 
                                               msg.position.y, 
                                               msg.position.z))
    return numpy.dot(T,R)

def convert_from_trans_message(msg):
    R = tf.transformations.quaternion_matrix((msg.rotation.x,
                                              msg.rotation.y,
                                              msg.rotation.z,
                                              msg.rotation.w))
    T = tf.transformations.translation_matrix((msg.translation.x, 
                                               msg.translation.y, 
                                               msg.translation.z))
    return numpy.dot(T,R)
   
class Node(object):
    
    def __init__(self,config):
        # config list
        self.config = config
        self.parent = None

    def SetParent(self,parent):
        # Parent Node type
        self.parent = parent

    def GetParent(self):
        return self.parent

    def GetConfig(self):
        return self.config

class MoveArm(object):

    def __init__(self):
        print "Motion Planning Initializing..."
        # Prepare the mutex for synchronization
        self.mutex = Lock()

        # Some info and conventions about the robot that we hard-code in here
        # min and max joint values are not read in Python urdf, so we must hard-code them here
        self.num_joints = 7
        self.q_min = []
        self.q_max = []
        self.q_min.append(-3.1459);self.q_max.append(3.1459)
        self.q_min.append(-3.1459);self.q_max.append(3.1459)
        self.q_min.append(-3.1459);self.q_max.append(3.1459)
        self.q_min.append(-3.1459);self.q_max.append(3.1459)
        self.q_min.append(-3.1459);self.q_max.append(3.1459)
        self.q_min.append(-3.1459);self.q_max.append(3.1459)
        self.q_min.append(-3.1459);self.q_max.append(3.1459)
        # How finely to sample each joint
        self.q_sample = [0.05, 0.05, 0.05, 0.1, 0.1, 0.1, 0.1]
        self.joint_names = ["lwr_arm_0_joint",
                            "lwr_arm_1_joint",
                            "lwr_arm_2_joint",
                            "lwr_arm_3_joint",
                            "lwr_arm_4_joint",
                            "lwr_arm_5_joint",
                            "lwr_arm_6_joint"]

        # Subscribes to information about what the current joint values are.
        rospy.Subscriber("/joint_states", sensor_msgs.msg.JointState, 
                         self.joint_states_callback)

        # Subscribe to command for motion planning goal
        rospy.Subscriber("/motion_planning_goal", geometry_msgs.msg.Transform,
                         self.move_arm_cb)

        # Publish trajectory command
        self.pub_trajectory = rospy.Publisher("/joint_trajectory", trajectory_msgs.msg.JointTrajectory, 
                                              queue_size=1)        

        # Initialize variables
        self.joint_state = sensor_msgs.msg.JointState()

        # Wait for moveit IK service
        rospy.wait_for_service("compute_ik")
        self.ik_service = rospy.ServiceProxy('compute_ik',  moveit_msgs.srv.GetPositionIK)
        print "IK service ready"

        # Wait for validity check service
        rospy.wait_for_service("check_state_validity")
        self.state_valid_service = rospy.ServiceProxy('check_state_validity',  
                                                      moveit_msgs.srv.GetStateValidity)
        print "State validity service ready"

        # Initialize MoveIt
        self.robot = moveit_commander.RobotCommander()
        self.scene = moveit_commander.PlanningSceneInterface()
        self.group_name = "lwr_arm"
        self.group = moveit_commander.MoveGroupCommander(self.group_name) 
        print "MoveIt! interface ready"

        # Options
        self.subsample_trajectory = True
        print "Initialization done."

    def get_joint_val(self, joint_state, name):
        if name not in joint_state.name:
            print "ERROR: joint name not found"
            return 0
        i = joint_state.name.index(name)
        return joint_state.position[i]

    def set_joint_val(self, joint_state, q, name):
        if name not in joint_state.name:
            print "ERROR: joint name not found"
        i = joint_state.name.index(name)
        joint_state.position[i] = q

    """ Given a complete joint_state data structure, this function finds the values for 
    our arm's set of joints in a particular order and returns a list q[] containing just 
    those values.
    """
    def q_from_joint_state(self, joint_state):
        q = []
        for i in range(0,self.num_joints):
            q.append(self.get_joint_val(joint_state, self.joint_names[i]))
        return q

    """ Given a list q[] of joint values and an already populated joint_state, this 
    function assumes that the passed in values are for a our arm's set of joints in 
    a particular order and edits the joint_state data structure to set the values 
    to the ones passed in.
    """
    def joint_state_from_q(self, joint_state, q):
        for i in range(0,self.num_joints):
            self.set_joint_val(joint_state, q[i], self.joint_names[i])

    """ This function will perform IK for a given transform T of the end-effector. It 
    returns a list q[] of 7 values, which are the result positions for the 7 joints of 
    the left arm, ordered from proximal to distal. If no IK solution is found, it 
    returns an empy list.
    """
    def IK(self, T_goal):
        req = moveit_msgs.srv.GetPositionIKRequest()
        req.ik_request.group_name = self.group_name
        req.ik_request.robot_state = moveit_msgs.msg.RobotState()
        req.ik_request.robot_state.joint_state = self.joint_state
        req.ik_request.avoid_collisions = True
        req.ik_request.pose_stamped = geometry_msgs.msg.PoseStamped()
        req.ik_request.pose_stamped.header.frame_id = "world_link"
        req.ik_request.pose_stamped.header.stamp = rospy.get_rostime()
        req.ik_request.pose_stamped.pose = convert_to_message(T_goal)
        req.ik_request.timeout = rospy.Duration(3.0)
        res = self.ik_service(req)
        q = []
        if res.error_code.val == res.error_code.SUCCESS:
            q = self.q_from_joint_state(res.solution.joint_state)
        return q

    """ This function checks if a set of joint angles q[] creates a valid state, or 
    one that is free of collisions. The values in q[] are assumed to be values for 
    the joints of the left arm, ordered from proximal to distal. 
    """
    def is_state_valid(self, q):
        req = moveit_msgs.srv.GetStateValidityRequest()
        req.group_name = self.group_name
        current_joint_state = deepcopy(self.joint_state)
        current_joint_state.position = list(current_joint_state.position)
        self.joint_state_from_q(current_joint_state, q)
        req.robot_state = moveit_msgs.msg.RobotState()
        req.robot_state.joint_state = current_joint_state
        res = self.state_valid_service(req)
        return res.valid
        
    def valid_point_func(self,q_start,q_goal):
        ## inputs : q_start,q_goal Node
        ## outputs : point without colision Node

        step = 0.2
        #### descritize the path
        start_to_goal = q_goal - q_start
        norm_stg = numpy.linalg.norm(start_to_goal)
        unit_stg = start_to_goal/norm_stg
        #n = numpy.max(numpy.abs(unit_stg/self.q_sample))
        #step = (1/n)*unit_stg
        #num_of_points = norm_stg/numpy.linalg.norm(step)
        disc_points = numpy.outer(numpy.arange(step,norm_stg,step),unit_stg) + q_start
        #disc_points = numpy.outer(numpy.arange(1,num_of_points+ 1),step) + q_start
        #print(disc_points)
        past_point = [q_start]
        for disc_point in disc_points:
            #print(self.is_state_valid(disc_point))
            #print(past_point)
            if self.is_state_valid(disc_point) == False:
                return past_point
            past_point = numpy.array([disc_point])
        
        return q_goal

    def motion_plan(self, q_start, q_goal, q_min, q_max):
        #print(q_goal)
        # Replace this with your code
        q_space = numpy.array([q_start],dtype=numpy.float64)
        q_index = []
        # start from the second point
        #V = []
        #E = []
        step = 0.5

        #V.append(Node(q_start.tolist()))

        #for itr in range(100):
        while True:
            #print(itr)
            if numpy.allclose(self.valid_point_func(q_space[-1],q_goal),numpy.array([q_goal])):
                #print(self.valid_point_func(q_space[-1],q_goal))
                #print(numpy.array(q_goal))
                nearest_point = q_space[-1]
                q_index.append(len(q_space)-1)
                q_space = numpy.append(q_space,numpy.array([q_goal]),axis=0)
                
                #node = Node(q_goal)
                # for i in range(len(V)):
                #     if numpy.all(V[i].GetConfig() == nearest_point.tolist()):
                #         parent_node = V[i]
                #         break 
                #node.SetParent(-1)
                #V.append(node)
                break
            
            #### generate random sample 
            q_random = []
            for i in range(self.num_joints):                
                #q_random.append(random.uniform(-1,1)*3.1459)
                q_random.append(random.uniform(-3.1459,3.1459))

            #### find nearest point

            q_random_np = numpy.array([q_random])
            vec_to_points = q_space - q_random_np
            
            index_to_nearest = numpy.argmin(numpy.sqrt(numpy.sum((vec_to_points)**2,axis=1)))
            #print(numpy.sqrt(numpy.sum((vec_to_points)**2)))
            #print(len(vec_to_points))
            nearest_point = q_space[index_to_nearest]

            #### point lies in 0.25 distance from point to the generated point
            nearest_to_random = q_random_np - nearest_point
            norm_ntr = numpy.linalg.norm(nearest_to_random)
            unit_ntr = nearest_to_random/norm_ntr
            # point in directed direction
            next_point = nearest_point + unit_ntr*step

            #### return a valid point
            valid_point = self.valid_point_func(nearest_point,next_point)

            #########################################################################################################
            

            #### append it to the array
            q_space = numpy.append(q_space,valid_point,axis=0)
            q_index.append(index_to_nearest)
            #node = Node(valid_point[0].tolist())
            #for i in range(len(V)):
            #    if numpy.all(V[i].GetConfig() == nearest_point.tolist()):
            #        parent_node = V[i]
            #        break 
            #node.SetParent(parent_node)
            #V.append(node)
            #print(q_space)
        
        #print('X'*50)
        #node = V[-1]
        #print(q_index)
        #print(q_space)
        q_list = []
        cur_index = q_index[-1]
        q_list.append(q_goal)
        for i in range(len(q_space)):
            if  numpy.all(q_space[cur_index] == q_start):        
                q_list.append(q_start.tolist())
                break
            q_list.append(q_space[cur_index].tolist())
            cur_index = q_index[cur_index - 1]
            
        #    q_list.append(node.GetConfig())
        #    node = node.GetParent()
                
        #print(q_start)
        #print(q_goal)
        q_list.reverse()
        #print(q_list)
        return q_list 
    
    
    def create_trajectory(self, q_list, v_list, a_list, t):
        joint_trajectory = trajectory_msgs.msg.JointTrajectory()
        for i in range(0, len(q_list)):
            point = trajectory_msgs.msg.JointTrajectoryPoint()
            point.positions = list(q_list[i])
            point.velocities = list(v_list[i])
            point.accelerations = list(a_list[i])
            point.time_from_start = rospy.Duration(t[i])
            joint_trajectory.points.append(point)
        joint_trajectory.joint_names = self.joint_names
        return joint_trajectory

    def create_trajectory(self, q_list):
        joint_trajectory = trajectory_msgs.msg.JointTrajectory()
        for i in range(0, len(q_list)):
            point = trajectory_msgs.msg.JointTrajectoryPoint()
            point.positions = list(q_list[i])
            joint_trajectory.points.append(point)
        joint_trajectory.joint_names = self.joint_names
        return joint_trajectory

    def project_plan(self, q_start, q_goal, q_min, q_max):
        q_list = self.motion_plan(q_start, q_goal, q_min, q_max)
        joint_trajectory = self.create_trajectory(q_list)
        return joint_trajectory

    def move_arm_cb(self, msg):
        T = convert_from_trans_message(msg)
        self.mutex.acquire()
        q_start = self.q_from_joint_state(self.joint_state)
        #print(self.is_state_valid([0.9332970208293161, 0.7256278570990718, 2.5594325471094663, 1.7652295464395606, 0.4708529716243601, -0.17818698208150993, 0.5357455372788732]))
        print "Solving IK"
        q_goal = self.IK(T)
        if len(q_goal)==0:
            print "IK failed, aborting"
            self.mutex.release()
            return
        print "IK solved, planning"
        trajectory = self.project_plan(numpy.array(q_start), q_goal, self.q_min, self.q_max)
        if not trajectory.points:
            print "Motion plan failed, aborting"
        else:
            print "Trajectory received with " + str(len(trajectory.points)) + " points"
            self.execute(trajectory)
        self.mutex.release()
        
    def joint_states_callback(self, joint_state):
        self.mutex.acquire()
        self.joint_state = joint_state
        self.mutex.release()

    def execute(self, joint_trajectory):
        self.pub_trajectory.publish(joint_trajectory)

if __name__ == '__main__':
    moveit_commander.roscpp_initialize(sys.argv)
    rospy.init_node('move_arm', anonymous=True)
    ma = MoveArm()
    rospy.spin()