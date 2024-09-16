FROM ubuntu:latest
RUN apt-get update && apt-get install -y tightvncserver
RUN mkdir /root/.vnc
RUN x11vnc -storepasswd 'passwordAnda' /root/.vnc/passwd
EXPOSE 5900
CMD ["/usr/bin/tightvncserver", "-geometry", "1280x800"]