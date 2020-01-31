FROM adoptopenjdk:latest

COPY . /workdir

#Add QEMU
#COPY --from=builder /qemu-arm-static /workdir

WORKDIR /workdir
RUN javac Main.java
CMD ["java", "Main"]