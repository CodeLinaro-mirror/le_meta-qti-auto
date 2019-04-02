cmake_minimum_required(VERSION 2.8.9)

project (pppou)

macro(USR_INCLUDE_DIR subdir)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I =/usr/include/${subdir}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I =/usr/include/${subdir}")
endmacro()

# set target name
set(TARGET_NAME pppou)
set(CMAKE_CXX_STANDARD 11)

include_directories(BEFORE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
)

USR_INCLUDE_DIR(qmi-framework)
USR_INCLUDE_DIR(powermanagerqmi)

set(SOURCE_FILES pppou.c)

add_executable (${TARGET_NAME} ${SOURCE_FILES})

target_link_libraries(${TARGET_NAME} qmipowermanager qmi_encdec qmi_cci)

set(EXEC_PERM OWNER_EXECUTE OWNER_WRITE OWNER_READ
              GROUP_EXECUTE GROUP_READ
              WORLD_EXECUTE WORLD_READ)

install(FILES start_pppou_le
             DESTINATION ${CMAKE_INSTALL_PREFIX}/../etc/init.d
             PERMISSIONS ${EXEC_PERM})

install(TARGETS pppou
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
