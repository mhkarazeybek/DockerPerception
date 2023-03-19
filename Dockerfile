ARG UBUNTU_VERSION
ARG CUDA_VERSION
ARG CMAKE_VERSION
ARG OPENCV_VERSION
ARG UBUNTU_URL
ARG USE_ZED

FROM ubuntu:$UBUNTU_VERSION

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install ubuntu-desktop -y

RUN rm /run/reboot-required*

RUN useradd -m -s /bin/bash -G sudo mhkarazeybek

RUN apt-get update -y
RUN apt-get install xrdp -y
RUN adduser xrdp ssl-cert

RUN sed -i '3 a echo "\
export GNOME_SHELL_SESSION_MODE=ubuntu\\n\
export XDG_SESSION_TYPE=x11\\n\
export XDG_CURRENT_DESKTOP=ubuntu:GNOME\\n\
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg\\n\
" > ~/.xsessionrc' /etc/xrdp/startwm.sh

RUN apt-get install xfce4-terminal -y
RUN apt-get install -y git
RUN apt-get install -y python3-pip
RUN echo "root:mhk12345" | chpasswd

WORKDIR /root

# #CUDA INSTALL
COPY cuda_install /root/
# RUN sh cuda_install ${CUDA_VERSION} ${UBUNTU_URL}

#CMAKE INSTALL
COPY cmake_install /root/
# RUN sh cmake_install ${CMAKE_VERSION}

#OPENCV INSTALL
COPY opencv_install /root/
# RUN sh opencv_install ${OPENCV_VERSION} ${CUDA_VERSION}

#DARKNET INSTALL
COPY darknet_install /root/
# RUN sh darknet_install ${USE_ZED}

EXPOSE 3389

CMD service dbus start; /usr/lib/systemd/systemd-logind & service xrdp start ; bash

# RUN sh opencv_install > out_opencv.txt
# RUN sh darknet_install > out_darknet.txt
# RUN mv