from flask import Flask
from flask_login import LoginManager
from dotenv import load_dotenv
from os import getenv
from flask_sqlalchemy import SQLAlchemy

load_dotenv()

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql://{getenv("DB_USERNAME")}:{getenv("DB_PASSWORD")}@{getenv("DB_HOST")}:5432/{getenv("DB_NAME")}'
app.secret_key = getenv("SECRET_KEY")

db = SQLAlchemy(app)

login_manager = LoginManager()
login_manager.init_app(app)