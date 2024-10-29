from flask import request
from flask_login import logout_user

from app import app, api
from controllers.customer_controllers import *
from controllers.user_loader import *
from resources.customer_resources import *


# call keys -> email: str, password: str, first_name: str, last_name: str
# return keys -> message: str
api.add_resource(CustomerRegister, '/customer/register')


# call keys -> email: str, password: str
# return keys -> message: str, id: int, email: str, first_name: str, last_name: str
api.add_resource(CustomerLogin, '/customer/login')


# call keys -> None
# return keys -> message: str
@app.route('/customer/logout', methods=['POST'])
def logout_customer_route():
    logout_user()
    return jsonify({'message': 'Customer logged out successfully'}), 200


# TODO: Test this route
# call keys -> first_name: str, last_name: str, date_of_birth: date, health_information: str
# return keys -> message: str
@app.route('/customer/add_student', methods=['POST'])
def add_student_route():
    data = request.get_json()
    return add_student(data)


# TODO: Test this route
# call keys -> None
# return keys -> students: list
@app.route('/customer/get_students', methods=['GET'])
def get_students_route():
    data = request.get_json()
    return get_students(data)


# TODO: Test this route
# call keys -> student_id
# return keys -> message: str
@app.route('/customer/remove_student', methods=['DELETE'])
def remove_student_route():
    data = request.get_json()
    return remove_student(data) 


