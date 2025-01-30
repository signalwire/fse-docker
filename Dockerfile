FROM debian:bookworm-slim

# Add FreeSwitch user and group
RUN groupadd -r freeswitch && useradd -r -g freeswitch freeswitch

# Open ports to container
# NOTE: Recommended ports.  These can be adjusted as necessary.
# ESL, SIP/SIPS, RTP
EXPOSE 443/tcp
EXPOSE 8021/tcp
EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 6050/tcp 6050/udp
EXPOSE 5061/tcp 5061/udp 5081/tcp 5081/udp
EXPOSE 7443/tcp
EXPOSE 5070/udp 5070/tcp
EXPOSE 64535-65535/udp
EXPOSE 16384-32768/udp
EXPOSE 8081/tcp 8082/tcp

# Install required packages
RUN apt-get update && apt-get install -y \
    gnupg2          \
    wget            \
    lsb-release     \
    telnet          \
    procps          \
    net-tools       \
    curl            \
    software-properties-common     \
    apt-transport-https

# Copy any custom modules (mod directory) and install
COPY mod /usr/src/mod

# Set up apt with FSA stack repo creds
RUN --mount=type=secret,id=secrets \
    FSA_TOKEN=$(cat /run/secrets/secrets | grep 'FSA_TOKEN' | sed 's/FSA_TOKEN=//g' ); \
    echo "machine fsa.freeswitch.com login signalwire password $FSA_TOKEN" > /etc/apt/auth.conf; \    
    /usr/bin/curl --netrc-file /etc/apt/auth.conf -o - https://fsa.freeswitch.com/repo/deb/fsa/pubkey.gpg | apt-key add - ; \
    echo "deb https://fsa.freeswitch.com/repo/deb/fsa/ `lsb_release -sc` 1.8" > /etc/apt/sources.list.d/freeswitch.list; \
    echo "deb-src https://fsa.freeswitch.com/repo/deb/fsa/ `lsb_release -sc` 1.8" >> /etc/apt/sources.list.d/freeswitch.list; \
    apt-get update && apt-get install -y freeswitch-meta-all; \
    if [ -d /usr/src/mod ]; then \
        for file in $(find /usr/src/mod/ -name "*.deb"); do \
            dpkg -i $file; \
        done; \
        apt-get update && apt-get upgrade -y; \
    fi; \
    rm -f /etc/apt/auth.conf


# CONFIGURATION (to be added as needed)
# Set event_socket to localhost
RUN sed -i 's/::/127.0.0.1/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml

# Start FreeSwitch and drop into console
# The startup switches can be changed to whatever is needed.
ENTRYPOINT ["/usr/bin/freeswitch","-u", "freeswitch", "-g", "freeswitch", "-nonat", "-c"]
