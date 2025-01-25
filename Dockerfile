FROM ubuntu:latest

# Install necessary packages

# Install dependencies including flex
RUN apt-get update && \
    apt-get install -y autoconf libtool pkg-config build-essential libpcap-dev libsqlite3-dev lua5.3 lua5.3-dev \
                       libpcre3-dev zlib1g-dev libnet1-dev libdumbnet-dev libgeoip-dev cmake g++ git wget unzip \
                       libhwloc-dev bison flex liblzma-dev openssl libssl-dev cpputest uuid-dev libcmocka-dev \
                       libnetfilter-queue-dev libmnl-dev autotools-dev libluajit-5.1-dev libunwind-dev libfl-dev && \
    wget https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz && \
    tar -xvzf flex-2.6.4.tar.gz && cd flex-2.6.4 && ./configure && make -j$(nproc) && make install && ldconfig

# Install libdaq
RUN git clone https://github.com/snort3/libdaq.git /opt/libdaq && \
    cd /opt/libdaq && ./bootstrap && ./configure && make -j$(nproc) && make install && ldconfig

# Clone and build Snort
RUN git clone https://github.com/snort3/snort3.git /opt/snort3/snort && \
    cd /opt/snort3/snort && mkdir build && cd build && cmake .. && make -j$(nproc) && make install

# Create Snort log directory
RUN mkdir -p /var/log/snort

# Copy configuration files and rules (to be added later)
COPY snort.lua /usr/local/etc/snort/snort.lua
COPY rules/ /usr/local/etc/rules/

# Expose port (optional, for management purposes)
EXPOSE 9000

# Default command to run Snort
CMD ["/usr/local/bin/snort", "-i", "ens33", "-l", "/var/log/snort", "-c", "/usr/local/etc/snort/snort.lua"]
