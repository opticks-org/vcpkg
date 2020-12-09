vcpkg_fail_port_install(ON_TARGET "UWP")
set(VCPKG_POLICY_ALLOW_RESTRICTED_HEADERS enabled)

vcpkg_download_distfile(
    distfile
    URLS https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/CMake-hdf-4.2.15.zip
    FILENAME CMake-hdf-4.2.15.zip
    SHA512 8cc5fc89a0baca493b1bfb70f151e18b243de302b40395f2a928f12fa8284605080be3eca6031a0733cce65649ac3c291a39dd3c9423a1aec2fac143ea55c04b
)

vcpkg_extract_source_archive(
    ${distfile}
)

if ("fortran" IN_LIST FEATURE)
    message(WARNING "Fortran is not yet official supported within VCPKG. Build will most likly fail if ninja 1.10 and a Fortran compiler are not available.")
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
   FEATURES # <- Keyword FEATURES is required because INVERTED_FEATURES are being used
     szip         HDF4_ENABLE_SZIP_SUPPORT
     zlib         HDF4_ENABLE_Z_LIB_SUPPORT
     netcdf       HDF4_ENABLE_NETCDF
     fortran      HDF4_BUILD_FORTRAN
)

if(NOT VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND FEATURE_OPTIONS
                    -DBUILD_STATIC_LIBS=OFF
                    -DONLY_SHARED_LIBS=ON)
endif()

find_library(SZIP_RELEASE NAMES libsz libszip szip sz PATHS "${CURRENT_INSTALLED_DIR}/lib" NO_DEFAULT_PATH)
find_library(SZIP_DEBUG NAMES libsz libszip szip sz libsz_D libszip_D szip_D sz_D szip_debug PATHS "${CURRENT_INSTALLED_DIR}/debug/lib" NO_DEFAULT_PATH)

vcpkg_configure_cmake(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/CMake-hdf-4.2.15/hdf-4.2.15
    DISABLE_PARALLEL_CONFIGURE
    PREFER_NINJA
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_TESTING=OFF
        -DHDF4_BUILD_EXAMPLES=OFF
)

vcpkg_install_cmake()

#vcpkg_copy_pdbs()
vcpkg_fixup_cmake_targets(
    CONFIG_PATH cmake
    TARGET_PATH share
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
                    ${CURRENT_PACKAGES_DIR}/debug/COPYING
                    ${CURRENT_PACKAGES_DIR}/debug/RELEASE.txt
                    ${CURRENT_PACKAGES_DIR}/debug/USING_HDF4_CMake.txt
                    ${CURRENT_PACKAGES_DIR}/debug/USING_HDF4_VS.txt
)

file(READ "${CURRENT_PACKAGES_DIR}/share/hdf4/hdf4-config.cmake" contents)
string(REPLACE [[${HDF4_PACKAGE_NAME}_TOOLS_DIR "${PACKAGE_PREFIX_DIR}/bin"]] [[${HDF4_PACKAGE_NAME}_TOOLS_DIR "${PACKAGE_PREFIX_DIR}/tools/hdf4"]] contents ${contents})
file(WRITE "${CURRENT_PACKAGES_DIR}/share/hdf4/hdf4-config.cmake" ${contents})

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/${PORT})
file(RENAME ${CURRENT_PACKAGES_DIR}/COPYING ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright)
file(RENAME ${CURRENT_PACKAGES_DIR}/RELEASE.txt ${CURRENT_PACKAGES_DIR}/share/${PORT}/RELEASE.txt)
file(RENAME ${CURRENT_PACKAGES_DIR}/USING_HDF4_CMake.txt ${CURRENT_PACKAGES_DIR}/share/${PORT}/USING_HDF4_CMake.txt)
file(RENAME ${CURRENT_PACKAGES_DIR}/USING_HDF4_VS.txt ${CURRENT_PACKAGES_DIR}/share/${PORT}/USING_HDF4_VS.txt)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/hdf4)
#configure_file(${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake ${CURRENT_PACKAGES_DIR}/${PORT}/vcpkg-cmake-wrapper.cmake @ONLY)
