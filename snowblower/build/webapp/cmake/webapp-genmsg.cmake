# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "webapp: 1 messages, 0 services")

set(MSG_I_FLAGS "-Iwebapp:/home/jetson/snowblower/src/webapp/msg;-Istd_msgs:/opt/ros/melodic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(webapp_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/jetson/snowblower/src/webapp/msg/user_input.msg" NAME_WE)
add_custom_target(_webapp_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "webapp" "/home/jetson/snowblower/src/webapp/msg/user_input.msg" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(webapp
  "/home/jetson/snowblower/src/webapp/msg/user_input.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/webapp
)

### Generating Services

### Generating Module File
_generate_module_cpp(webapp
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/webapp
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(webapp_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(webapp_generate_messages webapp_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jetson/snowblower/src/webapp/msg/user_input.msg" NAME_WE)
add_dependencies(webapp_generate_messages_cpp _webapp_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(webapp_gencpp)
add_dependencies(webapp_gencpp webapp_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS webapp_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(webapp
  "/home/jetson/snowblower/src/webapp/msg/user_input.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/webapp
)

### Generating Services

### Generating Module File
_generate_module_eus(webapp
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/webapp
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(webapp_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(webapp_generate_messages webapp_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jetson/snowblower/src/webapp/msg/user_input.msg" NAME_WE)
add_dependencies(webapp_generate_messages_eus _webapp_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(webapp_geneus)
add_dependencies(webapp_geneus webapp_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS webapp_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(webapp
  "/home/jetson/snowblower/src/webapp/msg/user_input.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/webapp
)

### Generating Services

### Generating Module File
_generate_module_lisp(webapp
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/webapp
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(webapp_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(webapp_generate_messages webapp_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jetson/snowblower/src/webapp/msg/user_input.msg" NAME_WE)
add_dependencies(webapp_generate_messages_lisp _webapp_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(webapp_genlisp)
add_dependencies(webapp_genlisp webapp_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS webapp_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(webapp
  "/home/jetson/snowblower/src/webapp/msg/user_input.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/webapp
)

### Generating Services

### Generating Module File
_generate_module_nodejs(webapp
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/webapp
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(webapp_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(webapp_generate_messages webapp_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jetson/snowblower/src/webapp/msg/user_input.msg" NAME_WE)
add_dependencies(webapp_generate_messages_nodejs _webapp_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(webapp_gennodejs)
add_dependencies(webapp_gennodejs webapp_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS webapp_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(webapp
  "/home/jetson/snowblower/src/webapp/msg/user_input.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/webapp
)

### Generating Services

### Generating Module File
_generate_module_py(webapp
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/webapp
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(webapp_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(webapp_generate_messages webapp_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jetson/snowblower/src/webapp/msg/user_input.msg" NAME_WE)
add_dependencies(webapp_generate_messages_py _webapp_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(webapp_genpy)
add_dependencies(webapp_genpy webapp_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS webapp_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/webapp)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/webapp
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(webapp_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/webapp)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/webapp
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(webapp_generate_messages_eus std_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/webapp)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/webapp
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(webapp_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/webapp)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/webapp
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(webapp_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/webapp)
  install(CODE "execute_process(COMMAND \"/usr/bin/python2\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/webapp\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/webapp
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(webapp_generate_messages_py std_msgs_generate_messages_py)
endif()
