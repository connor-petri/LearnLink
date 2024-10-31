from flask import request
from flask_restful import Resource
from flask_bcrypt import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token, jwt_required

from models.tutor_models import *


class TutorRegisterResource(Resource):
    def put(self):
        try:
            data = request.get_json()
            email = data.get('email')
            password = data.get('password')

            if not (email and password and data.get('first_name') and data.get('last_name') and data.get('subject')):
                return {'message': 'All fields are required'}, 400
            
            hashed_password = generate_password_hash(data.get('password')).decode('utf-8')
            first_name = data.get('first_name')
            last_name = data.get('last_name')

            tutor = Tutor(email=email, password=hashed_password, first_name=first_name, last_name=last_name, 
                            outstanding_pay=0.0, hourly_rate=15.00)
            db.session.add(tutor)

            subject = Subject(name=data.get('subject'), tutor_id=tutor.id)
            db.session.add(subject)

            db.session.commit()

            return {'message': 'Tutor registered successfully'}, 201
        
        except Exception as e:
            db.session.rollback()
            print(f"Error: {e}")
            return {"message": f"Error: {e}"}, 500
        

class TutorLoginResource(Resource):
    def post(self):
        try:
            data = request.get_json()
            email = data.get('email')
            password = data.get('password')

            if not email or not password:
                return {'message': 'Email and password are required'}, 400

            tutor = Tutor.query.filter_by(email=email).first()
            if tutor is None or not check_password_hash(tutor.password, password):
                return {'message': 'Invalid credentials',
                        'id': None,
                        'email': None,
                        'first_name': None,
                        'last_name': None,
                        'access_token': None}, 401

            return {'message': 'Tutor logged in successfully',
                    'id': tutor.id,
                    'email': tutor.email,
                    'first_name': tutor.first_name,
                    'last_name': tutor.last_name,
                    'access_token': create_access_token(identity=tutor.id)}, 200
        
        except Exception as e:
            print(f"Error: {e}")
            return {"message": f"Error: {e}",
                    'id': None,
                    'email': None,
                    'first_name': None,
                    'last_name': None,
                    'access_token': None}, 500