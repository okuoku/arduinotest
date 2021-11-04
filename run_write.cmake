#
# INPUTs:
#   BIN: CMake path to binary
#

set(COMPORT COM11)
set(BOSSA /cygdrive/c/Users/oku/AppData/Local/Arduino15/packages/Seeeduino/tools/bossac/1.8.0-48-gb176eee/bossac.exe)

get_filename_component(bin_dir ${BIN} DIRECTORY)
get_filename_component(bin_file ${BIN} NAME)

if(NOT EXISTS ${bin_file})
    message(FATAL_ERROR "Couldn't find ${bin_file}")
endif()

execute_process(
    COMMAND ${BOSSA} -i -d --port=COM11 -w -v --offset=0x4000 ${bin_file}
    WORKING_DIRECTORY ${bin_dir})
