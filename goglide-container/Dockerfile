FROM golang:1.8.3
MAINTAINER Mikel Nelson <github@mikelnelson.net>

# NOTE: should use: $(dpkg --print-architecture)  vs amd64
ENV GLIDE_VERSION v0.12.3
ENV GLIDE_URL https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.tar.gz
ENV GOSU_VERSION 1.10
ENV GOSU_URL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64
ENV GOSU_PATH /usr/local/bin/gosu

#
# Luckily golang container has curl and ca-certificates installed already, so we don't need apt-get for anything.
# Just need to add in glide for golang dependency management.
#
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

RUN curl -L "$GLIDE_URL" -o glide.tgz \
	&& tar xzvf glide.tgz \
	&& mv linux-amd64/glide /usr/local/bin \
	&& rm -rf linux-amd64 \
	&& rm glide.tgz 

RUN curl -L "$GOSU_URL" -o "$GOSU_PATH" \
	&& curl -fsSL "$GOSU_URL.asc" -o "$GOSU_PATH.asc" \
	&& gpg --verify "$GOSU_PATH.asc" \
	&& rm "$GOSU_PATH.asc" \
	&& chmod +x "$GOSU_PATH"

#
# entrypoint script to set the container user to host user
#
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
