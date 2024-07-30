FROM gcc:11.3.0 AS itk-build-stage

RUN apt-get update
RUN apt-get install cmake git build-essential libtcmalloc-minimal4 cmake gfortran- libboost-all-dev graphviz doxygen -y
RUN ln -s /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so

COPY . /kretz

# Build ITK
WORKDIR /itk-build

RUN cmake -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF /kretz/ITK
RUN make -j

# Build Kretz
WORKDIR /kretz-module-build
RUN cmake -DITK_DIR=/itk-build /kretz
RUN make -j

# Build Kretz Programs
WORKDIR /kretz-programs-build
RUN cmake -DITK_DIR=/itk-build /kretz/examples
RUN make -j

ENTRYPOINT ["/kretz/run.sh"]
