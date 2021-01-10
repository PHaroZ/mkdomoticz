FROM debian:buster
MAINTAINER PHaroZ

ARG DOMOTICZ_VERSION="master"

# install packages
RUN apt-get update && apt-get install -y \
	make gcc g++ libssl-dev git libcurl4-gnutls-dev libusb-dev python3-dev zlib1g-dev \
    libcereal-dev liblua5.3-dev uthash-dev \
	build-essential cmake \
	libboost-all-dev \
	libsqlite3-dev \
	curl \
	wget \
	libffi-dev \
	libusb-0.1-4 \
	libudev-dev \
	python3-pip \
    fail2ban && \
    apt-get remove -y --purge --auto-remove cmake

RUN apt-get update && apt-get install -y \
        liblua5.2-dev

COPY scripts/cmaker.sh /scripts/cmaker.sh
RUN bash /scripts/cmaker.sh


## Domoticz installation
# clone git source in src
RUN git clone --depth 2 https://github.com/domoticz/domoticz.git /src/domoticz && \
# Domoticz needs the full history to be able to calculate the version string
cd /src/domoticz && \
git fetch --unshallow && \
# prepare makefile
cmake -DCMAKE_BUILD_TYPE=Release . && \
# compile
make


# remove git and tmp dirs ; cleanup of apt
RUN apt-get remove -y git cmake linux-headers-amd64 build-essential libssl-dev libboost-dev libboost-thread-dev libboost-system-dev libsqlite3-dev libcurl4-openssl-dev libusb-dev zlib1g-dev libudev-dev && \
   apt-get autoremove -y && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/*


VOLUME /config

EXPOSE 8080

COPY scripts/start.sh /start.sh

#ENTRYPOINT ["/src/domoticz/domoticz", "-dbase", "/config/domoticz.db", "-log", "/config/domoticz.log"]
#CMD ["-www", "8080"]
CMD [ "/start.sh" ]
