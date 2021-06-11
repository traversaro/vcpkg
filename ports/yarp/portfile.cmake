vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO robotology/yarp
    REF v3.4.5
    SHA512 b7732f6a324f0268cc10d3e6dad93ddfcb397ed8139a874e2954a6094fb9837ae2a81d05a7243bdbf58d0cda712e32dcf8149bc426ad3e0f2efdecbf4bc1da20
    HEAD_REF master
)

set(YARP_ADDITIONAL_CMAKE_OPTIONS "")

if(VCPKG_CROSSCOMPILING AND VCPKG_TARGET_IS_UWP)
    # CMake buildsystem of YARP inspect the environment via try_run,
    # for cross-compiling try_run is not available so we need to set the results
    list(APPEND YARP_ADDITIONAL_CMAKE_OPTIONS "-DYARP_FLOAT32_IS_IEC559=1")
    list(APPEND YARP_ADDITIONAL_CMAKE_OPTIONS "-DYARP_FLOAT64_IS_IEC559=1")
    list(APPEND YARP_ADDITIONAL_CMAKE_OPTIONS "-DYARP_DBL_EXP_DIG=4")
    list(APPEND YARP_ADDITIONAL_CMAKE_OPTIONS "-DYARP_FLT_EXP_DIG=3")
    list(APPEND YARP_ADDITIONAL_CMAKE_OPTIONS "-DYARP_LDBL_EXP_DIG=4")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DYARP_COMPILE_EXECUTABLES=OFF
        # vcpkg does not support .dll installed in lib
        -DYARP_DYNAMIC_PLUGINS_INSTALL_DIR="bin/yarp"
        # Workaround as tcpros otherwise is always created
        -DSKIP_tcpros=ON
        -DSKIP_rossrv=ON
        # Temporary, to quickly check compilation
        -DYARP_COMPILE_CARRIER_PLUGINS=OFF
        -DYARP_COMPILE_DEVICE_PLUGINS=OFF
        ${YARP_ADDITIONAL_CMAKE_OPTIONS}
)

vcpkg_cmake_install()
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

# YARP installs a lot of CMake package config files
file(GLOB COMPONENTS_CMAKE_PACKAGE_NAMES
     LIST_DIRECTORIES TRUE
     RELATIVE "${CURRENT_PACKAGES_DIR}/lib/cmake/"
              "${CURRENT_PACKAGES_DIR}/lib/cmake/*")

foreach(COMPONENT_CMAKE_PACKAGE_NAME IN LISTS COMPONENTS_CMAKE_PACKAGE_NAMES)
    vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/${COMPONENT_CMAKE_PACKAGE_NAME}"
                              TARGET_PATH "share/${COMPONENT_CMAKE_PACKAGE_NAME}"
                              DO_NOT_DELETE_PARENT_CONFIG_PATH)
endforeach()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle post-build CMake instructions
vcpkg_copy_pdbs()
