from flask import session
from app import login_manager

from models.customer_models import Customer
from models.tutor_models import Tutor


@login_manager.user_loader
def load_user(user_id):
    if session["account_type"] == "customer":
        return Customer.query.get(user_id)
    elif session["account_type"] == "tutor":
        return Tutor.query.get(user_id)