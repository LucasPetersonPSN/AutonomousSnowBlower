; Auto-generated. Do not edit!


(cl:in-package serial_communication-msg)


;//! \htmlinclude ultrasonic_data.msg.html

(cl:defclass <ultrasonic_data> (roslisp-msg-protocol:ros-message)
  ((l
    :reader l
    :initarg :l
    :type cl:fixnum
    :initform 0)
   (r
    :reader r
    :initarg :r
    :type cl:fixnum
    :initform 0)
   (b
    :reader b
    :initarg :b
    :type cl:fixnum
    :initform 0))
)

(cl:defclass ultrasonic_data (<ultrasonic_data>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ultrasonic_data>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ultrasonic_data)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name serial_communication-msg:<ultrasonic_data> is deprecated: use serial_communication-msg:ultrasonic_data instead.")))

(cl:ensure-generic-function 'l-val :lambda-list '(m))
(cl:defmethod l-val ((m <ultrasonic_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader serial_communication-msg:l-val is deprecated.  Use serial_communication-msg:l instead.")
  (l m))

(cl:ensure-generic-function 'r-val :lambda-list '(m))
(cl:defmethod r-val ((m <ultrasonic_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader serial_communication-msg:r-val is deprecated.  Use serial_communication-msg:r instead.")
  (r m))

(cl:ensure-generic-function 'b-val :lambda-list '(m))
(cl:defmethod b-val ((m <ultrasonic_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader serial_communication-msg:b-val is deprecated.  Use serial_communication-msg:b instead.")
  (b m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ultrasonic_data>) ostream)
  "Serializes a message object of type '<ultrasonic_data>"
  (cl:let* ((signed (cl:slot-value msg 'l)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'r)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'b)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ultrasonic_data>) istream)
  "Deserializes a message object of type '<ultrasonic_data>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'l) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'r) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'b) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ultrasonic_data>)))
  "Returns string type for a message object of type '<ultrasonic_data>"
  "serial_communication/ultrasonic_data")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ultrasonic_data)))
  "Returns string type for a message object of type 'ultrasonic_data"
  "serial_communication/ultrasonic_data")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ultrasonic_data>)))
  "Returns md5sum for a message object of type '<ultrasonic_data>"
  "b84b3d698239ad2fd054a4286e165219")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ultrasonic_data)))
  "Returns md5sum for a message object of type 'ultrasonic_data"
  "b84b3d698239ad2fd054a4286e165219")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ultrasonic_data>)))
  "Returns full string definition for message of type '<ultrasonic_data>"
  (cl:format cl:nil "int16 l~%int16 r~%int16 b~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ultrasonic_data)))
  "Returns full string definition for message of type 'ultrasonic_data"
  (cl:format cl:nil "int16 l~%int16 r~%int16 b~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ultrasonic_data>))
  (cl:+ 0
     2
     2
     2
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ultrasonic_data>))
  "Converts a ROS message object to a list"
  (cl:list 'ultrasonic_data
    (cl:cons ':l (l msg))
    (cl:cons ':r (r msg))
    (cl:cons ':b (b msg))
))
