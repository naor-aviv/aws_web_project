from flask import Blueprint, render_template, request, flash, redirect, url_for
from .models import User
from flask_login import login_user, login_required, logout_user, current_user


about = Blueprint('about', __name__)

@about.route('/about', methods=['GET', 'POST'])
def about_page():
    previous_page = request.args.get('previous_page')
    return render_template("about.html", user=current_user)
