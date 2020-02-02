FROM maven:3.6.3-jdk-14 as builder
WORKDIR /app
COPY pom.xml .
RUN mvn -e -B dependency:resolve
COPY src ./src
RUN mvn -e -B package

FROM openjdk:11-jre-slim
COPY --from=builder /app/target/multiJavaArchBuild-1.0.jar /
CMD ["java", "-jar", "/multiJavaArchBuild-1.0.jar"]
