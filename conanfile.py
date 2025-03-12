import os
import re
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps


class ProjectRecipe(ConanFile):
    package_type = "library"

    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": True}

    # Sources are located in the same place as this recipe, copy them to the recipe
    # way of simplify is to use "*" - export all files
    exports_sources = (
        "CMakeLists.txt",
        "dependencies.cmake",
        "options.cmake",
        "core/**",
        "utility/**",
        "cmake/**",)

    @property
    def _project_components(self):
        def fmt(): return ['fmt::fmt']

        project_components = [
            {
                'target': 'utility',
            },
            {
                'target': 'core',
                'lib': 'core',
                'requires': (
                    ['utility']
                    + fmt()
                ),
            }
        ]

        return project_components
    
    def set_name(self):
        cmakelists_path = os.path.join(self.recipe_folder, "CMakeLists.txt")
        with open(cmakelists_path, "r") as f:
            cmake_content = f.read()

            # Extract version from `project()` statement
            match = re.search(r"project\(\s*([\w\-]+)", cmake_content)
            if match:
                self.name = match.group(1)
                print(self.name)
            else:
                raise ValueError("`NAME` not found in CMakeLists.txt")
    
    def set_version(self):
        cmakelists_path = os.path.join(self.recipe_folder, "CMakeLists.txt")
        with open(cmakelists_path, "r") as f:
            cmake_content = f.read()

            # Extract version from `project()` statement
            match = re.search(r"VERSION\s+(\d+\.\d+\.\d+)\s*", cmake_content)
            if match:
                self.version = match.group(1)
            else:
                raise ValueError("Version not found in CMakeLists.txt")

    def requirements(self):
        self.requires("fmt/11.1.4")
        self.test_requires("catch2/3.8.0")

    def config_options(self):
        if self.settings.os == "Windows":
            self.options.rm_safe("fPIC")

    def configure(self):
        if self.options.shared:
            self.options.rm_safe("fPIC")

    def layout(self):
        cmake_layout(self)
        os_name = self.settings.os
        self.folders.generators = f"conan/{os_name}"

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        tc = CMakeToolchain(self)

        tc.cache_variables[f"{self.name}_BUILD_TESTING"] = False
        tc.cache_variables[f"{self.name}_BUILD_EXAMPLES"] = False
        tc.cache_variables[f"{self.name}_BUILD_DOCS"] = False

        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        #! ----
        #! CMake only based solution for provide package info and to reuse cmake configs 
        #! package do not propagates its requirements for consumers
        #! ----
        
        self.cpp_info.set_property('cmake_find_mode', 'none')
        self.cpp_info.builddirs.append(os.path.join('lib', 'cmake', f"{self.name}"))

        #! ----
        #! Below is example of packaging `generic` package
        #! Compatible with any other build tools but requires to 
        #! repeat cmake's info
        #! Might become redundant with the arrival CPS
        #! ----

        # debug = 'd' if self.settings.build_type == 'Debug' else ''

        # # declare super-target
        # self.cpp_info.set_property("cmake_find_mode", "both")
        # self.cpp_info.set_property("cmake_file_name", f"{self.name}")
        # self.cpp_info.set_property("cmake_target_name", f"{self.name}::{self.name}")

        # self.cpp_info.components[f"utility"].bindirs = []
        # self.cpp_info.components[f"utility"].libdirs = []        
        # self.cpp_info.components[f"utility"].set_property("cmake_target_name", f"{self.name}::utility")

        # self.cpp_info.components[f"core"].libs.append(f"core{debug}")
        # self.cpp_info.components[f"core"].requires.extend(["fmt::fmt"])
        # self.cpp_info.components[f"core"].set_property("cmake_target_name", f"{self.name}::core")

