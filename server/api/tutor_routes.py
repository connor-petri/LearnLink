from app import api
from resources.tutor.account_resources import *


# call keys -> email: str, password: str, first_name: str, last_name: str, hourly_rate: float, primary_subject: str
# return keys -> message: str
api.add_resource(TutorRegisterResource, '/tutor/register')


# call keys -> email: str, password: str
# return keys -> message: str, id: int, email: str, first_name: str, last_name: str, access_token: str
api.add_resource(TutorLoginResource, '/tutor/login')