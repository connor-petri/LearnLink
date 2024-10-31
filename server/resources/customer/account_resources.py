from flask import request
from flask_restful import Resource
from flask_bcrypt import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token, jwt_required

from models.customer_models import *


class CustomerRegisterResource(Resource):
    def put(self):
        try:
            data = request.get_json()
            email = data.get('email')
            password = data.get('password')

            if not email:
                print("Email ise required")
                return {'message': 'Email is required'}, 400
            
            if not password:
                print("Password is required")
                return {'message': 'Password is required'}, 400
            
            if not data.get('first_name'):
                print("First name is required")
                return {'message': 'First name is required'}, 400
            
            if not data.get('last_name'):
                print("Last name is required")
                return {'message': 'Last name is required'}, 400

            if Customer.query.filter_by(email=email).first():
                print("Email already exists")
                return {'message': 'Email already exists'}, 400

            hashed_password = generate_password_hash(data.get('password')).decode('utf-8')
            first_name = data.get('first_name')
            last_name = data.get('last_name')

            customer = Customer(email=email, password=hashed_password, first_name=first_name, last_name=last_name, 
                                outstanding_balance=0.0)
            db.session.add(customer)
            db.session.commit()

            return {'message': 'Customer registered successfully'}, 201
        
        except Exception as e:
            db.session.rollback()
            print(f"Error: {e}")
            return {"message": f"Error: {e}"}, 500


class CustomerLoginResource(Resource):
    def post(self):
        try:
            data = request.get_json()
            email = data.get('email')
            password = data.get('password')

            if not email or not password:
                print("Email and password are required")
                return {'message': 'Email and password are required',
                        'id': None,
                        'email': None,
                        'first_name': None,
                        'last_name': None,
                        'access_token': None}, 400

            customer = Customer.query.filter_by(email=email).first()
            if customer is None or not check_password_hash(customer.password, password):
                print("Invalid credentials")
                return {'message': 'Invalid credentials',
                        'id': None,
                        'email': None,
                        'first_name': None,
                        'last_name': None,
                        'access_token': None}, 401

            return {'message': 'Customer logged in successfully',
                    'id': customer.id,
                    'email': customer.email,
                    'first_name': customer.first_name,
                    'last_name': customer.last_name,
                    'access_token': create_access_token(identity=customer.id)}, 200
        
        except Exception as e:
            print(f"Error: {e}")
            return {"message": f"Error: {e}",
                    'id': None,
                    'email': None,
                    'first_name': None,
                    'last_name': None,
                    'access_token': None}, 500
