SET(GIFLIB_VERSION "5.1.4")

PROJECT(giflib VERSION ${GIFLIB_VERSION} LANGUAGES C)

# Try to download the source from the internet if no source folder is specified.
IF(NOT GIFLIB_SOURCE_DIR)
  DownloadAndExtract("https://sourceforge.net/projects/giflib/files/giflib-${GIFLIB_VERSION}.tar.gz/download"
    ${CMAKE_CURRENT_SOURCE_DIR}/giflib-${GIFLIB_VERSION}.tar.gz
    ${CMAKE_CURRENT_BINARY_DIR}
    )
  SET(_GIFLIB_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/giflib-${GIFLIB_VERSION})
ELSE()
  SET(_GIFLIB_SOURCE_DIR ${GIFLIB_SOURCE_DIR})

  FILE(READ ${GIFLIB_SOURCE_DIR}/lib/gif_lib.h _gif_lib_h_contents)
  STRING(REGEX REPLACE ".*#define[ \t]+GIFLIB_MAJOR[ \t]+([0-9]+).*" "\\1" GIFLIB_MAJOR_VERSION_DETECTED ${_gif_lib_h_contents})
  STRING(REGEX REPLACE ".*#define[ \t]+GIFLIB_MINOR[ \t]+([0-9]+).*" "\\1" GIFLIB_MINOR_VERSION_DETECTED ${_gif_lib_h_contents})
  STRING(REGEX REPLACE ".*#define[ \t]+GIFLIB_RELEASE[ \t]+([0-9]+).*" "\\1" GIFLIB_RELEASE_VERSION_DETECTED ${_gif_lib_h_contents})

  SET(GIFLIB_VERSION_DETECTED "#{GIFLIB_VERSION_MAJOR_DETECTED}.${GIFLIB_VERSION_MINOR_DETECTED}.${GIFLIB_VERSION_PATCH_DETECTED}")
  IF(NOT ${GIFLIB_VERSION_DETECTED} STREQUAL ${GIFLIB_VERSION})
    MESSAGE(WARNING "GifLib version mismatch. Expecting '${GIFLIB_VERSION}' but source code contains '${GIFLIB_VERSION_DETECTED}'")
  ENDIF()
ENDIF()
SET(GIFLIB_SOURCE_DIR ${_GIFLIB_SOURCE_DIR} CACHE PATH "Path where to find GIFLIB source")

# Use GNUInstallDirs to install libraries into correct
# locations on all platforms.
INCLUDE(GNUInstallDirs)

SET(GIFLIB_PUBLIC_HEADERS
  ${GIFLIB_SOURCE_DIR}/lib/gif_lib.h
)

SET(GIFLIB_PRIVATE_HEADERS
  ${GIFLIB_SOURCE_DIR}/lib/gif_lib_private.h
  ${GIFLIB_SOURCE_DIR}/lib/gif_hash.h
)

SET(GIFLIB_SRCS
  ${GIFLIB_SOURCE_DIR}/lib/dgif_lib.c
  ${GIFLIB_SOURCE_DIR}/lib/egif_lib.c
  ${GIFLIB_SOURCE_DIR}/lib/gif_err.c
  ${GIFLIB_SOURCE_DIR}/lib/gif_font.c
  ${GIFLIB_SOURCE_DIR}/lib/gif_hash.c
  ${GIFLIB_SOURCE_DIR}/lib/gifalloc.c
  ${GIFLIB_SOURCE_DIR}/lib/quantize.c
  ${GIFLIB_SOURCE_DIR}/lib/openbsd-reallocarray.c
)

IF(MSVC)
  # Create file to avoid include file name collision on other platforms
  CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/unistd.h.in unistd.h @ONLY)

  # Add unistd.h, getopt.h, getopt.c and stdbool.h for windows build
  # getopt from: http://gist.github.com/ashelly/7776712
  # unistd.h from: http://stackoverflow.com/questions/341817/is-there-a-replacement-for-unistd-h-for-windows-visual-c
  # stdbool.h is just a simple redefinition of bool as int
  SET(GIFLIB_PUBLIC_HEADERS
    ${GIFLIB_PUBLIC_HEADERS}
    ${CMAKE_CURRENT_SOURCE_DIR}/stdbool.h
  )

  SET(GIFLIB_PRIVATE_HEADERS
    ${GIFLIB_PRIVATE_HEADERS}
    ${CMAKE_CURRENT_SOURCE_DIR}/getopt.h
    ${CMAKE_CURRENT_SOURCE_DIR}/unistd.h
  )

  SET(GIFLIB_SRCS
    ${GIFLIB_SRCS}
    ${CMAKE_CURRENT_SOURCE_DIR}/getopt.c
  )
ENDIF(MSVC)

IF(MSVC)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  LIST(APPEND PRIVATE_DEFINITIONS -D_LIB) #
  LIST(APPEND PRIVATE_DEFINITIONS -DWIN32) #

  # Supress warnings
  LIST(APPEND PRIVATE_OPTIONS /wd4018) # expression' : signed/unsigned mismatch
  LIST(APPEND PRIVATE_OPTIONS /wd4028) # formal parameter 'number' different from declaration
  LIST(APPEND PRIVATE_OPTIONS /wd4244) # conversion' conversion from 'type1' to 'type2', possible loss of data
  LIST(APPEND PRIVATE_OPTIONS /wd4996) # The compiler encountered a deprecated declaration.

  SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

IF(MINGW)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  LIST(APPEND PRIVATE_DEFINITIONS -D_LIB) #
ENDIF(MINGW)

ADD_LIBRARY(giflib STATIC ${GIFLIB_SRCS} ${GIFLIB_PUBLIC_HEADERS} ${GIFLIB_PRIVATE_HEADERS})

# Dependent include files
TARGET_INCLUDE_DIRECTORIES(giflib PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
  )

TARGET_COMPILE_DEFINITIONS(giflib
  PRIVATE ${PRIVATE_DEFINITIONS}
  )

TARGET_COMPILE_OPTIONS(giflib
  PRIVATE ${PRIVATE_OPTIONS}
  )

IF(MINGW)
  SET_TARGET_PROPERTIES(${TARGET_LIB} PROPERTIES OUTPUT_NAME gif)
ENDIF()

# INSTALL
INSTALL(TARGETS giflib EXPORT giflib_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

INSTALL(FILES
  ${GIFLIB_PUBLIC_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
