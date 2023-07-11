include(cmake/SystemLink.cmake)
include(cmake/LibFuzzer.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)


macro(soko_cpp_tools_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(soko_cpp_tools_setup_options)
  option(soko_cpp_tools_ENABLE_HARDENING "Enable hardening" ON)
  option(soko_cpp_tools_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    soko_cpp_tools_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies"
    ON
    soko_cpp_tools_ENABLE_HARDENING
    OFF)

  soko_cpp_tools_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR soko_cpp_tools_PACKAGING_MAINTAINER_MODE)
    option(soko_cpp_tools_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(soko_cpp_tools_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(soko_cpp_tools_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(soko_cpp_tools_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(soko_cpp_tools_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(soko_cpp_tools_ENABLE_PCH "Enable precompiled headers" OFF)
    option(soko_cpp_tools_ENABLE_CACHE "Enable ccache" OFF)
  else()
    option(soko_cpp_tools_ENABLE_IPO "Enable IPO/LTO" ON)
    option(soko_cpp_tools_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
    option(soko_cpp_tools_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
    option(soko_cpp_tools_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
    option(soko_cpp_tools_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(soko_cpp_tools_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(soko_cpp_tools_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(soko_cpp_tools_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
    option(soko_cpp_tools_ENABLE_PCH "Enable precompiled headers" OFF)
    option(soko_cpp_tools_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      soko_cpp_tools_ENABLE_IPO
      soko_cpp_tools_WARNINGS_AS_ERRORS
      soko_cpp_tools_ENABLE_USER_LINKER
      soko_cpp_tools_ENABLE_SANITIZER_ADDRESS
      soko_cpp_tools_ENABLE_SANITIZER_LEAK
      soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED
      soko_cpp_tools_ENABLE_SANITIZER_THREAD
      soko_cpp_tools_ENABLE_SANITIZER_MEMORY
      soko_cpp_tools_ENABLE_UNITY_BUILD
      soko_cpp_tools_ENABLE_CLANG_TIDY
      soko_cpp_tools_ENABLE_CPPCHECK
      soko_cpp_tools_ENABLE_COVERAGE
      soko_cpp_tools_ENABLE_PCH
      soko_cpp_tools_ENABLE_CACHE)
  endif()

  soko_cpp_tools_check_libfuzzer_support(LIBFUZZER_SUPPORTED)
  if(LIBFUZZER_SUPPORTED AND (soko_cpp_tools_ENABLE_SANITIZER_ADDRESS OR soko_cpp_tools_ENABLE_SANITIZER_THREAD OR soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED))
    set(DEFAULT_FUZZER ON)
  else()
    set(DEFAULT_FUZZER OFF)
  endif()

  option(soko_cpp_tools_BUILD_FUZZ_TESTS "Enable fuzz testing executable" ${DEFAULT_FUZZER})

endmacro()

macro(soko_cpp_tools_global_options)
  if(soko_cpp_tools_ENABLE_IPO)
    include(cmake/InterproceduralOptimization.cmake)
    soko_cpp_tools_enable_ipo()
  endif()

  soko_cpp_tools_supports_sanitizers()

  if(soko_cpp_tools_ENABLE_HARDENING AND soko_cpp_tools_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED
       OR soko_cpp_tools_ENABLE_SANITIZER_ADDRESS
       OR soko_cpp_tools_ENABLE_SANITIZER_THREAD
       OR soko_cpp_tools_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message("${soko_cpp_tools_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED}")
    soko_cpp_tools_enable_hardening(soko_cpp_tools_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()

macro(soko_cpp_tools_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(soko_cpp_tools_warnings INTERFACE)
  add_library(soko_cpp_tools_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  soko_cpp_tools_set_project_warnings(
    soko_cpp_tools_warnings
    ${soko_cpp_tools_WARNINGS_AS_ERRORS}
    ""
    ""
    ""
    "")

  if(soko_cpp_tools_ENABLE_USER_LINKER)
    include(cmake/Linker.cmake)
    configure_linker(soko_cpp_tools_options)
  endif()

  include(cmake/Sanitizers.cmake)
  soko_cpp_tools_enable_sanitizers(
    soko_cpp_tools_options
    ${soko_cpp_tools_ENABLE_SANITIZER_ADDRESS}
    ${soko_cpp_tools_ENABLE_SANITIZER_LEAK}
    ${soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED}
    ${soko_cpp_tools_ENABLE_SANITIZER_THREAD}
    ${soko_cpp_tools_ENABLE_SANITIZER_MEMORY})

  set_target_properties(soko_cpp_tools_options PROPERTIES UNITY_BUILD ${soko_cpp_tools_ENABLE_UNITY_BUILD})

  if(soko_cpp_tools_ENABLE_PCH)
    target_precompile_headers(
      soko_cpp_tools_options
      INTERFACE
      <vector>
      <string>
      <utility>)
  endif()

  if(soko_cpp_tools_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    soko_cpp_tools_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(soko_cpp_tools_ENABLE_CLANG_TIDY)
    soko_cpp_tools_enable_clang_tidy(soko_cpp_tools_options ${soko_cpp_tools_WARNINGS_AS_ERRORS})
  endif()

  if(soko_cpp_tools_ENABLE_CPPCHECK)
    soko_cpp_tools_enable_cppcheck(${soko_cpp_tools_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()

  if(soko_cpp_tools_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    soko_cpp_tools_enable_coverage(soko_cpp_tools_options)
  endif()

  if(soko_cpp_tools_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      # target_link_options(soko_cpp_tools_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(soko_cpp_tools_ENABLE_HARDENING AND NOT soko_cpp_tools_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR soko_cpp_tools_ENABLE_SANITIZER_UNDEFINED
       OR soko_cpp_tools_ENABLE_SANITIZER_ADDRESS
       OR soko_cpp_tools_ENABLE_SANITIZER_THREAD
       OR soko_cpp_tools_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    soko_cpp_tools_enable_hardening(soko_cpp_tools_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()

endmacro()
