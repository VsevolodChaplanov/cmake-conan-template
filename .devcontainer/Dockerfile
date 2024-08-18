ARG VARIANT="jammy"
FROM ubuntu:${VARIANT}

# Restate the variant to use it later on in the llvm and cmake installations
ARG VARIANT

# By default, anything you run in Docker is done as superuser.
# Conan runs some install commands as superuser, and will prepend `sudo` to
# these commands, unless `CONAN_SYSREQUIRES_SUDO=0` is in your env variables.
ENV CONAN_SYSREQUIRES_SUDO 0
# Some packages request that Conan use the system package manager to install
# a few dependencies. This flag allows Conan to proceed with these installations;
# leaving this flag undefined can cause some installation failures.
ENV CONAN_SYSREQUIRES_MODE enabled

# Env variables to up python
ENV PYTHON_ENV = PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random

# up system env
# Install necessary packages available from standard repos
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    software-properties-common wget apt-utils file zip \
    openssh-client gpg-agent socat rsync \
    make ninja-build git

RUN apt install python3 python3-pip python3-dev -y
RUN pip3 install conan numpy codespell cmakelang


# User-settable versions:
ARG GCC_VER="13"
# Add gcc-${GCC_VER}
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    gcc-${GCC_VER} g++-${GCC_VER} gdb && \
    rm -rf /var/lib/apt/lists/*


# Set gcc-${GCC_VER} as default gcc
RUN update-alternatives --install /usr/bin/gcc gcc $(which gcc-${GCC_VER}) 100 && \
    update-alternatives --install /usr/bin/g++ g++ $(which g++-${GCC_VER}) 100 && \
    update-alternatives --install /usr/bin/gcov gcov $(which gcov-${GCC_VER}) 100


ARG LLVM_VER="18"
# Add clang-${LLVM_VER}
ARG LLVM_URL="http://apt.llvm.org/${VARIANT}/"
ARG LLVM_PKG="llvm-toolchain-${VARIANT}-${LLVM_VER}"
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - 2>/dev/null && \
    add-apt-repository -y "deb ${LLVM_URL} ${LLVM_PKG} main" && \
    apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    clang-${LLVM_VER} lldb-${LLVM_VER} lld-${LLVM_VER} clangd-${LLVM_VER} \
    llvm-${LLVM_VER}-dev libclang-${LLVM_VER}-dev clang-tidy-${LLVM_VER} \
    clang-format-${LLVM_VER} && \
    rm -rf /var/lib/apt/lists/*


# Set the default clang-tidy, so CMake can find it
RUN update-alternatives \
    --verbose \
    --install /usr/bin/llvm-config       llvm-config      /usr/bin/llvm-config-${LLVM_VER} 20 \
    --slave   /usr/bin/llvm-ar           llvm-ar          /usr/bin/llvm-ar-${LLVM_VER} \
    --slave   /usr/bin/llvm-as           llvm-as          /usr/bin/llvm-as-${LLVM_VER} \
    --slave   /usr/bin/llvm-bcanalyzer   llvm-bcanalyzer  /usr/bin/llvm-bcanalyzer-${LLVM_VER} \
    --slave   /usr/bin/llvm-cov          llvm-cov         /usr/bin/llvm-cov-${LLVM_VER} \
    --slave   /usr/bin/llvm-diff         llvm-diff        /usr/bin/llvm-diff-${LLVM_VER} \
    --slave   /usr/bin/llvm-dis          llvm-dis         /usr/bin/llvm-dis-${LLVM_VER} \
    --slave   /usr/bin/llvm-dwarfdump    llvm-dwarfdump   /usr/bin/llvm-dwarfdump-${LLVM_VER} \
    --slave   /usr/bin/llvm-extract      llvm-extract     /usr/bin/llvm-extract-${LLVM_VER} \
    --slave   /usr/bin/llvm-link         llvm-link        /usr/bin/llvm-link-${LLVM_VER} \
    --slave   /usr/bin/llvm-mc           llvm-mc          /usr/bin/llvm-mc-${LLVM_VER} \
    --slave   /usr/bin/llvm-nm           llvm-nm          /usr/bin/llvm-nm-${LLVM_VER} \
    --slave   /usr/bin/llvm-objdump      llvm-objdump     /usr/bin/llvm-objdump-${LLVM_VER} \
    --slave   /usr/bin/llvm-ranlib       llvm-ranlib      /usr/bin/llvm-ranlib-${LLVM_VER} \
    --slave   /usr/bin/llvm-readobj      llvm-readobj     /usr/bin/llvm-readobj-${LLVM_VER} \
    --slave   /usr/bin/llvm-rtdyld       llvm-rtdyld      /usr/bin/llvm-rtdyld-${LLVM_VER} \
    --slave   /usr/bin/llvm-size         llvm-size        /usr/bin/llvm-size-${LLVM_VER} \
    --slave   /usr/bin/llvm-stress       llvm-stress      /usr/bin/llvm-stress-${LLVM_VER} \
    --slave   /usr/bin/llvm-symbolizer   llvm-symbolizer  /usr/bin/llvm-symbolizer-${LLVM_VER} \
    --slave   /usr/bin/llvm-tblgen       llvm-tblgen      /usr/bin/llvm-tblgen-${LLVM_VER} \
    --slave   /usr/bin/llvm-objcopy      llvm-objcopy     /usr/bin/llvm-objcopy-${LLVM_VER} \
    --slave   /usr/bin/llvm-strip        llvm-strip       /usr/bin/llvm-strip-${LLVM_VER}

RUN update-alternatives \
    --verbose \
    --install /usr/bin/clang                 clang                 /usr/bin/clang-${LLVM_VER} 20 \
    --slave   /usr/bin/clang++               clang++               /usr/bin/clang++-${LLVM_VER}  \
    --slave   /usr/bin/asan_symbolize        asan_symbolize        /usr/bin/asan_symbolize-${LLVM_VER} \
    --slave   /usr/bin/clang-cpp             clang-cpp             /usr/bin/clang-cpp-${LLVM_VER} \
    --slave   /usr/bin/clang-check           clang-check           /usr/bin/clang-check-${LLVM_VER} \
    --slave   /usr/bin/clang-cl              clang-cl              /usr/bin/clang-cl-${LLVM_VER} \
    --slave   /usr/bin/ld.lld                ld.lld                /usr/bin/ld.lld-${LLVM_VER} \
    --slave   /usr/bin/lld                   lld                   /usr/bin/lld-${LLVM_VER} \
    --slave   /usr/bin/lld-link              lld-link              /usr/bin/lld-link-${LLVM_VER} \
    --slave   /usr/bin/clang-format          clang-format          /usr/bin/clang-format-${LLVM_VER} \
    --slave   /usr/bin/clang-format-diff     clang-format-diff     /usr/bin/clang-format-diff-${LLVM_VER} \
    --slave   /usr/bin/clang-include-fixer   clang-include-fixer   /usr/bin/clang-include-fixer-${LLVM_VER} \
    --slave   /usr/bin/clang-offload-bundler clang-offload-bundler /usr/bin/clang-offload-bundler-${LLVM_VER} \
    --slave   /usr/bin/clang-query           clang-query           /usr/bin/clang-query-${LLVM_VER} \
    --slave   /usr/bin/clang-rename          clang-rename          /usr/bin/clang-rename-${LLVM_VER} \
    --slave   /usr/bin/clang-reorder-fields  clang-reorder-fields  /usr/bin/clang-reorder-fields-${LLVM_VER} \
    --slave   /usr/bin/clang-tidy            clang-tidy            /usr/bin/clang-tidy-${LLVM_VER} \
    --slave   /usr/bin/lldb                  lldb                  /usr/bin/lldb-${LLVM_VER} \
    --slave   /usr/bin/lldb-server           lldb-server           /usr/bin/lldb-server-${LLVM_VER} \
    --slave   /usr/bin/clangd                clangd                /usr/bin/clangd-${LLVM_VER}


# cmake install stage
ARG CMAKE_URL="https://apt.kitware.com/ubuntu/"
ARG CMAKE_PKG=${VARIANT}
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
    | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository -y "deb ${CMAKE_URL} ${CMAKE_PKG} main" && \
    apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends cmake cmake-curses-gui && \
    rm -rf /var/lib/apt/lists/*


# Install optional dependencies
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    doxygen graphviz ccache cppcheck && \
    rm -rf /var/lib/apt/lists/*

# Install include-what-you-use
ENV IWYU /home/iwyu
ENV IWYU_BUILD ${IWYU}/build
ENV IWYU_SRC ${IWYU}/include-what-you-use
RUN mkdir -p ${IWYU_BUILD} && \
    git clone --branch clang_${LLVM_VER} \
    https://github.com/include-what-you-use/include-what-you-use.git \
    ${IWYU_SRC}
RUN CC=clang-${LLVM_VER} CXX=clang++-${LLVM_VER} cmake -S ${IWYU_SRC} \
    -B ${IWYU_BUILD} \
    -G "Unix Makefiles" -DCMAKE_PREFIX_PATH=/usr/lib/llvm-${LLVM_VER} && \
    cmake --build ${IWYU_BUILD} -j && \
    cmake --install ${IWYU_BUILD}

# Per https://github.com/include-what-you-use/include-what-you-use#how-to-install:
# `You need to copy the Clang include directory to the expected location before
#  running (similarly, use include-what-you-use -print-resource-dir to learn
#  exactly where IWYU wants the headers).`
RUN mkdir -p $(include-what-you-use -print-resource-dir 2>/dev/null)
RUN ln -s $(readlink -f /usr/lib/clang/${LLVM_VER}/include) \
    $(include-what-you-use -print-resource-dir 2>/dev/null)/include

## Cleanup cached apt data we don't need anymore
RUN apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Allow the user to set compiler defaults
ARG USE_CLANG
# if --build-arg USE_CLANG=1, set CC to 'clang' or set to null otherwise.
ENV CC=${USE_CLANG:+"clang"}
ENV CXX=${USE_CLANG:+"clang++"}
# if CC is null, set it to 'gcc' (or leave as is otherwise).
ENV CC=${CC:-"gcc"}
ENV CXX=${CXX:-"g++"}

ENV LC_ALL="en_US.UTF-8"

CMD ["/bin/bash"]