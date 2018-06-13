This utility helps to delete pipeline history from GoCD database for the deleted pipeline. Please make sure to delete pipeline from UI first.

# Usuage:

```
> bundle install
> PIPELINE_NAME=<pipline_name> bundle exec rake (e.g. PIPELINE_NAME=PipelineA bundle exec rake)
```

# Requirement:

Add database details in setting.rb file.

```
@dbhost='127.0.0.1'
@dbport=5432
@database='gocd_database_name'
@dbuser='postgres_user'
@dbpassword='password'
```

# Limitation:
 - Doesn't work for dependent pipelines. You will need to remove pipeline dendency and then delete pipeline from UI.
 - Works only with Postgres DB
