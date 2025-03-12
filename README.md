# cmake-conan-template

Thats is a small template based on [cmake-init](https://github.com/friendlyanon/cmake-init) to quick start a new cmake project with a lot features such as:

- many build and configure customization points
- examples for static/shared lib and interface lib
- installation rules
- test for fetch content and conan packaging
- targets for
  - building
  - examples
  - testing
  - linting
  - formatting
- static analyzers
- doxygen
- possible cpm predownload script as opposite to conan package manager

Main changes differences form `cmake-init` is more `target-oriented` cmake tools, possibility to divide project on subprojects and some scripts improvements

## quick start

- [ ] Change `my_project` -> `your project name`
- [ ] Change `my_project` directories -> `your project name` directories, because includes given in form `#include <my_project/core/core.hpp>`
- [ ] In main `CMakeLists.txt` fill `DESCRIPTION`, `HOMEPAGE_URL` and `VERSION`
- [ ] In `cmake/packaging.cmake` fill package info
- [ ] Add to vcs ignore `fetch_content_test` and `test_package` folders or remove if do not required for package consume tests support. `fetch_content_test` contains link to github repository where `fetch` package. Better to have separate repo with this tests group, they are presented here for example.
- [ ] Fill version and other fields in `pyproject.toml` if required

## Using CPM package manager

- Include cmake/cpm.cmake

```cmake
include(cmake/cpm.cmake)
```

- Below is example how to modify `CMakePresets.json` to add cpm package manager to suppress some warnings and enable packages caching

```json
...
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
...
```
