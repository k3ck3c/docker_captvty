FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive
	# activate i386 arch for Wine and install stuff we need
RUN dpkg --add-architecture i386 && \
	apt-get update && \
        BUILD_PACKAGES='wget software-properties-common unzip apt-transport-https openssh-server xauth cabextract winbind squashfs-tools pulseaudio sudo x11-apps xfce4 c
ups joe xfce4-terminal xvfb socat x11vnc firefox' &&\
	apt-get -qy upgrade && apt-get -qy install $BUILD_PACKAGES && \
        AUTO_ADDED_PACKAGES=`apt-mark showauto` && \	
	# install latest Wine
	wget -qO- https://dl.winehq.org/wine-builds/Release.key | apt-key add - && \
	apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/ && \
	apt-get update && apt-get -qy install --install-recommends winehq-devel && \
	# create our user for Wine
useradd -d /home/gg -m -s /bin/bash gg && \
echo gg:gg | chpasswd && \ 
	# winetricks
	wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /tmp/winetricks && \
	chmod +x /tmp/winetricks
        USER gg 
ENV WINEDEBUG=-all WINEPREFIX=/home/gg/.wine WINEARCH=win32
RUN winecfg && \
xvfb-run -a /tmp/winetricks -q vcrun2010 dotnet40 gdiplus comctl32 ie8 
        USER root	
	RUN apt-get autoremove -y --purge software-properties-common && \
	apt-get autoremove -y --purge && \
	apt-get remove --purge -y $BUILD_PACKAGES $AUTO_ADDED_PACKAGES && \
	apt-get clean -y && \
	rm -rf /home/wine/.cache && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER gg
RUN wget -q -O- http://captvty.fr/ | egrep -o '\/\/.+?\.zip' | sed 's/\/\//http:\/\//' | xargs wget -O /tmp/Captvty.zip && \
ls -alrt /tmp/Cap*zip && unzip -d  ~/Captvty /tmp/Captvty.zip && rm /tmp/Captvty.zip
CMD wine /home/gg/Captvty/Captvty.exe
