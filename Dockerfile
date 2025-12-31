FROM amazoncorretto:17 AS builder
WORKDIR /app

COPY gradle ./gradle
COPY gradlew ./gradlew
COPY build.gradle settings.gradle ./
RUN ./gradlew dependencies

COPY src ./src
RUN ./gradlew build

FROM amazoncorretto:17-alpine3.21
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar /app/app.jar

# 8081로 포트 번호 변경..?
EXPOSE 8080

ENTRYPOINT ["sh","-c","java $JVM_OPTS -jar /app/app.jar"]
