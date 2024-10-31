from flask_restful import Resource
from flask import request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity

from models.customer_models import *


class StudentResource(Resource):
    @jwt_required
    def get(self):
        try:
            data = request.get_json()
            if not data.get('student_id') or not data.get('token'):
                return {'message': 'Student ID and Token are required'}, 400
            
            customer_id = get_jwt_identity()
            student = Student.query.filter_by(customer_id=customer_id, id=data.get('student_id')).first()
            
            if not student:
                return {'message': 'Student not found'}, 404
            
            return {'student': student.to_json()}, 200
        
        except Exception as e:
            print(f"Error: {e}")
            return {"message": f"Error: {e}"}, 500

    @jwt_required
    def put(self):
        try:
            data = request.get_json()
            if not data.get('token'):
                return {'message': 'Token is required'}, 400
            
            first_name = data.get('first_name')
            last_name = data.get('last_name')
            date_of_birth = data.get('date_of_birth')
            health_information = data.get('health_information')
            
            if not (first_name and last_name and date_of_birth and health_information):
                return {'message': 'All fields are required'}, 400
            
            customer_id = get_jwt_identity()
            student = Student(customer_id=customer_id, first_name=first_name, last_name=last_name, date_of_birth=date_of_birth,
                              health_information=health_information)
            
            db.session.add(student)
            db.session.commit()

        except Exception as e:
            db.session.rollback()
            print(f"Error: {e}")
            return {"message": f"Error: {e}"}, 500


    def delete(self):
        try:
            data = request.get_json()
            if not data.get('token'):
                return {'message': 'Token is required'}, 400
            
            if not data.get('student_id'):
                return {'message': 'Student ID is required'}, 400
            
            student = Student.query.filter_by(id=data.get('student_id')).first()
            if not student:
                return {'message': 'Student not found'}, 404
            
            db.session.delete(student)
            db.session.commit()

            return {'message': 'Student deleted successfully'}, 200
        
        except Exception as e:
            db.session.rollback()
            print(f"Error: {e}")
            return {"message": f"Error: {e}"}, 500


class GetStudentsResource(Resource):
    # Returns all students associated with the customer id
    @jwt_required
    def get(self):
        try:
            data = request.get_json()
            if not data.get('token'):
                return {'message': 'Token is required'}, 400

            customer_id = get_jwt_identity()
            students = Student.query.filter_by(customer_id=customer_id).all()

            if not students:
                return {'message': 'No students found'}, 404

            return {'students': [student.to_json() for student in students]}, 200
        
        except Exception as e:
            print(f"Error: {e}")
            return {"message": f"Error: {e}"}, 500