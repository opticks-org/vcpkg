include(vcpkg_common_functions)
vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
vcpkg_from_github (
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gbm19/qwt5-qt5
    REF 0052f96fdd6d5f021f20a1cfc4d2fcfc605941da
    SHA512 1980f7e21684dba36c192a08e1a3bce719dcd7b1e700ce5f8a27821af83a65fe518d078888d6ad3733d3cde1c2af40cd694537ce0193d622d7f0b3bcee1ed55e
    PATCHES static.patch
)

vcpkg_configure_qmake(
    SOURCE_PATH ${SOURCE_PATH}/qwt.pro
    OPTIONS
        CONFIG+=${VCPKG_LIBRARY_LINKAGE}
)

vcpkg_install_qmake(RELEASE_TARGETS release DEBUG_TARGETS debug)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

#Install the header files
file(GLOB HEADER_FILES ${SOURCE_PATH}/src/*.h)
file(INSTALL ${HEADER_FILES} DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
