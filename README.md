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

## Python and tools

Some tools can be consumed using python's pip or other tool. Project contains special targets for spell to enable them from venv, pass an env variable in preset (it can be helpful to find venv's python instead of system one)

```json
...
{
    "name": "pyvenv",
    "hidden": true,
    "environment": {
        "VIRTUAL_ENV": "${sourceDir}/.venv"
    },
    "cacheVariables": {
        "Python_FIND_VIRTUALENV": "FIRST"
    }
}
...
```

You can activate venv in several ways but recommend to use [uv](https://docs.astral.sh/uv/)

## Using Sanitizers

Sanitizers are now configured through CMake presets instead of CMake options. This provides better control and easier management of sanitizer configurations.

### Available Sanitizer Presets

The following sanitizer presets are available:

- **`sanitize-address`** - Address sanitizer for detecting memory errors
- **`sanitize-leak`** - Leak sanitizer for detecting memory leaks  
- **`sanitize-ub`** - Undefined behavior sanitizer
- **`sanitize-thread`** - Thread sanitizer for detecting data races
- **`sanitize-memory`** - Memory sanitizer (Clang only)
- **`sanitize-safe-stack`** - Safe stack sanitizer (Clang only)
- **`sanitize-address-leak-ub`** - Combined address, leak, and undefined behavior sanitizers

### Usage Examples

To use a single sanitizer:
```bash
cmake --preset ci-ubuntu-debug-sanitize-address
```

**Note**: Some sanitizers are incompatible with each other:
- Thread sanitizer doesn't work with Address or Leak sanitizer
- Memory sanitizer doesn't work with Address, Thread, or Leak sanitizer
- MSVC only supports address sanitizer

You declare `CONAN_COMMAND` variable for [cmake-conan](https://github.com/conan-io/cmake-conan) wrapper and conan will be stored in current venv.