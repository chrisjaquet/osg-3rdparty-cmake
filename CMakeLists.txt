CMAKE_MINIMUM_REQUIRED(VERSION 3.4)

PROJECT(OpenSceneGraph-3rdPartyLibs)

INCLUDE(CMakeModules/FunctionDefinitions.cmake)

# Some global options
SET(CMAKE_DEBUG_POSTFIX "d")

# Only enable release and debug builds
IF(CMAKE_CONFIGURATION_TYPES)
  SET(CMAKE_CONFIGURATION_TYPES Debug Release)
  SET(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING
    "Reset the configurations to what we need"
    FORCE
    )
ENDIF()

# Determine architecture bitness
IF(${CMAKE_SIZEOF_VOID_P} EQUAL 8)
  SET(BITS "x64")
ELSEIF (${CMAKE_SIZEOF_VOID_P} EQUAL 4)
  SET(BITS "x86")
ENDIF()

# Determine compiler name (and version for VS)
IF (MSVC)
  IF (${MSVC_VERSION} EQUAL 1600)
    SET(TOOLSET "v100") # Visual Studio 2010
  ELSEIF (${MSVC_VERSION} EQUAL 1700)
    SET(TOOLSET "v110") # Visual Studio 2012
  ELSEIF (${MSVC_VERSION} EQUAL 1800)
    SET(TOOLSET "v120") # Visual Studio 2013
  ELSEIF (${MSVC_VERSION} EQUAL 1900)
    SET(TOOLSET "v140") # Visual Studio 2015
  ELSEIF ((${MSVC_VERSION} GREATER_EQUAL 1910) AND (${MSVC_VERSION} LESS_EQUAL 1919))
    SET(TOOLSET "v141") # Visual Studio 2017
  ELSEIF ((${MSVC_VERSION} GREATER_EQUAL 1920) AND (${MSVC_VERSION} LESS_EQUAL 1929))
    SET(TOOLSET "v142") # Visual Studio 2019
  ENDIF()
ELSEIF(MINGW)
  SET(TOOLSET "mingw")
ELSE()
  MESSAGE(FATAL_ERROR "Unknown compiler/toolset being used.")
ENDIF()

# Output root directory name
SET(dirname "${TOOLSET}-${BITS}")

# Set output sub-directory names
SET(EXECUTABLE_OUTPUT_PATH "${dirname}/bin")
SET(ARCHIVE_OUTPUT_PATH "${dirname}/lib")
SET(LIBRARY_OUTPUT_PATH "${dirname}/lib")
SET(INCLUDE_OUTPUT_PATH "${dirname}/include")

# Configurations for specifying the 3rd-Party libraries to build
OPTION(USE_ZLIB "Use and compile ZLIB source" ON)
OPTION(USE_LIBPNG "Use and compile LIBPNG source" ON)
OPTION(USE_LIBJPEG "Use and compile LIBJPEG source" ON)
OPTION(USE_LIBTIFF "Use and compile LIBTIFF source" ON)
OPTION(USE_FREETYPE "Use and compile FREETYPE source" ON)
OPTION(USE_GLUT "Use and compile GLUT source" ON)
OPTION(USE_GIFLIB "Use and compile GIFLIB source" ON)
OPTION(USE_MINIZIP "Use and compile MINIZIP source" ON)
OPTION(USE_CURL "Use and compile cURL source" ON)

# Add all the libraries
IF(USE_ZLIB)
  ADD_SUBDIRECTORY(zlib)
ENDIF()
IF(USE_LIBPNG)
  ADD_SUBDIRECTORY(libpng)
ENDIF()
IF(USE_LIBJPEG)
  ADD_SUBDIRECTORY(libjpeg)
ENDIF()
IF(USE_LIBTIFF)
  ADD_SUBDIRECTORY(libtiff)
ENDIF()
IF(USE_FREETYPE)
  ADD_SUBDIRECTORY(freetype)
ENDIF()
IF(USE_GLUT)
  ADD_SUBDIRECTORY(glut)
ENDIF()
IF(USE_GIFLIB)
  ADD_SUBDIRECTORY(giflib)
ENDIF()
IF(USE_MINIZIP)
  ADD_SUBDIRECTORY(minizip)
ENDIF()
IF(USE_CURL)
  ADD_SUBDIRECTORY(curl)
ENDIF()
