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
    URLS "https://osrf-distributions.s3.amazonaws.com/ign-common/releases/ignition-common-1.1.1.tar.bz2"
    FILENAME "ignition-common-1.1.1.tar.bz2"
    SHA512 3ec16d68c35b1c7d77373eb3ed72304f5a990f57fc15a91f49af49bf0c6b43e6f31e888e4b0a8308cc63840aa995dd423d5b23d28a98f132b4be13c46f5d7d6e
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
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/ignition-common1")

# Remove debug files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include 
                    ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/ignition-common1 RENAME copyright)

# Post-build test for cmake libraries
vcpkg_test_cmake(PACKAGE_NAME ignition-common1)
