FROM openjdk:11.0.6-jdk-slim AS builder

## Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
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

#FROM openjdk:11.0.6-jdk-slim as builder
COPY Main.java /
RUN javac Main.java
#CMD ["java", "Main"]
#CMD ["uname", "-a"]

FROM arm32v7/openjdk:11-jre-slim
#Add QEMU
COPY --from=builder /qemu-arm-static /usr/bin
#COPY --from=builder /Main.class /
COPY --from=builder /Main.class /
CMD ["java", "Main"]
