from app import login_manager

from models.customer_models import Customer
from models.tutor_models import Tutor


@login_manager.user_loader
def load_user(user_id):
    user = Customer.query.get(user_id)
    if user is None:
        user = Tutor.query.get(user_id)
    return user