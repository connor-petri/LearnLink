from flask import jsonify

from app import app
from models.customer_models import *


def register_customer(data):
    email = data.get('email')
    password = data.get('password')
    first_name = data.get('first_name')
    last_name = data.get('last_name')

    customer = Customer(email=email, password=password, first_name=first_name, last_name=last_name, 
                        outstanding_balance=0.0)
    db.session.add(customer)
    db.session.commit()

    return jsonify({'message': 'Customer registered successfully'}), 201


def login_customer(data):
    email = data.get('email')
    password = data.get('password')

    customer = Customer.query.filter_by(email=email).first()
    if customer is None or not customer.check_password(password):
        return jsonify({'message': 'Invalid credentials'}), 401

    return jsonify({'message': 'Customer logged in successfully',
                    "login_type": "customer"}), 200