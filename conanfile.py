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
        "core/include/*",
        "core/src/*",
        "core/cmake/*",
        "core/CMakeLists.txt",
        "utility/include/*",
        "utility/src/*",
        "utility/cmake/*",
        "utility/CMakeLists.txt",
        "cmake/*")

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
        self.requires("fmt/[11.0.2]", transitive_headers=True)
        self.test_requires("catch2/3.5.3")

    def config_options(self):
        if self.settings.os == "Windows":
            self.options.rm_safe("fPIC")

    def configure(self):
        if self.options.shared:
            self.options.rm_safe("fPIC")

    def layout(self):
        cmake_layout(self)

    def generate(self):
        deps = CMakeDeps(self)
        deps.generate()
        tc = CMakeToolchain(self)
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        debug = (
            'd'
            if self.settings.build_type == 'Debug'
            and self.settings.os == 'Windows'
            else ''
        )

        def get_lib_name(module):
            return f'{module}{debug}' if module else None

        self.cpp_info.set_property("cmake_find_mode", "both")
        self.cpp_info.set_property("cmake_file_name", f"{self.name}")

        for component in self._project_components:
            target = component["target"]
            lib = get_lib_name(component.get("lib", None))

            self.cpp_info.components[target].set_property(
                "cmake_target_name", f"{self.name}::{target}")
            self.cpp_info.components[target].libs = [
                f"{self.name}-{lib}"] if lib else []

            requirements = component.get("requires", [])
            self.cpp_info.components[target].requires = requirements
        
        # this approach can be used if package consumed only by cmake projects
        # self.cpp_info.builddirs.append(os.path.join('share', f'{self.name}'))
        # self.cpp_info.set_property("cmake_find_mode", "none")
