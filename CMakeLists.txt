CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

PROJECT(OpenscenegraphThirdParty)

# Only enable release and debug builds
IF(CMAKE_CONFIGURATION_TYPES)
   SET(CMAKE_CONFIGURATION_TYPES Debug Release)
   set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING
     "Reset the configurations to what we need"
     FORCE)
ENDIF()

# Generate folder name for install
IF(${CMAKE_SIZEOF_VOID_P} EQUAL 8)
    SET(BITS "x64")
ELSEIF (${CMAKE_SIZEOF_VOID_P} EQUAL 4)
    SET(BITS "x86")
ENDIF()

IF (MSVC)
    IF (${MSVC_VERSION} EQUAL 1600)
        SET(COMPILER "v100") # Visual Studio 2010
    ELSEIF (${MSVC_VERSION} EQUAL 1700)
        SET(COMPILER "v110") # Visual Studio 2012
    ELSEIF (${MSVC_VERSION} EQUAL 1800)
        SET(COMPILER "v120") # Visual Studio 2013
    ELSEIF (${MSVC_VERSION} EQUAL 1900)
        SET(COMPILER "v140") # Visual Studio 2015
    ELSE()
        MESSAGE(FATAL_ERROR "Unkown version of Visual Studio Detected")
    ENDIF()
ENDIF()

IF(MINGW)
    SET(COMPILER "mingw")
ENDIF()

SET(dirname "${COMPILER}-${BITS}")

# Set directories
SET(EXECUTABLE_OUTPUT_PATH "${PROJECT_BINARY_DIR}/3rdParty/${dirname}/bin")
SET(ARCHIVE_OUTPUT_PATH "${PROJECT_BINARY_DIR}/3rdParty/${dirname}/lib")
SET(LIBRARY_OUTPUT_PATH "${PROJECT_BINARY_DIR}/lib")
SET(INCLUDE_OUTPUT_PATH "${PROJECT_BINARY_DIR}/3rdParty/${dirname}/include")

SET(USE_ZLIB ON CACHE BOOL "Use and compile ZLIB source")
SET(USE_LIBPNG OFF CACHE BOOL "Use and compile LIBPNG source")
SET(USE_LIBJPEG OFF CACHE BOOL "Use and compile LIBJPEG source")
SET(USE_LIFTIFF OFF CACHE BOOL "Use and compile LIFTIFF source")
SET(USE_FREETYPE OFF CACHE BOOL "Use and compile FREETYPE source")
SET(USE_GLUT OFF CACHE BOOL "Use and compile GLUT source")
SET(USE_GIFLIB OFF CACHE BOOL "Use and compile GIFLIB source")
SET(USE_MINIZIP OFF CACHE BOOL "Use and compile MINIZIP source")
SET(USE_CURL OFF CACHE BOOL "Use and compile cURL source")

# Add libraries
ADD_SUBDIRECTORY(zlib)
ADD_SUBDIRECTORY(libpng)
ADD_SUBDIRECTORY(libjpeg)
ADD_SUBDIRECTORY(libtiff)
ADD_SUBDIRECTORY(freetype)
ADD_SUBDIRECTORY(glut)
ADD_SUBDIRECTORY(giflib)
ADD_SUBDIRECTORY(minizip)
ADD_SUBDIRECTORY(curl)

