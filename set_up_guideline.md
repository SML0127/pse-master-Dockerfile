
Set up guideline for pse master server
=============


# 1. Set up locale


sudo locale-gen ko_KR.UTF-8
sudo dpkg-reconfigure locales



# 2. Set up postgresql


vi ~/.bashrc
PATH=$PATH:/usr/lib/postgresql/12/bin


/var/lib/postgresql/12/main/data 생성 및 postgresql chown 설정
sudo pg_ctl -D /var/lib/postgresql/12/main/data initdb
in /main/data; mv * ../ 


* create database pse
* grant select,insert,update,delete on all tables in schema public to pse; 
* grant select,usage,update on all sequences in schema public to pse; 
* grant execute on all functions in schema public to pse; grant references, trigger on all tables in schema public to pse; 
* grant create on schema public to pse; grant usage on schema public to pse;
* ALTER USER pse WITH PASSWORD 'pse';


CREATE ROLE postgres WITH SUPERUSER
psql < pse_database.schema



create user airflow password 'airflow';
CREATE DATABASE airflow;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow;


file: /etc/postgresql/12/main/pg_hba.conf에
host    all             all             0.0.0.0/0               md5 추가



/etc/postgresql/12/main/postgresql.conf에
listen_addresses = ‘*’ # for Airflow connection




# 3. Install airflow version 2.1.1


pip install apache-airflow[rabbitmq,celery]==2.1.1  --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.1.1/constraints-3.6.txt"


mkdir airflow
export AIRFLOW_HOME=~/airflow

airflow.cfg
sql_alchemy_conn = postgresql+psycopg2://airflow:airflow@localhost/airflow
default_timezone = Aisa/Seoul
default_ui_timezone = Aisa/Seoul
executor = CeleryExecutor
parallelism = 100
dag_concurrency = 100
load_examples = False
web_server_port = 5003
result_backend = db+postgresql://airflow:airflow@localhost/airflow


airflow db init


airflow users create -r Admin -u pse -f pse -l pse -p pse -e smlee@dblab.postech.ac.kr

