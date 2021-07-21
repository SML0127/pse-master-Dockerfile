ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install sudo vim wget lsb-release
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
RUN apt update && apt install -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get -y install git ssh tmux python3.6 python3.6-dev python3-pip python3-setuptools postgresql-12 postgresql-client-12 libpq-dev unzip curl network-manager net-tools redis-server psycopg2 rabbitmq-server
RUN useradd -rm -d /home/pse -s /bin/bash -g root -G sudo -u 1001 pse
RUN ln -sfn /usr/bin/python3.6 /usr/bin/python
RUN curl https://bootstrap.pypa.io/get-pip.py | sudo -H python3.6
