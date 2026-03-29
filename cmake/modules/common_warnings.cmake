function(set_common_warnings target_name)
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        target_compile_options(${target_name} PRIVATE
            -Wall
            -Wextra
            -Wpedantic
            -Wshadow
            -Wconversion
            -Wsign-conversion
        )
    elseif(MSVC)
        target_compile_options(${target_name} PRIVATE
            /W4
        )
    endif()
endfunction()