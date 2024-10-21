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
ENV PYTHONUNBUFFERED 1

# up system env
# Install necessary packages available from standard repos
RUN apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    software-properties-common wget apt-utils file zip \
    openssh-client gpg-agent socat rsync \
    make ninja-build git lcov gcovr valgrind && \
    rm -rf /var/lib/apt/lists/*

RUN apt update -qq && apt install python3 python3-pip python3-dev -y && rm -rf /var/lib/apt/lists/*

# boost has build issues with numpy2.0
RUN pip3 install conan numpy==1.26 codespell cmakelang


# User-settable versions:
ARG GCC_VER="13"
# Add gcc-${GCC_VER}
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    gcc-${GCC_VER} g++-${GCC_VER} gdb && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives \
    --verbose \
    --install /usr/bin/gcc gcc $(which gcc-${GCC_VER}) 20 \
    --slave   /usr/bin/g++ g++ $(which g++-${GCC_VER}) \
    --slave   /usr/bin/gcov gcov $(which gcov-${GCC_VER})

ARG LLVM_VER="18"
# Add clang-${LLVM_VER}
ARG LLVM_URL="http://apt.llvm.org/${VARIANT}/"
ARG LLVM_PKG="llvm-toolchain-${VARIANT}-${LLVM_VER}"
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - 2>/dev/null && \
    add-apt-repository -y "deb ${LLVM_URL} ${LLVM_PKG} main" && \
    apt-get update -qq && export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
    clang-${LLVM_VER} lldb-${LLVM_VER} lld-${LLVM_VER} clangd-${LLVM_VER} \
    llvm-${LLVM_VER}-dev libclang-${LLVM_VER}-dev libclang-rt-${LLVM_VER}-dev clang-tidy-${LLVM_VER} \
    clang-format-${LLVM_VER} && \
    rm -rf /var/lib/apt/lists/*


# Set the default clang-tidy, so CMake can find it
RUN update-alternatives \
    --verbose \
    --install /usr/bin/llvm-config       llvm-config      $(which llvm-config-${LLVM_VER}) 20 \
    --slave   /usr/bin/llvm-ar           llvm-ar          $(which llvm-ar-${LLVM_VER}) \
    --slave   /usr/bin/llvm-as           llvm-as          $(which llvm-as-${LLVM_VER}) \
    --slave   /usr/bin/llvm-bcanalyzer   llvm-bcanalyzer  $(which llvm-bcanalyzer-${LLVM_VER}) \
    --slave   /usr/bin/llvm-cov          llvm-cov         $(which llvm-cov-${LLVM_VER}) \
    --slave   /usr/bin/llvm-diff         llvm-diff        $(which llvm-diff-${LLVM_VER}) \
    --slave   /usr/bin/llvm-dis          llvm-dis         $(which llvm-dis-${LLVM_VER}) \
    --slave   /usr/bin/llvm-dwarfdump    llvm-dwarfdump   $(which llvm-dwarfdump-${LLVM_VER}) \
    --slave   /usr/bin/llvm-extract      llvm-extract     $(which llvm-extract-${LLVM_VER}) \
    --slave   /usr/bin/llvm-link         llvm-link        $(which llvm-link-${LLVM_VER}) \
    --slave   /usr/bin/llvm-mc           llvm-mc          $(which llvm-mc-${LLVM_VER}) \
    --slave   /usr/bin/llvm-nm           llvm-nm          $(which llvm-nm-${LLVM_VER}) \
    --slave   /usr/bin/llvm-objdump      llvm-objdump     $(which llvm-objdump-${LLVM_VER}) \
    --slave   /usr/bin/llvm-ranlib       llvm-ranlib      $(which llvm-ranlib-${LLVM_VER}) \
    --slave   /usr/bin/llvm-readobj      llvm-readobj     $(which llvm-readobj-${LLVM_VER}) \
    --slave   /usr/bin/llvm-rtdyld       llvm-rtdyld      $(which llvm-rtdyld-${LLVM_VER}) \
    --slave   /usr/bin/llvm-size         llvm-size        $(which llvm-size-${LLVM_VER}) \
    --slave   /usr/bin/llvm-stress       llvm-stress      $(which llvm-stress-${LLVM_VER}) \
    --slave   /usr/bin/llvm-symbolizer   llvm-symbolizer  $(which llvm-symbolizer-${LLVM_VER}) \
    --slave   /usr/bin/llvm-tblgen       llvm-tblgen      $(which llvm-tblgen-${LLVM_VER}) \
    --slave   /usr/bin/llvm-objcopy      llvm-objcopy     $(which llvm-objcopy-${LLVM_VER}) \
    --slave   /usr/bin/llvm-strip        llvm-strip       $(which llvm-strip-${LLVM_VER}) \
    --slave   /usr/bin/llvm-profdata     llvm-profdata    $(which llvm-profdata-${LLVM_VER})

RUN update-alternatives \
    --verbose \
    --install /usr/bin/clang                 clang                 $(which clang-${LLVM_VER}) 20 \
    --slave   /usr/bin/clang++               clang++               $(which clang++-${LLVM_VER}) \
    --slave   /usr/bin/asan_symbolize        asan_symbolize        $(which asan_symbolize-${LLVM_VER}) \
    --slave   /usr/bin/clang-cpp             clang-cpp             $(which clang-cpp-${LLVM_VER}) \
    --slave   /usr/bin/clang-check           clang-check           $(which clang-check-${LLVM_VER}) \
    --slave   /usr/bin/clang-cl              clang-cl              $(which clang-cl-${LLVM_VER}) \
    --slave   /usr/bin/ld.lld                ld.lld                $(which ld.lld-${LLVM_VER}) \
    --slave   /usr/bin/lld                   lld                   $(which lld-${LLVM_VER}) \
    --slave   /usr/bin/lld-link              lld-link              $(which lld-link-${LLVM_VER}) \
    --slave   /usr/bin/clang-format          clang-format          $(which clang-format-${LLVM_VER}) \
    --slave   /usr/bin/clang-format-diff     clang-format-diff     $(which clang-format-diff-${LLVM_VER}) \
    --slave   /usr/bin/clang-include-fixer   clang-include-fixer   $(which clang-include-fixer-${LLVM_VER}) \
    --slave   /usr/bin/clang-offload-bundler clang-offload-bundler $(which clang-offload-bundler-${LLVM_VER}) \
    --slave   /usr/bin/clang-query           clang-query           $(which clang-query-${LLVM_VER}) \
    --slave   /usr/bin/clang-rename          clang-rename          $(which clang-rename-${LLVM_VER}) \
    --slave   /usr/bin/clang-reorder-fields  clang-reorder-fields  $(which clang-reorder-fields-${LLVM_VER}) \
    --slave   /usr/bin/clang-tidy            clang-tidy            $(which clang-tidy-${LLVM_VER}) \
    --slave   /usr/bin/lldb                  lldb                  $(which lldb-${LLVM_VER}) \
    --slave   /usr/bin/lldb-server           lldb-server           $(which lldb-server-${LLVM_VER}) \
    --slave   /usr/bin/clangd                clangd                $(which clangd-${LLVM_VER} \
    --slave   /usr/bin/clang-apply-replacements clang-apply-replacements $(which clang-apply-replacements-${LLVM_VER})


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
    cmake --build ${IWYU_BUILD} --parallel 4 && \
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