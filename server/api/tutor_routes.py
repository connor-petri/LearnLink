from flask import request
from flask_login import logout_user

from app import app
from controllers.tutor_controllers import *


# call keys -> email: str, password: str, first_name: str, last_name: str, hourly_rate: float, primary_subject: str
# return keys -> message: str
@app.route('/tutor/register', methods=['POST'])
def register_tutor_route():
    data = request.get_json()
    return register_tutor(data)


# call keys -> email: str, password: str
# return keys -> message: str
@app.route('/tutor/login', methods=['POST'])
def login_tutor_route():
    data = request.get_json()
    return login_tutor(data)


# call keys -> None
# return keys -> message: str
@app.route('/tutor/logout', methods=['POST'])
def logout_tutor_route():
    logout_user()
    return jsonify({'message': 'Tutor logged out successfully'}), 200


# call keys -> None
# return keys -> subjects: list
@app.route('/tutor/get_subjects', methods=['GET'])
def get_subjects_route():
    pass


# call keys -> subject_string
# return keys -> message: str
@app.route('/tutor/add_subject', methods=['POST'])
def add_subject_route():
    pass



@app.route('/tutor/remove_subject', methods=['DELETE'])
def remove_subject_route():
    pass


@app.route('/tutor/add_availability', methods=['POST'])
def add_availability_route():
    pass


@app.route('/tutor/remove_availability', methods=['DELETE'])
def remove_availability_route():
    pass