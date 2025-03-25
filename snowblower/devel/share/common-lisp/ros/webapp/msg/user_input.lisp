; Auto-generated. Do not edit!


(cl:in-package webapp-msg)


;//! \htmlinclude user_input.msg.html

(cl:defclass <user_input> (roslisp-msg-protocol:ros-message)
  ((direction
    :reader direction
    :initarg :direction
    :type cl:string
    :initform "")
   (speed
    :reader speed
    :initarg :speed
    :type cl:string
    :initform ""))
)

(cl:defclass user_input (<user_input>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <user_input>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'user_input)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name webapp-msg:<user_input> is deprecated: use webapp-msg:user_input instead.")))

(cl:ensure-generic-function 'direction-val :lambda-list '(m))
(cl:defmethod direction-val ((m <user_input>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader webapp-msg:direction-val is deprecated.  Use webapp-msg:direction instead.")
  (direction m))

(cl:ensure-generic-function 'speed-val :lambda-list '(m))
(cl:defmethod speed-val ((m <user_input>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader webapp-msg:speed-val is deprecated.  Use webapp-msg:speed instead.")
  (speed m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <user_input>) ostream)
  "Serializes a message object of type '<user_input>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'direction))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'direction))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'speed))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'speed))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <user_input>) istream)
  "Deserializes a message object of type '<user_input>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'direction) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'direction) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'speed) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'speed) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<user_input>)))
  "Returns string type for a message object of type '<user_input>"
  "webapp/user_input")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'user_input)))
  "Returns string type for a message object of type 'user_input"
  "webapp/user_input")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<user_input>)))
  "Returns md5sum for a message object of type '<user_input>"
  "cfec82bafd42343d86626b1cd93e67da")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'user_input)))
  "Returns md5sum for a message object of type 'user_input"
  "cfec82bafd42343d86626b1cd93e67da")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<user_input>)))
  "Returns full string definition for message of type '<user_input>"
  (cl:format cl:nil "string direction~%string speed~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'user_input)))
  "Returns full string definition for message of type 'user_input"
  (cl:format cl:nil "string direction~%string speed~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <user_input>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'direction))
     4 (cl:length (cl:slot-value msg 'speed))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <user_input>))
  "Converts a ROS message object to a list"
  (cl:list 'user_input
    (cl:cons ':direction (direction msg))
    (cl:cons ':speed (speed msg))
))
