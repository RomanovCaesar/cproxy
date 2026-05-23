FROM alpine:latest as builder
ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"

RUN apk add --no-cache gzip && \
    mkdir /cproxy-config && \
    wget -O /cproxy-config/geoip.metadb https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb && \
    wget -O /cproxy-config/geosite.dat https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat && \
    wget -O /cproxy-config/geoip.dat https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat

COPY docker/file-name.sh /cproxy/file-name.sh
WORKDIR /cproxy
COPY bin/ bin/
RUN FILE_NAME=`sh file-name.sh` && echo $FILE_NAME && \
    FILE_NAME=`ls bin/ | egrep "$FILE_NAME.gz"|awk NR==1` && echo $FILE_NAME && \
    mv bin/$FILE_NAME cproxy.gz && gzip -d cproxy.gz && chmod +x cproxy && echo "$FILE_NAME" > /cproxy-config/test
FROM alpine:latest
LABEL org.opencontainers.image.source="https://github.com/RomanovCaesar/cproxy"

RUN apk add --no-cache ca-certificates tzdata iptables

VOLUME ["/root/.config/cproxy/"]

COPY --from=builder /cproxy-config/ /root/.config/cproxy/
COPY --from=builder /cproxy/cproxy /cproxy
ENTRYPOINT [ "/cproxy" ]
