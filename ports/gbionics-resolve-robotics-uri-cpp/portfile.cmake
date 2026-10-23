set(VCPKG_BUILD_TYPE release) # header-only

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gbionics/resolve-robotics-uri-cpp
    REF "v${VERSION}"
    SHA512 c78d5441332ce466933957169f80c1ec48ebe9fc7468a4b3399c6ad693a90317d0f39f092670ea5cf0658781beb981232e439db4253fe44d7368683cb08c1654
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DRRUC_BUILD_TOOL=OFF
        -DRRUC_INSTALL=ON
        -DRRUP_USE_SYSTEM_YCM=ON
        "-DYCM_DIR=${CURRENT_HOST_INSTALLED_DIR}/share/ycm-cmake-modules"
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(
    PACKAGE_NAME ResolveRoboticsURICpp
    CONFIG_PATH lib/cmake/ResolveRoboticsURICpp
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
