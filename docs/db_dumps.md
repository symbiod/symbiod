## DB dumps

We have a couple of shortcuts to simplify pulling the latest dump from the production.

* `bin/make-db-backup` - pulls the dump from production database and uploads it to S3
* `bin/load_dump` - pulls the dump from S3 to the local machine and imports it to the development database

The first command is executed on daily basis on Travis CI, so every 24h the dump will be updated.

If you want to get the _latest_ dump from production you are able to pull it directly from heroku.
To do that you need an access to Heroku, via `HEROKU_API_KEY` or sign in with regular login/password via heroku toolchain.

Additionally you may need AWS key to be able to upload the latest dump to the S3.
