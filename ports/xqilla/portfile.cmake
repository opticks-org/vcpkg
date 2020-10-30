vcpkg_from_sourceforge(
    OUT_SOURCE_PATH SOURCE_PATH
    FILENAME "XQilla-2.3.4.tar.gz"
    REPO xqilla
    SHA512 f744ff883675887494780d24ecdc94afa394d3795d1544b1c598016b3f936c340ad7cd84529ac12962e3c5ce2f1be928a0cd4f9b9eb70e6645a38b0728cb1994
    PATCHES remove-xerces-build-step.patch fix-snprintf.patch
)

if (NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    vcpkg_build_msbuild(
        PROJECT_PATH ${SOURCE_PATH}/Win32Projects/VC14/XQilla.sln
        OPTIONS /p:PreBuildEvent=""
        USE_VCPKG_INTEGRATION
    )
else ()
endif ()

#Install the header files
file(INSTALL ${SOURCE_PATH}/include/xqilla/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT}/)
if (NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
	file(INSTALL ${SOURCE_PATH}/build/windows/VC14/${VCPKG_TARGET_ARCHITECTURE}/Release/xqilla23.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/)
	file(INSTALL ${SOURCE_PATH}/build/windows/VC14/${VCPKG_TARGET_ARCHITECTURE}/Release/xqilla23.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin/)
endif ()
if (NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
	file(INSTALL ${SOURCE_PATH}/build/windows/VC14/${VCPKG_TARGET_ARCHITECTURE}/Debug/xqilla23d.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/)
	file(INSTALL ${SOURCE_PATH}/build/windows/VC14/${VCPKG_TARGET_ARCHITECTURE}/Debug/xqilla23d.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin/)
endif ()
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
