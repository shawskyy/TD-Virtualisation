FROM debian:latest

RUN apt-get update && apt-get install -y bash htop vim net-tools

ENV OWNER=Mohamed

RUN useradd nonroot
USER nonroot

CMD ["sleep", "3600"]
