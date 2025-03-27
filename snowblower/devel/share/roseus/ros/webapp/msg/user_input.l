;; Auto-generated. Do not edit!


(when (boundp 'webapp::user_input)
  (if (not (find-package "WEBAPP"))
    (make-package "WEBAPP"))
  (shadow 'user_input (find-package "WEBAPP")))
(unless (find-package "WEBAPP::USER_INPUT")
  (make-package "WEBAPP::USER_INPUT"))

(in-package "ROS")
;;//! \htmlinclude user_input.msg.html


(defclass webapp::user_input
  :super ros::object
  :slots (_direction _speed ))

(defmethod webapp::user_input
  (:init
   (&key
    ((:direction __direction) "")
    ((:speed __speed) "")
    )
   (send-super :init)
   (setq _direction (string __direction))
   (setq _speed (string __speed))
   self)
  (:direction
   (&optional __direction)
   (if __direction (setq _direction __direction)) _direction)
  (:speed
   (&optional __speed)
   (if __speed (setq _speed __speed)) _speed)
  (:serialization-length
   ()
   (+
    ;; string _direction
    4 (length _direction)
    ;; string _speed
    4 (length _speed)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _direction
       (write-long (length _direction) s) (princ _direction s)
     ;; string _speed
       (write-long (length _speed) s) (princ _speed s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _direction
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _direction (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; string _speed
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _speed (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(setf (get webapp::user_input :md5sum-) "cfec82bafd42343d86626b1cd93e67da")
(setf (get webapp::user_input :datatype-) "webapp/user_input")
(setf (get webapp::user_input :definition-)
      "string direction
string speed

")



(provide :webapp/user_input "cfec82bafd42343d86626b1cd93e67da")


