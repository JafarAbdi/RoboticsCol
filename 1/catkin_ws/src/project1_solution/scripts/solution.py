#!/usr/bin/env python  
import rospy

from std_msgs.msg import Int16
from project1_solution.msg import TwoInts

def cb(msg):
    global SumMsg,addPub
    SumMsg = msg.a + msg.b
    addPub.publish(SumMsg)

rospy.init_node('solution')

SumMsg = Int16()
addPub = rospy.Publisher('/sum',Int16,queue_size=1)
Sub = rospy.Subscriber('/two_ints',TwoInts,cb)

rospy.spin()
