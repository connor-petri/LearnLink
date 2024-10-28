from app import db
from flask_login import UserMixin


class Tutor(db.Model, UserMixin):
    __tablename__ = 'tutors'

    id = db.Column(db.Integer, primary_key=True)

    email = db.Column(db.String(50), nullable=False, unique=True)
    password = db.Column(db.String(100), nullable=False)

    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    hourly_rate = db.Column(db.Float, nullable=False)
    outstanding_pay = db.Column(db.Float, nullable=False, default=0.0)

    subjects = db.relationship('Subject', backref=__tablename__)



class Subject(db.Model):
    __tablename__ = 'subjects'

    id = db.Column(db.Integer, primary_key=True)
    tutor_id = db.Column(db.Integer, db.ForeignKey('tutors.id'))

    name = db.Column(db.String(50), nullable=False)