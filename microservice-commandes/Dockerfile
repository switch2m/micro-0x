FROM fabric8/java-alpine-openjdk8-jre
VOLUME /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
RUN chown -R javauser:javauser /app
USER javauser
ADD /target/mcommandes-0.0.1-SNAPSHOT.jar app.jar
RUN pwd
RUN ls
EXPOSE 9002 9002
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
