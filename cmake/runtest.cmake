
set(_TEST_PROGS ${TEST_PROG})
if(MSVC)
   set(_TEST_PROGS ${TEST_PROG} ${TEST_PROG}.exe)
endif()

set(EXEC "")
foreach(d . ./Release ./Debug )
   file(GLOB _execs ${d} ${_TEST_PROGS})
   set(EXEC "${_execs} ${EXEC}")
   list(LENGTH _execs _size)
   if(${_size} GREATER  0 )
     set(EXEC ${d}/${TEST_PROG})
     break()
   endif()
endforeach()

 
execute_process (COMMAND ${EXEC} ${ARGUMENTS}
  INPUT_FILE ${INPUT}
  OUTPUT_FILE ${OUTPUT}
)
execute_process(COMMAND ${CMAKE_COMMAND} -E compare_files ${OUTPUT} ${EXPECTED} 
  RESULT_VARIABLE _RESULT
)

file(WRITE test.log "
execute_process (COMMAND ${EXEC} ${ARGUMENTS}
  INPUT_FILE ${INPUT}
  OUTPUT_FILE ${OUTPUT}
)
=====================
execute_process(COMMAND ${CMAKE_COMMAND} -E compare_files 
                ${OUTPUT} 
                ${EXPECTED} 
                RESULT_VARIABLE _RESULT)
")
#
if(NOT _RESULT EQUAL 0)
  message (SEND_ERROR "Comparison failed")
endif()
