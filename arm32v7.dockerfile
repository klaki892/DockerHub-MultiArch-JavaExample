FROM debian:buster AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    apt-utils \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean
RUN export QEMU_USER_STATIC_LATEST_TAG=$(curl -s https://api.github.com/repos/multiarch/qemu-user-static/tags \
        | grep 'name.*v[0-9]' | head -n 1 | cut -d '"' -f 4) && \
    curl -SL "https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_USER_STATIC_LATEST_TAG}/x86_64_qemu-arm-static.tar.gz" \
        | tar xzv --directory /

FROM balenalib/raspberrypi3-debian-openjdk:11

COPY . /workdir

#Add QEMU
COPY --from=builder /qemu-arm-static /workdir

WORKDIR /workdir
RUN javac Main.java
CMD ["java", "Main"]