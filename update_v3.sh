set -x
command -v docker-squash >/dev/null 2>&1 || { echo >&2 "docker-squash pas installé, faites pip install docker-squash pour l'installer"; exit 1; }
command -v trivy >/dev/null 2>&1 || { echo >&2 "trivy pas installé, voyez https://github.com/aquasecurity/trivy/blob/master/README.md#debianubuntu pour l'installer"; ex
it 1; }
id=$(docker ps -qf  name=^captvty_v3_1$)
while [[ -z $id ]]; do docker run -d -e DISPLAY --name=captvty_v3_1 -v ${HOME}:/home/gg/Captvtyv3/Vidéos --net=host k3ck3c/captvty_v3_1 && sleep 3 && id=$(docker ps -qf
  name=^captvty_v3_1$) ; done
echo $id
latest=$(wget -q -O- 'http://v3.captvty.fr' | sed -n 's/.*href="\(\/\/.\+\.zip\).*/http:\1/p')
test -n "$latest" && wget -qO /tmp/Captvty3.zip "$latest"
docker cp /tmp/Captvty3.zip $id:/tmp
docker exec -it $id unzip -fo -d /home/gg/Captvtyv3 /tmp/Captvty3.zip
docker exec -it $id rm /tmp/Captvty3.zip
docker exec -it -u root $id apt-get update 
docker exec -it -u root $id apt-get --allow-unauthenticated -y upgrade 
docker commit $id k3ck3c/captvty_v3_1
docker tag $(docker-squash k3ck3c/captvty_v3_1 | awk '/New squashed image ID is/ {print $NF}') k3ck3c/captvty_v3_1
docker images k3ck3c/captvty_v3_1
trivy --clear-cache k3ck3c/captvty_v3_1 > doc_trivy_v3_1
grep ^Total: doc_trivy_v2
set +x
