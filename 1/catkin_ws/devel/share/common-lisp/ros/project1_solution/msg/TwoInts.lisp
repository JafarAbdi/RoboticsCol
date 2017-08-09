; Auto-generated. Do not edit!


(cl:in-package project1_solution-msg)


;//! \htmlinclude TwoInts.msg.html

(cl:defclass <TwoInts> (roslisp-msg-protocol:ros-message)
  ((a
    :reader a
    :initarg :a
    :type cl:fixnum
    :initform 0)
   (b
    :reader b
    :initarg :b
    :type cl:fixnum
    :initform 0))
)

(cl:defclass TwoInts (<TwoInts>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <TwoInts>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'TwoInts)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name project1_solution-msg:<TwoInts> is deprecated: use project1_solution-msg:TwoInts instead.")))

(cl:ensure-generic-function 'a-val :lambda-list '(m))
(cl:defmethod a-val ((m <TwoInts>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader project1_solution-msg:a-val is deprecated.  Use project1_solution-msg:a instead.")
  (a m))

(cl:ensure-generic-function 'b-val :lambda-list '(m))
(cl:defmethod b-val ((m <TwoInts>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader project1_solution-msg:b-val is deprecated.  Use project1_solution-msg:b instead.")
  (b m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <TwoInts>) ostream)
  "Serializes a message object of type '<TwoInts>"
  (cl:let* ((signed (cl:slot-value msg 'a)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'b)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <TwoInts>) istream)
  "Deserializes a message object of type '<TwoInts>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'a) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'b) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<TwoInts>)))
  "Returns string type for a message object of type '<TwoInts>"
  "project1_solution/TwoInts")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'TwoInts)))
  "Returns string type for a message object of type 'TwoInts"
  "project1_solution/TwoInts")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<TwoInts>)))
  "Returns md5sum for a message object of type '<TwoInts>"
  "e01e889cb1a7965611513515df5899bf")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'TwoInts)))
  "Returns md5sum for a message object of type 'TwoInts"
  "e01e889cb1a7965611513515df5899bf")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<TwoInts>)))
  "Returns full string definition for message of type '<TwoInts>"
  (cl:format cl:nil "int16 a~%int16 b~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'TwoInts)))
  "Returns full string definition for message of type 'TwoInts"
  (cl:format cl:nil "int16 a~%int16 b~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <TwoInts>))
  (cl:+ 0
     2
     2
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <TwoInts>))
  "Converts a ROS message object to a list"
  (cl:list 'TwoInts
    (cl:cons ':a (a msg))
    (cl:cons ':b (b msg))
))
