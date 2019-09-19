FROM alpine
LABEL maintainer="奶爸 <hi@nai.ba>"

# View versions on https://pkgs.alpinelinux.org/package/edge/community/x86/beanstalkd
ENV Version=1.11-r0

RUN apk add --no-cache beanstalkd=${Version}

EXPOSE 11300
ENTRYPOINT ["/usr/bin/beanstalkd"]
