# Dockerfile
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    gnupg \
    lsb-release \
    openjdk-11-jdk \
    openjdk-17-jdk \
    redis

# Install Cassandra
RUN echo "deb [signed-by=/etc/apt/keyrings/apache-cassandra.asc] https://debian.cassandra.apache.org 41x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
    curl -o /etc/apt/keyrings/apache-cassandra.asc https://downloads.apache.org/cassandra/KEYS && \
    apt-get update && apt-get install -y cassandra

# Install MongoDB
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    apt-get update && apt-get install -y mongodb-org

EXPOSE 9042 6379 27017

CMD mkdir -p /data/db && service cassandra start && service redis-server start && mongod --bind_ip 0.0.0.0 --auth --dbpath /data/db
