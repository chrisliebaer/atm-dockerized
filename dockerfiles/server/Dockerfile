FROM ubuntu:latest as builder
ARG SERVER_FILES_URL
RUN apt update && apt install -y curl unzip
RUN curl -L "$SERVER_FILES_URL" -o /tmp/server.zip \
  && unzip -q /tmp/server.zip -d /tmp/mc-server \
  && rm /tmp/server.zip

# zip contains folder with name 'Server-Files-x.y.z', parse and write to /tmp/.version
RUN echo $(ls /tmp/mc-server | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+') > /tmp/.version
RUN mv /tmp/mc-server/* /mc-server
RUN chmod +x /mc-server/startserver.sh
RUN cp /tmp/.version /mc-server/.version

# new container since we need a jvm now
FROM eclipse-temurin:21-jre-alpine as installer
COPY --from=builder /mc-server /mc-server
WORKDIR /mc-server
RUN ATM9_INSTALL_ONLY=true ./startserver.sh

FROM eclipse-temurin:21-jre-alpine
COPY --from=installer /mc-server /mc-server
WORKDIR /mc-server

# copy custom files
COPY ./additions/ /mc-server

# create symlinks for files in server root
RUN \
	rm /mc-server/server.properties \
	&& rm -f /mc-server/whitelist.json \
	&& rm -f /mc-server/ops.json \
	&& rm -f /mc-server/banned-ips.json \
	&& rm -f /mc-server/banned-players.json \
	&& ln -s /mc-server/world/server/server.properties /mc-server/server.properties \
	&& ln -s /mc-server/world/server/whitelist.json /mc-server/whitelist.json \
	&& ln -s /mc-server/world/server/ops.json /mc-server/ops.json \
	&& ln -s /mc-server/world/server/banned-ips.json /mc-server/banned-ips.json \
	&& ln -s /mc-server/world/server/banned-players.json /mc-server/banned-players.json

ENTRYPOINT ["./custom_start.sh"]
STOPSIGNAL SIGINT
