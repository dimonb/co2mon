FROM ubuntu:14.04

RUN apt-get update && apt-get install -y git
RUN apt-get install -y libhidapi-dev cmake

RUN git clone https://github.com/dmage/co2mon.git

RUN apt-get install -y build-essential
RUN apt-get install -y libhidapi-libusb0
RUN apt-get install -y pkg-config

RUN mkdir co2mon/build && cd co2mon/build && cmake .. && make

RUN apt-get purge -y --auto-remove  git cmake build-essential libhidapi-libusb0 pkg-config
RUN apt-get install -y libhidapi-libusb0 curl

COPY monitor.sh /monitor.sh

CMD /monitor.sh
