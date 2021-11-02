execute_process(
    COMMAND ${CMAKE_COMMAND}
    -DROOT=${CMAKE_CURRENT_LIST_DIR}
    -DPATH=ArduinoCore-samd/cores/arduino
    -DTYPE=core
    -P ${CMAKE_CURRENT_LIST_DIR}/gen_arduino_srctab.cmake
    OUTPUT_FILE core.cmake
    ERROR_FILE core.cmake
    )
execute_process(
    COMMAND ${CMAKE_COMMAND}
    -DREPO=ArduinoCore-samd
    -DROOT=${CMAKE_CURRENT_LIST_DIR}
    -DPATH=ArduinoCore-samd/libraries
    -DTYPE=lib
    -P ${CMAKE_CURRENT_LIST_DIR}/gen_arduino_srctab.cmake
    OUTPUT_FILE libs.cmake
    ERROR_FILE libs.cmake
    )

execute_process(
    COMMAND ${CMAKE_COMMAND}
    -DREPO=seeedlibs
    -DROOT=${CMAKE_CURRENT_LIST_DIR}
    -DPATH=seeedlibs
    -DTYPE=lib
    -P ${CMAKE_CURRENT_LIST_DIR}/gen_arduino_srctab.cmake
    OUTPUT_FILE libs_seeed.cmake
    ERROR_FILE libs_seeed.cmake
    )
