vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO robotology/yarp
    REF v3.4.5
    SHA512 b7732f6a324f0268cc10d3e6dad93ddfcb397ed8139a874e2954a6094fb9837ae2a81d05a7243bdbf58d0cda712e32dcf8149bc426ad3e0f2efdecbf4bc1da20
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DYARP_COMPILE_EXECUTABLES=OFF
)

vcpkg_cmake_install()
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle post-build CMake instructions
vcpkg_copy_pdbs()
