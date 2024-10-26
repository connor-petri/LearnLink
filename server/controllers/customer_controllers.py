from flask import jsonify, session
from flask_bcrypt import generate_password_hash, check_password_hash
from flask_login import login_user

from app import app
from models.customer_models import *


def register_customer(data):
    email = data.get('email')

    if not Customer.query.filter_by(email=email).first():
        return jsonify({'message': 'Email already exists'}), 400

    try:
        hashed_password = generate_password_hash(data.get('password')).decode('utf-8')
        first_name = data.get('first_name')
        last_name = data.get('last_name')

        customer = Customer(email=email, password=hashed_password, first_name=first_name, last_name=last_name, 
                            outstanding_balance=0.0)
        db.session.add(customer)
        db.session.commit()

    except Exception as e:
        app.logger.error(e)
        db.session.rollback()
        return jsonify({'message': 'An error occurred while registering the customer'}), 500

    return jsonify({'message': 'Customer registered successfully'}), 201


def login_customer(data):
    email = data.get('email')

    customer = Customer.query.filter_by(email=email).first()
    if customer is None or not check_password_hash(customer.password, data.get('password')):
        return jsonify({'message': 'Invalid credentials'}), 401

    login_user(customer)
    session['account_type'] = 'customer'
    return jsonify({'message': 'Customer logged in successfully'}), 200