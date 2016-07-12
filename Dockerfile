FROM ubuntu:trusty
MAINTAINER Abi Hafshin <abi@hafs.in>

ENV TERM xterm
VOLUME /data

ADD ./conf /conf
ADD ./docker-entrypoint.sh /docker-entrypoint.sh

RUN apt update && apt upgrade -y && \
    apt install -y  --no-install-recommends \
       git ca-certificates software-properties-common && \
    \
    git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/mjolnir.git && \
    git clone --depth=1 --recurse-submodules --single-branch --branch=master https://github.com/valhalla/tools.git && \
    pushd mjolnir && \
    ./scripts/dependencies.sh && ./scripts/install.sh && \
    popd && \
    pushd tools && \
    ./scripts/dependencies.sh && ./scripts/install.sh && \
    popd && \
    \
    ldconfig && \
    apt install -y  --no-install-recommends \
        liblua5.2-0 libgeos-3.4.2 libspatialite5 \
        libboost-filesystem1.54.0 libboost-graph1.54.0 \
        libboost-thread1.54.0 libboost-system1.54.0 libboost-regex1.54.0 \
        libboost-program-options1.54.0 && \
    apt purge --auto-remove \
        git g++ gcc autoconf automake binutils `apt list --manual-installed | cut -d"/" -f1 | grep "\-dev"` && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /mjolnir /tools
    
EXPOSE 8002
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/data/valhalla.json"]
