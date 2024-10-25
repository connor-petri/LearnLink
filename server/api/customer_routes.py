from flask import request

from app import app
from controllers.customer_controllers import *


@app.route('/customer/register', methods=['POST'])
def register_customer_route():
    data = request.get_json()
    return register_customer(data)


@app.route('/customer/login', methods=['POST'])
def login_customer_route():
    data = request.get_json()
    return login_customer(data)