from config import ConfigPostgres
from flask import Flask

app = Flask(__name__)

app.config.from_object(ConfigPostgres)

from app import routes
