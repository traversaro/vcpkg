# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_download_distfile(ARCHIVE
    URLS "https://osrf-distributions.s3.amazonaws.com/ign-math/releases/ignition-math4-4.0.0.tar.bz2"
    FILENAME "ignition-math4-4.0.0.tar.bz2"
    SHA512 a7194c7d758490934f5c4be27ffc463a44027c3634b8eab0bd6764e6ad6785b8cc98f3357337ba924dc7a6bfb209a2286da582e59128862c5d9c044da838cc07
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE} 
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()

# Fix cmake targets location
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/ignition-math4")

# Remove debug files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include 
                    ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/ignition-math4 RENAME copyright)

# Post-build test for cmake libraries
vcpkg_test_cmake(PACKAGE_NAME ignition-math4)
