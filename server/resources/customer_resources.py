from flask import jsonify, request
from flask_restful import Resource
from flask_bcrypt import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token, jwt_required

from app import api
from models.customer_models import *


class CustomerLogin(Resource):
    def post(self):
        try:
            data = request.get_json()
            email = data.get('email')
            password = data.get('password')

            if not email or not password:
                print("Email and password are required")
                return {'message': 'Email and password are required'}, 400

            customer = Customer.query.filter_by(email=email).first()
            if customer is None or not check_password_hash(customer.password, data.get('password')):
                print("Invalid credentials")
                return {'message': 'Invalid credentials'}, 401

            return {'message': 'Customer logged in successfully',
                            'id': customer.id,
                            'email': customer.email,
                            'first_name': customer.first_name,
                            'last_name': customer.last_name}, 200
        
        except Exception as e:
            print(f"Error: {e}")
            return {"message": f"Error: {e}"}, 500
