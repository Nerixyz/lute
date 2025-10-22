function(lute_codegen_to_absolute)
    set(oneValueArgs OUTPUT_VARIABLE WORKDIR)
    set(multiValueArgs PATHS)
    cmake_parse_arguments(PARSE_ARGV 0 arg
        "" "${oneValueArgs}" "${multiValueArgs}"
    )
    set(paths "")
    foreach(path ${arg_PATHS})
        cmake_path(ABSOLUTE_PATH path BASE_DIRECTORY "${arg_WORKDIR}")
        list(APPEND paths "${path}")
    endforeach()
    set(${arg_OUTPUT_VARIABLE} "${paths}" PARENT_SCOPE)
endfunction()

function(lute_embed_files)
    set(oneValueArgs OUTPUT CXX_NAME PREFIX WORKDIR)
    set(multiValueArgs FILES)
    cmake_parse_arguments(PARSE_ARGV 0 arg
        "" "${oneValueArgs}" "${multiValueArgs}"
    )

    if (LUTE_BOOTSTRAPPED)
        return()
    endif()

    if (arg_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "lute_embed_files(): missing ${arg_KEYWORDS_MISSING_VALUES}")
    endif()

    set(codegen_script "${PROJECT_SOURCE_DIR}/tools/codegen.luau")

    lute_codegen_to_absolute(
        OUTPUT_VARIABLE deps
        WORKDIR "${arg_WORKDIR}"
        PATHS ${arg_FILES}
    )
    add_custom_command(
        COMMAND
            "${LUTE_EXECUTABLE}"
            "${codegen_script}"
            --kind embed-files
            --out "${CMAKE_CURRENT_SOURCE_DIR}/${arg_OUTPUT}"
            --cxxname "${arg_CXX_NAME}"
            --prefix "${arg_PREFIX}"
            ${arg_FILES}
        OUTPUT
            "${CMAKE_CURRENT_SOURCE_DIR}/${arg_OUTPUT}.cpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/${arg_OUTPUT}.h"
        WORKING_DIRECTORY
            "${arg_WORKDIR}"
        COMMENT
            "Generating ${arg_OUTPUT}"
        DEPENDS
            ${deps}
            "${codegen_script}"
            "${LUTE_EXECUTABLE}"
        VERBATIM
    )
endfunction()

function(lute_merge_types)
    set(oneValueArgs OUTPUT WORKDIR)
    set(multiValueArgs FILES)
    cmake_parse_arguments(PARSE_ARGV 0 arg
        "" "${oneValueArgs}" "${multiValueArgs}"
    )

    if (LUTE_BOOTSTRAPPED)
        return()
    endif()

    if (arg_KEYWORDS_MISSING_VALUES)
        message(FATAL_ERROR "lute_merge_types(): missing ${arg_KEYWORDS_MISSING_VALUES}")
    endif()

    set(codegen_script "${PROJECT_SOURCE_DIR}/tools/codegen.luau")

    set(deps "${arg_FILES}")
    list(FILTER deps EXCLUDE REGEX "^@")
    add_custom_command(
        COMMAND
            "${LUTE_EXECUTABLE}"
            "${codegen_script}"
            --kind merge-types
            --out "${CMAKE_CURRENT_SOURCE_DIR}/${arg_OUTPUT}"
            ${arg_FILES}
        OUTPUT
            "${CMAKE_CURRENT_SOURCE_DIR}/${arg_OUTPUT}"
        WORKING_DIRECTORY
            "${arg_WORKDIR}"
        COMMENT
            "Generating ${arg_OUTPUT}"
        DEPENDS
            ${deps}
            "${codegen_script}"
            "${LUTE_EXECUTABLE}"
        VERBATIM
    )
endfunction()

function(check_lute)
    if (LUTE_BOOTSTRAPPED)
        return()
    endif()

    message(STATUS "Using '${LUTE_EXECUTABLE}' as existing lute executable")
    execute_process(
        COMMAND
            "${LUTE_EXECUTABLE}"
            "${PROJECT_SOURCE_DIR}/tools/codegen.luau"
            --help
        TIMEOUT 1
        RESULT_VARIABLE check_exit
        OUTPUT_VARIABLE check_output
        ERROR_VARIABLE check_output
    )
    if (NOT check_exit EQUAL 0)
        message(FATAL_ERROR "'${LUTE_EXECUTABLE}' failed to run (exit code ${check_exit}):\n${check_output}")
    endif()
endfunction()


