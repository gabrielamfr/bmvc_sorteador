from bottle import Bottle, run, static_file
import bottle, os
from app.controllers.application import Application
from app.controllers.sorteio_runner import run_draw_api, get_user_draws_api

bottle.TEMPLATE_PATH = [os.path.join(os.path.dirname(__file__), 'app', 'views')]

app = Bottle()
ctl = Application()

@app.route('/static/<filepath:path>')
def serve_static(filepath):
    return static_file(filepath, root=os.path.join(os.path.dirname(__file__), 'app', 'static'))

@app.route('/')
def index():
    return ctl.index()

from app.controllers.auth_controller import login_get, login_post, logout
from app.controllers.sorteio_crud import admin_index, create_sorteio, delete_sorteio_route 

@app.route('/login', method='GET')
def _login_get():
    return login_get()

@app.route('/login', method='POST')
def _login_post():
    return login_post()

@app.route('/logout')
def _logout():
    return logout()

@app.route('/admin')
def _admin():
    return admin_index()

@app.route('/admin/create', method='POST')
def _admin_create():
    return create_sorteio()

@app.route('/admin/delete/<id>')
def _admin_delete(id):
    return delete_sorteio_route(id) 

@app.post('/api/draw')
def _api_draw():
    return run_draw_api()

@app.get('/api/draws')
def _api_draws():
    return get_user_draws_api()

if __name__ == '__main__':
    run(app, host='localhost', port=8080, debug=True)