vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO robotology/ycm
    REF v0.12.2
    SHA512 26ac16b59deb52ae8cc8112fe3071e86fb5be535d74df8e80919a41a32f4c1f5a15783ca8f0d906d7d05cb0c39aab7f73a30e59c004c9c160a02785a8962c5ba
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

include(GNUInstallDirs) # for CMAKE_INSTALL_DATADIR
vcpkg_fixup_cmake_targets(CONFIG_PATH "${CMAKE_INSTALL_DATADIR}/cmake/ycm")

# Remove debug files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

file(COPY ${CURRENT_PORT_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})

# Handle copyright
file(INSTALL ${SOURCE_PATH}/Copyright.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

# Allow empty include directory
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
