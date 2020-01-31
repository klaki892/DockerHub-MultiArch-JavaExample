FROM openjdk:8-alpine
COPY . /workdir
WORKDIR /workdir
CMD ["ls"]
RUN javac Main.java
CMD ["java", "Main"]