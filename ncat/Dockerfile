# Use the official Ubuntu base image
FROM --platform=linux/amd64 ubuntu:latest

# Update package lists and install ncat
RUN apt-get update && apt-get install -y ncat
RUN apt-get update && apt-get install -y curl


RUN mkdir -p /home/agent
WORKDIR /home/agent
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.9.0-linux-x86_64.tar.gz
RUN tar xzvf elastic-agent-8.9.0-linux-x86_64.tar.gz
COPY ./agent/elastic-agent.yml /home/agent/elastic-agent-8.9.0-linux-x86_64

EXPOSE 8500