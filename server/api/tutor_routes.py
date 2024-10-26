from flask import request

from app import app
from controllers.tutor_controllers import *


@app.route('/tutor/register', methods=['POST'])
def register_tutor_route():
    data = request.get_json()
    return register_tutor(data)


@app.route('/tutor/login', methods=['POST'])
def login_tutor_route():
    data = request.get_json()
    return login_tutor(data)