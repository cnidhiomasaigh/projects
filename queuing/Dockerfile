FROM openjdk:8-jdk
MAINTAINER cdempsey+ibm@streets.ie
EXPOSE 4567
VOLUME /data
COPY target/*.jar /app/service.jar
CMD ["java", "-jar", "/app/service.jar"]