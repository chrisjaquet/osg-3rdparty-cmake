# Some helper functions.

FUNCTION(DownloadAndExtract downloadURL destinationFilePath workingDirectory)
  IF(NOT EXISTS ${destinationFilePath})
    MESSAGE(STATUS "Downloading '${destinationFilePath}' from '${downloadURL}'...")
    FILE(DOWNLOAD ${downloadURL} ${destinationFilePath})
  ELSE()
    MESSAGE("Using existing file '${destinationFilePath}'.")
  ENDIF()
  MESSAGE(STATUS "Extracting '${destinationFilePath}'...")
  IF(NOT EXISTS ${workingDirectory})
    EXECUTE_PROCESS(COMMAND cmake -E make_directory ${destinationFilePath})
  ENDIF()
  EXECUTE_PROCESS(COMMAND cmake -E tar xvf ${destinationFilePath}
    WORKING_DIRECTORY ${workingDirectory}
    RESULT_VARIABLE EXTRACT_RESULT_VAR
    OUTPUT_VARIABLE EXTRACT_OUTPUT_VAR
    ERROR_VARIABLE EXTRACT_OUTPUT_VAR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE
    )
  IF(NOT ${EXTRACT_RESULT_VAR} EQUAL 0)
    MESSAGE(FATAL_ERROR "Could not extract '${destinationFilePath}'.\nReturn code: '${EXTRACT_RESULT_VAR}'.\nOutput:\n${EXTRACT_OUTPUT_VAR}")
  ENDIF()
ENDFUNCTION()
