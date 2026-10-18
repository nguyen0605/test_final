FROM gradle:8.5-jdk21-alpine AS builder

WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

RUN chmod +x gradlew && ./gradlew dependencies --no-daemon

COPY src src
RUN ./gradlew bootJar -x test --no-daemon

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S nguyen0605group && adduser -S daonbm -G nguyen0605group

COPY --from=builder --chown=daonbm:nguyen0605group /app/build/libs/*.jar app.jar

USER nguyen0605

EXPOSE 8083

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
