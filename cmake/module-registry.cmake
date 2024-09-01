# Wrapper around and subdirectory

include_guard(GLOBAL)

set(MODULES_REGISTRY
    ""
    CACHE INTERNAL "Contains all porject modules")

# wraps add_subdirectory(module) to automatically register modules in cache
macro(register_module module)
    list(FIND MODULES_REGISTRY ${module} INDEX)
    if(INDEX EQUAL -1)
        set(MODULES_REGISTRY
            "${MODULES_REGISTRY};${module}"
            CACHE INTERNAL "Contains all porject modules")
    endif()
    add_subdirectory(${module})
endmacro()
