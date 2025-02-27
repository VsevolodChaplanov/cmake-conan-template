# cmake-conan-template

Thats is a small template to quick start a new cmake project with a lot features such as 

- many build and configure customization points
- examples for static/shared lib and interface lib
- installation rules
- test for fetch content and conan packaging
- targets for 
    * building
    * examples
    * testing
    * linting
    * formatting
- static analyzers 
- doxygen
- possible cpm predownload script as opposite to conan package manager


# quick start

Change my_project -> to your project name and start to develop

## Using CPM package manager

- Include cmake/cpm.cmake
    
```
include(cmake/cpm.cmake)
```

- Below is example how to modify `CMakePresets.json` to add cpm package manager to suppress some warnings and enable packages caching

```json
    {
        "name": "cpm-common",
        "hidden": true,
        "environment": {
            "CPM_USE_LOCAL_PACKAGES": "ON",
            "CPM_LOCAL_PACKAGES_ONLY": "OFF",
            "CPM_USE_NAMED_CACHE_DIRECTORIES": "ON"
        }
    },
    {
        "name": "cpm-windows",
        "hidden": true,
        "condition": {
            "type": "equals",
            "lhs": "${hostSystemName}",
            "rhs": "Windows"
        },
        "inherits": "cpm-common",
        "environment": {
            "CPM_SOURCE_CACHE": "$env{USERPROFILE}\\.cache\\.cpm"
        }
    },
    {
        "name": "cpm-unix",
        "hidden": true,
        "condition": {
            "type": "equals",
            "lhs": "${hostSystemName}",
            "rhs": "Linux"
        },
        "inherits": "cpm-common",
        "environment": {
            "CPM_SOURCE_CACHE": "$env{HOME}\\.cache\\.cpm"
        }
    },
```