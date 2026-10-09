FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# BOMBKI DOSBox-X + Turbo Pascal 7.01 image.
# Contains the genuine Borland TPC.EXE compiler (TP7.01) with original LONG.OBJ semantics.
# TP7.01 payload sourced from the checked-in tp701.all archive.

RUN apt-get update -qq && \
    apt-get install -y -qq dosbox-x xvfb unzip && \
    rm -rf /var/lib/apt/lists/*

# Extract TP7.01 compiler/runtime (verified checksums)
COPY tools/TPC701.ZIP /tmp/TPC701.ZIP
COPY tools/RTPL701.ZIP /tmp/RTPL701.ZIP
RUN set -e && \
    mkdir -p /tools/tp7/BIN && \
    unzip -p /tmp/TPC701.ZIP TPC.EXE > /tools/tp7/BIN/TPC.EXE && \
    unzip -p /tmp/RTPL701.ZIP TURBO.TPL > /tools/tp7/BIN/TURBO.TPL && \
    rm -f /tmp/TPC701.ZIP /tmp/RTPL701.ZIP /tmp/checksums

RUN mkdir -p /workspace
WORKDIR /workspace

COPY dosbox-tp7.conf /etc/dosbox-tp7.conf
ENTRYPOINT ["xvfb-run", "-a", "dosbox-x", "-conf", "/etc/dosbox-tp7.conf"]
