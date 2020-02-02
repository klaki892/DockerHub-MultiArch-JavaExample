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

FROM maven:3.6.3-jdk-14 as javaBuilder
WORKDIR /app
COPY pom.xml .
RUN mvn -e -B dependency:resolve
COPY src ./src
RUN mvn -e -B package

FROM arm32v7/openjdk:11-jre-slim
#Add QEMU
COPY --from=builder /qemu-arm-static /usr/bin
#Add java files
COPY --from=javaBuilder /app/target/multiJavaArchBuild-1.0.jar /
CMD ["java", "-jar", "/multiJavaArchBuild-1.0.jar"]
