FROM ubuntu:latest

LABEL maintainer="Thomas Seals" 
# grabs latest apt cache, install iperf3, and remove the clutter
RUN apt-get update && \
    apt-get install -y iperf3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose iperf default port
EXPOSE 5201

# requires ags to be passed 
# Example: '-s' to start the listening server
ENTRYPOINT ["iperf3"]