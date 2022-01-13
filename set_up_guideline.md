
Set up guideline for pse master server
=============


# 1. Set up locale


- sudo locale-gen ko_KR.UTF-8
- sudo dpkg-reconfigure locales



# 2. Set up postgresql


2.1 Add path 
- vi ~/.bashrc
- PATH=$PATH:/usr/lib/postgresql/12/bin

2.2 Init postgres db
-  mkdir /var/lib/postgresql/12/main/data 
- chown postgres:postgres /var/lib/postgresql/12/main/data 
- sudo pg_ctl -D /var/lib/postgresql/12/main/data initdb
- (in /main/data) mv * ../ 


2.3 Create pse database
- create database pse
- grant select,insert,update,delete on all tables in schema public to pse; 
- grant select,usage,update on all sequences in schema public to pse; 
- grant execute on all functions in schema public to pse; grant references, trigger on all tables in schema public to pse; 
- grant create on schema public to pse; grant usage on schema public to pse;
- alter user pse with password 'pse';
- create role postgres with superuser

2.4 Create tables in pse database
- psql < pse_database.schema


2.5 Create airflow database
- create user airflow password 'airflow';
- create database airflow;
- grant all privileges on all tables in schema public to airflow;

2.6 Set psql configuration
- Add (host    all             all             0.0.0.0/0               md5 ) to /etc/postgresql/12/main/pg_hba.conf
- Add (listen_addresses = ‘*’ # for Airflow connection) to /etc/postgresql/12/main/postgresql.conf





# 3. Install airflow version 2.1.1

3.1 Install airflow
- pip install apache-airflow[rabbitmq,celery]==2.1.1  --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.1.1/constraints-3.6.txt"

3.2 Init airflow
- mkdir airflow
- export AIRFLOW_HOME=~/airflow


3.3 Set airflow configuration (in airflow.cfg)
- sql_alchemy_conn = postgresql+psycopg2://airflow:airflow@localhost/airflow
- default_timezone = Aisa/Seoul
- default_ui_timezone = Aisa/Seoul
- executor = CeleryExecutor
- parallelism = 100
- dag_concurrency = 100
- load_examples = False
- web_server_port = 5003
- result_backend = db+postgresql://airflow:airflow@localhost/airflow
- broker_url = amqp://guest:guest@localhost:5672//

3.4 Init airflow database
- airflow db init

3.5 create airflow user (for airflow web)
- airflow users create -r Admin -u pse -f pse -l pse -p pse -e email@address.com




# 4. Set redis configuration

4.1 Set configure
- In /etc/redis/redis.conf, replace "bind 127.0.0.1" to "bind 0.0.0.0" 

