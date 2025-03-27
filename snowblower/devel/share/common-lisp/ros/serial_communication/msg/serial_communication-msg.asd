
(cl:in-package :asdf)

(defsystem "serial_communication-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "ultrasonic_data" :depends-on ("_package_ultrasonic_data"))
    (:file "_package_ultrasonic_data" :depends-on ("_package"))
  ))