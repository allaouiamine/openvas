FROM debian
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y supervisor build-essential cmake bison flex libpcap-dev pkg-config libglib2.0-dev libgpgme11-dev uuid-dev \
sqlfairy xmltoman doxygen libssh-dev libksba-dev libldap2-dev python-setuptools python-pip python-dev \
libsqlite3-dev libmicrohttpd-dev libxml2-dev libxslt1-dev libpopt-dev heimdal-dev gcc-mingw-w64-i686 \
xsltproc clang rsync rpm nsis alien sqlite3 libhiredis-dev libgcrypt11-dev libgnutls28-dev wget redis-server texlive-latex-base
WORKDIR /usr/local/src
RUN wget http://wald.intevation.org/frs/download.php/2291/openvas-libraries-8.0.7.tar.gz && \
  wget http://wald.intevation.org/frs/download.php/2266/openvas-scanner-5.0.5.tar.gz && \
  wget http://wald.intevation.org/frs/download.php/2295/openvas-manager-6.0.8.tar.gz && \
  wget http://wald.intevation.org/frs/download.php/2299/greenbone-security-assistant-6.0.10.tar.gz && \
  wget http://wald.intevation.org/frs/download.php/2332/openvas-cli-1.4.4.tar.gz && \
  wget http://wald.intevation.org/frs/download.php/1975/openvas-smb-1.0.1.tar.gz && \
  wget http://nmap.org/dist/nmap-5.51.6.tgz && \
  tar xvf openvas-smb-1.0.1.tar.gz && \
  tar xvf greenbone-security-assistant-6.*.tar.gz && \
  tar xvf openvas-libraries-8.*.tar.gz && \
  tar xvf openvas-scanner-5.*.tar.gz && \
  tar xvf openvas-manager-6.*.tar.gz && \
  tar xvf openvas-cli-1.4.4.tar.gz && \
  tar xvf nmap-5.51.6.tgz
RUN cd openvas-smb-1.0.1 && \
  cmake . && \
  make && \
  make install && \
  make rebuild_cache && \
  ldconfig && \
  cd ..
RUN cd openvas-libraries-8.0.7 && \
cmake . && \
make && \
make doc && \
make install && \
ldconfig && \
cd ..
RUN cd openvas-manager-6.0.8/ && \
cmake . && \
make && \
make doc && \
make install && \
ldconfig && \
cd ..
RUN cd openvas-scanner-5.0.5/ && \
cmake . && \
make && \
make doc && \
make install && \
ldconfig && \
cd ..
RUN cd openvas-cli-1.4.4/ && \
cmake . && \
make && \
make doc && \
make install && \
ldconfig && \
cd ..
RUN cd greenbone-security-assistant-6.0.10/ && \
cmake . && \
make && \
make doc && \
make install && \
ldconfig && \
cd ..
RUN cd nmap-5.51.6 && \
  ./configure && \
  make && \
  make install && \
  ldconfig
RUN mkdir /osp && \
  cd /osp && \
      wget http://wald.intevation.org/frs/download.php/1999/ospd-1.0.0.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2145/ospd-1.0.1.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2177/ospd-1.0.2.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2005/ospd-ancor-1.0.0.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2097/ospd-debsecan-1.0.0.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2003/ospd-ovaldi-1.0.0.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2149/ospd-paloalto-1.0b1.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2004/ospd-w3af-1.0.0.tar.gz && \
      wget http://wald.intevation.org/frs/download.php/2181/ospd-acunetix-1.0b1.tar.gz && \
      tar zxvf ospd-1.0.0.tar.gz && \
      tar zxvf ospd-1.0.1.tar.gz && \
      tar zxvf ospd-1.0.2.tar.gz && \
      tar zxvf ospd-ancor-1.0.0.tar.gz && \
      tar zxvf ospd-debsecan-1.0.0.tar.gz && \
      tar zxvf ospd-ovaldi-1.0.0.tar.gz && \
      tar zxvf ospd-paloalto-1.0b1.tar.gz && \
      tar zxvf ospd-w3af-1.0.0.tar.gz && \
      tar zxvf ospd-acunetix-1.0b1.tar.gz
RUN cd /osp/ospd-1.0.0 && \
          python setup.py install && \
      cd /osp/ospd-ancor-1.0.0 && \
          pip install requests && \
          python setup.py install && \
      cd /osp/ospd-debsecan-1.0.0 && \
          python setup.py install && \
      cd /osp/ospd-ovaldi-1.0.0 && \
          pip install pyasn1 --upgrade && \
          python setup.py install && \
      cd /osp/ospd-1.0.1 && \
          python setup.py install && \
      cd /osp/ospd-paloalto-1.0b1 && \
          python setup.py install && \
      cd /osp/ospd-w3af-1.0.0 && \
          pip install Pexpect && \
          python setup.py install && \
      cd /osp/ospd-acunetix-1.0b1 && \
          python setup.py install && \
      cd /osp/ospd-1.0.2 && \
          python setup.py install && \
      ldconfig
RUN     cd /tmp && \
              wget https://github.com/Arachni/arachni/releases/download/v1.4/arachni-1.4-0.5.10-linux-x86_64.tar.gz && \
                  tar -zxvf arachni-1.4-0.5.10-linux-x86_64.tar.gz && \
                  rm -rf arachni-1.4-0.5.10-linux-x86_64.tar.gz && \
                  mv arachni-* /opt/arachni && \
                  ln -s /opt/arachni/bin/* /usr/local/bin/ && \
                  ldconfig
RUN cd /usr/local/bin/ && wget --no-check-certificate https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup && \
chmod +x openvas-check-setup
RUN openvas-mkcert -q && \
    openvas-mkcert-client -n -i
RUN openvas-nvt-sync && \
  openvas-scapdata-sync && \
  openvas-certdata-sync
RUN openvassd && \
  openvasmd --rebuild --progress && \
  openvassd && \
  openvasmd && \
  gsad
RUN wget http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml && \
openvas-portnames-update service-names-port-numbers.xml && \
rm -rf service-names-port-numbers.xml
RUN apt-get clean -yq && \
apt-get autoremove -yq && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/local/src/* && rm -rf /tmp/* && \
rm -rf /tmp/arachni*
RUN openvasmd --create-user=admin --role=Admin && \
openvasmd --user=admin --new-password=admin && \
echo 'unixsocket /tmp/redis.sock' > /etc/redis.conf && \
echo 'unixsocketperm 777' >> /etc/redis.conf
RUN redis-server /etc/redis.conf &
EXPOSE 80 443 9390 9391 9392
ADD supervisor.conf /etc/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord","-c /etc/supervisord.conf"]
