## URL analyzer
* bundle install --without test
* rackup

 Change storage type by changing ENV['STORAGE'] in the "config/enviroment.rb"
 You can choose "db" or "file"

#### If curb installation fails:
* sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev

#### Default user: admin, admin

#### Install PostgreSQL(Debian/Ubuntu/...):
* sudo apt-get install postgresql-common

* sudo apt-get install postgresql-9.3 postgresql-server-dev-9.3 libpq-dev

* Change settings in data_base_provider.rb

#### If you are going to use clean SQL storage (db in CONFIG file):
* Change settings in /lib/storage/data_base_provider.rb

* Do this:

    * CREATE DATABASE project;

    * CREATE TABLE reports (id serial PRIMARY KEY, url varchar(255), ip cidr, time bigint, links_count int);

    * CREATE TABLE links(id serial PRIMARY KEY, href text, content text, rel varchar(255), target varchar(50), report_id int REFERENCES reports(id));

    * CREATE TABLE headers(id serial PRIMARY KEY, name text, content text, report_id int REFERENCES reports(id));
