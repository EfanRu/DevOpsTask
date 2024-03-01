FROM adoptopenjdk:11-jre-hotspot
ARG JAR_FILE=*.jar
COPY ${JAR_FILE} jm_my_web4_spring_boot-0.0.1.jar
ENTRYPOINT ["java", "-jar", "jm_my_web4_spring_boot-0.0.1.jar"]
