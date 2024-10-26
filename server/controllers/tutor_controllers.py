from flask import jsonify, session
from flask_bcrypt import generate_password_hash, check_password_hash
from flask_login import login_user

from app import app
from models.tutor_models import *


def register_tutor(data):
    email = data.get('email')

    if Tutor.query.filter_by(email=email).first():
        return jsonify({'message': 'Email already exists'}), 400
    
    try:
        hashed_password = generate_password_hash(data.get('password')).decode('utf-8')
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        hourly_rate = 15.00
        subject = data.get('subject')

        tutor = Tutor(email=email, password=hashed_password, first_name=first_name, last_name=last_name, 
                      hourly_rate=hourly_rate, outstanding_pay=0.0)
        db.session.add(tutor)
        db.session.commit()

        subject = Subject(name=subject, tutor_id=tutor.id)
        db.session.add(subject)
        db.session.commit()

        return jsonify({'message': 'Tutor registered successfully'}), 201

    except Exception as e:
        app.logger.error(e)
        db.session.rollback()
        return jsonify({'message': 'An error occurred while registering the tutor'}), 500
    

def login_tutor(data):
    email = data.get('email')

    tutor = Tutor.query.filter_by(email=email).first()
    if tutor is None or not check_password_hash(tutor.password, data.get('password')):
        return jsonify({'message': 'Invalid credentials'}), 401

    login_user(tutor)
    session['account_type'] = 'tutor'
    return jsonify({'message': 'Tutor logged in successfully'}), 200