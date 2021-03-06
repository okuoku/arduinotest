cmake_minimum_required(VERSION 3.10)

project(arduinotest C ASM CXX)

include(./core.cmake)
include(./libs.cmake)
include(./libs_seeed.cmake)

set(repos ArduinoCore-samd seeedlibs)
set(libs)
foreach(r ${repos})
    list(APPEND libs ${arduinolibs_${r}})
endforeach()

list(REMOVE_ITEM libs 
    # FIXME
    HID USBHost 
    # SAMD51 port needed?
    I2S EnergySaving FlashStorage
    # n/a for SAMD51
    TimerTCC0)

foreach(l ${libs})
    include_directories(${arduinolib_${l}_incs})
endforeach()

set(CMAKE_C_FLAGS "-g -Os -std=gnu11")
set(CMAKE_CXX_FLAGS "-g -Os -std=gnu++11 -fno-exceptions -fno-rtti")
set(CMAKE_EXE_LINKER_FLAGS
    "-Wl,-T -Wl,${CMAKE_CURRENT_LIST_DIR}/ArduinoCore-samd/variants/wio_terminal/linker_scripts/gcc/flash_with_bootloader.ld -Wl,--gc-sections -fuse-ld=bfd -Wl,-Map,out.map"
    )

# Defs
add_definitions(
    -D__SAMD51P19A__ 
    -DWIO_TERMINAL 
    -DSEEED_WIO_TERMINAL 
    -DSEEED_GROVE_UI_WIRELESS 
    -D__SAMD51__ 
    -D__FPU_PRESENT 
    -DARM_MATH_CM4 

    # Toolchain config
    -mfloat-abi=hard -mfpu=fpv4-sp-d16

    -mcpu=cortex-m4
    -mthumb 
    -ffunction-sections 
    -fdata-sections 
    -nostdlib 
    --param max-inline-insns-single=500 
    -D__SKETCH_NAME__=ArduinoTest

    # usb_flags
    -DUSB_VID=0x2886
    -DUSB_PID=0x802D
    -DUSBCON
    -DUSB_CONFIG_POWER=100 # 100mA
    -DUSB_MANUFACTURER=\"DummyYuniArduino\"
    -DUSB_PRODUCT=\"DummyYuniArduino\"
    -DUSE_TINYUSB

    # 120MHz
    -DF_CPU=120000000L
    -DARDUINO_ARCH_SAMD
    )

# USB incs
include_directories(
    ArduinoModule-CMSIS/CMSIS/CMSIS/Include
    ArduinoModule-CMSIS-Atmel/CMSIS-Atmel/CMSIS/Device/ATMEL
    ArduinoCore-samd/cores/arduino
    ArduinoCore-samd/variants/wio_terminal
    ArduinoCore-samd/cores/arduino/TinyUSB
    ArduinoCore-samd/cores/arduino/TinyUSB/Adafruit_TinyUSB_ArduinoCore
    ArduinoCore-samd/cores/arduino/TinyUSB/Adafruit_TinyUSB_ArduinoCore/tinyusb/src
    )

# libs
foreach(l ${libs})
    add_library(${l} STATIC ${arduinolib_${l}_srcs})
endforeach()

add_library(ArduinoCore STATIC 
    ArduinoCore-samd/variants/wio_terminal/variant.cpp
    ${arduinolib_core_srcs})

add_executable(target blink.cpp)
target_link_libraries(target ArduinoCore)

add_custom_command(TARGET target POST_BUILD
    COMMAND ${CMAKE_OBJCOPY}
    -O binary $<TARGET_FILE:target> $<TARGET_FILE:target>.bin)

add_custom_target(write
    COMMAND ${CMAKE_COMMAND} -DBIN=$<TARGET_FILE:target>.bin
    -P ${CMAKE_CURRENT_LIST_DIR}/run_write.cmake)

