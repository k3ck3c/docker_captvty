# docker_captvty
captvty, as a Windows .exe, requires, for running with Linux, wine and some work
This Dockerfile tries to use the recipes of
https://www.dajobe.org/blog/2015/04/18/making-debian-docker-images-smaller/

that is, install some tools, use them, remove them in one RUN, as they are only needed for the installation
but not for the run
for example
software-properties-common
is useful to be able to do 
apt-add-repository
but is not useful for running 
wine Captvty.exe
