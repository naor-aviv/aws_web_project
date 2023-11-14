from flask import Blueprint, render_template, request, flash, jsonify
from flask_login import login_required, current_user
from .models import Cert, User
from . import db
import json


views = Blueprint('views', __name__)


@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    if request.method == 'POST':
        cert = request.form.get('cert')

        if len(cert) < 1:
            flash('certificate is too short!', category='error')
        else:
            new_cert = Cert(data=cert, user_id=current_user.id)
            db.session.add(new_cert)
            db.session.commit()
            flash('Certificate added!', category='success')
            print(current_user.id)

    return render_template("home.html", user=current_user)


@views.route('/teams-certificates', methods=['GET', 'POST'])
@login_required
def teams_cert():
    UserList = User.query.filter_by().all()
    return render_template("team_certs.html", user=current_user, UserList=UserList)


@views.route('/delete-cert', methods=['POST'])
def delete_cert():
    cert = json.loads(request.data)
    certId = cert['certId']
    cert = Cert.query.get(certId)
    if cert:
        if cert.user_id == current_user.id:
            db.session.delete(cert)
            db.session.commit()

    return jsonify({})
