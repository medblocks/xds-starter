FROM tomcat:9-jdk17

ARG githubreleaselabel=6.4.1

# please note .dockerignore if files change
# github released version 5.2.3 external cache
RUN mkdir /path 
RUN mkdir /path/to 
RUN mkdir /path/to/my/ 
RUN mkdir /path/to/my/external 
RUN mkdir /path/to/my/external/cache 
# latest build version external cache build with Release.properties -Dbuild.profile.id=Release
RUN mkdir /your
RUN mkdir /your/external
RUN mkdir /your/external/cache
RUN mkdir /your/external/cache/location 

COPY ./server.xml /usr/local/tomcat/conf/

# Create setenv.sh with JVM arguments to fix Java 17 module access issues
RUN echo '#!/bin/sh\n\
export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.base/java.lang=ALL-UNNAMED"\n\
export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.base/java.util=ALL-UNNAMED"\n\
export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.base/java.lang.reflect=ALL-UNNAMED"\n\
export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.base/java.text=ALL-UNNAMED"\n\
export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.desktop/java.awt.font=ALL-UNNAMED"\n\
export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.base/jdk.internal.org.xml.sax=ALL-UNNAMED"\n\
export CATALINA_OPTS="$CATALINA_OPTS --add-opens java.base/jdk.internal.ref=ALL-UNNAMED"\n\
' > /usr/local/tomcat/bin/setenv.sh && chmod +x /usr/local/tomcat/bin/setenv.sh

# Add JAXB dependencies for Java 17 compatibility
RUN cd /usr/local/tomcat/lib && \
    curl -L -o jaxb-api.jar https://repo1.maven.org/maven2/javax/xml/bind/jaxb-api/2.3.1/jaxb-api-2.3.1.jar && \
    curl -L -o jaxb-core.jar https://repo1.maven.org/maven2/com/sun/xml/bind/jaxb-core/2.3.0.1/jaxb-core-2.3.0.1.jar && \
    curl -L -o jaxb-impl.jar https://repo1.maven.org/maven2/com/sun/xml/bind/jaxb-impl/2.3.0.1/jaxb-impl-2.3.0.1.jar && \
    curl -L -o activation.jar https://repo1.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar

ADD https://github.com/usnistgov/iheos-toolkit2/releases/download/v${githubreleaselabel}/xdstools${githubreleaselabel}.war /usr/local/tomcat/webapps/xdstools6.war

EXPOSE 8080 8888 8443
# CMD ["catalina.sh", "run"]
