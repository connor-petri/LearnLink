from app import api
from resources.customer_resources import *


# call keys -> email: str, password: str, first_name: str, last_name: str
# return keys -> message: str
api.add_resource(CustomerRegister, '/customer/register')


# call keys -> email: str, password: str
# return keys -> message: str, id: int, email: str, first_name: str, last_name: str, access_token: str
api.add_resource(CustomerLogin, '/customer/login')