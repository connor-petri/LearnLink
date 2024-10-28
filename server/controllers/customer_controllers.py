from flask import jsonify, session, make_response
from flask_bcrypt import generate_password_hash, check_password_hash
from flask_login import login_user, current_user, login_required

from app import app
from models.customer_models import *
from models.tutor_models import Tutor


def register_customer(data):
    email = data.get('email')

    if Customer.query.filter_by(email=email).first() or Tutor.query.filter_by(email=email).first():
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
    return jsonify({'message': 'Customer logged in successfully',
                    'id': customer.id,
                    'email': customer.email,
                    'first_name': customer.first_name,
                    'last_name': customer.last_name}), 200


@login_required
def add_student(data):
    customer = Customer.query.get(current_user.id)

    first_name = data.get('first_name')
    last_name = data.get('last_name')
    date_of_birth = data.get('date_of_birth')
    health_information = data.get('health_information')

    if Student.query.filter_by(customer_id=customer.id, first_name=first_name, last_name=last_name).first():
        return jsonify({'message': 'A Student with that name already exists'}), 400
    
    try:
        s = Student(customer_id=customer.id, first_name=first_name, last_name=last_name, date_of_birth=date_of_birth, health_information=health_information)
        db.session.add(s)
        db.session.commit()

        return jsonify({'message': 'Student added successfully'}), 201

    except Exception as e:
        app.logger.error(e)
        db.session.rollback()
        return jsonify({'message': 'An error occurred while adding the student'}), 500
    

@login_required
def get_students():
    customer = Customer.query.get(current_user.id)
    students = customer.students

    students_list = []
    for student in students:
        students_list.append({
            'id': student.id,
            'first_name': student.first_name,
            'last_name': student.last_name,
            'date_of_birth': student.date_of_birth,
            'health_information': student.health_information
        })

    return jsonify({'students': students_list})
        

@login_required
def remove_student(data):
    customer = Customer.query.get(current_user.id)
    student_id = data.get('student_id')

    student = Student.query.filter_by(customer_id=customer.id, id=student_id).first()
    if student is None:
        return jsonify({'message': 'Student not found'}), 404
    
    try:
        db.session.delete(student)
        db.session.commit()

        return jsonify({'message': 'Student removed successfully'}), 200
    
    except Exception as e:
        app.logger.error(e)
        db.session.rollback()
        return jsonify({'message': 'An error occurred while removing the student'}), 500
