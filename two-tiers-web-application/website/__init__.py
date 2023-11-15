from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from os import path
from flask_login import LoginManager
from flask_bcrypt import Bcrypt
import cred
import pymysql
from sqlalchemy import inspect, text

pymysql.install_as_MySQLdb()


bcrypt = Bcrypt()
db = SQLAlchemy()
#DB_NAME = "database.db"

def create_app():
    app = Flask(__name__)
    bcrypt.init_app(app)

    #db_table = "mysql"
    app.config['SECRET_KEY'] = 'hjshjhdjah kjshkjdhjs'
    app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql://{cred.mysql_user}:{cred.mysql_password}@{cred.mysql_host}/{cred.mysql_db}'
#    app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{DB_NAME}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db.init_app(app)

    from .models import User
    
    #Create DB if not exist
    with app.app_context():
        db.create_all()
        # inspector = inspect(db.engine)
        # if cred.mysql_db not in inspector.get_schema_names():
        #     connection = db.engine.connect()
        #     connection.execute(text(f"CREATE DATABASE {cred.mysql_db}"))
        #     connection.close()


    from .views import views
    from .auth import auth
    from .about import about
    from .profile import profile

    app.register_blueprint(views, url_prefix='/')
    app.register_blueprint(auth, url_prefix='/')
    app.register_blueprint(about, url_prefix='/')
    app.register_blueprint(profile, url_prefix='/')

            
    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))

    return app