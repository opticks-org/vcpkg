vcpkg_download_distfile(
    distfile
    URLS https://opticks.org/downloads/working_deps/raptor-1.4.16-windows-mods.zip
    FILENAME raptor-1.4.16-windows-mods.zip
    SHA512 1d8e436d2a8a870dd0e12b7edde206ba1cdcb634a9391bb16d107a41004bea5a3bab79e6d38eb2160a152f929e36fe28f6d3f21ccd16f692cf16c95d380ac8eb
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${distfile}
    PATCHES fix-msnames-error.patch
) 

vcpkg_install_msbuild(
    SOURCE_PATH ${SOURCE_PATH}
    PROJECT_SUBPATH win32/raptor.vcxproj
    INCLUDES_SUBPATH src
    ALLOW_ROOT_INCLUDES
    LICENSE_SUBPATH COPYING
    RELEASE_CONFIGURATION Release
    DEBUG_CONFIGURATION Debug
    PLATFORM x64
    USE_VCPKG_INTEGRATION
)

#file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

#if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
#    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
#endif()

#file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/${PORT})
#file(RENAME ${CURRENT_PACKAGES_DIR}/COPYING ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright)
