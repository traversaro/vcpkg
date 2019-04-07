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
    URLS "https://osrf-distributions.s3.amazonaws.com/ign-transport/releases/ignition-transport4-4.0.0.tar.bz2"
    FILENAME "ignition-transport4-4.0.0.tar.bz2"
    SHA512 90facd527e953d3319b4b3b7c5efa610d6c965fcaaf053b8b32039825fccca89c17f153ffec5c0562d4d3d534741f3d6c1a603eb2c75fd5cb217bf22a6d6e503
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
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/ignition-transport4")

# Remove debug files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include 
                    ${CURRENT_PACKAGES_DIR}/debug/lib/cmake
                    ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/ignition-transport4 RENAME copyright)

# Post-build test for cmake libraries
vcpkg_test_cmake(PACKAGE_NAME ignition-transport4)
