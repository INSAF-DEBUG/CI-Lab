FROM tomcat:9.0-jdk8-temurin

USER root

RUN apt-get update \
    && apt-get install -y --only-upgrade curl libcurl4t64 \
    && dpkg-query -W -f='${Version}\n' curl libcurl4t64 \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /usr/local/tomcat/webapps/*

COPY ci-app-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
