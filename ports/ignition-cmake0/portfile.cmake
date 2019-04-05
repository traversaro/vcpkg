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
    URLS "https://osrf-distributions.s3.amazonaws.com/ign-cmake/releases/ignition-cmake-0.6.1.tar.bz2"
    FILENAME "ignition-cmake-0.6.1.tar.bz2"
    SHA512 82e01a1a9758148680bb18d312a7e2253eb9dd360845476ade9e2ea306ad1f962e93b9c8949fcacfaa35aeb618595395ba35b8752a8ada0168961a93f34bda4f
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE} 
    # (Optional) A friendly name to use instead of the filename of the archive (e.g.: a version number or tag).
    # REF 1.0.0
    # (Optional) Read the docs for how to generate patches at: 
    # https://github.com/Microsoft/vcpkg/blob/master/docs/examples/patching.md
    # PATCHES
    #   001_port_fixes.patch
    #   002_more_port_fixes.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/ignition-cmake0")

file(GLOB_RECURSE CMAKE_RELEASE_FILES 
                  "${CURRENT_PACKAGES_DIR}/lib/cmake/ignition-cmake0/*")

file(COPY ${CMAKE_RELEASE_FILES} DESTINATION 
           "${CURRENT_PACKAGES_DIR}/share/ignition-cmake0/")

# Remove debug files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

# Remove unneccessary directory 
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib)


# Handle copyright
file(INSTALL ${SOURCE_PATH}/README.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/ignition-cmake0 RENAME copyright)

# Post-build test for cmake libraries 
vcpkg_test_cmake(PACKAGE_NAME ignition-cmake0)

# Permit empty include folder
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
