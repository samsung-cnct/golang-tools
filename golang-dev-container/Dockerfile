FROM golang:1.8

# A container to simplify your Go development workflow, by abstracting the use
# of a few critical utilities.
#
# Usage:
# docker build -t "golang_dev:local" -f Dockerfile.golangdev ./
# docker run -it "golang_dev:local" shell
# (other commands documented in dev_golang.sh)

RUN apt-get -qq update && apt-get -qq -y install build-essential

RUN go get \
    golang.org/x/tools/cmd/godoc \
    golang.org/x/tools/cmd/goimports \
    github.com/golang/lint/golint \
    honnef.co/go/tools/cmd/gosimple \
    github.com/tools/godep

    


RUN mkdir -p /usr/local/bin/
COPY ./scripts/dev_golang_lib.sh /scripts/
COPY ./scripts/dev_golang.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

VOLUME ["/go/"]
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/dev_golang.sh"]
CMD ["help"]
