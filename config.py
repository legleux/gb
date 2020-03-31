import os


class ConfigPostgres(object):
    DBNAME=os.environ.get('PG_DBNAME')
    USER=os.environ.get('PG_USER')
    HOST=os.environ.get('PG_HOST')
    PORT=os.environ.get('PG_PORT')
    PASSWORD=os.environ.get('PG_PASSWORD')
