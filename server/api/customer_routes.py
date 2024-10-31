from app import api
from resources.customer.account_resources import *
from resources.customer.student_resources import *


# Put keys -> email: str, password: str, first_name: str, last_name: str
# return keys -> message: str
api.add_resource(CustomerRegisterResource, '/customer/register')


# Post keys -> email: str, password: str
# return keys -> message: str, id: int, email: str, first_name: str, last_name: str, access_token: str
api.add_resource(CustomerLoginResource, '/customer/login')


# Get keys -> token: str, student_id: int
# Get returns student: dict -> id: int, first_name: str, last_name: str, date_of_birth: str, health_information: str
# Put keys -> token: str, first_name: str, last_name: str, date_of_birth: str, health_information: str
# Put returns message: str
# Delete keys -> token: str, student_id: int
# Delete returns message: str
api.add_resource(StudentResource, 'customer/student')


# Get keys -> token: str
# Get returns students: list -> id: int, first_name: str, last_name: str, date_of_birth: str, health_information: str
api.add_resource(GetStudentsResource, 'customer/get_students')