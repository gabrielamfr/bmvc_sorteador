from bottle import template
from app.controllers.auth_controller import current_username

class Application:
    def index(self):
        username = current_username()
        return template('index', titulo='Sorteador - Início', username=username)
