FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/* \
    && groupadd --system tomcat \
    && useradd --system --gid tomcat \
       --home-dir /usr/local/tomcat \
       --no-create-home tomcat \
    && chown -R tomcat:tomcat /usr/local/tomcat

COPY --chown=tomcat:tomcat ci-app-1.0-20261002.021714-14.war /usr/local/tomcat/webapps/ci-app.war

EXPOSE 8080

USER tomcat

HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD bash -c 'cat < /dev/null > /dev/tcp/127.0.0.1/8080' || exit 1

CMD ["catalina.sh", "run"]
