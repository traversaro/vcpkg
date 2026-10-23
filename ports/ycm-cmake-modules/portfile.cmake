set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
set(VCPKG_BUILD_TYPE release) # CMake modules only

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO robotology/ycm-cmake-modules
    REF "v${VERSION}"
    SHA512 68410e8e341486a17a2991e5a90a6c9d8b0d9745b09a939393321a8f448ab2fed112b94eb665a5bf9f51b8f6c703c5658ab839d960b666621d470a7e774143a5
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DYCM_NO_3RDPARTY=ON
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH share/cmake/YCM)

vcpkg_install_copyright(FILE_LIST
    "${SOURCE_PATH}/LICENSE"
    "${SOURCE_PATH}/cmake-next/Copyright.txt"
)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
