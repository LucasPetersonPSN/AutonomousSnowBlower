;; Auto-generated. Do not edit!


(when (boundp 'serial_communication::ultrasonic_data)
  (if (not (find-package "SERIAL_COMMUNICATION"))
    (make-package "SERIAL_COMMUNICATION"))
  (shadow 'ultrasonic_data (find-package "SERIAL_COMMUNICATION")))
(unless (find-package "SERIAL_COMMUNICATION::ULTRASONIC_DATA")
  (make-package "SERIAL_COMMUNICATION::ULTRASONIC_DATA"))

(in-package "ROS")
;;//! \htmlinclude ultrasonic_data.msg.html


(defclass serial_communication::ultrasonic_data
  :super ros::object
  :slots (_l _r _b ))

(defmethod serial_communication::ultrasonic_data
  (:init
   (&key
    ((:l __l) 0)
    ((:r __r) 0)
    ((:b __b) 0)
    )
   (send-super :init)
   (setq _l (round __l))
   (setq _r (round __r))
   (setq _b (round __b))
   self)
  (:l
   (&optional __l)
   (if __l (setq _l __l)) _l)
  (:r
   (&optional __r)
   (if __r (setq _r __r)) _r)
  (:b
   (&optional __b)
   (if __b (setq _b __b)) _b)
  (:serialization-length
   ()
   (+
    ;; int16 _l
    2
    ;; int16 _r
    2
    ;; int16 _b
    2
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int16 _l
       (write-word _l s)
     ;; int16 _r
       (write-word _r s)
     ;; int16 _b
       (write-word _b s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int16 _l
     (setq _l (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int16 _r
     (setq _r (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int16 _b
     (setq _b (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;;
   self)
  )

(setf (get serial_communication::ultrasonic_data :md5sum-) "b84b3d698239ad2fd054a4286e165219")
(setf (get serial_communication::ultrasonic_data :datatype-) "serial_communication/ultrasonic_data")
(setf (get serial_communication::ultrasonic_data :definition-)
      "int16 l
int16 r
int16 b

")



(provide :serial_communication/ultrasonic_data "b84b3d698239ad2fd054a4286e165219")


