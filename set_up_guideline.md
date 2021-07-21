
Set up guideline for pse master server
=============


# 1. Set up locale


1. sudo locale-gen ko_KR.UTF-8
2. sudo dpkg-reconfigure locales



# 2. Set up postgresql


Add path 
1. vi ~/.bashrc
2. PATH=$PATH:/usr/lib/postgresql/12/bin

Init postgres db
1.  mkdir /var/lib/postgresql/12/main/data 
2. chown postgres:postgres /var/lib/postgresql/12/main/data 
3. sudo pg_ctl -D /var/lib/postgresql/12/main/data initdb
4. (in /main/data) mv * ../ 


Create pse database
- create database pse
- grant select,insert,update,delete on all tables in schema public to pse; 
- grant select,usage,update on all sequences in schema public to pse; 
- grant execute on all functions in schema public to pse; grant references, trigger on all tables in schema public to pse; 
- grant create on schema public to pse; grant usage on schema public to pse;
- alter user pse with password 'pse';
- create role postgres with superuser

Create tables in pse database
- psql < pse_database.schema


Create airflow database
- create user airflow password 'airflow';
- create database airflow;
- grant all privileges on all tables in schema public to airflow;

Set psql configuration
- Add (host    all             all             0.0.0.0/0               md5 ) to /etc/postgresql/12/main/pg_hba.conf
- Add (listen_addresses = ‘*’ # for Airflow connection) to /etc/postgresql/12/main/postgresql.conf





# 3. Install airflow version 2.1.1

Install airflow
- pip install apache-airflow[rabbitmq,celery]==2.1.1  --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.1.1/constraints-3.6.txt"

Init airflow
- mkdir airflow
- export AIRFLOW_HOME=~/airflow


Set airflow configuration (in airflow.cfg)
- sql_alchemy_conn = postgresql+psycopg2://airflow:airflow@localhost/airflow
- default_timezone = Aisa/Seoul
- default_ui_timezone = Aisa/Seoul
- executor = CeleryExecutor
- parallelism = 100
- dag_concurrency = 100
- load_examples = False
- web_server_port = 5003
- result_backend = db+postgresql://airflow:airflow@localhost/airflow

Init airflow database
- airflow db init

create airflow user (for airflow web)
- airflow users create -r Admin -u pse -f pse -l pse -p pse -e smlee@dblab.postech.ac.kr

