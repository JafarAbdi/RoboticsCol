# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "project1_solution: 1 messages, 0 services")

set(MSG_I_FLAGS "-Iproject1_solution:/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg;-Istd_msgs:/opt/ros/kinetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(project1_solution_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg" NAME_WE)
add_custom_target(_project1_solution_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "project1_solution" "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(project1_solution
  "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/project1_solution
)

### Generating Services

### Generating Module File
_generate_module_cpp(project1_solution
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/project1_solution
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(project1_solution_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(project1_solution_generate_messages project1_solution_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg" NAME_WE)
add_dependencies(project1_solution_generate_messages_cpp _project1_solution_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(project1_solution_gencpp)
add_dependencies(project1_solution_gencpp project1_solution_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS project1_solution_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(project1_solution
  "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/project1_solution
)

### Generating Services

### Generating Module File
_generate_module_eus(project1_solution
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/project1_solution
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(project1_solution_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(project1_solution_generate_messages project1_solution_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg" NAME_WE)
add_dependencies(project1_solution_generate_messages_eus _project1_solution_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(project1_solution_geneus)
add_dependencies(project1_solution_geneus project1_solution_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS project1_solution_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(project1_solution
  "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/project1_solution
)

### Generating Services

### Generating Module File
_generate_module_lisp(project1_solution
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/project1_solution
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(project1_solution_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(project1_solution_generate_messages project1_solution_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg" NAME_WE)
add_dependencies(project1_solution_generate_messages_lisp _project1_solution_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(project1_solution_genlisp)
add_dependencies(project1_solution_genlisp project1_solution_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS project1_solution_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(project1_solution
  "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/project1_solution
)

### Generating Services

### Generating Module File
_generate_module_nodejs(project1_solution
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/project1_solution
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(project1_solution_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(project1_solution_generate_messages project1_solution_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg" NAME_WE)
add_dependencies(project1_solution_generate_messages_nodejs _project1_solution_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(project1_solution_gennodejs)
add_dependencies(project1_solution_gennodejs project1_solution_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS project1_solution_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(project1_solution
  "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/project1_solution
)

### Generating Services

### Generating Module File
_generate_module_py(project1_solution
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/project1_solution
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(project1_solution_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(project1_solution_generate_messages project1_solution_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/jafar/Desktop/Courses/RoboticsCol/1/catkin_ws/src/project1_solution/msg/TwoInts.msg" NAME_WE)
add_dependencies(project1_solution_generate_messages_py _project1_solution_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(project1_solution_genpy)
add_dependencies(project1_solution_genpy project1_solution_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS project1_solution_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/project1_solution)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/project1_solution
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(project1_solution_generate_messages_cpp std_msgs_generate_messages_cpp)

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/project1_solution)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/project1_solution
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
add_dependencies(project1_solution_generate_messages_eus std_msgs_generate_messages_eus)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/project1_solution)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/project1_solution
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(project1_solution_generate_messages_lisp std_msgs_generate_messages_lisp)

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/project1_solution)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/project1_solution
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
add_dependencies(project1_solution_generate_messages_nodejs std_msgs_generate_messages_nodejs)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/project1_solution)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/project1_solution\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/project1_solution
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(project1_solution_generate_messages_py std_msgs_generate_messages_py)
