FROM golang:1.6
MAINTAINER Mikel Nelson <github@mikelnelson.net>

ENV GLIDE_VERSION 0.10.2
ENV GLIDE_URL https://github.com/Masterminds/glide/releases/download/$GLIDE_VERSION/glide-$GLIDE_VERSION-linux-amd64.tar.gz

#
# Luckily golang container has curl installed already, so we don't need apt-get for anything.
# Just need to add in glide for golang dependency management.
#

RUN curl -fsSL "$GLIDE_URL" -o glide.tgz \
	&& tar xzvf glide.tgz \
	&& mv linux-amd64/glide /usr/local/bin \
	&& rm -rf linux-amd64 \
	&& rm glide.tgz 

#
# do no add anything else, should default to the base container's setup.
#
