FROM debian:bookworm-slim

# Arguments passed from commandline
ARG FSA_USERNAME
ARG FSA_PASSWORD

# Add FreeSwitch user and group
RUN groupadd -r freeswitch && useradd -r -g freeswitch freeswitch

# Open ports to container
# NOTE: Recommended ports.  These can be adjusted as necessary.
# ESL, SIP/SIPS, RTP
EXPOSE 8021/tcp
EXPOSE 5060/tcp 5060/udp
EXPOSE 5080/tcp 5080/udp
EXPOSE 5061/tcp 5081/tcp

# Install required packages
RUN apt-get update && apt-get install -y \
    gnupg2          \
    wget            \
    lsb-release     \
    telnet          \
    procps          \
    net-tools       \
    software-properties-common     \
    apt-transport-https

# Set up apt with FSA repo
RUN /usr/bin/wget --http-user=$FSA_USERNAME --http-password=$FSA_PASSWORD -O - https://fsa.freeswitch.com/repo/deb/fsa/pubkey.gpg | apt-key add - 
RUN echo "machine fsa.freeswitch.com login $FSA_USERNAME password $FSA_PASSWORD" > /etc/apt/auth.conf
RUN echo "deb https://fsa.freeswitch.com/repo/deb/fsa/ `lsb_release -sc` 1.8" > /etc/apt/sources.list.d/freeswitch.list
RUN echo "deb-src https://fsa.freeswitch.com/repo/deb/fsa/ `lsb_release -sc` 1.8" >> /etc/apt/sources.list.d/freeswitch.list

# Install FreeSWITCH from packages
RUN apt-get update && apt-get install -y freeswitch-meta-all

# CONFIGURATION (to be added as needed)
# Set event_socket to localhost
RUN sed -i 's/::/127.0.0.1/g' /etc/freeswitch/autoload_configs/event_socket.conf.xml

# Start FreeSwitch and drop into console
# The startup switches can be changed to whatever is needed.
ENTRYPOINT ["/usr/bin/freeswitch","-u", "freeswitch", "-g", "freeswitch", "-nonat", "-c"]
