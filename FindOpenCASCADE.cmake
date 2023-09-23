if (DEFINED CAS_CMAKE_ROOT)
    list(APPEND CMAKE_PREFIX_PATH ${CAS_CMAKE_ROOT})
elseif(DEFINED ENV{CAS_CMAKE_ROOT})
    list(APPEND CMAKE_PREFIX_PATH $ENV{CAS_CMAKE_ROOT})
else()
    message(FATAL_ERROR "A environment variable or a cmake parameter named CAS_CMAKE_ROOT should be specified as 'path/to/OpenCASCADE-x.y.z/cmake'.")
endif()
find_package(OpenCASCADE CONFIG REQUIRED)

function(LinkOpenCASCADE target)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        foreach (LIB ${OpenCASCADE_LIBRARIES} )
            target_link_libraries(${target} PUBLIC ${OpenCASCADE_LIBRARY_DIR}d/${LIB}.lib)
            add_custom_command(
                TARGET ${target} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                ${OpenCASCADE_BINARY_DIR}d/${LIB}.dll
                $<TARGET_FILE_DIR:${target}>
            )
        endforeach()
    else()
        foreach (LIB ${OpenCASCADE_LIBRARIES})
            target_link_libraries(${target} PUBLIC ${OpenCASCADE_LIBRARY_DIR}/${LIB}.lib)
            add_custom_command(
                TARGET ${target} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                ${OpenCASCADE_BINARY_DIR}/${LIB}.dll
                $<TARGET_FILE_DIR:${target}>
            )
        endforeach()
    endif()
    target_include_directories(${target} PUBLIC ${OpenCASCADE_INCLUDE_DIR})

    set_property(TARGET ${target} PROPERTY VS_DEBUGGER_ENVIRONMENT "PATH=$<$<CONFIG:DEBUG>:${OpenCASCADE_BINARY_DIR}d>$<$<NOT:$<CONFIG:DEBUG>>:${OpenCASCADE_BINARY_DIR}>;%PATH%")
endfunction()
