from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps


class ProjectRecipe(ConanFile):
    name = "my_project"
    version = "0.1"
    package_type = "library"

    # Optional metadata
    license = "<Put the package license here>"
    author = "<Put your name here> <And your email here>"
    url = "<Package recipe repository url here, for issues about the package>"
    description = "<Description of project package here>"
    topics = ("<Put some tag here>", "<here>", "<and here>")

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
        "cmake/*")

    @property
    def _project_components(self):
        def fmt(): return ['fmt::fmt']

        project_components = [
            {
                'target': 'core',
                'lib': 'core',
                'requires': (fmt())
            }
        ]

        return project_components

    def requirements(self):
        self.requires("fmt/[10.2.1]", transitive_headers=True)
        self.test_requires("catch2/3.5.3")

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
            return f'{module}{debug}'
    
        def add_components(components):
            for component in components:
                conan_component = component['target']
                cmake_target = component['target']
                requires = component['requires']
                lib_name = get_lib_name(component['lib'])
                self.cpp_info.components[conan_component].set_property(
                    'cmake_target_name', f'{self.name}::' + cmake_target,
                )
                self.cpp_info.components[conan_component].requires = requires
                self.cpp_info.components[conan_component].libs = [lib_name]

        add_components(self._project_components)
