FROM openjdk:7-jdk-alpine
# ----
# Install Maven
RUN apk add --no-cache curl tar bash git
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"
RUN mkdir -p /usr/share/maven && \
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
#ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
ENTRYPOINT ["/usr/bin/mvn"]
# ----
# Install project dependencies and keep sources
# make source folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# install maven dependency packages (keep in image)
RUN git clone https://github.com/r1th4l1n/gae-java-basic-pom.git && cp gae-java-basic-pom/pom.xml . && rm -rf gae-java-basic-pom
#RUN rm -rf /usr/src/app/gae-java-basic-pom
#RUN mvn -T 1C install && rm -rf target
#RUN mvn clean #redo
RUN mvn dependency:resolve && rm -rf target
# copy other source files (keep in image)
#COPY src /usr/src/app/src
