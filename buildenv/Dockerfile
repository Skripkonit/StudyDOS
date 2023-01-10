FROM gcc:latest

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install nasm -y
RUN apt-get install xorriso -y
RUN apt-get install grub-pc-bin -y
RUN apt-get install grub-common -y

VOLUME [ "/root/env" ]
WORKDIR /root/env
