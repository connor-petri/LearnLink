from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Api
from flask_jwt_extended import JWTManager

from dotenv import load_dotenv
from os import getenv


load_dotenv()

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{getenv("DB_USERNAME")}:{getenv("DB_PASSWORD")}@{getenv("DB_HOST")}:5432/{getenv("DB_NAME")}'
app.secret_key = getenv("SECRET_KEY")
app.config['JWT_SECRET_KEY'] = getenv("JWT_SECRET_KEY")

db = SQLAlchemy(app)
api = Api(app)
jwt = JWTManager(app)