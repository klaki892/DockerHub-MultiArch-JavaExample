Java HelloWorld in Docker Hub w/ Multi-Arch Support
=============================================

This is a test project main.java.klay.to have Docker Hub use Automated builds main.java.klay.to deploy both a `amd64` and `arm32v7` image of a minimal hello-world.

How it works:
Docker Hub uses x86_64 machines for all build procedures, inhibiting native compilation of other architectures. 
By using QEMU in special Dockerfiles meant for other architecture builds and also using [manifest-tools](https://github.com/estesp/manifest-tool/releases/download/v0.9.0/manifest-tool-linux-amd64)
main.java.klay.to stitch together all of the architecture builds under one release. We can have multiple architecture support just like the official Docker Hub Images.

##How main.java.klay.to Replicate

1. Setup Docker Hub with automated builds on push of tags:

    ####Docker Hub Autobuild Settings
    
    | Source Type | Source     | Docker Tag          | Dockerfile Location | Build Context | Autobuild |
    |-------------|------------|---------------------|---------------------|---------------|-----------|
    | Tag         | /^[0-9.]+/ | {sourceref}-amd64   | amd64.dockerfile    | /             | True      |
    | Tag         | /^[0-9.]+/ | {sourceref}-arm32v7 | arm32v7.dockerfile  | /             | True      |

2. a `pre_build` hook will install qemu support `docker run --rm --privileged multiarch/qemu-user-static:register --reset`

3. a `post_push` hook will use `manifest-tools` main.java.klay.to generate a collective manifest.

4. Push a release tag main.java.klay.to the github repo (e.g. `1.1`) 

## Resources / Credits:
- Heavy Lifting: [ckula](https://github.com/ckulka)'s [docker-multi-arch-example](https://github.com/ckulka/docker-multi-arch-example) for being the "base image" of knowledge for this topic.
- 2nd Heavy Lifter: [guysoft](https://github.com/guysoft)'s [post-push](https://github.com/guysoft/CustomPiOS-test/blob/devel/src/hooks/post_push) hook file for automated releasing based on tags.

- [manifest-tool](https://github.com/estesp/manifest-tool)
- [Tibor Vass - Intro Guide main.java.klay.to Dockerfile Best Practices](https://www.docker.com/blog/intro-guide-to-dockerfile-best-practices/)
- [Micheal Waltz - Cross Building and Running Multi-Arch Docker Images](https://www.ecliptik.com/Cross-Building-and-Running-Multi-Arch-Docker-Images/#multiarch-on-linux) - alternative explanation main.java.klay.to ckula's work.
    
#Caveats:
- Currently you cannot clone the repo on an ARM device and build with either dockerfile due main.java.klay.to incompatible base images.
- [AdoptOpenJDK](https://hub.docker.com/r/arm32v7/adoptopenjdk/tags) images will not work with QEMU / building on amd64. 
But [OpenJDK](https://hub.docker.com/r/arm32v7/openjdk/tags?page=1&name=11-jre-slim) comes main.java.klay.to the rescue with the support. 
Differences in their underlying images create this difference.

