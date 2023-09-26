# docker build , -t name
# docker run --rm -v .:/workspace name

FROM debian:12

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends tzdata

ENV TZ=Europe/CET
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN <<EOF
        apt-get install -y --no-install-recommends git vim-tiny build-essential cmake make gdb valgrind cppcheck clang clang-format llvm libclang-rt-dev libgtest-dev
        apt-get clean
        cd /usr/src/gtest && cmake CMakeLists.txt && make && cp lib/*.a /usr/lib && ln -s /usr/lib/libgtest.a /usr/local/lib/libgtest.a && ln -s /usr/lib/libgtest_main.a /usr/local/lib/libgtest_main.a
EOF

RUN useradd -ms /bin/bash user
USER user
WORKDIR /workspace

CMD cmake -B build \
        && cmake --build build \
        && build/*-tests \
        && valgrind --leak-check=full --error-exitcode=1 build/*-tests
