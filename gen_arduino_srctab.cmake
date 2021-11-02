#
# INPUTs
#   ROOT: CMake path to root directory
#   PATH: Relative path to check
#   TYPE: `core` or `lib`
#          core: treat root directory as Arduino1.5 `src` dir
#           lib: Search for libraries (ArduinoLegacy or Arduino1.5)

if(NOT ROOT)
    message(FATAL_ERROR "No ROOT?")
endif()
if(NOT PATH)
    message(FATAL_ERROR "No PATH?")
endif()
if(NOT TYPE)
    message(FATAL_ERROR "No TYPE?")
endif()

function(get_dir_type out_type dir)
    # ArduinoCore is only for manual-detection
    set(type ArduinoLegacy)
    if(NOT IS_DIRECTORY ${dir})
        message(FATAL_ERROR "Directory required(${dir})")
    endif()
    if(IS_DIRECTORY ${dir}/src)
        set(type Arduino15)
    endif()
    set(${out_type} ${type} PARENT_SCOPE)
endfunction()

function(get_srcs out_srcs dir type)
    if(type STREQUAL Arduino15)
        file(GLOB_RECURSE srcs
            RELATIVE ${ROOT}
            ${dir}/src/*.c ${dir}/src/*.cpp ${dir}/src/*.S)
    elseif(type STREQUAL ArduinoCore)
        file(GLOB_RECURSE srcs
            RELATIVE ${ROOT}
            ${dir}/*.c ${dir}/*.cpp ${dir}/*.S)
    else()
        file(GLOB srcs0
            RELATIVE ${ROOT}
            ${dir}/*.c ${dir}/*.cpp ${dir}/*.S)
        file(GLOB srcs1
            RELATIVE ${ROOT}
            ${dir}/utility/*.c ${dir}/utility/*.cpp ${dir}/utility/*.S)
        set(srcs)
        list(APPEND srcs ${srcs0} ${srcs1})
    endif()
    set(${out_srcs} ${srcs} PARENT_SCOPE)
endfunction()

set(repo ${ROOT}/${PATH})

if(TYPE STREQUAL core)
    set(libdirs core)
    get_srcs(arduinolib_core_srcs ${repo} ArduinoCore)
else()
    set(libdirs)
    file(GLOB nodes RELATIVE ${repo} ${repo}/*) # FIXME: Remove _ etc
    foreach(n ${nodes})
        if(IS_DIRECTORY ${repo}/${n})
            list(APPEND libdirs ${n})
        endif()
        foreach(d ${libdirs})
            get_dir_type(type ${repo}/${d})
            get_srcs(arduinolib_${d}_srcs ${repo}/${d} ${type})
            if(type STREQUAL Arduino15)
                set(arduinolib_${d}_incs ${PATH}/${d}/src)
            else()
                set(arduinolib_${d}_incs ${PATH}/${d})
            endif()
        endforeach()
    endforeach()
endif()

function(dumpvar nam)
    message("set(${nam}")
    foreach(e ${${nam}})
        message("    ${e}")
    endforeach()
    message(")\n")
endfunction()

list(SORT libdirs)

foreach(lib ${libdirs})
    dumpvar(arduinolib_${lib}_srcs)
    if(arduinolib_${lib}_incs)
        dumpvar(arduinolib_${lib}_incs)
    endif()
endforeach()