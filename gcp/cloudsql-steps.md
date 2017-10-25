# Setup Cloud SQL

- Create a CloudSql instance named tdl-middleware-rails in europe-west1-b, generate password
- Enable Cloud Sql API
- Get connection info: gcloud sql instances describe tdl-middleware-rails | grep connection
    - Should be something like <PROJECT>:europe-west1:tdl-middleware-rails
- Create user
    - ```gcloud sql users create rails % --instance=tdl-middleware-rails --password=<PASSWORD>```
- Create database (needs cloud_sql_proxy see Development)
    - ```RAILS_ENV=production bundle exec rake db:create```
    - ```RAILS_ENV=production bundle exec rake db:reset```
    
    

## Development
1. Download cloud_sql_proxy: 
    1. ```wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy```
    2. chmod +x cloud_sql_proxy
1. Connect to the Cloud SQL instance
    1. ./cloud_sql_proxy -instances=<PROJECT>:europe-west1:tdl-middleware-rails=tcp:3306
