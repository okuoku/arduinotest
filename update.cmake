execute_process(
    COMMAND ${CMAKE_COMMAND}
    -DROOT=${CMAKE_CURRENT_LIST_DIR}/ArduinoCore-samd
    -DPATH=cores/arduino
    -DTYPE=core
    -P ${CMAKE_CURRENT_LIST_DIR}/gen_arduino_srctab.cmake
    OUTPUT_FILE core.cmake
    ERROR_FILE core.cmake
    )

execute_process(
    COMMAND ${CMAKE_COMMAND}
    -DROOT=${CMAKE_CURRENT_LIST_DIR}/ArduinoCore-samd
    -DPATH=libraries
    -DTYPE=lib
    -P ${CMAKE_CURRENT_LIST_DIR}/gen_arduino_srctab.cmake
    OUTPUT_FILE libs.cmake
    ERROR_FILE libs.cmake
    )
