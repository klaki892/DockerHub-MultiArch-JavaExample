FROM openjdk:11.0.6-jdk-slim as builder
COPY Main.java /
RUN javac Main.java

FROM openjdk:11-jre-slim
COPY --from=builder /Main.class /
CMD ["java", "Main"]
