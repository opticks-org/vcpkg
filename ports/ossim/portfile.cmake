vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ossimlabs/ossim
    REF OrchidIsland-2.11.1
    SHA512 ec075e2809d6117b8307f72c31892e351312c227d143c047c8c56b68ce1b6eba68deb49d875d5df0c5a1aefd78fe25ec7fccaa6dcb5b8df9e560445385123e4e
    HEAD_REF dev
    PATCHES 
        vs2017_fix.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND OPTIONS "-DBUILD_SHARED_LIBS=OFF"
                        "-DBUILD_STATIC_LIBS=ON")
else()
    list(APPEND OPTIONS "-DBUILD_SHARED_LIBS=ON"
                        "-DBUILD_STATIC_LIBS=OFF")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DBUILD_OSSIM_APPS=OFF
            -DBUILD_OSSIM_TESTS=OFF
            ${FEATURE_OPTIONS}
            ${OPTIONS}
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_copy_pdbs()
