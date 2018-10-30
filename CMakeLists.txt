cmake_minimum_required (VERSION 3.1)
project (bzip2 C)

set (MAJOR_VERSION 1)
set (MINOR_VERSION 0)
set (VERSION_PATCH 6)
set (VERSION 1.0.6)


if(MSVC)
    add_definitions(-D_FILE_OFFSET_BITS=64)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)    
endif(MSVC)

if(MSVC)
    set (_LIB_NAME libbz2)
else()
    set (_LIB_NAME bz2)
endif()

set (CMAKE_DEBUG_POSTFIX )

set(_SOURCES blocksort.c bzlib.c compress.c 
             crctable.c decompress.c huffman.c randtable.c)

set(_HEADERS bzlib.h bzlib_private.h)	

if (BUILD_SHARED_LIBS)
  add_library(${_LIB_NAME} SHARED ${_SOURCES})
  if (MSVC)
    target_sources (${_LIB_NAME} PRIVATE libbz2.def)
  endif()
else()
  add_library(${_LIB_NAME} STATIC ${_SOURCES})  
endif()

if(MSVC)
   set_target_properties(${_LIB_NAME} PROPERTIES OUTPUT_NAME bz2)
endif()


add_executable (bzip2 bzip2.c )

target_link_libraries (bzip2 PRIVATE ${_LIB_NAME})

add_executable (bzip2recover bzip2recover.c )
target_link_libraries (bzip2recover ${_LIB_NAME})

install (TARGETS ${_LIB_NAME} bzip2 bzip2recover
         RUNTIME DESTINATION bin
         LIBRARY DESTINATION lib
         ARCHIVE DESTINATION lib)

install(FILES ${_HEADERS} DESTINATION include)

enable_testing()
message("2) TEST_PROBE_DIRS:${TEST_PROBE_DIRS}")
if(NOT TEST_PROBE_DIRS)
   set(TEST_PROBE_DIRS . ./Release ./Debug)
endif()
message("3) TEST_PROBE_DIRS:${TEST_PROBE_DIRS}")
add_test(NAME compress_block_size_1
    COMMAND ${CMAKE_COMMAND}
    -DTEST_PROG=bzip2
    -DARGUMENTS=-1
    -DINPUT=${CMAKE_SOURCE_DIR}/sample1.ref
    -DEXPECTED=${CMAKE_SOURCE_DIR}/sample1.bz2
    -DOUTPUT=${CMAKE_CURRENT_BINARY_DIR}/sample1.rb2
    -DSOURCEDIR=${CMAKE_CURRENT_SOURCE_DIR}
	-DPROBEDIRS=${TEST_PROBE_DIRS}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/runtest.cmake
    )

add_test(NAME compress_block_size_2
    COMMAND ${CMAKE_COMMAND}
    -DTEST_PROG=bzip2
    -DARGUMENTS=-2
    -DINPUT=${CMAKE_SOURCE_DIR}/sample2.ref
    -DEXPECTED=${CMAKE_SOURCE_DIR}/sample2.bz2
    -DOUTPUT=${CMAKE_CURRENT_BINARY_DIR}/sample2.rb2
    -DSOURCEDIR=${CMAKE_CURRENT_SOURCE_DIR}
	-DPROBEDIRS=${TEST_PROBE_DIRS}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/runtest.cmake
    )

add_test(NAME compress_block_size_3
    COMMAND ${CMAKE_COMMAND}
    -DTEST_PROG=bzip2
    -DARGUMENTS=-3
    -DINPUT=${CMAKE_SOURCE_DIR}/sample3.ref
    -DEXPECTED=${CMAKE_SOURCE_DIR}/sample3.bz2
    -DOUTPUT=${CMAKE_CURRENT_BINARY_DIR}/sample3.rb2
    -DSOURCEDIR=${CMAKE_CURRENT_SOURCE_DIR}
	-DPROBEDIRS=${TEST_PROBE_DIRS}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/runtest.cmake
    )

add_test(NAME decompress_block_size_1
    COMMAND ${CMAKE_COMMAND}
    -DTEST_PROG=bzip2
    -DARGUMENTS=-d
    -DINPUT=${CMAKE_SOURCE_DIR}/sample1.bz2
    -DEXPECTED=${CMAKE_SOURCE_DIR}/sample1.ref
    -DOUTPUT=${CMAKE_CURRENT_BINARY_DIR}/sample1.tst
    -DSOURCEDIR=${CMAKE_CURRENT_SOURCE_DIR}
	-DPROBEDIRS=${TEST_PROBE_DIRS}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/runtest.cmake
    )

add_test(NAME decompress_block_size_2
    COMMAND ${CMAKE_COMMAND}
    -DTEST_PROG=bzip2
    -DARGUMENTS=-d
    -DINPUT=${CMAKE_SOURCE_DIR}/sample2.bz2
    -DEXPECTED=${CMAKE_SOURCE_DIR}/sample2.ref
    -DOUTPUT=${CMAKE_CURRENT_BINARY_DIR}/sample2.tst
    -DSOURCEDIR=${CMAKE_CURRENT_SOURCE_DIR}
	-DPROBEDIRS=${TEST_PROBE_DIRS}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/runtest.cmake
    )

add_test(NAME decompress_block_size_3
    COMMAND ${CMAKE_COMMAND}
    -DTEST_PROG=bzip2
    -DARGUMENTS=-ds
    -DINPUT=${CMAKE_SOURCE_DIR}/sample3.bz2
    -DEXPECTED=${CMAKE_SOURCE_DIR}/sample3.ref
    -DOUTPUT=${CMAKE_CURRENT_BINARY_DIR}/sample3.tst
    -DSOURCEDIR=${CMAKE_CURRENT_SOURCE_DIR}
	-DPROBEDIRS=${TEST_PROBE_DIRS}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/runtest.cmake
    )