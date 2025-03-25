
(cl:in-package :asdf)

(defsystem "webapp-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "user_input" :depends-on ("_package_user_input"))
    (:file "_package_user_input" :depends-on ("_package"))
  ))