# docker build , -t name
# docker run --rm -v .:/workspace name

FROM debian:12

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends tzdata

ENV TZ=Europe/CET
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN <<EOF
        apt-get install -y --no-install-recommends ca-certificates apt-transport-https
        apt-get install -y --no-install-recommends git vim-tiny build-essential cmake make gdb valgrind cppcheck clang clang-format llvm libclang-rt-dev libgtest-dev
        apt-get clean
EOF

RUN <<EOF
        git clone https://github.com/google/googletest.git -b v1.14.0 --depth 1
        cd googletest        # Main directory of the cloned repository.
        mkdir build          # Create a directory to hold the build output.
        cd build
        cmake ..             # Generate native build scripts for GoogleTest.
        make -j4
        make install
        cd ../..
        rm -rf googletest
EOF

RUN useradd -ms /bin/bash user
USER user
WORKDIR /workspace

CMD cmake -B build \
        && cmake --build build \
        && build/*-tests \
        && valgrind --leak-check=full --error-exitcode=1 build/*-tests
